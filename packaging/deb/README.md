# devops
DevOps Tools and Scritps

to build:
dpkg-deb --build hello

to install:
sudo apt-get install ./hello.deb
or
sudo dpkg -i ./hello.deb

to unisntall:
sudo apt-get remove hello -y
sudo apt-get purge hello -y