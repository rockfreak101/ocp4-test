# ocp4-test

Configure TFTP Server
dnf install -y xinetd tftp-server tftp
copy ocp4-test/xinetd.d/tftp to /etc/xinetd.d/tftp
systemctl enable xinetd
systemctl restart xinetd
systemctl status xinetd

make dirs for hosting files 
mkdir -p /var/lib/tftpboot/tftp/ocp4
copy the rhcos-live-* files to that dir. They are image files needed to boot the servers

firewall-cmd --add-service={dhcp,http,tftp} --zone=internal --permanent
firewall-cmd --add-port={4011/udp,69/udp} --zone=internal --permanent
setsebool -P tftp_home_dir 1

Mirroring OCP4 
https://www.openshift.com/blog/openshift-4-2-disconnected-install
https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/release.txt

podman run --name poc-registry -p 5000:5000 \
-v /opt/registry/data:/var/lib/registry:z \
-v /opt/registry/auth:/auth:z \
-e "REGISTRY_AUTH=htpasswd" \
-e "REGISTRY_AUTH_HTPASSWD_REALM=Registry" \
-e "REGISTRY_HTTP_SECRET=ALongRandomSecretForRegistry" \
-e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
-v /opt/registry/certs:/certs:z \
-e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt \
-e REGISTRY_HTTP_TLS_KEY=/certs/domain.key \
docker.io/library/registry:2

VARS
export GODEBUG=x509ignoreCN=0
export OCP_RELEASE='4.7.13'
export LOCAL_REGISTRY='ocp-srv.ocp.lan:5000'
export LOCAL_REPOSITORY='ocp4/openshift4'
export PRODUCT_REPO='openshift-release-dev'
export LOCAL_SECRET_JSON='/root/pull-secret.json'
export RELEASE_NAME="ocp-release"
export ARCHITECTURE='x86_64'
export REMOVABLE_MEDIA_PATH='<path>'

### Initiate the mirror

oc adm release mirror -a ${LOCAL_SECRET_JSON}  \
     --from=quay.io/${PRODUCT_REPO}/${RELEASE_NAME}:${OCP_RELEASE}-${ARCHITECTURE} \
     --to=${LOCAL_REGISTRY}/${LOCAL_REPOSITORY} \
     --to-release-image=${LOCAL_REGISTRY}/${LOCAL_REPOSITORY}:${OCP_RELEASE}-${ARCHITECTURE}


To use the new mirrored repository to install, add the following section to the install-config.yaml:

imageContentSources:
- mirrors:
  - ocp-srv.ocp.lan:5000/ocp4/openshift4
  source: quay.io/openshift-release-dev/ocp-release
- mirrors:
  - ocp-srv.ocp.lan:5000/ocp4/openshift4
  source: quay.io/openshift-release-dev/ocp-v4.0-art-dev


To use the new mirrored repository for upgrades, use the following to create an ImageContentSourcePolicy:

apiVersion: operator.openshift.io/v1alpha1
kind: ImageContentSourcePolicy
metadata:
  name: example
spec:
  repositoryDigestMirrors:
  - mirrors:
    - ocp-srv.ocp.lan:5000/ocp4/openshift4
    source: quay.io/openshift-release-dev/ocp-release
  - mirrors:
    - ocp-srv.ocp.lan:5000/ocp4/openshift4
    source: quay.io/openshift-release-dev/ocp-v4.0-art-dev


TODO
1. configure chrony local ntp
	https://docs.openshift.com/container-platform/4.7/installing/install_config/installing-customizing.html#installation-special-config-chrony_installing-customizing
