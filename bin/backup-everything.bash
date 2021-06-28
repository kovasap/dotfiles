# Install from https://github.com/clockfort/GitHub-Backup, see
# https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token
# to make the token (first argument).
# FYI: This key is now invalid, need to fix in order to run.
~/GitHub-Backup/github-backup.py 2ce0f4ea839c0de8ac1c01f4e267660a1dedcced ~/backup_data/github/

# See https://www.howtogeek.com/451262/how-to-use-rclone-to-back-up-to-google-drive-on-linux/
# Need to run rclone config before this command can be used.
rclone copy --update --verbose --transfers 30 --checkers 8 --contimeout 60s --timeout 300s --retries 3 --low-level-retries 10 --stats 1s "googledrive:" ~/backup_data/google_drive/
