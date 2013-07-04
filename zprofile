# 文字コードの設定
export LANG=ja_JP.UTF-8

# ホスト名
export HOSTNAME=`hostname`

# パスの設定
export PATH="$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH"
export MANPATH=/usr/local/share/man:/usr/local/man:/usr/share/man
export    LIBRARY_PATH="/usr/local/lib"
export LD_LIBRARY_PATH="/usr/local/lib"

# エディタ設定
export EDITOR=vim

# rvm
PATH=$PATH:$HOME/.rvm/bin

# nodebrew
PATH=$HOME/.nodebrew/current/bin:$PATH

# cabal
PATH=$HOME/.cabal/bin:$PATH

# gcc
PATH=/usr/local/gcc/latest/bin:$PATH

# boost
export BOOST_ROOT=/usr/local/boost/latest
export CPLUS_INCLUDE_PATH=$BOOST_ROOT:$CPLUS_INCLUDE_PATH
