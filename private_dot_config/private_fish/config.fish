if status is-interactive
    set FLINE_PATH $HOME/.config/fish/fishline
    source $FLINE_PATH/init.fish
end
bass source /etc/profile
bass source ~/.profile
bass source ~/.bashrc
nvm use lts
neofetch
alias d="kitten diff"
alias icat="kitten icat"
