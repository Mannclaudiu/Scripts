#/bin/bash

####################################################################
# The aim of this script is to switch branches of AS*/CM projects 
# to master or adp-main
# How to use:
#   ./gitSwitchBranch
####################################################################

# Add all AS* folders to array
dirArray=(*AS*)
# Add CM to array
#dirArray+=("CM")

# Check the number of folders
printf 'The total number of folders is %d\n\n' "${#dirArray[@]}"
# Check the folders
printf 'The folders are:\n' 
echo ${dirArray[@]} | tr " " "\n"

# empty array used to keep the current branch
branchArray=()

# iterate over all directories
for index in "${!dirArray[@]}";
do
  # enter in directory
  cd ${dirArray[index]}
  # display directory on screen
  printf '\n%s\n' "${dirArray[index]}"
  # clean the branch and redirect the output (I don't want it on screen)
  git clean -fdx > /dev/null
  # reset branch, because I want to be able to switch the branches
  git reset --hard > /dev/null
  # first switch on master because not all projects have adp-main
  git checkout master > /dev/null
  # second switch on adp-main for the projects who have it
  # if projects don't have this branch, they will stay on master (easy way)
  git checkout adp-main > /dev/null
  # pull latest changes
  git pull > /dev/null
  # store current branch to variable
  currBranch=`git rev-parse --abbrev-ref HEAD`
  # store the folder name together with current branch, and display aligned results
  listBranch=$(printf %-20s%-20s "${dirArray[index]}" "$currBranch")
  # put the string in array
  branchArray+=("$listBranch")
  # leave the directory
  cd ..
done

# iterate over array
for index in "${!branchArray[@]}";
do
  # display the results
  printf '%s\n' "${branchArray[index]}" 
done
