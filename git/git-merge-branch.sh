#!/usr/bin/bash

set -e;
export PROMPT_EOL_MARK='';

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

echo "Merge $source_branch into $target_branch ? (y/n)";
read i
if [ "$i" = "y" ]; then
    git checkout $target_branch;
    git fetch origin $target_branch
    git reset --hard origin/$target_branch
    git merge --continue 2> /dev/null || git merge $source_branch;
    bash ./git-rebase-master.sh;
    git checkout $current_branch;
elif [ "$i" = "n" ]; then
    exit 0;
fi
