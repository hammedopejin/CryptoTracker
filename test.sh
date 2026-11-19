#!/bin/bash
set -o pipefail
cd "$(dirname "$0")"
xcodebuild test -project CryptoTracker.xcodeproj -scheme CryptoTracker \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  -only-testing:CryptoTrackerTests -parallel-testing-enabled NO 2>&1 \
  | grep -E "Test case|error:|\*\* TEST"
