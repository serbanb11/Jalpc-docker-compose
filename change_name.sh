#!/bin/bash
#A script to enumerate local information from a Linux host

#help function
usage() 
{ 
echo -e "\n\e[00;31m#########################################################\e[00m" 
echo -e "\e[00;31m#\e[00m" "\e[00;33mChange domain name\e[00m" "\e[00;31m#\e[00m"
echo -e "\e[00;31m#########################################################\e[00m"
echo -e "\e[00;33m# Example: ./LinEnum.sh example.com \e[00m"
echo -e "\e[00;31m#########################################################\e[00m"		
}

if [ $(( $# - $OPTIND )) -lt 0 ]; then
    usage
    exit 1
fi

if [ ! -d "Jalpc" ]; then
    echo "First clone Jalpc project: git clone https://github.com/jarrekk/Jalpc.git"
    exit 1
fi

ARG=${@:$OPTIND:1}

regex='.*\..*\..*'
[[ ! $ARG =~ $regex ]] && (echo "domain name should be CNAME, eg www.example.com"; exit 1)

sed -i -- "s|url: https.*|url: https://$ARG/|g" Jalpc/_config.yml
sed -i -- "s|baseurl:.*|#baseurl: /|g" Jalpc/_config.yml
sed -i -- "s/www.yourdomain.com/$ARG/g" nginx-lets-encrypt/nginx.conf
sed -i -- "s/yourdomain.com/${ARG#*.}/g" nginx-lets-encrypt/nginx.conf
sed -i -- "s|https://$host$request_uri;|https://www.test.com$request_uri;|g" nginx-lets-encrypt/nginx.conf
echo $ARG > Jalpc/CNAME

echo -e "\e[00;33m### CHANGE COMPLETE ####################################\e[00m"
