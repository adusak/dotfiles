#!/bin/sh
## SDKMAN
add_lazy init_sdk sdk java gradle gradlew

init_sdk() {
    export SDKMAN_DIR="$HOME/.sdkman"
    [[ -s "/Users/melkus/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/melkus/.sdkman/bin/sdkman-init.sh"
}
