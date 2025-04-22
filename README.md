## How to install

First, install homebrew and coreutils

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval $(/opt/homebrew/bin/brew shellenv)
    brew install coreutils

for `grealpath` command in install script.

Then run

    ./install-script.bash -n -u 'Your Name' -m 'your-address@example.com'

to show executed commands.

If no problem found, then run

    ./install-script.bash -x -u 'Your Name' -m 'your-address@example.com'

to install.
