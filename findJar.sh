#!/bin/bash

#########################################################################################
#	The aim of this script is to locate needed jars, and even the files inside them
# 	Parameters 
#		<folder where to look for> <jar/file name>  
#	Example:
#		./findJar . abc.jar
#		./findJar . abcd.class
#########################################################################################

printf "Script began\n"
 
fileArray=( $(find $1 -name *.jar) )
 
printf "Total number of elements is "
echo ${#fileArray[@]}
 
printf "The elements of array are \n"
echo ${fileArray[@]} | tr " " "\n"
 
printf "\nLooking for a file ...\n"
 
for index in "${fileArray[@]}";
do
    if unzip -l $index | grep $2;
    then
        echo "$index";
    fi
done
