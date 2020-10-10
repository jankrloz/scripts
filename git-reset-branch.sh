#!/usr/bin/bash

if [ $# -eq 0 ]; then 
    echo "Use: ./script.sh [-t <target_branch> [-s <source_branch>]]"; 
    exit 1; 
fi

while test $# -gt 0; do
   case "$1" in
    -t)
        shift
        target_branch=$1
        shift
        ;;
    -s)
        shift
        source_branch=$1
        shift
        ;;
    *)
       echo "Use: ./script.sh [-t <target_branch> [-s <source_branch>]]"
       return 1;
       ;;
  esac
done  

if [ -z "$target_branch" ]; then
    echo "Provide a target branch";
    exit 0;
fi

current_branch="$(git rev-parse --abbrev-ref HEAD)";
if [ -z "$source_branch" ]; then
    source_branch=$current_branch
fi

echo "Reset $target_branch as $source_branch ? (y/n)";
read i
if [ "$i" = "y" ]; then
    git checkout $target_branch;
    git reset --hard $source_branch;
    git checkout $current_branch;
fi

echo "Push $target_branch ? (y/n)";
read i
if [ "$i" = "y" ]; then
    git checkout $target_branch;
    git push -f --no-verify;
    git checkout $current_branch;
fi