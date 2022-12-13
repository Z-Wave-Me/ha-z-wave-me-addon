#!/usr/bin/with-contenv bashio

echo "===================================CUSTOM COLORIZE LOG START========================================="

BLACK='\o033[0;30m'
RED__='\o033[0;31m' # Critical
GREEN='\o033[0;32m' # Information
BROWN='\o033[0;33m' # Warning
BLUE_='\o033[0;34m' # -z [1]
PURPL='\o033[0;35m' # custom text
CYAN_='\o033[0;36m' # Debug
LGRAY='\o033[0;37m'
DGRAY='\o033[1;30m'
L_RED='\o033[1;31m' # Error
LGREN='\o033[1;32m' # -z [2]
YELLW='\o033[1;33m' # -z [3]
LBLUE='\o033[1;34m' # Receiving
LCYAN='\o033[1;35m' # Sending
LPRPL='\o033[1;36m' # -z [4]
WHITE='\o033[1;37m' # -z [5]
NC='\o033[0m'

zwayNamesColors=("${BLUE_}" "${LGREN}" "${YELLW}" "${LPRPL}" "${WHITE}")

# Defaults
tail="cat" # default
tail_param="" # default
file="-" # stdin
less="cat" # default
timestampRewriteCmd="cat" # default
timestampRewriteParam="-" # default
delta=0
sending="${__BASHIO_COLORS_CYAN}"
received="${__BASHIO_COLORS_CYAN}"
communicationsColorize=''
removeLines=''
zwayNamesColorize=''
zwayNamesColorsIndex=0

processing="processing"
while [ "$processing" != "" ];
do
	if [ "$1" == "-h" ];
	then
		echo "Usage:"
		echo "$0 [-c] [-l] [-q] [-z zwayName [-z zwayName] ..] [file]"
		echo " -c                     Color Received and Sending lines different from debug"
		echo " -x text                Select custom text with a color"
		echo " -t from_time to_time   Convert time in the log from from_time to to_time (shift all timestamps). Both times in the format \"YYYY-MM-dd HH:MM:SS.mmm\""
		echo " -f                     Pass thru tail -f"
		echo " -l                     Pass thru less"
		echo " -z zwayName            Color zwayName with different colors. Can be used many times."
		echo " -q                     Supress background statistics, deleted from queue and UART ACKs from the log"
		echo " -h                     Help"
		echo
		echo "Recommended usage:"
		echo "$0 -c -l -q -z zwayACM0 -z zwayACM1 -z zwayUSB0 -z core [file]"
		echo
		echo "If the log is from library, do first: sed -i 's/\(\] \[\(.\)\] \)/\1[zway] /' <file>"
		exit
	fi

	if [ "$1" == "-q" ];
	then
		removeLines=\
'/\[[^][]*\] \[D\] \[[^][]*\] RECEIVED ACK/ d;'\
'/\[[^][]*\] \[D\] \[[^][]*\] SENT ACK/ d;'\
'/\[[^][]*\] \[D\] \[[^][]*\] Job 0x..: deleted from queue/ d;'\
\
'/\[[^][]*\] \[I\] \[[^][]*\] Adding job: Get background noise level/ d;'\
'/\[[^][]*\] \[D\] \[[^][]*\] SENDING: ( 01 03 00 3B C7 )/ d;'\
'/\[[^][]*\] \[D\] \[[^][]*\] RECEIVED: ( 01 .. 01 3B .* .. )/ d;'\
'/\[[^][]*\] \[D\] \[[^][]*\] SETDATA controller\.data\.statistics\.backgroundRSSI.channel. = .*/ d;'\
'/\[[^][]*\] \[I\] \[[^][]*\] Job 0x3b (Get background noise level): RSSI .*/ d;'\
'/\[[^][]*\] \[D\] \[[^][]*\] Job 0x3b (Get background noise level): success/ d;'\
'/\[[^][]*\] \[I\] \[[^][]*\] Removing job: Get background noise level/ d;'\
\
'/\[[^][]*\] \[I\] \[[^][]*\] Adding job: Get statistics gathered by the Z-Wave protocol/ d;'\
'/\[[^][]*\] \[D\] \[[^][]*\] SENDING: ( 01 03 00 3A C6 )/ d;'\
'/\[[^][]*\] \[D\] \[[^][]*\] RECEIVED: ( 01 .. 01 3A .* .. )/ d;'\
'/\[[^][]*\] \[D\] \[[^][]*\] SETDATA controller\.data.statistics\..* = .*/ d;'\
'/\[[^][]*\] \[I\] \[[^][]*\] Job 0x3a (Get statistics gathered by the Z-Wave protocol): Done/ d;'\
'/\[[^][]*\] \[D\] \[[^][]*\] Job 0x3a (Get statistics gathered by the Z-Wave protocol): success/ d;'\
'/\[[^][]*\] \[I\] \[[^][]*\] Removing job: Get statistics gathered by the Z-Wave protocol/ d;'\
\
'/\[[^][]*\] \[I\] \[[^][]*\] Adding job: Clear statistics gathered by the Z-Wave protocol/ d;'\
'/\[[^][]*\] \[D\] \[[^][]*\] SENDING: ( 01 03 00 39 C5 )/ d;'\
'/\[[^][]*\] \[D\] \[[^][]*\] RECEIVED: ( 01 04 01 39 01 C2 )/ d;'\
'/\[[^][]*\] \[I\] \[[^][]*\] Job 0x39 (Clear statistics gathered by the Z-Wave protocol): Done/ d;'\
'/\[[^][]*\] \[D\] \[[^][]*\] Job 0x39 (Clear statistics gathered by the Z-Wave protocol): success/ d;'\
'/\[[^][]*\] \[I\] \[[^][]*\] Removing job: Clear statistics gathered by the Z-Wave protocol/ d;'\
''
		shift
		continue
	fi

	if [ "$1" == "-c" ];
	then
		sending="${LCYAN}"
		receiving="${LBLUE}"
		communicationsColorize=\
's/\(\[[^][]*\] \[.\]\) \(\[[^][]*\]\) \(RECEIVED: ( 01 .. .. 04 .. .*\)/\1 \2 '${receiving}'\3'${__BASHIO_COLORS_RESET}'/;'\
's/\(\[[^][]*\] \[.\]\) \(\[[^][]*\]\) \(Received reply on job (.*)\)/\1 \2 '${receiving}'\3'${__BASHIO_COLORS_RESET}'/;'\
's/\(\[[^][]*\] \[.\]\) \(\[[^][]*\]\) \(Node .* CC Security.*: passing .*decrypted packet to application level:\) \(\[ .* \]\)/\1 \2 \3 '${receiving}'\4'${__BASHIO_COLORS_RESET}'/;'\
's/\(\[[^][]*\] \[.\]\) \(\[[^][]*\]\) \(SENDING (cb 0x..): ( 01 .. 00 13 .*\)/\1 \2 '${sending}'\3'${__BASHIO_COLORS_RESET}'/;'\
's/\(\[[^][]*\] \[.\]\) \(\[[^][]*\]\) \(Job 0x13 (.*):\) \(Delivered\)/\1 \2 \3 '${sending}'\4'${__BASHIO_COLORS_RESET}'/;'\
's/\(\[[^][]*\] \[.\]\) \(\[[^][]*\]\) \(Job 0x13 (.*):\) \(Not delivered to recipient.*\)/\1 \2 \3 '${sending}'\4'${__BASHIO_COLORS_RESET}'/;'\
's/\(\[[^][]*\] \[.\]\) \(\[[^][]*\]\) \(Secure payload:\) \(( .* )\)/\1 \2 \3 '${sending}'\4'${__BASHIO_COLORS_RESET}'/;'\
''
		shift
		continue
	fi

	if [ "$1" == "-l" ];
	then
		less="less -R"
		shift
		continue
	fi

	if [ "$1" == "-z" ];
	then
		shift
		zwayNamesColorize=${zwayNamesColorize}'s/\(\[[^][]*\] \[.\]\) \(\['$1'\]\) \(.*\)/\1 '${zwayNamesColors[$zwayNamesColorsIndex]}'\2'${__BASHIO_COLORS_RESET}' \3/;'
		zwayNamesColorsIndex=$((zwayNamesColorsIndex + 1))
		shift
		continue
	fi

	if [ "$1" == "-t" ];
	then
		from_time=$2
		to_time=$3
		shift; shift; shift
		from_timestamp=$(echo "$from_time" | awk '{ date = substr($0, 0, 19); gsub("[-:]", " ", date); ts = mktime(date); ms = substr($0, 21, 3); tms = ts * 1000 + ms; print tms }')
		to_timestamp=$(echo "$to_time" | awk '{ date = substr($0, 0, 19); gsub("[-:]", " ", date); ts = mktime(date); ms = substr($0, 21, 3); tms = ts * 1000 + ms; print tms }')
		delta=$(($to_timestamp-$from_timestamp))
		timestampRewriteCmd=awk
		timestampRewriteParam='BEGIN { format = "%Y-%m-%d %H:%M:%S"; } { date = substr($0, 2, 19); gsub("[-:]", " ", date); ts = mktime(date); ms = substr($0, 22, 3); rest = substr($0, 26); tms = ts * 1000 + ms + '$delta'; print "[" strftime(format, tms / 1000) "." (tms % 1000) "]" rest }'
		continue
	fi

	if [ "$1" == "-x" ];
	then
		shift
		customColorize='s/^\(.*'"$1"'.*\)/'${PURPL}'\1'${__BASHIO_COLORS_RESET}'/;'
		shift
		continue
	fi
	
	if [ "$1" == "-f" ];
	then
		shift
		tail="tail"
		tail_param="-f"
		continue
	fi
	
	if [ "$1" != "" ];
	then
		file=$1
		shift
		continue
	fi

	processing=""
done

logLevelColorize=\
's/\(Got NULL from.*\)$/'${__BASHIO_COLORS_RED}'\1'${__BASHIO_COLORS_RESET}'/;'\
's/\(\[[^][]*\] \[C\]\) \(\[[^][]*\]\) \(.*\)/\1 \2 '${__BASHIO_COLORS_RED}'\3'${__BASHIO_COLORS_RESET}'/;'\
's/\(\[[^][]*\] \[E\]\) \(\[[^][]*\]\) \(.*\)/\1 \2 '${__BASHIO_COLORS_MAGENTA}'\3'${__BASHIO_COLORS_RESET}'/;'\
's/\(\[[^][]*\] \[W\]\) \(\[[^][]*\]\) \(.*\)/\1 \2 '${__BASHIO_COLORS_YELLOW}'\3'${__BASHIO_COLORS_RESET}'/;'\
's/\(\[[^][]*\] \[I\]\) \(\[[^][]*\]\) \(.*\)/\1 \2 '${__BASHIO_COLORS_GREEN}'\3'${__BASHIO_COLORS_RESET}'/;'\
's/\(\[[^][]*\] \[D\]\) \(\[[^][]*\]\) \(.*\)/\1 \2 '${__BASHIO_COLORS_CYAN}'\3'${__BASHIO_COLORS_RESET}'/;'\
''
$tail $tail_param "$file" | $timestampRewriteCmd "$timestampRewriteParam" | sed -u -e "${removeLines};${communicationsColorize};${logLevelColorize};${zwayNamesColorize};${customColorize}" | $less
