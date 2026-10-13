# Wikilayer APT repository

Debian and Ubuntu packages of Wikilayer tools, for amd64 and arm64.

## Install

```sh
sudo curl -fsSL -o /usr/share/keyrings/wikilayer.gpg https://wikilayer.github.io/apt/wikilayer.gpg
echo "deb [signed-by=/usr/share/keyrings/wikilayer.gpg] https://wikilayer.github.io/apt stable main" \
  | sudo tee /etc/apt/sources.list.d/wikilayer.list
sudo apt update
sudo apt install wlget
```

`apt upgrade` then brings new versions.

## Packages

- [wlget](https://github.com/wikilayer/wlget) prints a Wikilayer page, wiki or
  chat in the terminal.

## Signing key

The index is signed with the key in
[`wikilayer.gpg`](https://github.com/wikilayer/apt/blob/main/wikilayer.gpg)
(armored: [`wikilayer.asc`](https://github.com/wikilayer/apt/blob/main/wikilayer.asc)),
fingerprint `8EC9 FCEC 18EB 53DD 891F 78EE A731 992C 5647 65AF`.

## Publishing

The Publish workflow takes a release of a wikilayer repository, adds its `.deb`
files to `pool/` and signs a new index under `dists/`. A file already in the pool
is never replaced: a changed package is a new version. The Withdraw workflow
takes a version out of the pool and the index when it must not be offered any
more, and refuses to take out the last version of a package. Two runs at once do not
queue: the later push fails, and running it again is safe. `make test` checks
the repository end to end in a Debian container.
