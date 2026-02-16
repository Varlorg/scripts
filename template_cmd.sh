#!/usr/bin/env bash
# script to launch function as cmd, ex ./template_cmd.sh <my_func>

###################
# Variables       #
###################

SCRIPT_FULLPATH="$(realpath "${BASH_SOURCE[-1]}")"
readonly SCRIPT_FULLPATH
SCRIPT_DIR="$(dirname "$SCRIPT_FULLPATH")"
readonly SCRIPT_DIR

# Public functions pattern
# all expect the ones starting by '_'
# pattern: ^<funtion_name>(){
readonly FUNCTION_PATTERN='^[^_][[:graph:]]*()\s*{'

######################
# Internal Functions #
######################
_internal_fct() {
	echo "Call only form inside the script"
}

####################
# Public Functions #
####################

# default default_action
default_action() {
	echo "Default action when no argument given"
}

###################
# Generic script  #
###################

# Help command
usage() {
	echo "Usage: $0 <command>"
	echo "Commands availables:"
	# Display the functions matching the pattern
	# Print the line before as description
	grep -B1 "${FUNCTION_PATTERN}" "$0" |
		sed -e 's/()\s*{//' \
			-e 's/^#\s*//' \
			-e '/--/d' |
		awk '{a=$0; getline; print $0";"a}' |
		column -t -s ';'
}

# Script is being run directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
	if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
		usage
		exit 0
	fi
	if [ -z "$1" ]; then #Default action when no argument given
		default_action
	else
		# Allow command only the function matching the pattern
		INTERNAL_FUNCTIONS=$(grep "${FUNCTION_PATTERN}" "$0" |
			sed -e 's/()\s*{//' -e '/--/d')

		echo "${INTERNAL_FUNCTIONS}" | grep -e "^$1$" >/dev/null ||
			{
				echo "$1: Bad command"
				usage
				exit 1
			}

		# shellcheck disable=SC2068 # splitting elements is wanted
		$@
	fi
fi
