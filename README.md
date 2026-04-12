## Termipedia


Termipedia is a POSIX shell script for searching Wikipedia without the hassle of opening a web browser because it lives in your terminal. It has fuzzy searching, disambiguation page handling, and is lightweight all out of the box

## Dependencies

<details>
<summary>Alpine</summary>

```sh
apk add curl jq fzf less
```
</details>

<details>
<summary>Arch</summary>

```sh
pacman -S curl jq fzf less
```
</details>

<details>
<summary>Debian/Ubuntu</summary>

```sh
apt install curl jq fzf less
```
</details>

<details>
<summary>Fedora</summary>

```sh
dnf install curl jq fzf less
```
</details>

<details>
<summary>macOS (Homebrew)</summary>

```sh
brew install curl jq fzf
```
</details>


## Installation

```sh
git clone https://github.com/kantiankant/Termipedia
cd Termipedia
doas/sudo cp termipedia.sh /usr/local/bin/termipedia
```

<details>
<summary>
Using Nix
</summary>

Run without installing:

```sh
nix run github:kantiankant/Termipedia -- <search query>
# or
nix shell github:kantiankant/Termipedia
termipedia <search query>
```

Install:
```sh
nix profile add github:kantiankant/Termipedia
```

Or add to your NixOS/Home-Manager configuration:

```nix
inputs.termipedia.url = "github:kantiankant/Termipedia";
# then include this in your packages
inputs.termipedia.packages.${system}.termipedia
```
</details>


## Usage

```sh
termipedia <search query>
```
## License

GPL-v3


