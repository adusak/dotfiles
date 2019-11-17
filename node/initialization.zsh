#!/bin/sh
## NVM
add_lazy init_nvm nvm npm node gulp yarn

init_nvm() {
    echo "Loading nvm"
    export NVM_DIR="$HOME/.nvm"
    [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
}