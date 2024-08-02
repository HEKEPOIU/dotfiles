if status is-interactive
    set FLINE_PATH $HOME/.config/fish/fishline
    source $FLINE_PATH/init.fish
end

neofetch
bass source /etc/profile
nvm use lts
source "$HOME/.cargo/env.fish"
alias d="kitten diff"
alias icat="kitten icat"
export PATH="$HOME/.luaenv/bin:$PATH"
eval "$(luaenv init -)" 
set EDITOR nvim

