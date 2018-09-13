# Git Status All (Shell)

A shell script that recurses down the current directory to find all git repositores.

If the status does not contain `working tree clean`, it is marked as needing attention.

If the environment variable `GITSA_shell=true` is set, a new interactive shell is started for you to perform cleanup on each repo. Once you have cleaned up the repo, exit the subshell, and the script will continue.

Examples

    # List all repos that need attention under current working directory
    git-status-all.sh

    # Step through each repo that needs attention, opening a shell for each
    GITSA_shell=true git-status-all.sh

    # Check a single repo, or recurse through the repos of the target directory for checking
    git-status-all.sh some-dir/
