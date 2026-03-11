#!/usr/bin/env bash
set -euo pipefail

# 1. Full dist-upgrade without recommends
sudo zypper dup --no-recommends   # [web:23][web:20]

# 2. Remove openSUSE branding package forcibly, ignoring deps
sudo rpm -e --nodeps branding-openSUSE   # [web:19][web:22]

# 3. Install upstream branding variant
sudo zypper in --no-recommends branding-upstream   # [web:21][web:27]

# 4. Install Bluetooth, audio, brightness, and network TUI tools
sudo zypper in --no-recommends \
  bluez \
  pipewire-pulseaudio \
  brightnessctl \
  blutui \
  NetworkManager-tui   # [web:23]

# 5. Install CLI tools, fonts, terminal, and portal
sudo zypper in --no-recommends \
  git-core \
  flatpak \
  nano \
  symbols-only-nerd-fonts \
  alacritty \
  tmux \
  xdg-desktop-portal-gtk   # [web:23]

# 6. Install KVM support
sudo zypper in --no-recommends qemu-kvm   # [web:23]

# 7. Install Wayland/Sway-related tools
sudo zypper in --no-recommends \
  swayidle \
  swaylock \
  fuzzel \
  waybar \
  mako \
  slurp \
  grim \
  yazi   # [web:23]

# 8. Install niri
sudo zypper in --no-recommends niri   # [web:23]

# 9. Create dev1 user with home
sudo useradd -m dev1   # [web:15]

# 10. Add dev1 to kvm group
sudo usermod -aG kvm dev1   # [web:17]

# 11–12. As dev1, clone repo and copy .config
sudo -u dev1 bash <<'EOF'   # [web:16]
set -euo pipefail

mkdir -p "$HOME/osrepos"
git clone -b dev \
  https://github.com/gitgudorgitpwnd/niri-wm-dots-os-1.git \
  "$HOME/osrepos/niri-wm-dots-os-1/"

cp -r "$HOME/osrepos/niri-wm-dots-os-1/.config" "$HOME/"
EOF

# 13–14. Ensure ownership of dev1 home
sudo chown -R dev1:dev1 /home/dev1   # [web:17]
