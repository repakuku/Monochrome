set -euo pipefail

cd ./Project

# Ensure Homebrew
if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

# Ensure mise
if ! command -v mise >/dev/null 2>&1; then
  brew install mise
fi
eval "$(mise activate bash)"

# Ensure tuist (same as build)
mise install tuist@3.36.2
mise use -g tuist@3.36.2
export PATH="$HOME/.local/share/mise/shims:$PATH"
hash -r

# Generate Xcode project (so build scripts and paths are correct)
tuist generate

# Run local SwiftLint binary committed in repo
SwiftLint/swiftlint --version
SwiftLint/swiftlint
