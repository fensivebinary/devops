#!/bin/bash -xe
echo "---Reading name and versions"
version=$(cat version_control)
base_name=hello
final_name="${base_name}_$version${BUILD_NUMBER}"
echo $final_name
echo "---Creating directories"
mkdir -p $final_name/opt/${base_name}/bin $final_name/DEBIAN
chmod -R 0775 $final_name
echo "---Building"
python3 -m PyInstaller -F -n ${base_name} --log-level INFO  hello.py &&
echo "---Copying files"
cp $(pwd)/dist/${base_name} $(pwd)/$final_name/opt/${base_name}/bin/

echo "---Creating Control for Packaging"
echo -e "Package: helloworld\n\
Version: "$(cat version_control)"\n\
Section: base\n\
Priority: optional\n\
Architecture: amd64\n\
Multi-Arch: same\n\
Depends: \n\
Maintainer: Muhammad Junaid Raza <strawberriesfrozen@gmail.com>\n\
Description: Hello World\n\
 When you need some sunshine, just run this\n\
 small program!\n" >> $final_name/DEBIAN/control

echo "---Creating Config for Packaging"
echo -e "#!/bin/sh\n\
# Exit on error\n\
set -e\n\
# Source debconf library.\n\
. /usr/share/debconf/confmodule\n\
# Ask questions\n\
db_beginblock\n\
db_fset $final_name/Name seen false\
db_fset $final_name/Age seen false\
db_input low $final_name/Name || true\n\
db_input low $final_name/Age || true\n\
db_endblock\n\
# Show interface\n\
db_go || true\n" >> $final_name/DEBIAN/config

echo "---Creating templates for Packaging"
echo -e "Template: $final_name/Name\n\
Type: text\n\
Description: What is your Name?\n\
	Please tell me what is your name.\n\n\
Template: $final_name/Age\n\
Type: text\n\
Description: What is your age?\n\
	Please tell me what is you age">>$final_name/DEBIAN/templates

echo "---Creating preinst for Packaging"
echo -e "#!/bin/sh\n\
echo \"\$(pwd)\"\n\
echo \"I am in the Pre Installation File\"\n">>$final_name/DEBIAN/preinst

echo "---Creating postinst for Packaging"
echo -e "#!/bin/sh\n\
# Source debconf library.\n\
. /usr/share/debconf/confmodule\n\
# Fetching configuration from debconf\n\
db_get $final_name/Name\n\
ANSWER1=\$RET\n\
echo \"Got First Answer as: \${ANSWER1}\"\n\
db_get $final_name/Age\n\
ANSWER2=\$RET\n\
echo \"Got Second Answer as: \${ANSWER2}\"\n">>$final_name/DEBIAN/postinst 

echo "---Creating prerm for Packaging"
echo -e "#!/bin/sh\n\
echo \"I am in the Pre Remove File\"\n">>$final_name/DEBIAN/prerm

echo "---Creating postrm for Packaging"
echo -e "#!/bin/sh\n\
. /usr/share/debconf/confmodule\n\
echo \"I am in the Post Remove File\"\n
db_purge">>$final_name/DEBIAN/postrm

echo "---Taking Care of permissions"
chmod -R 0775 $final_name/DEBIAN/control $final_name/DEBIAN/postrm $final_name/DEBIAN/prerm $final_name/DEBIAN/postinst $final_name/DEBIAN/preinst $final_name/DEBIAN/templates $final_name/DEBIAN/config
dos2unix $final_name/DEBIAN/control $final_name/DEBIAN/postrm $final_name/DEBIAN/prerm $final_name/DEBIAN/postinst $final_name/DEBIAN/preinst $final_name/DEBIAN/templates $final_name/DEBIAN/config

dpkg-deb --build $final_name

echo "---Packge Created, Removing files now"

echo "---Done, Uploading the artifacts now"


curl -i -X PUT -u admin:admin123 \
-T ./${final_name}.deb \
http://IP:Port/repository/Test_Artifacts/${final_name}.deb