#!/bin/bash

###############################################################################################
# This script is used in order to sign the jars 
# just move this script in the location where the jars that need to be signed are, and run it.
# input : unsigned jar
# output : signed jar
# How to run it
#   ./signJars.sh .
###############################################################################################

# the jar signer credentials
JSIGNER="/usr/java/jdk1.6.0_18/bin/jarsigner -sigalg SHA256withRSA -digestalg SHA-256"
AS_CERTSTORE="path/tp/secstore"
AS_CERTPASS="<password> -keypass <keypass>"
AS_CERTALIAS="<certalias>"

#add all the jars in current folder into an array
jarArray=(*.jar)

printf "The total number of jars is "
echo ${#jarArray[@]}
printf "The jars are \n"
echo ${jarArray[@]} | tr " " "\n"

# this is the name of signed jar
signedJar="S.jar"

# Some jars have other signatures, which need to be deleted
printf "\nDeleting existing signatures\n"
for index in "${!jarArray[@]}";
do
    zip -d ${jarArray[index]} "META-INF/*.RSA" "META-INF/*.SF" "META-INF/*.rsa" "META-INF/*.sf"
done
printf "Signatures deleted !\n\n"

printf "Signing the jars \n"
for index in "${!jarArray[@]}";
do

    # this script takes 2 parameters:
    # $1 the name of the signed jar (output file)
    # $2 the name of the unsigned jar (input file)
    # so, we add as input let's say cache.jar ($2) and receive as output S.jar ($1)
    $JSIGNER -keystore $AS_CERTSTORE -storepass $AS_CERTPASS -signedjar $signedJar ${jarArray[index]} $AS_CERTALIAS
    
    printf 'Jar %s signed!\n' "${jarArray[index]}"
    
    # replace the unsigned (cache.jar) jar with the signed jar (S.jar)
    mv $signedJar ${jarArray[index]}

done
