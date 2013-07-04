# 関数
find-grep () { find . -type f -print | xargs grep -n --binary-files=without-match $@ }

# エイリアスの設定
alias ls='ls --color=auto'
alias ll='ls -ltr'
alias gd='dirs -v; echo -n "select number: "; read newdir; cd +"$newdir"'
alias o=xdg-open
alias v=vim
alias vi=vim
alias e=vim

alias g++03='g++ -std=gnu++03 -Wall -Wextra'
alias g++0x='g++ -std=gnu++0x -Wall -Wextra'
alias g++11='g++ -std=gnu++11 -Wall -Wextra'
alias g++1y='g++ -std=gnu++1y -Wall -Wextra'

# rvm
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"


# プロンプトの設定 
local GREEN=$'%{\e[1;32m%}'
local BLUE=$'%{\e[1;34m%}'
local DEFAULT=$'%{\e[1;m%}'

PROMPT=$BLUE'[${USER}@${HOSTNAME}] %(!.#.$) '$DEFAULT
RPROMPT=$GREEN'[%~]'$DEFAULT
setopt PROMPT_SUBST

# ターミナルの設定
case "${TERM}" in
kterm*|xterm*)
  precmd() {
    echo -ne "\033]0;Terminal: ${PWD/#$HOME/~}\007"
  }
esac


# ヒストリの設定
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000

# 履歴ファイルに時刻を記録
setopt extended_history

# 補完するかの質問は画面を超える時にのみに行う｡
LISTMAX=0

autoload -Uz compinit; compinit

# sudo でも補完の対象
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin

# cdのタイミングで自動的にpushd
setopt auto_pushd 

# 複数の zsh を同時に使う時など history ファイルに上書きせず追加
setopt append_history

# 補完候補が複数ある時に、一覧表示
setopt auto_list

# 保管結果をできるだけ詰める
setopt list_packed

# 補完キー（Tab, Ctrl+I) を連打するだけで順に補完候補を自動で補完
setopt auto_menu

# カッコの対応などを自動的に補完
setopt auto_param_keys

# ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_slash

# ビープ音を鳴らさないようにする
setopt no_beep

# 直前と同じコマンドラインはヒストリに追加しない
setopt hist_ignore_dups

# ヒストリにhistoryコマンドを記録しない
setopt hist_no_store

# 余分なスペースを削除してヒストリに記録する
setopt hist_reduce_blanks

# 行頭がスペースで始まるコマンドラインはヒストリに記録しない
# setopt hist_ignore_spece

# 重複したヒストリは追加しない
# setopt hist_ignore_all_dups

# ヒストリを呼び出してから実行する間に一旦編集できる状態になる
setopt hist_verify

# auto_list の補完候補一覧で、ls -F のようにファイルの種別をマーク表示しない
setopt no_list_types

# コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
setopt magic_equal_subst

# ファイル名の展開でディレクトリにマッチした場合末尾に / を付加する
setopt mark_dirs

# 8 ビット目を通すようになり、日本語のファイル名を表示可能
setopt print_eight_bit

# シェルのプロセスごとに履歴を共有
setopt share_history

# Ctrl+wで､直前の/までを削除する｡
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# ディレクトリを水色にする｡
export LS_COLORS='di=01;36'

# ファイルリスト補完でもlsと同様に色をつける｡
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# ディレクトリ名だけで､ディレクトリの移動をする｡
setopt auto_cd

# C-s, C-qを無効にする。
setopt no_flow_control
