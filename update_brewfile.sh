#!/bin/bash
set -x
rm Brewfile Brewfile.lock.json
brew bundle dump
