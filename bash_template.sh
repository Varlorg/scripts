#!/usr/bin/env bash

# ------------------------------------------------------------
# Script to <do some wonderful tasks>
# -----------------------------------------------------------

#-----------------------------------------------------------------------------
# CONSTANTS
#-----------------------------------------------------------------------------

# <explain what FOO is >
readonly FOO='bar'

# return values
readonly CONST_RETURN_CODE_NO_ERROR=0
readonly CONST_RETURN_CODE_INVALID_FOO=0
# Some more errors...

#-----------------------------------------------------------------------------
# FUNCTIONS
#-----------------------------------------------------------------------------

usage() {
	echo ""
	echo "*****************************************************************************"
	echo " FUNCTION"
	echo "   <do some wonderful tasks> "
	echo ""
	echo ""
	echo " OPTIONS"
	echo "   -h, --help : Display usage."
	echo ""
	echo ""
	echo " PARAMETERS"
	echo "   - 1   : <Something>."
	echo "   - 2   : <Something else>."
	echo ""
	echo ""
	echo " OUTPUT"
	echo "  None"
	echo ""
	echo ""
	echo " USAGE"
	echo "   sh $0 [OPTIONS] PARAMETERS"
	echo ""
	echo "   Examples"
	echo "   sh $0 -h"
	echo "   sh $0 ..."
	echo ""
	echo "*****************************************************************************"
	echo ""
}

#-----------------------------------------------------------------------------
# GET OPTIONS
#-----------------------------------------------------------------------------

while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do
	case $1 in
	-h | --help)
		usage
		exit $CONST_RETURN_CODE_NO_ERROR
		;;
	*)
		echo "[WARNING] Unknown option '$1' has been ignored"
		echo ""
		;;
	esac
	shift
done

if [[ "$1" == '--' ]]; then shift; fi

#-----------------------------------------------------------------------------
# GET PARAMETERS
#-----------------------------------------------------------------------------
FOO=$1
if [ -z "$FOO" ]; then
	>&2 echo "fatal : \`$FOO\` is not a valid FOO. Expected a FOO"
	exit $CONST_RETURN_CODE_INVALID_FOO
fi

#-----------------------------------------------------------------------------
# DEPENDANT CONSTANTS
#-----------------------------------------------------------------------------

# <explain what FOO is >
readonly DEPENDS_ON_FOO="$FOO/..."

#-----------------------------------------------------------------------------
# DEPENDANT FUNCTIONS
#-----------------------------------------------------------------------------

# Do the cleanup at the end of the script.
#
cleanup() {
	true
}

# Processing FOO
#
process_foo() {
	true
}

main() {
	process_foo
}

#-----------------------------------------------------------------------------
# SIGNAL HANDLERS
#-----------------------------------------------------------------------------
trap cleanup EXIT

#-----------------------------------------------------------------------------
# START PROCESSING
#-----------------------------------------------------------------------------

main
