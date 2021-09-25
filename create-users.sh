#!/bin/bash


# HOW TO USE: 
# 1. Create a file. Put all usernames in it. One username per line.
# 2. Run the script and pass your file as an argument. e.g
#    ./create-users.sh [your_file] 
# 
# NOTE: The script was tested on Ubuntu 18 - works fine!

if [ -z "$1" ]
  then
    echo "Argument is missing"
    exit 1
fi

apt-get update -y
apt-get install expect -y
echo " === CREATING USERS .. "
while IFS= read -r line; 
  do
    username=$line
    groupname=$line
    password="2Acce33@otoz"
    if [ -z "$username" ]
      then
        echo "\$username is empty"
	continue
    fi
    if id -u "$username" >/dev/null 2>&1; 
      then
        echo "user: '$username' already exists"
        continue
      else
        echo "creating user $username"
	    useradd $username -m -s /bin/bash
        usermod -a -G $groupname $username
        echo "#!/usr/bin/expect -f
        spawn passwd $username
        expect \"Enter new UNIX password:\"
        send -- \"$password\r\"
        expect \"Retype new UNIX password:\"
        send -- \"$password\r\"
        expect eof
        " >> setPassword
        chmod +x setPassword
        ./setPassword
        rm setPassword
        echo "$username ALL=(ALL:ALL) ALL" >> /etc/sudoers.d/$username
	    passwd --expire $username
    fi
done < $1
