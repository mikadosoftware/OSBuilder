#!/usr/bin/python
# -*- coding: utf-8 -*-

"""
There seems little point in having the Application subclass. What does it give us?
It is difficult to identify subclasses of a class in module A within module B.

 * Is there any reason not to simply list the commands in commands = []
 
Requirements
------------
 * Copy files to remote locations
 * Move files remotely
 * Install eggs
 * Setup and bootstrap a virtualenv
 * Write config files
 * Add to existing config files
 * Search and replace within existing files
 * Support various methods of logging (simple http call)
 * Support additional commands either in the deploy file, in ~/deploy/mod.py or via includes in the deploy script
 * Support command line args to overwrite default settings
 * Copy a directory structure (referenced RELATIVE TO THE DEPLOYMENT FILE)

Fabric can do most of this. Its plugin mechanism is not yet finalised, so adding functions will have to take place in the fabfiles, or we 
should add them to a modified fabric.py

AppDeploy is init'd with a deploy_file path and options (parsed by setup())
the deployment class from the deploy_file is init'd with the command line options (which override defaults)
AppDeploy.deploy() calls the deploy() method of the selected deployment class in deploy_file
deploy() tries to prepare commands by filling in %(<name>)s replacements. If any params are missing, MissingParam is raised
Otherwise, the deploy() runs

"""

__version__ = '0.6'

import datetime, os, re, sys, types
import operator
import subprocess
import select
import fcntl
import urllib, urllib2
from optparse import OptionParser

NULL_UUID = '00000000-0000-0000-0000-000000000000'

class MissingParam(Exception):
    """Raised when command expansion fails to find the named variable"""
    pass

class CommandError(Exception):
    """Raised on failed command execution"""
    pass

class Prompt(object):
    """Stub. Prompt is unused"""
    def __init__(self, questionText, questionName, default="", uuid=NULL_UUID):
        pass

class ChoicePrompt(object):
    """Stub. Not used anymore"""
    def __init__(self, questionText, questionName, default="", choices=[], uuid=NULL_UUID):
        pass


class Command(object):
    """Modified to take kargs and prepare params correctly,
    then fill cmd using %(key)s style string substitution
    """
    def __init__(self, cmd, *args, **kargs):
        self.command = cmd
    
    def __str__(self):
        return "COMMAND: %s" % self.command
    
    def prepareParams(self, param_value_dict):
        """paramValues is passed by Application.
        For all Params associated with this Command, set its value based on 
        items in paramValues. Else None.
        """
        try:
            ## Inject cwd into params
            param_value_dict['cwd'] = os.getcwd()
            self.command = self.command % param_value_dict
            #this breaks things like 'svn://svn' and frankly if we cannot pass in correct strings in the conf files we have other problems. pbrian
            #self.command = os.path.normpath(self.command)
        except KeyError, e:
            raise MissingParam(e.message)
    
    def run(self, shell=True):
        try:
            retcode = subprocess.call(self.command, shell=shell)
        except Exception, e:
            raise CommandError(e.message)
        if retcode:
            raise CommandError('Non-zero return code from %s' % self.command)
        return retcode


class FunctionCall(object):
    """Represents a function to call at deploy time.
    A dictionary of keyword arguments may be passed. Only string types are supported at present.
    The function may be a ref to a callable or a string which is looked up in globals()
    """
    def __init__(self, function, kargs={}):
        if isinstance(function, types.StringTypes):
            ## Lookup in globals() filtered to remove non-callables
            try:
                function = dict([(name, func) for name, func in globals().items() if operator.isCallable(func)])[function]
            except KeyError:
                raise KeyError("Unknown function named '%s'" % function)
        
        self.function = function
        self.kargs    = kargs
    
    def __str__(self):
        return "FUNCTION: %s %s" % (self.function.__name__, self.kargs)
    
    ## Called by Application.prepareParams (which is called by Application.deploy)
    def prepareParams(self, param_value_dict):
        """For all kargs passed, try to fill any python string replacements"""
        for key, item in self.kargs.items():
            try:
                if isinstance(item, (list, tuple)):
                    self.kargs[key] = [i % param_value_dict for i in item]
                else:
                    self.kargs[key] = item % param_value_dict
            except KeyError, e:
                raise MissingParam(e.message)
    
    def run(self, runtimeArgs={}):
        """Replace karg values with any passed in runtimeArgs"""
        for key in runtimeArgs.keys():
            self.kargs[key] = runtimeArgs[key]
        ## TODO: Should we pass kargs as actual kargs, not a dict?
        self.function(**self.kargs)
        return 0


class Application(object):
    """The base class for all application deployment recipes"""
    Name = "Base Application - do not use"
    
    ## NOTE: Ignore prompts. Here for backwards compatibility
    def __init__(self, options={}, commands=[], prompts=[], logfile='app_deploy.log', verbose=True):
        ## Override default options with command line args
        self.options.update(options)
        self.commands    = commands
        self.prompts     = prompts
        self.logfile     = logfile
        self.logfileptr  = None
        self.verbose     = verbose
    
    def prepare_params(self):
        """Pass the given paramvalues dict to all commands and functioncalls defined in self.commands.
        These values are used as defaults by the commands
        """
        for command in ( cmd for cmd in self.commands if isinstance(cmd, (Command, FunctionCall)) ):
            command.prepareParams(self.options)
    
    def open_log(self):
        """Open the deploy log in append mode"""
        if not self.logfileptr:
            self.logfileptr = open(self.logfile, "a")
    
    def close_log(self):
        """Close the deploy log file"""
        try:
            self.logfileptr.close()
        except AttributeError:
            pass
    
    def write_out(self, text):
        """Write text to log AND to sys.stdout if self.verbose"""
        if self.verbose:
            sys.stdout.write(u'%s\n'.encode('utf-8') % text)
        self.write_log(text)
    
    def write_log(self, text):
        """Write text to log line"""
        try:
            self.logfileptr.write(text + "\n")
        except AttributeError:
            pass
    
    
    def deploy(self):
        """ """
        ## Ensure the log file is open
        self.open_log()
        self.write_log("=> %s install, %s" % (self.__class__.__name__, str(datetime.datetime.now())))
        
        ## Prepare all params
        self.prepare_params()
        
        ## Iterate through commands, executing with subprocess.call
        for idx, command in enumerate(self.commands):
            try:
                self.write_out("%d, %s" % (idx, str(command)))
                result = command.run()
            except (CommandError, Exception), e:
                self.write_out(str(e))
                self.close_log()
                raise
        
        ## Write config file if self.config() is defined
        try:
            self.create_config()
        except AttributeError:
            self.write_log('==> No config file created')
    
    def displayCommands(self):
        """Print representations of all commands defined for this App deployment"""
        for command in self.commands:
            print command
            print


##### MODIFIED DEPLOYMENT EXECUTION CODE #####
class AppDeploy(object):
    """ """
    def __init__(self, deploy_file, options):
        """Requires a path to a deploy file and and options dict"""
        self.deploy_file = deploy_file
        self.options = options
    
    def logInstall(self, host, ip, app, rev):
        """The default logger. Do not override this. Instead, use the install_log hook to 
        pass a callable
        """
        log_url = "compswww.office.pirc.co.uk/cgi-bin/admin/store_deployment.py"
        #headers = {'User-agent': 'python-httplib'}
        log_data = {'host': host, 'ip': ip, 'app': app, 'rev': rev, 'ts': str(datetime.datetime.now())}
        data = urllib.encode(log_data)
        
        try:
            req = urllib2.Request(log_url, data)
            response = urllib2.urlopen(req)
            if not response.msg == 'OK':
                print "There was a problem logging the installer with the server"
        except Exception:
            print "There was a problem logging the installer with the server"
        
        if getattr(self, 'install_log') and operator.isCallable(self.install_log):
            try:
                self.install_log()
            except Exception:
                print "Failed to run install_log callable"
    
    def load_deployfile(self, deploy_file):
        """Load the given file as a module and return a module reference"""
        ## Add the deploy directory to PATH
        ## Also add current to PATH to allow the deploy file to import app_deploy
        self.orig_cwd = os.getcwd()
        deploy_dir, deploy_file = os.path.split(deploy_file)
        os.chdir(deploy_dir)
        
        sys.path.insert(0, deploy_dir)
        sys.path.insert(0, os.path.dirname(__file__))
        
        try:
            return __import__(os.path.splitext(deploy_file)[0], globals(), {}, [])
        except Exception:
            raise
    
    def runDeployment(self):
        """Import the deployment recipe file, run the application deployment.
        This method is responsible for identifying the correct deployment class """
        try:
            recipe = self.load_deployfile(self.deploy_file)
        except Exception, e:
            self.cleanup()
            raise
        
        ## Find classes with names that match pattern
        deploy_classes = []
        patt = re.compile('^[a-zA-Z0-9]+Application$')
        for key, obj in recipe.__dict__.items():
            try:
                if patt.match(key):
                    deploy_classes.append(obj)
            except TypeError:
                continue
        
        ## Run the deployent
        ## TODO: We select only the first matching deployment class
        ## There may be more, but I'm not sure we want to support that
        deploy = deploy_classes[0](self.options)
        try:
            deploy.deploy()
        except MissingParam, e:
            print "ERROR: Missing parameter %s" % e.message
        except CommandError, e:
            print str(e)
        except Exception, e:
            raise
        
        self.cleanup()

  
    
    def cleanup(self):
        """Run after the deployment"""
        ##log 
        self.logInstall(None,None,'test','test')
        ## Remove the deploy directory
        sys.path.pop(0)
        ## Remove the __file__ directory
        sys.path.pop(0)
        ## Reset cwd
        os.chdir(self.orig_cwd)




## Utility Functions ##
def replaceStringInFile(src, dest, src_str, replace_str, **kargs):
    """Given a sourcefile, replace instances of sourceString with replaceString"""
    fix_path = lambda x: os.path.abspath(os.path.expandvars(x))
    #sourceFile    = fix_path(kargs['sourceFile'])
    #destFile      = fix_path(kargs['destFile'])
    #sourceString  = kargs['sourceString']
    #replaceString = kargs['replaceString']
    sourceFile    = fix_path(src)
    destFile      = fix_path(dest)
    sourceString  = src_str
    replaceString = replace_str    
    fout = open(destFile, 'w')
    
    for line in open(sourceFile, 'r'):
        fout.write( line.replace(sourceString, replaceString) )
    
    fout.close()
    return True

def replaceStringInDir(**kargs):
    """For each file with extension in exts within sourceDir, replace string
    sourceString with replaceString
    """
    import shutil
    
    fix_path      = lambda x: os.path.abspath(os.path.expandvars(x))
    exts          = kargs['exts'].split(",")
    sourceDir     = fix_path(kargs['sourceDir'])
    sourceString  = kargs['sourceString']
    replaceString = kargs['replaceString']
    
    files = [i for i in os.listdir(sourceDir) if os.path.splitext(i)[1].lstrip('.') in exts]
    files = [os.path.join(sourceDir, i) for i in files]
    
    for infile in files:                                                          
        shutil.copy(infile, '%s.copy' % infile)                                   
        outfile = file(infile, 'w')
        for line in file("%s.copy" % infile):
            outfile.write(line.replace(sourceString, replaceString))
        outfile.close()
        os.remove("%s.copy" % infile)


def setup():
    """Require one positional argument and accept any keyword args.
    --verbose, --version are reserved by app_deploy and are not passed 
    to the recipes
    """
    def process_special(arg):
        if arg == 'version':
            sys.stdout.write("Version: %s\n" % __version__)
            raise SystemExit(0)
    
    special_args = ['verbose', 'version']
    args = sys.argv[1:]
    
    ## Check the deploy file has been passed and is valid
    try:
        deploy_file = os.path.abspath(os.path.expandvars(args.pop(0)))
        if not os.path.isfile(deploy_file):
            raise ValueError("Invalid deploy file")
    except (IndexError, ValueError):
        sys.stdout.write("ERROR: Ensure the first arg points to a valid deploy script\n")
        sys.stdout.flush()
        raise SystemExit(1)
        
    ## Now parse the options
    ## We are assuming sys.argv retains position
    options = {}
    for idx, arg in enumerate(args):
        arg = arg.lstrip('-').strip()
        
        ## If special arg
        if arg in special_args:
            process_special(arg)
        
        try:
            key, value   = arg.split("=")
            options[key] = value
            
        except ValueError:
            ## Likely to be an option value separated by space
            if not args[idx+1].startswith('-'):
                key   = arg
                value = args.pop(idx+1)
                options[key] = value
            continue
    
    return deploy_file, options
    

def main(deploy_file, opts):
    """ """
    deployment = AppDeploy(deploy_file, opts)
    deployment.runDeployment()


if __name__ == '__main__':
    deploy_file, opts = setup()
    main(deploy_file, opts)
