#! /bin/bash

read -p "Enter branches: " branches
read -p "Enter assignee email: " assignee

current_branch=$(git branch --show-current)
last_commit_hash=$(git log --format="%H" -n 1)
last_commit_subject=$(git log --format="%s" -n 1)

echo "Cherry-picking commit - ($last_commit_subject : $last_commit_hash)"
echo "To branches : ${branches}"
echo "Assigned to : ${assignee}"


`git fetch --all`

for branch in ${branches}
do
	echo "************************************* START *************************************"
	echo "Starting process for branch - $branch"

	temp_branch="${branch}-${last_commit_hash}"
	`git checkout -b ${temp_branch} origin/${branch}`
	`git cherry-pick ${last_commit_hash}`
	`git push --set-upstream origin ${temp_branch} -o merge_request.create -o merge_request.remove_source_branch -o merge_request.title="${last_commit_subject}" -o merge_request.assign="${assignee}" -o merge_request.target="${branch}"`
	`git checkout ${current_branch}`
	`git branch -D ${temp_branch}`

	echo "MR rasied for branch - $branch - "
	echo "************************************* END *************************************"
done

# 1. Get last log hash -> git log --format="%H" -n 1
# 2. Get last log subject -> git log --format="%H" -n 1
# 3. Git fetch all -> git fetch --all
# 4. git checkout -b <random-new-branch-name> origin/<branch-against>
# 5. cherrypick
# 6. Raise MR



# chmod +x /usr/local/bin/myscript
# cp ~/Documents/myscript.sh /usr/local/bin/myscript
