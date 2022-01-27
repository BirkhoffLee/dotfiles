#!/bin/bash
set -x
# rm Brewfile Brewfile.lock.json
brew bundle dump --describe --force
git add Brewfile
git commit -m "chore: update Brewfile"
