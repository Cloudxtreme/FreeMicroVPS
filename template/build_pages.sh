#!/bin/bash
# build static pages
PAGES=( "index.html" "tos.html" "privacy.html" "anon_restrict.html" "reg_restrict.html" "supp_restrict.html" )
DEST_DIR=".."

mkdir -p $DEST_DIR

for page in ${PAGES[@]}
do
    SRC="`sed -r 's/html/php/' <<< $page`"

    if [ ! -f "$SRC" ]
    then
        echo File not found: $SRC
        exit 1
    fi

    echo Building page ${page}...
    php `sed -r 's/html/php/' <<< $page` > $DEST_DIR/$page
done
