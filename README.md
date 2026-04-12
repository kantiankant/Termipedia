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
<summary>Void Linux</summary>

```sh
xbps-install -S curl jq fzf less
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


## Usage

```sh
termipedia <search query>
```
## License

GPL-v3


