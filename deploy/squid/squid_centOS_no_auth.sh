#!/bin/bash -e

echo "---Installing Updates\n"
yum -y install epel-release
yum clean all
sed -i "s/mirrorlist=https/mirrorlist=http/" /etc/yum.repos.d/epel.repo

echo "---Done with the updates, Installing Squid now\n"
yum -y install squid


echo "---Done with the Installation, Updating rules Now\n"
sed -i "s/Deny requests to certain unsafe ports/allow all requests\nacl all src all\n\
http_access allow all\n\n# set visible_hostname (specify hostname)\n\
visible_hostname squid.server.commm\n\n# Deny requests to certain unsafe ports/" /etc/squid/squid.conf

echo "---Done, Starting the proxy Now\n"
service squid start

echo "---Proxy is running on Port:3128, you can chnage this from /etc/squid/squid.conf\n"
