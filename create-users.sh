#!/bin/bash

apt-get update -y
apt-get install expect -y

echo " === CREATING USERS .. "

while IFS= read -r line; 
  do
    username=$line
    groupname=$line
    password="P3rmission2Acce33"
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

	    passwd --expire $username
    fi
done < $1
