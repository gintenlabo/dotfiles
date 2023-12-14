## How to install


### 0. init submodules

    cd your/repository/path
    git submodule update --init


### 1. create symbolic links

    for file in `cat dotfiles`; do
      ln -srvbT ${file} ~/.${file}
    done


### 2. local setting for git

    cat <<EOF >~/.gitconfig.local
    [user]
    	name = Your Name
    	email = your-address@example.com
    EOF
    # or use some editor (recommended)


### 3. setup vim

    mkdir ~/.vim-backup
    mkdir ~/.vim-undo

and run vim, enter:

    :PluginInstall


### 4. compile locale

    sudo localedef -f UTF-8 -i ja_JP ja_JP.UTF-8


---
## To do

- Write install script
