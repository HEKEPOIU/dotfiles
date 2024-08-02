if status is-interactive
    set FLINE_PATH $HOME/.config/fish/fishline
    source $FLINE_PATH/init.fish
end

neofetch
bass source /etc/profile
nvm use v20.12.2
set -gx PATH $HOME/.cargo/bin $PATH
alias d="kitten diff"
alias icat="kitten icat"
export PATH="$HOME/.luaenv/bin:$PATH"
eval "$(luaenv init -)" 
set EDITOR nvim

