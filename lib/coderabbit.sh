#!/bin/sh
# -*- mode: sh -*-
# vim: set ft=sh :

set -eu
cd "$(cd "$(dirname "$0")"; pwd)/.."

# Download to a temp file first: `curl ... | sh -` would let a failed
# curl exit the pipeline at 0 (sh runs on an empty stdin), silently
# skipping the install instead of failing this stage.
installer="$(mktemp)"
trap 'rm -f "$installer"' EXIT
curl -fsSL https://cli.coderabbit.ai/install.sh -o "$installer"

# CI=1 is scoped to this one invocation only (not exported for the rest
# of this script): it makes the installer skip its interactive
# post-install "Start browser sign-in now? [Y/n]" prompt, which
# otherwise blocks on stdin during a non-interactive setup run.
CI=1 sh "$installer"
