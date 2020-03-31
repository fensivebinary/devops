#!/bin/bash -e

echo "Installing Updates\n"
yum -y install epel-release
sed -i "s/mirrorlist=https/mirrorlist=http/" /etc/yum.repos.d/epel.repo
echo "Done with the updates, Installing Nginx Now\n"
yum -y install nginx
echo "Done with the Installation, Starting Nginx Now\n"
service nginx start

# sed -i 's/ipaddress=""/ipaddress="1.1.1.1"/1' abc.txt

echo "Done, the nginx is running on: "
ip addr show eth0 | grep inet | awk '{ print $2; }' | sed 's/\/.*$//'
echo
echo "with port 80\n"

echo "You might need to configure iptables to access nginx from outside your network\n"
