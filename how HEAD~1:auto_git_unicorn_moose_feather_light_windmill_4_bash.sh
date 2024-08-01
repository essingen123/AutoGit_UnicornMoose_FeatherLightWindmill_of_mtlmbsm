[1mdiff --git a/auto_git_unicorn_moose_feather_light_windmill_4_bash.sh b/auto_git_unicorn_moose_feather_light_windmill_4_bash.sh[m
[1mindex 05b60b3..5f079bf 100755[m
[1m--- a/auto_git_unicorn_moose_feather_light_windmill_4_bash.sh[m
[1m+++ b/auto_git_unicorn_moose_feather_light_windmill_4_bash.sh[m
[36m@@ -132,7 +132,7 @@[m [mset303g=$("$homepage_githubpages_standard")[m
 set303h=index.html[m
 [m
 # 🌳 Branch to commit to, 'main' or a new branch name[m
[31m-set303j=master[m
[32m+[m[32mset303j=main[m
 [m
 # 💬 Default commit message (use ~date and ~data for auto-generated content)[m
 set303k=Automated ~date ~data[m
[36m@@ -251,20 +251,20 @@[m [mupdate_repo() {[m
     fun_echo "Homepage from kigit.txt: ${autogit_global_a[set303g]}" "🔍" 33[m
     fun_echo "Topics from kigit.txt: ${autogit_global_a[set303e]}" "🔍" 33[m
 [m
[31m-    # if gh repo edit "$repo_full_name" --description "${autogit_global_a[set303f]}" --homepage "${autogit_global_a[set303g]}" --add-topic "${autogit_global_a[set303e]//,/ --add-topic }"; then[m
[31m-    #     fun_echo "Updated GitHub repository: $repo_name" "🔄" 33[m
[32m+[m[32m    if gh repo edit "$repo_full_name" --description "${autogit_global_a[set303f]}" --homepage "${autogit_global_a[set303g]}" --add-topic "${autogit_global_a[set303e]//,/ --add-topic }"; then[m
[32m+[m[32m        fun_echo "Updated GitHub repository: $repo_name" "🔄" 33[m
 [m
[31m-    #     # Fetch and update local config if not forced[m
[31m-    #     local repo_data[m
[31m-    #     repo_data=$(gh repo view "$repo_full_name" --json description,homepageUrl,repositoryTopics --jq '.description + "|||" + .homepageUrl + "|||" + (.repositoryTopics | join(","))')[m
[31m-    #     IFS='|||' read -r fetched_description fetched_homepage fetched_topics <<< "$repo_data"[m
[32m+[m[32m        # Fetch and update local config if not forced[m
[32m+[m[32m        local repo_data[m
[32m+[m[32m        repo_data=$(gh repo view "$repo_full_name" --json description,homepageUrl,repositoryTopics --jq '.description + "|||" + .homepageUrl + "|||" + (.repositoryTopics | join(","))')[m
[32m+[m[32m        IFS='|||' read -r fetched_description fetched_homepage fetched_topics <<< "$repo_data"[m
 [m
[31m-    #     [[ ${autogit_global_a[set303f]} != force:* ]] && autogit_global_a[set303f]=$fetched_description[m
[31m-    #     [[ ${autogit_global_a[set303g]} != force:* ]] && autogit_global_a[set303g]=$fetched_homepage[m
[31m-    #     [[ ${autogit_global_a[set303e]} != force:* ]] && autogit_global_a[set303e]=$fetched_topics[m
[31m-    # else[m
[31m-    #     fun_echo "Failed to update GitHub repository" "❌" 31[m
[31m-    # fi[m
[32m+[m[32m        [[ ${autogit_global_a[set303f]} != force:* ]] && autogit_global_a[set303f]=$fetched_description[m
[32m+[m[32m        [[ ${autogit_global_a[set303g]} != force:* ]] && autogit_global_a[set303g]=$fetched_homepage[m
[32m+[m[32m        [[ ${autogit_global_a[set303e]} != force:* ]] && autogit_global_a[set303e]=$fetched_topics[m
[32m+[m[32m    else[m
[32m+[m[32m        fun_echo "Failed to update GitHub repository" "❌" 31[m
[32m+[m[32m    fi[m
     # Update repo details[m
     if gh repo edit "$repo_full_name" --description "${autogit_global_a[set303f]}" --homepage "${autogit_global_a[set303g]}"; then[m
         fun_echo "Updated GitHub repository details: $repo_name" "🔄" 33[m
[36m@@ -299,7 +299,7 @@[m [mupdate_repo() {[m
     fun_echo "Updated GitHub repository topics" "🏷️" 33[m
 [m
     # Push the latest changes to the remote branch[m
[31m-    local branch=${autogit_global_a[set303j]:-master}[m
[32m+[m[32m    local branch=${autogit_global_a[set303j]:-main}[m
     git push origin "$branch" --force[m
     if [[ $? -ne 0 ]]; then[m
         fun_echo "Failed to push the latest changes to the remote branch. Please check the branch and try again." "⚠️" 33[m
[36m@@ -314,7 +314,7 @@[m [mupdate_repo() {[m
 [m
 # Ensure the correct branch with style[m
 ensure_branch() {[m
[31m-    local branch=${autogit_global_a[set303j]:-master}[m
[32m+[m[32m    local branch=${autogit_global_a[set303j]:-main}[m
     if ! git rev-parse --verify "$branch" &>/dev/null; then[m
         git checkout -b "$branch"[m
         fun_echo "Created and switched to new branch: $branch" "🌿" 32[m
[36m@@ -358,13 +358,13 @@[m [mEOL[m
 [m
 # Sync changes with GitHub in style[m
 sync_repo() {[m
[31m-    local commit_msg=${autogit_global_a[set303k]//\~date/$(date '+%Y%m%d%H%M%s')}[m
[32m+[m[32m    local commit_msg=${autogit_global_a[set303k]//\~date/$(date '+%Y%m%d-%H')}[m
     commit_msg=${commit_msg//\~data/$(git status --porcelain | wc -l) files changed}[m
     git add . && git commit -m "$commit_msg" || true[m
     if ! git remote | grep -q '^origin$'; then[m
         git remote add origin "https://github.com/$repo_full_name.git"[m
     fi[m
[31m-    git push -u origin "${autogit_global_a[set303j]:-master}"[m
[32m+[m[32m    git push -u origin "${autogit_global_a[set303j]:-main}"[m
     fun_echo "Changes synced with GitHub!" "🌍" 32[m
 }[m
 [m
[36m@@ -424,7 +424,7 @@[m [mdef check_github_pages(repo_name, token):[m
 [m
 def setup_github_pages(repo_name, token):[m
     headers = {'Authorization': f'token {token}', 'Accept': 'application/vnd.github.v3+json'}[m
[31m-    data = {'source': {'branch': 'master', 'path': '/'}}[m
[32m+[m[32m    data = {'source': {'branch': 'main', 'path': '/'}}[m
     response = requests.post(f'https://api.github.com/repos/{repo_name}/pages', headers=headers, json=data)[m
     if response.status_code == 201:[m
         print('GitHub Pages has been set up.')[m
