#!/bin/zsh

set -euo pipefail

readonly project_root="${0:A:h:h}"
readonly device_id="${1:-$(xcrun simctl list devices booted | awk -F '[()]' '/iPhone/ { print $2; exit }')}"
readonly derived_data="/tmp/PortfolioMobileiOSScreenshotDerivedData"
readonly bundle_id="org.junpeiabe.PortfolioMobileiOS"
readonly output_directory="$project_root/READMEAssets/Screenshots"

if [[ -z "$device_id" ]]; then
    print -u2 "Boot an iPhone Simulator, then run this script again."
    exit 1
fi

xcodebuild \
    -project "$project_root/PortfolioMobileiOS.xcodeproj" \
    -scheme Debug \
    -configuration Debug \
    -destination "platform=iOS Simulator,id=$device_id" \
    -derivedDataPath "$derived_data" \
    build

mkdir -p "$output_directory"
xcrun simctl install \
    "$device_id" \
    "$derived_data/Build/Products/Debug-iphonesimulator/PortfolioMobileiOS.app"
xcrun simctl status_bar "$device_id" override \
    --time 9:41 \
    --batteryState charged \
    --batteryLevel 100 \
    --wifiBars 3 \
    --cellularBars 4

screens=(
    "01-splash:splash"
    "02-login:login"
    "03-register:register"
    "04-terms:terms"
    "05-features:features"
)

for specification in "${screens[@]}"; do
    filename="${specification%%:*}"
    screen="${specification##*:}"
    xcrun simctl terminate "$device_id" "$bundle_id" >/dev/null 2>&1 || true
    xcrun simctl launch \
        "$device_id" \
        "$bundle_id" \
        -screenshot-screen "$screen"
    sleep 2
    xcrun simctl io \
        "$device_id" \
        screenshot "$output_directory/$filename.png"
done

xcrun simctl terminate "$device_id" "$bundle_id" >/dev/null 2>&1 || true
print "Screenshots saved to $output_directory"
