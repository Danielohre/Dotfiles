#!/bin/bash

sudo rm -rf /opt/nvim-linux-x86_64
curl --output nvim-linux-x86_64.tar.gz -L "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz


echo export PATH="$PATH:/opt/nvim-linux-x86_64/bin" >> ~/.bashrc

sudo ln -s $(dirname ~/0)/nvim ~/.config/
sudo ln -s $(dirname ~/0)/.tmux.conf ~/

rm -rf *.tar.gz

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

source ~/.bashrc


echo Set working directory in alacritty.toml
