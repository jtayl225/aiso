#!/bin/bash
set -o errexit

# Install Flutter if needed (Render uses cached builds, but this ensures a clean install)
# git clone https://github.com/flutter/flutter.git -b stable

# Check if Flutter is already cloned (cached between builds)
if [ ! -d "$HOME/flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable "$HOME/flutter"
fi

export PATH="$PATH:`pwd`/flutter/bin"

# Enable web
flutter config --enable-web

# Get dependencies
flutter pub get

# Build the web app
flutter build web
