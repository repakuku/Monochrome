cd ./Project

xcodebuild test-without-building \
    -workspace 'Monochrome.xcworkspace' \
    -scheme 'MonochromeTests' \
    -destination 'platform=iOS Simulator,name=iPhone 17 Pro Max' \
