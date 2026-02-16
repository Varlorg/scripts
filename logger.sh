# color info https://misc.flogisoft.com/bash/tip_colors_and_formatting
# logger functions

: "${LOG_PREFIX:=date --iso-8601=ns}"

COLOR_RED="\e[1;91m"
COLOR_GREEN="\e[1;92m"
COLOR_YELLOW="\e[1;93m"
COLOR_BLUE="\e[1;94m"
COLOR_MAGENTA="\e[1;95m"
COLOR_CYAN="\e[1;96m"
COLOR_CLEAR="\e[0m"

# Define log levels
LOG_LEVEL_ERROR=0
LOG_LEVEL_WARN=1
LOG_LEVEL_INFO=2
LOG_LEVEL_DEBUG=3
LOG_LEVEL_TRACE=4

# Set current log level
CURRENT_LOG_LEVEL=$LOG_LEVEL_DEBUG

# Define color codes
COLOR_RESET='\e[0m'
COLOR_ERROR='\e[91m' # Light Red
COLOR_WARN='\e[93m'  # Light Yellow
COLOR_INFO='\e[96m'  # Light Cyan
COLOR_DEBUG='\e[92m' # Light Green
COLOR_TRACE='\e[95m'
ONLY_CATEGORY=''
ONLY_CATEGORY=$COLOR_RESET

log_info() {
	echo -e "[${COLOR_BLUE}INFO${COLOR_CLEAR}] $*"
}

log_warn() {
	echo -e "[${COLOR_YELLOW}WARN${COLOR_CLEAR}] $*"
}

log_error() {
	echo -e "[${COLOR_RED}ERROR${COLOR_CLEAR}] $*" >&2
}

log() {
	local log_message=$1
	local log_level=$2

	if [ "$log_level" -le "$CURRENT_LOG_LEVEL" ]; then
		echo -n "$(eval "$LOG_PREFIX")"
		case $log_level in
		"$LOG_LEVEL_ERROR") echo -e "${COLOR_ERROR}[ERROR]${ONLY_CATEGORY}  $log_message${COLOR_RESET}" >&2 ;;
		"$LOG_LEVEL_WARN") echo -e "${COLOR_WARN}[WARN]${ONLY_CATEGORY}  $log_message${COLOR_RESET}" ;;
		"$LOG_LEVEL_INFO") echo -e "${COLOR_INFO}[INFO]${ONLY_CATEGORY}  $log_message${COLOR_RESET}" ;;
		"$LOG_LEVEL_DEBUG") echo -e "${COLOR_DEBUG}[DEBUG]${ONLY_CATEGORY}  $log_message${COLOR_RESET}" ;;
		"$LOG_LEVEL_TRACE") echo -e "${COLOR_TRACE}[TRACE]${ONLY_CATEGORY}  $log_message${COLOR_RESET}" ;;
		esac
	fi
}

log2error() {
	log "$*" $LOG_LEVEL_ERROR
}
log2info() {
	log "$*" $LOG_LEVEL_INFO
}
log2warn() {
	log "$*" $LOG_LEVEL_WARN
}
log2debug() {
	log "$*" $LOG_LEVEL_DEBUG
}
log2trace() {
	log "$*" $LOG_LEVEL_TRACE
}

## Usage
#log "An error occurred." $LOG_LEVEL_ERROR
#log "This is a warning." $LOG_LEVEL_WARN
#log "Some info." $LOG_LEVEL_INFO
#log "Debug message." $LOG_LEVEL_DEBUG
