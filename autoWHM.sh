#!/bin/bash

INSTALLER_VERSION="1.0"
MD5_CHECKSUM="23cbe42f946382e52f5a5bc869eafcdf"
AUTHOR="Rizal Fakhri"
FILE_OPT="/bin/bash"



function sprout() {
  count=0
  total=34
  pstr="[#######################################################################]"

  while [ $count -lt $total ]; do
    sleep 0.1 # this is work
    count=$(( $count + 1 ))
    pd=$(( $count * 73 / $total ))
    printf "\r%3d.%1d%% %.${pd}s" $(( $count * 100 / $total )) $(( ($count * 1000 / $total) % 10 )) $pstr
  done
}

function verify() {
  echo -e "\e[34m Verifying Checksum ...."
  sprout 5
  echo -e "\e[0m"
  MD5=`md5sum autoWHM.sh | cut -c 1-32`
  if [ $MD5 == $MD5_CHECKSUM ]; then
    echo -e "Checksum verified!"
  else
    echo "Verify checksum failed!"
  fi
}

function install() {
  cd
  cd /home && curl -o latest -L https://securedownloads.cpanel.net/latest && sh latest
}

function showip() {
  curl -s http://myip.dnsomatic.com
}



# Display welcome messages!
clear
echo -e "\e[31m|-----------------------------[\e[96mAutoWHM Installer\e[0m\e[31m]------------------------------|\e[0m"
echo -e "\e[31m|                                                                              |\e[0m"
echo -e "\e[31m|  #####      ##     #####   #####     #####     #######       #######         |\e[0m"
echo -e "\e[31m|   #####    ####   #####    #####     #####     #### ###     ### #### \e[96m{V.1.0}\e[0m\e[31m |\e[0m"
echo -e "\e[31m|    ##### ### ### #####     ###############     ####  #### ####  ####         |\e[0m"
echo -e "\e[31m|     ######## ########      ###############     ####   ########  ####         |\e[0m"
echo -e "\e[31m|      ######   ######       #####     #####     ####    ######   ####         |\e[0m"
echo -e "\e[31m|       ####     ####        #####     #####     ####     ####    ####         |\e[0m"
echo -e "\e[31m|                                                                              |\e[0m"
echo -e "\e[31m|                                                       \e[96m (c) 2016 Rizal Fakhri \e[0m\e[31m|\e[m"
echo -e "\e[31m|------------------------------------------------------------------------------|\e[0m"
echo -e "\e[34m Verifying You Are Root ...."
sprout
echo -e "\e[0m"
if [[ $EUID -ne 0 ]]; then
   echo -e "\e[41mERROR! You are not root! Installation aborted!\e[0m" 1>&2
   exit 1
fi

#root & verify checksum

#checksum verified

echo -e "\e[46m*Setting Up Your WHM Installation\e[0m"
read -p "Set Your hostname (EX: s1.domain.com) : " hostname
while [[ $hostname == "" ]]; do
  echo -e "\e[41mHostname can't be empty!\e[0m"
  read -p "Set Your hostname (EX: s1.domain.com) : " hostname
done
unset PASSWORD
unset CHARCOUNT
echo -n "Set Your WHM Password : "
stty -echo
CHARCOUNT=0
while IFS= read -p "$PROMPT" -r -s -n 1 CHAR
do
    # Enter - accept password
    if [[ $CHAR == $'\0' ]] ; then
        break
    fi
    # Backspace
    if [[ $CHAR == $'\177' ]] ; then
        if [ $CHARCOUNT -gt 0 ] ; then
            CHARCOUNT=$((CHARCOUNT-1))
            PROMPT=$'\b \b'
            PASSWORD="${PASSWORD%?}"
        else
            PROMPT=''
        fi
    else
        CHARCOUNT=$((CHARCOUNT+1))
        PROMPT='*'
        PASSWORD+="$CHAR"
    fi
done
stty echo
echo \n

read -r -p "Are you sure? [y/N] : " response
case $response in
    [yY][eE][sS]|[yY])
        hostname $hostname
        echo root:$PASSWORD | chpasswd
        install
        ;;
    *)
        echo -e "\e[41mInstallation aborted by user!\e[0m"
        ;;
esac

echo -e "\e[31m|---------------------------[\e[96mINstallation Complete\e[0m\e[31m]-----------------------------|\e[0m"
echo -e "\e[31m|                                                                              |\e[0m"
echo -e "\e[31m|  +-----------------[Your WHM Details]-----------------+                      |\e[0m"
echo -e "\e[31m|  |     WHM Address    |   https://$(showip):2087  |                    |\e[0m"
echo -e "\e[31m|  ------------------------------------------------------                      |\e[0m"
echo -e "\e[31m|  |     WHM Username   |             root              |                      |\e[0m"
echo -e "\e[31m|  -----------------------------------------------------                       |\e[0m"
echo -e "\e[31m|  |     WHM Password   |       $PASSWORD           |                      |\e[0m"
echo -e "\e[31m|  +----------------------------------------------------+                      |\e[0m"
echo -e "\e[31m|                                                                              |\e[0m"
echo -e "\e[31m|    This maybe not real result of your WHM installation!.                     |\e[0m"
echo -e "\e[31m|    Your installation may failed if your server is not fresh                  |\e[0m"
echo -e "\e[31m|    So make sure your VPS is FRESH!                                           |\e[0m"
echo -e "\e[31m|-------------------------------[THANK YOU]------------------------------------|\e[0m"
