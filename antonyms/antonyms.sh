#!/usr/bin/env bash

# Get the entries in compact format
jq -c '.words' ../raw/jmdict-eng-common-3.5.0.json > jmdict.json

# Select all entries where any sense has an antonym
jq '[ .[] | select(.sense[].antonym[] | length > 0) ]' jmdict.json > antonyms.json

jq '
map(
    {
        kanji: .kanji | map(.text) | unique | join("・"),
        kana: .kana | map(.text) | unique | join("・"),
        antonym: .sense[].antonym | flatten | map(select(type != "number")) | join("・")
    }
)
| map(select(.antonym != ""))
| unique
' antonyms.json > kanji_kana_antonym.json
