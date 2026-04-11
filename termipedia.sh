#!/usr/bin/env sh
set -eu

API="https://en.wikipedia.org/w/api.php"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/wiki"
mkdir -p "$CACHE_DIR"

BLUE="$(printf '\033[34m')"
RESET="$(printf '\033[0m')"

NO_CACHE=0
QUERY=""

while [ $# -gt 0 ]; do
    case "$1" in
        -n|--no-cache) NO_CACHE=1 ;;
        -h|--help) exit 0 ;;
        *) QUERY="$1" ;;
    esac
    shift
done

[ -z "$QUERY" ] && exit 1

for cmd in curl jq fzf; do
    command -v "$cmd" >/dev/null 2>&1 || exit 1
done

HAS_BAT=1
command -v bat >/dev/null 2>&1 || HAS_BAT=0


cache_file() {
    printf "%s/%s.json" "$CACHE_DIR" "$1"
}

fetch() {
    URL="$1"
    FILE="$2"

    if [ "$NO_CACHE" -eq 0 ] && [ -f "$FILE" ]; then
        cat "$FILE"
    else
        curl -fsSL --retry 2 --connect-timeout 5 --max-time 10 "$URL" | tee "$FILE"
    fi
}

render() {
    TEXT="# $1

$2"

    if [ "$HAS_BAT" -eq 1 ]; then
        printf "%s" "$TEXT" | bat --language=markdown --style=plain --paging=always
    else
        printf "%s" "$TEXT" | less
    fi
}

article() {
    TITLE_RAW="$1"
    TITLE_ENC=$(printf '%s' "$TITLE_RAW" | jq -sRr @uri)

    FILE=$(cache_file "$TITLE_ENC")

    RES=$(fetch \
        "$API?action=query&titles=$TITLE_ENC&prop=extracts|pageprops&explaintext=1&format=json&redirects=1" \
        "$FILE" || true)

    [ -z "$RES" ] && return 1

    TITLE=$(printf '%s' "$RES" | jq -r '.query.pages | to_entries[0].value.title // empty')
    BODY=$(printf '%s' "$RES" | jq -r '.query.pages | to_entries[0].value.extract // empty')
    DISAMBIG=$(printf '%s' "$RES" | jq -r '.query.pages | to_entries[0].value.pageprops.disambiguation? // empty')

    [ -z "$TITLE" ] && return 1

    # DISAMBIGUATION HANDLING
    if [ -n "$DISAMBIG" ]; then
        SEL=$(curl -fsSL --retry 2 \
            "$API?action=query&titles=$TITLE_ENC&prop=links&pllimit=max&format=json" \
        | jq -r '.query.pages | to_entries[0].value.links[].title' \
        | grep -v ":" \
        | fzf \
            --prompt="${BLUE}Select > ${RESET}" \
            --preview "
t=\$(printf '%s' {} | jq -sRr @uri)
curl -fsSL '$API?action=query&titles='\$t'&prop=extracts&explaintext=1&format=json' 2>/dev/null \
| jq -r '.query.pages | to_entries[0].value.extract // \"\"' | head -n 20
")

        [ -z "$SEL" ] && return 0
        article "$SEL"
        return
    fi

    render "$TITLE" "$BODY"
}

# SEARCH + SELECT
SEL=$(curl -fsSL --retry 2 \
    "$API" \
    --data-urlencode "action=query" \
    --data-urlencode "list=search" \
    --data-urlencode "srsearch=$QUERY" \
    --data-urlencode "format=json" \
    --data-urlencode "srlimit=20" \
| jq -r '.query.search[].title' \
| fzf \
    --prompt="${BLUE}Wiki > ${RESET}" \
    --preview "
t=\$(printf '%s' {} | jq -sRr @uri)
curl -fsSL '$API?action=query&titles='\$t'&prop=extracts&explaintext=1&format=json' 2>/dev/null \
| jq -r '.query.pages | to_entries[0].value.extract // \"\"' | head -n 20
")

[ -z "$SEL" ] && exit 0

article "$SEL"
