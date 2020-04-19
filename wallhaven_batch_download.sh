#!/bin/bash

function choosemode
{
	read search_or_other
	case $search_or_other in
	1)

		;;
	2)

		;;
	*)
		echo -e "\033[31m Error input,Please try it again.\033[0m"
		choosemode
		;;
	esac
}

function input_and_check_website
{	
	read iweb  # input website
	echo -e "\033[32m If you wanna download wallpaper from Search input 1 otherwise input 2 (for example: Latest,Toplist,Random) \033[0m"	
	choosemode
	echo -e "\033[32m How many wallpaper pages you wanna download? \033[0m"	
	read wdpn #wanna download pages number
	# wget --spider when invoked with this option, wget will behave as a web spider, which means that it will not download the pages, just check that they are there
	wget --spider "$iweb" 2>/dev/null >>/dev/null
	if [ $? -ne 0 ];
	then
		echo "Input website is invaild, please try it again:"
		input_and_check_website
	fi
}

function href_list_from_search
{
	for((page=1;page<=wdpn;page++));
	do
	curl -s $iweb&page=$page | grep -o 'href=\"https:\/\/wallhaven.cc\/w\/[^"]*"'| sed 's/href=\"\(.*\)"/\1/g' >> ${dltf[0]}
	allcwn=`sed -n '$=' ${dltf[0]}` # all collected wallpaper number
	done
}

function href_list_from_other
{
	for((page=1;page<=wdpn;page++));
	do
	curl -s $iweb?page=$page | grep -o 'href=\"https:\/\/wallhaven.cc\/w\/[^"]*"'| sed 's/href=\"\(.*\)"/\1/g' >> ${dltf[0]}
	allcwn=`sed -n '$=' ${dltf[0]}` # all collected wallpaper number
	done
}
	

function download_wallpaper_from_search
{
	echo
	echo -e "\033[32m Please input a website of wallhaven . \033[0m"
	echo -e "\033[32m Such as https://wallhaven.cc/search?q=xxxxxxx . \033[0m"	
	input_and_check_website
	# href list 
	if [ $search_or_other -eq 1 ];
	then
		href_list_from_search
	else
		href_list_from_other
	fi
	fwn=0 # first wallpaper number
	IFSOURCE=$IFS
	IFS=$'\n'
	printf "Analysing... %2d/%2d" $fwn $allcwn
	for web in `cat ${dltf[0]}`
	do
		((fwn++))
	curl -s $web | grep -o  '<img id="wallpaper" src="https://w.wallhaven.cc/[^"]*"'| sed  's/.*src=\"\(.*\)\"/\1/g' >> ${dltf[1]}
		printf "\b\b\b\b\b%2d/%2d" $fwn $allcwn
	done 
	# Start Download
	echo 
	echo 
	cat -n ${dltf[1]}
	echo
	echo
	for dweb in `cat ${dltf[1]}`
	do
		cwef=`echo "$dweb" | grep -o "wallhaven-.*" ` # compare with existed file 
		if [ -f $cwef ];
		then 
			echo -e "\033[33m $cwef is existed \033[0m"
			continue
		else
		echo -e "\033[35m Downloading: $dweb \033[0m"
		wget -q  --show-progress $dweb 
		echo -e "\033[32m $dweb Download Successed \033[0m"
		echo 
		fi
	done
	echo -e "\033[32m All Download sucessed Bye~ \033[0m"
	rm -rf "$dltd"

}




echo 
echo -e "\033[32m ############################################################# \033[0m"
echo -e "\033[32m # wallhaven one key downloader				     # \033[0m"
echo -e "\033[32m # Author: lexssama	 				     # \033[0m"
echo -e "\033[32m # Github: https://github.com/LEXSSAMA/Shell-Script-Practice # \033[0m"
echo -e "\033[32m # Blog  : https://lexssama.github.io/			     # \033[0m"
echo -e "\033[32m #############################################################\033[0m"
dir="wallpaper"
# make a directory
if [ ! -d "$dir" ];
then 
	mkdir "$dir"
fi
chmod 777 "$dir"
cd "$dir"
ndir=`pwd` # The directory we are in 
#temp file
rnum=$RANDOM
dltd="${ndir}/.wallpaper-temp-directory-$rnum" #download temp directory
dltf=("${dltd}/allweb" "${dltd}/name") #download temp file 
if [ ! -d "$dltd" ];
then 
	mkdir "$dltd"
fi
chmod 777 "$dltd"
# start
download_wallpaper_from_search
