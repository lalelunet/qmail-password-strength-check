# qmail-password-strength-check

Read out vpasswd files from vpopmail and check the strength from the user passwords. Weak passwords you will find in the log file after the scan.

## Usage

qmail_password_check.sh /path/to/vpasswd-file /path-to-logfile(optional) -a(append log optional)

If no log path is defined the log will be created in /root. The name from the log file will be /root/qmail_passwd_check_DOMAIN.log. Domain is the Domain name from the vpasswd file.

To read password files from all domains you can use a one line bash script like this

```sh

for file in `find /home/vpopmail/domains/ -maxdepth 2 -name vpasswd`; do /root/password-check/qmail_password_check.sh $file /root/password-check/logfile.txt -a; done

```

Please note the -maxdepth 2 parameter. This will speed up the search but means that if vpopmail is using directory caching you are only scanning domains in the domains directory itself. Domains in 0,1,2,3... subdirectories not will not be considered. It can be faster to run the command with each subdirectory manual than run a find over all files. IT depands of how many billions of emails you store on your server :)

```sh

for file in `find /home/vpopmail/domains/1/....
for file in `find /home/vpopmail/domains/2/....
for file in `find /home/vpopmail/domains/3/....

```

Please also note the /root/password-check/logfile.txt -a in the example. This will append all domains in 1 logfiles instead of creating a logfile for each domain. This is useful if you host a lot of domains.. ;)


## Requirements

vpopmail has to be compiled without the --disable-clear-passwd flag to store passwords in plain text.

cracklib-runtime and cracklib2 has to be installed on your system.
