#!/bin/bash 
source ./main.conf 
host=""
first_start()
{
				if [[ ! -e ./firststart  ]];
				then 
						echo 1 > ./firststart 
						#scp -i "$IDENTITY_KEY" -P "$SSHPORT" ./mdns.sh "$host:/data/data/com.termux/files/home/mdns.sh"
						CONFIG_FILE="avahi-daemon.conf"  # Update this path as needed
						# Save the current value of IFS to restore it later
						oldIFS=$IFS
						# Set IFS to '.' to split the string by dots
						IFS='.'
						read -ra hostvalue <<< "$HOSTDOMAIN"
						# Restore the original value of IFS
						IFS=$oldIFS

						# Check if the configuration file exists
						if [ ! -f "$CONFIG_FILE" ]; then
						  echo "Avahi configuration file not found: $CONFIG_FILE"
						  exit 1
						fi
						
						# Use sed to insert the host and domain values into the configuration file
						sed -i "s/^host-name=.*/host-name=${hostvalue[0]}/" "$CONFIG_FILE"
						sed -i "s/^domain-name=.*/domain-name=${hostvalue[1]}/" "$CONFIG_FILE"
						
						echo "Host and domain values updated in $CONFIG_FILE"
						scp -i $IDENTITY_KEY  -P $SSHPORT $CONFIG_FILE  $host:/data/data/com.termux/files/usr/etc/avahi/
						#scp -i $IDENTITY_KEY -P $SSHPORT ./avahi-daemon.conf $host:/data/data/com.termux/files/usr/etc/avahi/
						
						
				fi
}
phone_ssh()
{



        #idkey='/home/sanbotbtrfs/phoneid'
		checkflag=0
		echo $HOSTDOMAIN
        ping -c 1 $HOSTDOMAIN >/dev/null 2>&1
        if [[ $? -ne 0 ]] 
        then
				first_start
                if host=$(ip neigh  | awk   '/([0-9]{1,3}\.){3}[0-9]{1,3}/ {print $1}' |nmap -p $SSHPORT  --open   -iL   -  |grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' )
                then

                        echo 'mdns failed ,bruteforce fallback'

						ssh -i $IDENTITY_KEY -p $SSHPORT  $host bash /data/data/com.termux/files/home/mdns.sh
                else
                        echo 'no server'
						#exit 1
						checkflag=1
                fi
        else
                echo "mdns ,  $HOSTDOMAIN  detected"
                host=$HOSTDOMAIN
				first_start
				if !  nmap -p $SSHPORT --open $host | grep -ow $SSHPORT  >/dev/null  2>&1 
				then
						checkflag=1
                        echo 'no server'
				fi 
        fi

		if [[ $checkflag -eq  0 ]]
		then
				printf "select =>\n 1>ssh \n 2>sftp \n 3>sshfs \n ==> "
				read choice
        	if [[ $choice -eq 1  ]]
        	then
        	        ssh -i $IDENTITY_KEY -o StrictHostkeychecking=no  -p $SSHPORT $host
        	elif [[ $choice -eq 2  ]]
        	then
        	        sftp -i $IDENTITY_KEY -o StrictHostkeychecking=no  -P $SSHPORT $host
        	elif (( choice == 3  ))
        	then
        	        if [[ ! -d ~/Desktop/phonefuse/ ]]
        	        then
        	                mkdir ~/Desktop/phonefuse
        	        fi
        	        sshfs -o IdentityFile=$IDENTITY_KEY -o StrictHostkeychecking=no  -p $SSHPORT $host:/sdcard/  ~/Desktop/phonefuse/
        	        pcmanfm ~/Desktop/phonefuse/ &
        	else
        	        echo "wrong choice!"
        	fi
		else
				echo 'exiting..'
		fi
}

phone_ssh
