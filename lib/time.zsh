# time - library to convert timestamps to human readable stuff

: ${GEOMETRY_COLOR_TIME_SHORT:=green}
: ${GEOMETRY_COLOR_TIME_NEUTRAL:=white}
: ${GEOMETRY_COLOR_TIME_LONG:=red}
: ${GEOMETRY_COLOR_NO_TIME:=red}

typeset -g geometry_time_human
typeset -g geometry_time_color

# Format time in short format: 4s, 4h, 1d
_geometry_time_short_format() {
  local human=""
  local color=""
  local days=$1
  local hours=$2
  local minutes=$3
  local seconds=$4

  if (( days > 0 )); then
    human="${days}d"
    color=$GEOMETRY_COLOR_TIME_LONG
  elif (( hours > 0 )); then
    human="${hours}h"
    : ${color:=$GEOMETRY_COLOR_TIME_NEUTRAL}
  elif (( minutes > 0 )); then
    human="${minutes}m"
    : ${color:=$GEOMETRY_COLOR_TIME_SHORT}
  else
    human="${seconds}s"
    : ${color:=$GEOMETRY_COLOR_TIME_SHORT}
  fi

  geometry_time_color=$color
  geometry_time_human=$human
}

# Format time in long format: 1d4h33m51s, 33m51s
_geometry_time_long_format() {
  local human=""
  local color=""
  local days=$1
  local hours=$2
  local minutes=$3
  local seconds=$4

  (( days > 0 )) && human+="${days}d " && color=$GEOMETRY_COLOR_TIME_LONG
  (( hours > 0 )) && human+="${hours}h " && : ${color:=$GEOMETRY_COLOR_TIME_NEUTRAL}
  (( minutes > 0 )) && human+="${minutes}m "
  human+="${seconds}s" && : ${color:=$GEOMETRY_COLOR_TIME_SHORT}

  geometry_time_color=$color
  geometry_time_human=$human
}

# from https://github.com/sindresorhus/pretty-time-zsh
_geometry_seconds_to_human_time() {
  local total_seconds=$1
  local long_format=${2:-false}

  local days=$(( total_seconds / 60 / 60 / 24 ))
  local hours=$(( total_seconds / 60 / 60 % 24 ))
  local minutes=$(( total_seconds / 60 % 60 ))
  local seconds=$(( total_seconds % 60 ))

  $long_format && _geometry_time_long_format $days $hours $minutes $seconds
  $long_format || _geometry_time_short_format $days $hours $minutes $seconds

  echo "$(ansi $geometry_time_color $geometry_time_human)"
}
