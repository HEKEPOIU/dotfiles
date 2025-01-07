if status is-interactive
    set FLINE_PATH $HOME/.config/fish/fishline
    source $FLINE_PATH/init.fish
end
function open_pdf_in_browser
    bash -c "source ~/.bashrc && open_pdf_in_browser '$argv[1]'" 
end

# Fish Version of fzt, may some day i will change to zsh so that i dont write two version.
function fzt
    set p (fzf)
    if test -z "$p"
        echo "No selection made"
        return 1
    end

    set dir (dirname "$p")
    echo $dir

    cd $dir
    if test $status -ne 0
        echo "Failed to change directory to $dir"
        return 1
    end
end

bass source /etc/profile
bass source ~/.profile
bass source ~/.bashrc
neofetch
nvm use lts
alias d="kitten diff"
alias icat="kitten icat"
alias opib="open_pdf_in_browser"
