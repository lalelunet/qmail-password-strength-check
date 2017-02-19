#!/bin/bash
#
# Latest script version and documentation
# https://github.com/lalelunet/qmail-password-strength-check
#

set -e

clc=$(command -v cracklib-check) || true;
if [ -z "$clc" ]
	then
		echo "cracklib-runtime and cracklib2 is necessary to use this script.";
		echo "Please check the docs from your system on how to install it.";
		exit 0;
fi

# simple check if the given file exists
if ! ( [ "${1+x}" ] && [ -f "$1" ] )
	then
	echo "Log file not found.";
	echo "Usage: qmail_passwd_check.sh path-to-vpasswd-file [path-to-result-file [-a] ]";
	exit 0;
fi

echo "vpasswd file found.";

# check if vpopmail is using directory hashing
re='^[0-9]+$';
domain=`cat "$1" | head -n1 | cut -d ':' -f6 | cut -d '/' -f5`;

if ! [[ "$domain" =~ "$re" ]] ;
	then
		domain=`cat "$1" | head -n1 | cut -d ':' -f6 | cut -d '/' -f6`;
fi

# should we use a specific log file and can we create it?
if [ "$2" ]
	then
		touch "$2" > /dev/null 2>&1 || true;
		if [ -f "$2" ]
			then
				log="$2";
			else
				echo "Please check the path to the log file. $2 is not a valid path";
				exit 1;
		fi
	else
		log="/root/qmail_passwd_check_$domain.log";
fi

echo "Logging to $log";

# should we append log infos to the log file or create a new one?
if ( [ "$3" ] && [ "$3" == '-a' ] )
then
	echo "" >> "$log"
else
	echo "" > "$log"
fi
echo "Creating new log for $domain `date`" >> "$log"
echo "" >> "$log"
echo "Processing $1 ..."

# the real magic starts here
while read l; do
	passwd=`echo "$l" | cut -d ':' -f 8`;
	user=`echo "$l" | cut -d ':' -f 1`;
	result=`echo "$passwd" | "$clc"`;

	if ! [[ "$result" =~ " OK"  ]]
		then
		echo "$user@$domain: $result" >> "$log";
	fi
done <"$1"

echo 'Processing done. Wish you a nice day!';

exit 0
