#!/usr/bin/env bash
set -euo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.."

# Use this Mac's native Homebrew Ruby instead of an inherited Intel/RVM Ruby.
# PREVIEW_RUBY_BIN can point to another directory containing Ruby 3.3 executables.
if [[ -n "${PREVIEW_RUBY_BIN:-}" ]]; then
  ruby_bin="$PREVIEW_RUBY_BIN"
elif [[ "$(uname -m)" == "arm64" ]]; then
  ruby_bin="/opt/homebrew/opt/ruby@3.3/bin"
else
  ruby_bin="/usr/local/opt/ruby@3.3/bin"
fi

if [[ ! -x "$ruby_bin/ruby" || ! -x "$ruby_bin/bundle" ]]; then
  echo "Ruby 3.3 / Bundler not found. Install it with: brew install ruby@3.3" >&2
  exit 1
fi

unset GEM_HOME GEM_PATH RUBY_VERSION RUBYOPT RUBYLIB BUNDLE_BIN_PATH
export PATH="$ruby_bin:$PATH"
export BUNDLE_GEMFILE="$PWD/Gemfile"
export BUNDLE_PATH="$PWD/vendor/bundle"
export BUNDLE_USER_HOME="$PWD/.bundle"

ruby -e 'abort "This preview uses Ruby 3.3.x; check PREVIEW_RUBY_BIN." unless RUBY_VERSION.start_with?("3.3.")'
ruby --version
bundle check || bundle install

# Only the local server uses an empty baseurl; deployment settings stay in _config.yml.
exec bundle exec jekyll serve --host 127.0.0.1 --port 4000 --baseurl "" --livereload "$@"
