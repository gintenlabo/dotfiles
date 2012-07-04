## How to install

    cd your/repository/path

    dotfiles=zshrc,gitconfig,vimrc,vim#, ...

    for file in $dotfiles; do
      ln -s ${file} ~/.${file}
    done


---
## To do

- Write install script
