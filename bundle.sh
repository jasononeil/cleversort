#!/bin/sh

libname='cleversort'
rm -f "${libname}.zip"
zip -r "${libname}.zip" haxelib.json src README.md
echo "Saved as ${libname}.zip"
