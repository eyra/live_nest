#!/bin/sh -e

asdf plugin-add erlang || true
asdf plugin-add elixir || true

asdf install

asdf exec mix deps.get

pre-commit install

echo "All done. Reload your shell to enable the new commands."