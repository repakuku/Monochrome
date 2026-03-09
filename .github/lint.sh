set -euo pipefail

cd ./Project

command -v brew >/dev/null || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

command -v mise >/dev/null || brew install mise
eval "$(mise activate bash)"

mise install tuist@3.36.2
mise use -g tuist@3.36.2
export PATH="$HOME/.local/share/mise/shims:$PATH"

tuist generate

SwiftLint/swiftlint
