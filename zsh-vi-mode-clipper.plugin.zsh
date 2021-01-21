#!/usr/bin/env zsh
# https://github.com/wincent/clipper plugin for zsh vi-mode

if nc -h |& grep -q '\s*-N\s*Shutdown'; then
    # option "-N" required on Ubuntu
    _clip="nc localhost -N 8377"
else
    _clip="nc localhost 8377"
fi

function vi-yank-clip() {
	zle vi-yank
	if [[ "${KEYS}" == "y" && "${KEYMAP}" == 'viopp' ]]; then # A new line should be added to the end
		printf '%s\n' "$CUTBUFFER" | eval $_clip
	else
		printf '%s' "$CUTBUFFER" | eval $_clip
	fi
}
zle -N vi-yank-clip

function vi-yank-eol-clip() {
	zle vi-yank-eol
	printf '%s' "$CUTBUFFER" | eval $_clip
}
zle -N vi-yank-eol-clip

# bind keys to widgets
bindkey -M vicmd y vi-yank-clip
bindkey -M vicmd Y vi-yank-eol-clip
