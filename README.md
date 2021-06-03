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

TODO
1. configure chrony local ntp
	https://docs.openshift.com/container-platform/4.7/installing/install_config/installing-customizing.html#installation-special-config-chrony_installing-customizing
