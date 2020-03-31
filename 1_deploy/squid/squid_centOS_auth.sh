#!/bin/bash -e

echo "---Installing Updates\n"
yum -y install epel-release
yum clean all
sed -i "s/mirrorlist=https/mirrorlist=http/" /etc/yum.repos.d/epel.repo

echo "---Done with the updates, Installing Squid now\n"
yum -y install squid
yum -y install httpd-tools

echo "Please enter the username for proxy authentication:"
read username
htpasswd -c /etc/squid/passwd $username
chmod o+r /etc/squid/passwd

echo "---Done with the Installation, Updating rules Now\n"
sed -i "s/# Example rule allowing/# Auth related settings\nauth_param basic program \/usr\/lib\/squid\/ncsa_auth \/etc\/squid\/passwd\n\
auth_param basic children 5\n\
auth_param basic realm Squid proxy-caching web server\n\
auth_param basic credentialsttl 2 hours\n\
auth_param basic casesensitive off\n\n# Example rule allowing/" /etc/squid/squid.conf

sed -i "s/# Deny requests to certain unsafe ports/# rules for access\nacl ncsa_users proxy_auth REQUIRED\n\
http_access allow ncsa_users\n\n# set visible_hostname (specify hostname)\n\
visible_hostname squid.server.commm\n\n# Deny requests to certain unsafe ports/" /etc/squid/squid.conf

echo "---Done, Starting the proxy Now\n"
service squid start

echo "---Proxy is running on Port:3128, you can chnage this from /etc/squid/squid.conf\n"