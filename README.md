## How to install


### 0. init submodules

    git submodule update --init


### 1. create symbolic links

    cd your/repository/path

    dotfiles=zshrc,gitconfig,vimrc,vim#, ...

    for file in `echo ${dotfiles//,/ }`; do
      ln -sr ${file} ~/.${file}
    done


### 2. local setting for git

    cat <<EOF >~/.gitconfig.local
    [user]
    	name = Your Name
    	email = your-address@example.com
    EOF
    # or use some editor (recommended)


### 3. install Vundle

Run Vim, enter:

    :PluginInstall


---
## To do

- Write install script
