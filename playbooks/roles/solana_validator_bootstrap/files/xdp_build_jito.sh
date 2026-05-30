#!/bin/bash

TAG="${1:-v2.0.19-jito}"
echo "TAG=$TAG"

echo Check if required packages are installed.

packages=("libssl-dev" "libudev-dev" "pkg-config" "zlib1g-dev" "llvm" "clang" "cmake" "make" "libprotobuf-dev" "protobuf-compiler" "libclang-dev")
missing_packages=()

for package in "${packages[@]}"
do
    if dpkg -s "$package" >/dev/null 2>&1; then
        echo "$package is installed."
    else
        missing_packages+=($package)
    fi
done

# shellcheck disable=SC2128
[ "${#missing_packages[@]}" -ne 0 ] && {
    echo ERROR: following packages are missing "${missing_packages[@]}";
    echo hint: sudo apt install -y "${missing_packages[@]}"
    exit 1;
  }

[ -f "$HOME"/.cargo/env ] && source "$HOME/.cargo/env"

if ! command -v cargo &> /dev/null
then
  curl https://sh.rustup.rs -sSf | sh
  source "$HOME/.cargo/env"
fi

rustup component add rustfmt

rustup update


[ -d jito-solana ] || git clone https://github.com/jito-foundation/jito-solana.git --recurse-submodules

pushd jito-solana > /dev/null

git fetch
if git tag --list | grep "$TAG"; then 
  echo "building $TAG"
  git checkout tags/"$TAG"
  git submodule update --init --recursive
  CI_COMMIT=$(git rev-parse HEAD) scripts/cargo-install-all.sh --validator-only ~/.local/share/solana/install/releases/"$TAG"
  echo "updating symlinks for active_release..."
  rm -rf "$HOME"/.local/share/solana/install/active_release
  ln -sf "$HOME"/.local/share/solana/install/releases/"$TAG" "$HOME"/.local/share/solana/install/active_release
  echo "run ubuntu@$ sudo setcap cap_net_raw,cap_bpf,cap_net_admin,cap_perfmon=p `which agave-validator`"
else
  echo "invalid git tag: $TAG  hint: git tag|grep jito|sort -V"
fi

popd >/dev/null