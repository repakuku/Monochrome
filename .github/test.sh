cd ./Project

xcodebuild test-without-building \
    -workspace 'Monochrome.xcworkspace' \
    -scheme 'Monochrome' \
    -destination 'platform=iOS Simulator,name=iPhone 15 Pro Max'
