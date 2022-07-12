#!/bin/bash

# Get token at https://github.com/settings/tokens/new
mkdir github-repos
cd github-repos
curl -s -H "Authorization: token YOUR_TOKEN_HERE" "https://api.github.com/user/repos?per_page=100" | jq -r ".[].ssh_url" | xargs -L1 git clone
cd ~/

# See https://www.howtogeek.com/451262/how-to-use-rclone-to-back-up-to-google-drive-on-linux/
# Need to run rclone config before this command can be used.
# rclone copy --update --verbose --transfers 30 --checkers 8 --contimeout 60s --timeout 300s --retries 3 --low-level-retries 10 --stats 1s "googledrive:" ~/backup_data/google_drive/

# grive -fP
