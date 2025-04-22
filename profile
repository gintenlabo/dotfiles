export PATH="$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH"
export MANPATH=/usr/local/share/man:/usr/local/man:/usr/share/man
export    LIBRARY_PATH="/usr/local/lib"
export LD_LIBRARY_PATH="/usr/local/lib"

# cabal
export PATH=$HOME/.cabal/bin:$PATH

# gcc
export PATH=/usr/local/gcc/latest/bin:$PATH

# boost
export BOOST_ROOT=/usr/local/boost/latest
export CPLUS_INCLUDE_PATH=$BOOST_ROOT:$CPLUS_INCLUDE_PATH

# pkg-config
export PKG_CONFIG_PATH=$HOME/local/lib/pkgconfig

#clang tools
export PATH=/usr/local/opt/llvm/bin:$PATH

#react native
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools

# homebrew is preinstalled, so no config needed
