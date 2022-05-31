# if running bash, include .bashrc if it exists
[ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"

activate_profile () {
    GUIX_PROFILE="$1"
    . "$GUIX_PROFILE/etc/profile"
    export XDG_DATA_DIRS="$GUIX_PROFILE/share:${XDG_DATA_DIRS:-/usr/local/share/:/usr/share/}"
}

# Activate the profile containing current guix install
activate_profile "$HOME/.config/guix/current"

# Activate the default profile
activate_profile "$HOME/.guix-profile"

# Activate profile containing packages for home environment
activate_profile "$HOME/.config/guix/home/.profile/home"
export GUIX_LOCPATH="$HOME/.config/guix/home/.profile/home/lib/locale"

# Activate profile containing Emacs related packages
activate_profile "$HOME/.config/emacs/.profile/emacs"

# flatpak desktop files
export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share:${XDG_DATA_DIRS:-/usr/local/share/:/usr/share/}"

export LOCALE_ARCHIVE=/usr/lib/locale/locale-archive

# Add Terraform to path
export PATH="$HOME/bin:$PATH"
