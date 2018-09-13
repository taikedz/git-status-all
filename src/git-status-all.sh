#!/bin/bash

set -e

#%include out.sh colours.sh
#%include help.sh

STR_clean_tree="working (tree|directory) clean"

git-status() { (
	cd "$1"
	echo "${CYEL}$(dirname "$1")${CDEF}"
	git status  | sed -r "s/^(\t.+)$/${CBRED}\1${CDEF}/ ; s/^/\t/"
) ; }

is-clean() {
	if [[ ! "$*" =~ $STR_clean_tree ]]; then
		echo "$*"
		return 1
	fi
	return 0
}

git-verify() {
	if is-clean "$(git-status "$1")"; then
		return 0
	fi

    (
        out:error "Fix '$1'"
        cd "$1"
        bash
    )
}

main() {
    if [[ "$*" =~ --help ]]; then
        printhelp
        exit 0
    fi

    local target git_paths path
    git_paths=(:)

	if [[ -n "${1:-}" ]]; then
		git-verify "$1"
	else
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
