#!/bin/bash
function df_log {
    echo "[$(date +"%D %T")] $1: $2" >> install.log;
}

function df_error {
    echo -e "\e[1m\e[196m[lluispons-dotfiles] \e[196mERROR: $1";
    df_log "Error" "$1";
}
function df_warning {
    echo -e "\e[1m\e[93m[lluispons-dotfiles] \e[208mWARNING: $1";
    df_log "Warning" "$1";
}
function df_notice { echo -e "\e[1m\e[38;5;226m[lluispons-dotfiles] \e[226mNOTICE:$1"; }

df_warning "This is America"
df_error "This is America"