#!/bin/bash
set -o errexit

# Install Flutter if needed (Render uses cached builds, but this ensures a clean install)
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Enable web
flutter config --enable-web

# Get dependencies
flutter pub get

# Build the web app
flutter build web
