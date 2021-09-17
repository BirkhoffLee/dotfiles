#!/bin/bash
set -x
rm Brewfile Brewfile.lock.json
brew bundle dump
git add Brewfile
git commit -S -m "chore: update Brewfile"
