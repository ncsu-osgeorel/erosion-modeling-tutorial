#!/bin/bash

# builds pages from source

# URL of the new version
URL="https://ncsu-geoforall-lab.github.io/erosion-modeling-tutorial/"

function build_page {
    FILE_SOURCE=$1
    FILE_TARGET=$2
    cat $HEAD_FILE > $OUTDIR/$FILE_TARGET
    echo "<!-- This is a generated file. Do not edit. -->" >> $OUTDIR/$FILE_TARGET
    FILE=$FILE_TARGET
    echo "<div style=\"background-color: #FA8; border: 4px solid #F00; padding: 10px;\"><p>This is an unmaintained course material, please see current material at:<ul><li><a href=\"$URL\">$URL</a></li><li><a href=\"$URL$FILE\">$URL$FILE</a> (likely URL)</li></ul></div>" >> $OUTDIR/$FILE_TARGET
    cat $FILE_SOURCE >> $OUTDIR/$FILE_TARGET
    cat $FOOT_FILE >> $OUTDIR/$FILE_TARGET
}

function build_page_rst {
    FILE_SOURCE=$1
    FILE_TARGET=$2
    cat $HEAD_FILE > $OUTDIR/$FILE_TARGET
    echo "<!-- This is a generated file. Do not edit. -->" >> $OUTDIR/$FILE_TARGET
    pandoc --to=html $FILE_SOURCE >> $OUTDIR/$FILE_TARGET
    cat $FOOT_FILE >> $OUTDIR/$FILE_TARGET
}

HEAD_FILE=head.html
FOOT_FILE=foot.html

CURRDIR=`pwd`
OUTDIR="build"

if [ ! -d "$OUTDIR" ]; then
    mkdir $OUTDIR
    echo "Creating directory $OUTDIR automatically."
    echo "The local build of pages will be in $OUTDIR directory."
    echo "If you are using GitHub pages to create publish the website,"
    echo "you probably want to create this directory by a dedicated script."
fi

# disable Jekyll which is not needed for out GitHub pages
touch $OUTDIR/.nojekyll

if [ ! -d "$OUTDIR" ]; then
    echo "The directory $OUTDIR does not exists and it will be created for you."
    mkdir $OUTDIR
fi

for FILE in `ls *.rst|grep -v foot|grep -v head`
do
    build_page_rst $FILE `basename --suffix=.rst $FILE`.html
done

for FILE in `ls *.html|grep -v foot|grep -v head`
do
    build_page $FILE $FILE
done

for FILE in *.css
do
    cp $FILE $OUTDIR
done

for DIR in img tables documents
do
    cp -r $DIR $OUTDIR
done
