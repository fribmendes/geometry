# geometry - simple customizable prompt based on avit, pure, and mnml
#
# avit: https://github.com/robbyrussell/oh-my-zsh/blob/master/themes/avit.zsh-theme
# pure: https://github.com/sindresorhus/pure
# mnml: https://github.com/subnixr/minimal

typeset -gA GEOMETRY; GEOMETRY[ROOT]=${0:A:h}

(($+GEOMETRY_PROMPT)) || GEOMETRY_PROMPT=(geometry_echo geometry_status geometry_path)
(($+GEOMETRY_RPROMPT)) || GEOMETRY_RPROMPT=(geometry_exec_time geometry_git geometry_hg geometry_echo)
(($+GEOMETRY_INFO)) || GEOMETRY_INFO=()
(($+GEOMETRY_TITLE)) || GEOMETRY_TITLE=(geometry_path)
(($+GEOMETRY_CMDTITLE)) || GEOMETRY_CMDTITLE=(geometry_cmd geometry_hostname)
(($+GEOMETRY_PATH_TRUNCATE)) || GEOMETRY_PATH_TRUNCATE=3

autoload -U add-zsh-hook

function { local fun; for fun ("${GEOMETRY[ROOT]}"/functions/*) . $fun }

(( $+functions[ansi] )) || ansi() { (($# - 2)) || echo -n "%F{$1}$2%f"; }
(( $+functions[deansi] )) || deansi() { (($# - 1)) || echo -n "$(echo "$1" | sed s/$(echo "\033")\\\[\[0-9\]\\\{1,2\\\}m//g)"; }
(( $+functions[geometry_cmd])) || geometry_cmd() { echo $GEOMETRY_LAST_CMD }

# Takes number of seconds and formats it for humans
# from https://github.com/sindresorhus/pretty-time-zsh
geometry::time() {
  local seconds detailed color
  local d h m s
  local -a human=()
  seconds=$1
  detailed=$2
  d=$(( seconds / 60 / 60 / 24 ))
  h=$(( seconds / 60 / 60 % 24 ))
  m=$(( seconds / 60 % 60 ))
  s=$(( seconds % 60 ))

  (( d > 0 )) && human+="${d}d" && : ${color:=${GEOMETRY_TIME_COLOR_LONG:-red}}
  (( h > 0 )) && human+="${h}h" && : ${color:=${GEOMETRY_TIME_COLOR_NEUTRAL:-default}}
  (( m > 0 )) && human+="${m}m"
  (( s > 0 )) && human+="${s}s" && : ${color:=${GEOMETRY_TIME_COLOR_SHORT:-green}}

  ${2:-false} && ansi $color ${(j: :)human} || ansi $color $human[1]
}

# Generate a color based on hostname.
geometry::hostcolor() {
  if (( ${+GEOMETRY_HOST_COLOR} )); then
    echo ${GEOMETRY_HOST_COLOR}
    return
  fi

  if (( ${+GEOMETRY_HOST_COLORS} )); then
    local colors=(${GEOMETRY_HOST_COLORS})
  else
    local colors=({1..9})
    (($(echotc Co) == 256)) && colors+=({17..230})
  fi

  local sum=0; for c in ${(s::)^HOST}; do ((sum += $(print -f '%d' "'$c"))); done
  local index="$(($sum % ${#colors}))"

  [[ "$index" -eq 0 ]] && index = 1

  echo ${colors[${index}]}
}

# Set terminal window and tab/icon title
#
# usage: title short_tab_title [long_window_title]
#
# See: http://www.faqs.org/docs/Linux-mini/Xterm-Title.html#ss3.1
# Fully supports screen, iterm, and probably most modern xterm and rxvt
# (In screen, only short_tab_title is used)
# Limited support for Apple Terminal (Terminal can't set window and tab separately)

# This is the title() function taken directly from oh-my-zsh
# https://github.com/ohmyzsh/ohmyzsh/blob/c44b99e901d7ef58f60247995152de1b937e2e9c/lib/termsupport.zsh
geometry::echo_title_sequence() {
  emulate -L zsh
  setopt prompt_subst

  [[ "$INSIDE_EMACS" == *term* ]] && return

  # if $2 is unset use $1 as default
  # if it is set and empty, leave it as is
  : ${2=$1}

  case "$TERM" in
    cygwin|xterm*|putty*|rxvt*|konsole*|ansi|mlterm*|alacritty|st*)
      print -Pn "\e]2;${2:q}\a" # set window name
      print -Pn "\e]1;${1:q}\a" # set tab name
      ;;
    screen*|tmux*)
      print -Pn "\ek${1:q}\e\\" # set screen hardstatus
      ;;
    *)
      if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
        print -Pn "\e]2;${2:q}\a" # set window name
        print -Pn "\e]1;${1:q}\a" # set tab name
      else
        # Try to use terminfo to set the title
        # If the feature is available set title
        if [[ -n "$terminfo[fsl]" ]] && [[ -n "$terminfo[tsl]" ]]; then
          echoti tsl
          print -Pn "$1"
          echoti fsl
        fi
      fi
      ;;
  esac
}

# set cmd title (while command is running)
geometry::set_cmdtitle() {
  # Make command title available for optional consumption by geometry_cmd
  GEOMETRY_LAST_CMD=$2
  local ansiCmdTitle=$(print -P $(geometry::wrap $PWD $GEOMETRY_CMDTITLE))
  local cmdTitle=$(deansi "$ansiCmdTitle")

  geometry::echo_title_sequence "$cmdTitle"
}
add-zsh-hook preexec geometry::set_cmdtitle

# set ordinary title (after command has completed)
geometry::set_title() {
  local ansiTitle=$(print -P $(geometry::wrap $PWD $GEOMETRY_TITLE))
  local title=$(deansi "$ansiTitle")

  geometry::echo_title_sequence "$title"
}
add-zsh-hook precmd geometry::set_title

# join outputs of functions - pwd first
geometry::wrap() {
  setopt localoptions noautopushd; builtin cd -q $1
  local -a outputs
  local cmd output
  shift
  for cmd in $@; do output=$($cmd); ( (( $? )) || [[ -z "${output// }" ]] ) || outputs+=$output; done

  echo "${(ej.${GEOMETRY_SEPARATOR:- }.)outputs}"
}

geometry::rprompt::set() {
  if [[ -z "$2" || "$2" == "hup" ]]; then
    read -r -u "$GEOMETRY_ASYNC_FD" RPROMPT
    zle reset-prompt
    exec {1}<&-
  fi
  zle -F "$1"
}

geometry::rprompt() {
  typeset -g GEOMETRY_ASYNC_FD=
  exec {GEOMETRY_ASYNC_FD}< <(geometry::wrap $PWD $GEOMETRY_RPROMPT)
  zle -F "$GEOMETRY_ASYNC_FD" geometry::rprompt::set
}

geometry::prompt() {
  GEOMETRY[LAST_STATUS]="$status"
  PROMPT=" $(geometry::wrap $PWD $GEOMETRY_PROMPT) "
  geometry::rprompt
}

add-zsh-hook precmd geometry::prompt

geometry::info() { # draw info if no command is given
    [[ -n "$BUFFER" ]] && { zle accept-line && return; }
    echo ${(%):-$(geometry::wrap $PWD $GEOMETRY_INFO)}
    geometry::prompt
}
zle -N buffer-empty geometry::info
bindkey '^M' buffer-empty
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=buffer-empty
