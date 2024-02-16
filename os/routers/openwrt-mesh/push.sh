#!/bin/sh
BASE_PATH=$(realpath "${BASH_SOURCE[0]}" | xargs dirname)

pushd "$BASE_PATH"

mode=${1:-"main"}
host=${2:-"root@192.168.1.1"}
file_name="create-${mode}.sh"
dotenv_file_name=".env"


if [ ! -f "${file_name}" ]; then
    echo "Invalid Mode ${mode}!"
    echo "Please use 'main' or 'ap'"
    exit 1
fi
if [ ! -f "${dotenv_file_name}" ]; then
    echo "Missing dotenv file!"
    echo "Please create a ${dotenv_file_name} in $BASE_PATH!"
    exit 1
fi

echo "mode=${mode}"
echo "host=${host}"

read -p "Continue? [Y/N]" -n 1 -r
echo 
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Continuing..."
else
    echo "Stopping!"
    exit 1
fi

scp -O "$file_name" "$host:/tmp/update-script.sh"
scp -O "$dotenv_file_name" "$host:/tmp/.env"
ssh -t "$host" <<EOF
set -e
echo "chmod +x /tmp/update-script.sh"
chmod +x /tmp/update-script.sh
echo "export \$(cat /tmp/.env | xargs -0)"
export \$(cat /tmp/.env | xargs -0)
echo "/tmp/update-script.sh"
/tmp/update-script.sh
EOF
