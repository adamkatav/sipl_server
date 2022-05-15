#!/bin/bash
<<comment
if [ -d "env" ]
then
    python3 -m venv env
fi
comment
[ $# -eq 0 ] && printf "Usage:\n       python3 main.py ftp_username ftp_password\n" && exit

[ -d "env" ] && python3 -m venv env
source env/bin/activate
pip install -r requirements.txt
#python3 main.py ftp_username ftp_password
python3 main.py $1 $2