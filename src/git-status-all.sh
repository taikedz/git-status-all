#!/bin/bash

set -e

#%include out.sh colours.sh abspath.sh
#%include help.sh

STR_clean_tree="working (tree|directory) clean"
: ${GITSA_shell=false}

git-status() { (
	cd "$1"
	echo "${CYEL}$1${CDEF}"
	git status  | sed -r "s/^(\t.+)$/${CBRED}\1${CDEF}/ ; s/^/\t/"
) ; }

is-clean() {
	if [[ ! "$*" =~ $STR_clean_tree ]]; then
		if cleaning-mode ; then
            echo "$*"
        fi
		return 1
	fi
	return 0
}

cleaning-mode() {
    [[ "$GITSA_shell" = true ]]
}

git-verify() {
	if is-clean "$(git-status "$1")"; then
		return 0
	fi

    if cleaning-mode; then
    (
        out:error "Fix '$1'"
        cd "$1"
        bash
    )
    else
        out:error "$1"
    fi
}

main() {
    if [[ "$*" =~ --help ]]; then
        printhelp
        exit 0
    fi

    local target git_paths path script
    git_paths=(:)

	if [[ -n "${1:-}" ]]; then
        if [[ -d "$1/.git" ]]; then
    		git-verify "$1"

        elif [[ -d "$1" ]]; then
            script="$(abspath:path "$0")"
            (cd "$1" ; bash "$script")

        else
            out:fail "Invalid target '$1'"
        fi
	else
        if ! cleaning-mode; then
            out:info "Cleaning mode is off - no subshell will spawn. Set GITSA_shell=true to enable it"
        fi

        # 2-passes
        # We want to potentially open subshells;
        # to prevent these from inheriting piped input from find
        # we process them in a second pass

		while read target; do
			git_paths[${#git_paths[@]}]="$(dirname "$target")"
		done < <(find "$PWD" -name '.git' -type d)

        for path in "${git_paths[@]:1}"; do
			bash "$0" "$path" || out:error "$path"
        done
	fi
}

main "$@"
