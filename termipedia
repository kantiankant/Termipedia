#!/bin/sh

if [ -z "$1" ]; then
    echo "Usage: wikisearch <query>" >&2
    exit 1
fi

fetch_article() {
    ENCODED=$(printf '%s' "$1" | sed 's/ /_/g')

    RESPONSE=$(curl -s \
        "https://en.wikipedia.org/w/api.php?action=query&titles=${ENCODED}&prop=extracts%7Cpageprops&explaintext=true&format=json&redirects=1")

    IS_DISAMBIG=$(printf '%s' "$RESPONSE" \
        | jq -r '.query.pages | to_entries[0].value | .pageprops | has("disambiguation") | tostring')

    if [ "$IS_DISAMBIG" = "true" ]; then
        echo "Disambiguation page. Pick one:" >&2

        SELECTION=$(curl -s \
            "https://en.wikipedia.org/w/api.php?action=query&titles=${ENCODED}&prop=links&pllimit=max&format=json&redirects=1" \
            | jq -r '.query.pages | to_entries[0].value | .links[].title' \
            | grep -v ":" \
            | fzf --prompt="Disambiguate > ")

        if [ -z "$SELECTION" ]; then
            echo "Nothing selected. Fine. Suit yourself." >&2
            exit 0
        fi

        fetch_article "$SELECTION"
    else
        printf '%s' "$RESPONSE" \
            | jq -r '.query.pages | to_entries[0].value | "# " + .title + "\n\n" + .extract' \
            | less
    fi
}

QUERY=$(printf '%s' "$1" | sed 's/ /_/g')

SELECTION=$(curl -s \
    "https://en.wikipedia.org/w/api.php?action=query&list=search&srsearch=${QUERY}&format=json&srlimit=20" \
    | jq -r '.query.search[].title' \
    | fzf --prompt="Wikipedia > ")

if [ -z "$SELECTION" ]; then
    echo "Nothing selected. Typical." >&2
    exit 0
fi

fetch_article "$SELECTION"
