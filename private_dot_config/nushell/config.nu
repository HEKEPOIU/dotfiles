# config.nu
#
# Installed by:
# version = "0.113.1"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings, 
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R

source ./.zoxide.nu
source ./.mise.nu
source ./.fzf.nu

alias cat = bat
source ./.carapace.nu
$env.config.show_banner = false

# See the doc: https://www.nushell.sh/blog/2023-09-19-nushell_0_85_0.html#improvements-to-parse-time-evaluation
# the fuck.
# tldr source only effect in statement 
const WINDOWS_CONFIG = "./windows_config.nu"
const UNIX_CONFIG = "./unix_config.nu"
const ACTUAL_CONFIG = if $nu.os-info.family == "windows" {
    $WINDOWS_CONFIG
} else {  
    $UNIX_CONFIG
}

source $ACTUAL_CONFIG


