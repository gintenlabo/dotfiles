## How to install

First, install homebrew and coreutils

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew install coreutils

for `realpath` command in install script.

Then run

    ./install-script.bash -n -u 'Your Name' -m 'your-address@example.com'

to show executed commands.

If no problem found, then run

    ./install-script.bash -x -u 'Your Name' -m 'your-address@example.com'

to install.
