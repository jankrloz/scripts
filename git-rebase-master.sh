#!/usr/bin/bash


set -e -u;
export PROMPT_EOL_MARK='';

echo "Fetching changes ..."
git fetch origin master;

uncommited_changes=$(git status --porcelain)
if [[ $uncommited_changes ]]; then
    echo "Uncommited changes ..."
    echo "Adding all ..."
    git add --all;
    commit=$(git log origin/master..HEAD --pretty=format:"%h" | tail -n 1);
    if [[ -z "$commit" ]]; then
        echo "Commiting changes ..."
        git commit -a;
    else
        echo "Fixing up changes ..."
        git commit -a --fixup $commit;
    fi
fi

echo "Rebasing ..."
git rebase --continue 2> /dev/null || git rebase -i origin/master --autosquash;

current_branch="$(git rev-parse --abbrev-ref HEAD)";
remote_name="$(git remote | head -1)";
while true; do
    echo -n "Push changes to $remote_name/$current_branch ? [y/n] : " 
    read -r yn
    case $yn in
        [Yy]* ) git push -u $remote_name $current_branch --force-with-lease; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
