#!/bin/bash

ICON="$HOME/.config/i3/lock.png"
IMG="$HOME/.cache/i3lock.png"

_log () {
	  echo "[$0] $1" | systemd-cat
}

_prepare_background() {
    # Take a screenshot for our background
    if scrot ${IMG}; then
        _log "Taking screenshot"
    fi

    # Pixelate the background
    if convert ${IMG} -scale 10% -scale 1000% $IMG; then
        _log "Pixelate the screenshot"
    fi

    # Add the lock-icon
    if convert ${IMG} ${ICON} -gravity center -composite ${IMG}; then
        _log "Add the lock-icon"
    fi
}

_lock_screen() {
    # run i3lock
    if i3lock -u -i ${IMG}; then
        _log "run i3lock"
    fi
}

_post () {
    _log "Nothing to do here"
}

_pre () {
    _prepare_background
    _lock_screen  
}

main () {
     _pre
}

main "$@"
