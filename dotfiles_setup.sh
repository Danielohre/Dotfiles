#!/bin/bash

sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz

echo export PATH="$PATH:/opt/nvim-linux64/bin" >> ~/.bashrc


sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'


sudo ln -s $(dirname ~/0)/nvim ~/.config/
sudo ln -s $(dirname ~/0)/.tmux.conf ~/

rm -rf *.tar.gz

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo Open NVIM and run :PlugInstall

echo Set working directory in alacritty.toml
