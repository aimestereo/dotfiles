
# Install Xcode and command line tool
sudo xcode-select --switch /Applications/Xcode.app


# Install apps
brew install --cask \
  karabiner-elements hammerspoon `# Keyboard customizer & Automation` \
  fluor `# Change the behavior of the fn keys depending on the active application` \
  mos `# Smooths scrolling and set mouse scroll directions independently` \
  force-paste gitup sourcetree visual-studio-code iterm2 teamviewer telegram slack \
  hadolint `# Dockerfile linting` \
  shfmt `# for VSCod shell-format` \
  android-file-transfer \
  raycast 1password/tap/1password-cli `# Spotlight replacement + plugin fro 1password` \
  arc `# browser` \
  postman \
  vlc \
  amethyst  `# window manager` \
  diff-so-fancy

# Install shell utils

brew install \
 gcc openssl \
 python psql wget git cookiecutter \
 awscli \
 aws/tap/aws-sam-cli `# PyCharm Extention - AWS Serverless Application Model Command Line Interface (AWS SAM CLI)` \
 neovim \
 ripgrep `# dependency of telescope (nvim plug)` \
 tmux fzf \
 jq \
 ngrok \
 rsync \
 pnpm yarn \
 vercel-cli \
 minikube kubectl \
 hashicorp/tap/terraform terragrunt \
 pre-commit \
 openjdk \
 stow

# Copy all config files
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
