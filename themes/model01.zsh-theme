# A Zsh Theme that supports setting the LEDs on a Model01 keyboard
# Based on `wedisagree`

# The prompt

PROMPT='[%{$fg[magenta]%}%c%{$reset_color%}] '

# The right-hand prompt

RPROMPT='${time} %{$fg[yellow]%}$(aws_prompt_info)%{$reset_color%} %{$fg[cyan]%}$(k8s_prompt_info)%{$reset_color%} %{$fg[magenta]%}$(git_prompt_info)%{$reset_color%}$(git_prompt_status)%{$reset_color%}$(git_prompt_ahead)%{$reset_color%}'

# Add this at the start of RPROMPT to include rvm info showing ruby-version@gemset-name
# %{$fg[yellow]%}$(~/.rvm/bin/rvm-prompt)%{$reset_color%}

# local time, color coded by last return code
time_enabled="%(?.%{$fg[green]%}.%{$fg[red]%})%*%{$reset_color%}"
time_disabled="%{$fg[green]%}%*%{$reset_color%}"
time=$time_enabled

ZSH_THEME_GIT_PROMPT_PREFIX=" ☁  %{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%} ☂" # Ⓓ
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} ✭" # ⓣ
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%} ☀" # Ⓞ

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[cyan]%} ✚" # ⓐ ⑃
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%} ⚡"  # ⓜ ⑁
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} ✖" # ⓧ ⑂
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%} ➜" # ⓡ ⑄
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[magenta]%} ♒" # ⓤ ⑊
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[blue]%} 𝝙"

# More symbols to choose from:
# ☀ ✹ ☄ ♆ ♀ ♁ ♐ ♇ ♈ ♉ ♚ ♛ ♜ ♝ ♞ ♟ ♠ ♣ ⚢ ⚲ ⚳ ⚴ ⚥ ⚤ ⚦ ⚒ ⚑ ⚐ ♺ ♻ ♼ ☰ ☱ ☲ ☳ ☴ ☵ ☶ ☷
# ✡ ✔ ✖ ✚ ✱ ✤ ✦ ❤ ➜ ➟ ➼ ✂ ✎ ✐ ⨀ ⨁ ⨂ ⨍ ⨎ ⨏ ⨷ ⩚ ⩛ ⩡ ⩱ ⩲ ⩵  ⩶ ⨠
# ⬅ ⬆ ⬇ ⬈ ⬉ ⬊ ⬋ ⬒ ⬓ ⬔ ⬕ ⬖ ⬗ ⬘ ⬙ ⬟  ⬤ 〒 ǀ ǁ ǂ ĭ Ť Ŧ

function aws_prompt_info() {
  local col
  if [[ -v AWS_PROFILE ]]; then
    case "$AWS_PROFILE" in
      root)
        set_left_leds 160 0 0
        col="%{$fg_bold[red]%}"
        ;;
      thomac)
        set_left_leds 160 0 0
        col="%{$fg[red]%}"
        ;;
      nirvana)
        set_left_leds 0 70 130
        col="%{$fg[blue]%}"
        ;;
      skyfall)
        set_left_leds 0 0 170
        col="%{$fg[red]%}"
        ;;
      corp)
        set_left_leds 170 170 170
        col="%{$fg_bold[white]%}"
        ;;
      legacy)
        set_left_leds 0 0 0
        col="%{$bg[white]$fg[black]%}"
        ;;
      infratest)
        set_left_leds 0 160 0
        col="%{$fg_bold[green]%}"
        ;;
      utopia)
        set_left_leds 0 0 170
        col="%{$fg[magenta]%}"
        ;;
      *)
        ;;
    esac
    echo "AWS%{$reset_color%}:$col$AWS_PROFILE"
  else
    set_left_leds 0 0 0
  fi
}

function k8s_prompt_info() {
  local col
  K8S_CONTEXT=`kubectl config current-context`
  if [[ -v K8S_CONTEXT ]]; then
    case "$K8S_CONTEXT" in
      nirvana)
        set_right_leds 0 70 130
        col="%{$fg[blue]%}"
        ;;
      skyfall)
        set_right_leds 0 0 170
        col="%{$fg[red]%}"
        ;;
      corp)
        set_right_leds 170 170 170
        col="%{$fg_bold[white]%}"
        ;;
      infratest)
        set_right_leds 0 160 0
        col="%{$fg_bold[green]%}"
        ;;
      utopia)
        set_right_leds 0 0 170
        col="%{$fg[magenta]%}"
        ;;
      minikube)
        set_right_leds 140 70 0
        col="%{$bg[white]$fg[black]%}"
        ;;
      *)
        ;;
    esac
    echo "K8S%{$reset_color%}:$col$K8S_CONTEXT"
  else
    set_right_leds 0 0 0
  fi
}

function set_left_leds() {
  local red
  local green
  local blue
  local commands

  red=$1;
  green=$2;
  blue=$3;
  commands=""
  for i in `seq 0 31`; do
    commands="$commands\nled.at $i $red $green $blue"
  done
  echo $commands > /dev/ttyACM0
}

function set_right_leds() {
  local red
  local green
  local blue
  local commands

  red=$1;
  green=$2;
  blue=$3;
  commands=""
  for i in `seq 32 63`; do
    commands="$commands$\nled.at $i $red $green $blue"
  done
  echo $commands > /dev/ttyACM0
}

function set_led_at()  {
  idx=$1
  red=$2
  green=$3
  blue=$4
  echo "led.at $i $red $green $blue" > /dev/ttyACM0
}
