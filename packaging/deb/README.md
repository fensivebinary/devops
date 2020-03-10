# devops
DevOps Tools and Scritps

to package:
~~~
dpkg-deb --build hello
~~~

If you want to assign your binary the same ownership as that of user running the script then package with following:
~~~
sudo update-alternatives --set fakeroot /usr/bin/fakeroot-tcp
fakeroot dpkg-deb --build hello
~~~


to install:
~~~
sudo apt-get install ./hello.deb
~~~
or
~~~
sudo dpkg -i ./hello.deb
~~~

to unisntall:
~~~
sudo apt-get remove hello -y
sudo apt-get purge hello -y
~~~