
# Install Xcode and command line tool
sudo xcode-select --switch /Applications/Xcode.app


# Install apps
brew install --cask \
  karabiner-elements hammerspoon `# Keyboard customizer & Automation` \
  fluor `# Change the behavior of the fn keys depending on the active application` \
  mos `# Smooths scrolling and set mouse scroll directions independently` \
  raycast 1password/tap/1password-cli `# Spotlight replacement + plugin fro 1password` \
  arc `# browser` \
  force-paste gitup slack \
  raycast 1password/tap/1password-cli \
  postman \
  amethyst  `# window manager` \
  kitty

# Install shell utils

brew install \
 gcc openssl \
 psql wget cookiecutter \
 shfmt \
 diff-so-fancy \
 hadolint \
 awscli \
 aws/tap/aws-sam-cli \
 neovim \
 ripgrep \
 tmux fzf \
 jq \
 rsync \
 minikube kubectl \
 hashicorp/tap/terraform terragrunt \
 pre-commit \
 openjdk \
 stow antigen

git clone git@github.com:ohmyzsh/ohmyzsh.git ~/.config/oh-my-zsh

# Copy all config files
mkdir ~/.config
stow --target ~/.config .


# PostgresQL
brew install libpq
brew link --force libpq

# Redis-cli
brew tap ringohub/redis-cli
brew install redis-cli

brew tap heroku/brew && brew install heroku


# Rust

curl https://sh.rustup.rs -sSf | sh
source "$HOME/.cargo/env"
cargo install sccache
RUSTC_WRAPPER=sccache cargo install --locked \
 cargo-cache cargo-update \
 exa bat mprocs ripgrep irust procs \
 nu zellij warp starship rtx-cli

RUSTC_WRAPPER=sccache cargo install \
 coreutils --locked --features macos

RUSTC_WRAPPER=sccache cargo install \
 cargo install taplo-cli --locked --features lsp

# RUSTC_WRAPPER=sccache cargo install-update -a


# Python
rtx use --global python@3.11
curl -sSL https://install.python-poetry.org | python3 -

# SSH
ssh-keygen
