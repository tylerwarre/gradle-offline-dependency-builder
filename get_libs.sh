#!/bin/bash

rm -f ./missing.log

red="\e[31m"
yellow="\e[33m"
green="\e[32m"
reset_color="\e[0m"

libs=$(find ./mavenLocal/ -type d -links 2 -exec bash -c 'echo "${1/.\/mavenLocal\//}"' bash {} \;)
repos=("https://repo1.maven.org/maven2" "https://plugins.gradle.org/m2" "https://dl.google.com/dl/android/maven2") 
num_repos=${#repos[@]}

for lib in $libs
do 
	i=1
	for repo in "${repos[@]}"
	do	
		request=$(curl -s -k "$repo/$lib/" | grep -Po '(?s)(?<=<a href=").*?.(jar|pom)(?=")')
		if [[ $request ]];
		then
			fail=0
			for item in $request
			do
				curl -f -s -k -L -o "./mavenLocal/$lib/$item" "$repo/$lib/$item"
				if [[ $? -ne 0 ]];
				then
					echo -e "[${red}-${reset_color}] Couldn't download $repo/$lib/$item"
					echo "$lib/$item" >> missing.log
					fail=1
				fi
			done
			if [[ $fail -eq 0 ]];
			then
				echo -e "[${green}+${reset_color}] $repo/$lib"
			else
				echo -e "[${yellow}*${reset_color}] Downloaded with errors: $repo/$lib"
			fi
			break
		else
			echo -e "[${yellow}?${reset_color}] $repo/$lib"
		fi

		i=$((i+1))

		if [[ $i -gt $num_repos ]];
		then
			echo -e "[${red}-${reset_color}] Couldn't resolve $lib"
			echo "$lib" >> missing.log
		fi
	done
done

if [[ -f ./missing.log ]];
then
	echo -e "\n[${red}-${reset_color}] $(wc -l ./missing.log | cut -d " " -f 1) librarie(s) were unable to be resolved. Check missing.log"
fi
