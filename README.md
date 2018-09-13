# Git Status All (Shell)

A shell script that recurses down the current directory to find all git repositores. If the status does not contain `working tree clean`, a new interactive shell is started for you to perform cleanup. Once you have cleaned up the repo, exit the subshell, and the script will continue.
