base_name='hello'
echo "---Building with PyInstaller"
python3 -m PyInstaller -F -n ${base_name} --log-level INFO  hello.py
