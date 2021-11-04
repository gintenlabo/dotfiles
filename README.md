## How to install


### 1. create symbolic links

    cd your/repository/path

    dotfiles=zshrc,gitconfig,vimrc,vim#, ...

    for file in `echo ${dotfiles//,/ }`; do
      ln -sr ${file} ~/.${file}
    done


### 2. local setting for git

To enable include, install latest version of git:

    sudo add-apt-repository ppa:git-core/ppa
    sudo apt-get update && sudo apt-get upgrade

then create your local gitconfig file:

    cat <<EOF >~/.gitconfig.local
    [user]
    	name = Your Name
    	email = your-address@example.com
    EOF
    # or use some editor (recommended)


### 3. install Vundle

    git submodule update --init

and run Vim, enter:

    :BundleInstall


---
## To do

- Write install script
