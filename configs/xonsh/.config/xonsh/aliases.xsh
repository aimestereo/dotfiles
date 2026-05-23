aliases['..'] = 'cd ..'
aliases['...'] = 'cd ../..'
aliases['....'] = 'cd ../../..'

# eza (modern ls)
aliases['l'] = 'eza --icons=auto'
aliases['ls'] = 'eza --icons=auto'
aliases['ll'] = 'eza -la --icons=auto'
aliases['la'] = 'eza -la --icons=auto'
aliases['lt'] = 'eza --tree --icons=auto'

# bat (modern cat)
aliases['c'] = 'bat -p'
aliases['cat'] = 'bat'

# git
aliases['g'] = 'git'
aliases['gst'] = 'git status'
aliases['gco'] = 'git checkout'
aliases['gcm'] = 'git commit -m'
aliases['gcam'] = 'git commit -am'

# editor / misc
aliases['v'] = 'nvim'
aliases['lazyvim'] = 'env NVIM_APPNAME=lazyvim nvim'
aliases['cl'] = 'clear'
aliases['rd'] = 'rmdir'
aliases['tf'] = 'terraform'
aliases['tg'] = 'terragrunt'
aliases['k'] = 'kubectl'
aliases['s'] = 'kitten ssh'
aliases['hm'] = 'home-manager switch --flake ~/projects/my/dotfiles/nix#main'

# network helpers
aliases['wanip'] = 'dig +short myip.opendns.com @resolver1.opendns.com'
aliases['whatismyip'] = 'curl ipinfo.io/ip'
