if status is-interactive
    set FLINE_PATH $HOME/.config/fish/fishline
    source $FLINE_PATH/init.fish
end
function open_pdf_in_browser
    bash -c "source ~/.bashrc && open_pdf_in_browser '$argv[1]'" 
end

bass source /etc/profile
bass source ~/.profile
bass source ~/.bashrc
neofetch
nvm use lts
alias d="kitten diff"
alias icat="kitten icat"
alias opib="open_pdf_in_browser"
