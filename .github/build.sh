set -euo pipefail

cd ./Project

if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

if ! command -v mise >/dev/null 2>&1; then
  brew install mise
fi
eval "$(mise activate bash)"

mise install tuist@3.36.2
mise use -g tuist@3.36.2
export PATH="$HOME/.local/share/mise/shims:$PATH"
hash -r
tuist version
if [ -f "Tuist/Dependencies.swift" ]; then
  tuist fetch
fi
tuist generate

xcodebuild clean -quiet
xcodebuild build-for-testing \
    -workspace 'Monochrome.xcworkspace' \
    -scheme 'Monochrome' \
    -destination 'platform=iOS Simulator,name=iPhone 17 Pro Max' \
    CODE_SIGNING_ALLOWED=NO
