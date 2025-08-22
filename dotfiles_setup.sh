#!/bin/bash

sudo rm -rf /opt/nvim-linux-x86_64
curl --output nvim-linux-x86_64.tar.gz -L "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz


echo export PATH="$PATH:/opt/nvim-linux-x86_64/bin" >> ~/.bashrc


#sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
#       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'


sudo ln -s $(dirname ~/0)/nvim ~/.config/
sudo ln -s $(dirname ~/0)/.tmux.conf ~/

rm -rf *.tar.gz

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm


echo Set working directory in alacritty.toml
