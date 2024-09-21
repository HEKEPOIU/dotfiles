if status is-interactive
    set FLINE_PATH $HOME/.config/fish/fishline
    source $FLINE_PATH/init.fish
end
bass source /etc/profile
bass source ~/.profile
bass source ~/.bashrc
neofetch
nvm use lts
alias d="kitten diff"
alias icat="kitten icat"
