# =============== CUSTOM SCRIPTS ======================
# brew autocomplete
if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

    autoload -Uz compinit
    compinit
        
    # Allow completion for all commands and options
    zstyle ':completion:*' expand 'yes'

    # Enable case-insensitive matching
    zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
fi

# Colima
export DOCKER_HOST="unix://$HOME/.colima/docker.sock"

# GPG
export GPG_TTY=$TTY

# Conda
# __conda_setup="$('/opt/homebrew/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/opt/homebrew/anaconda3/etc/profile.d/conda.sh" ]; then
#         . "/opt/homebrew/anaconda3/etc/profile.d/conda.sh"
#     else
#         export PATH="/opt/homebrew/anaconda3/bin:$PATH"
#     fi
# fi
# unset __conda_setup

# golang air
alias air='$(go env GOPATH)/bin/air'

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"                                       # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

# postgres
export PATH="/usr/local/opt/libpq/bin:$PATH:$HOME/bin"

# llvm
export PATH="/opt/homebrew/opt/llvm@14/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/llvm@14/lib/c++ -Wl,-rpath,/opt/homebrew/opt/llvm@14/lib/c++"

# rvm
export PATH="$PATH:$HOME/.rvm/bin"

# JDK
export PATH="/Users/matasramanauskas/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin:$PATH"
export JAVA_HOME="/Users/matasramanauskas/Applications/Android Studio.app/Contents/jbr/Contents/Home"

# Android home
export ANDROID_HOME="/Users/matasramanauskas/Library/Android/sdk/"

# AVD emulator
export PATH="/Users/matasramanauskas/Library/Android/sdk/emulator/:$PATH"

# adb
export PATH="/Users/matasramanauskas/Library/Android/sdk/platform-tools/:$PATH"

# openconnect VPN (shift4)
function vpn-up() {
    local VPN_HOST=vpn.shift4.com
    local VPN_USER=mramanauskas2

    if [ ! -f ~/.vpn_password ]; then
        echo "Error: missing ~/.vpn_password"
        return
    fi
    echo "Starting the vpn ..."
    echo $(cat ~/.vpn_password) | sudo openconnect --background --passwd-on-stdin --user=$VPN_USER $VPN_HOST
}

function vpn-down() {
    sudo kill -2 $(pgrep openconnect)
}