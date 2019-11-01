#!/bin/sh
if [ "$(uname -s)" = "Darwin" ]; then
	if command -v brew >/dev/null 2>&1; then
		brew tap homebrew/cask-fonts
		brew cask install font-fira-code
	fi
else
	mkdir -p ~/.fonts
	install ~/.fonts
fi
