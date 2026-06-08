If ($PSVersionTable.PSVersion.Major -Le 5 -Or $isWindows) {
    If (-Not (Test-Path $env:LOCALAPPDATA\nvim)) {
        New-Item -Path $env:LOCALAPPDATA\nvim -ItemType Junction -Value $env:USERPROFILE\.config\nvim
    }

    If (-Not (Test-Path $env:LOCALAPPDATA\lazygit)) {
        New-Item -Path $env:LOCALAPPDATA\lazygit -ItemType Junction -Value $env:USERPROFILE\.config\lazygit
    }

    If (-Not (Test-Path $env:APPDATA\Zellij)) {
        New-Item -Path $env:APPDATA\Zellij -ItemType Junction -Value $env:USERPROFILE\.config\Zellij
    }

    If (-Not (Test-Path $env:APPDATA\nushell)) {
        New-Item -Path $env:APPDATA\nushell -ItemType Junction -Value $env:USERPROFILE\.config\nushell
    }

    If (-Not (Test-Path $env:APPDATA\alacritty)) {
        New-Item -Path $env:APPDATA\alacritty -ItemType Junction -Value $env:USERPROFILE\.config\alacritty
    }
}
