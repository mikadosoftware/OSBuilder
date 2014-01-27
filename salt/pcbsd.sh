l='pcbsd: { url: "http://pkg.cdn.pcbsd.org/9.2-RELEASE/amd64", signature_type: "fingerprints", fingerprints: "/usr/local/etc/pkg/fingerprints/pcbsd", enabled: true }'

echo $l > /usr/local/etc/pkg/repos/pcbsd.conf 

mkdir -p /usr/local/etc/pkg/fingerprints/pcbsd/revoked 
mkdir -p /usr/local/etc/pkg/fingerprints/pcbsd/trusted

fetch -o /usr/local/etc/pkg/fingerprints/pcbsd/trusted/pkg.cdn.pcbsd.org.20131209 https://github.com/pcbsd/pcbsd/raw/master/src-sh/pc-extractoverlay/ports-overlay/usr/local/etc/pkg/fingerprints/pcbsd/trusted/pkg.cdn.pcbsd.org.20131209 

