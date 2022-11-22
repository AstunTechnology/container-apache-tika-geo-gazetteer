#!/usr/bin/env bash
set -e

if [[ ! -f gb.zip ]]; then
    echo "Downloading 'OS Open Names'"
    wget -O gb.zip "https://api.os.uk/downloads/v1/products/OpenNames/downloads?area=GB&format=CSV&redirect"
fi
if [[ ! -f en-ner-location.bin ]]; then
    echo "Downloading 'en-ner-location.bin'"
    curl -O https://opennlp.sourceforge.net/models-1.5/en-ner-location.bin
fi
if [[ ! -f custom-mimetypes.xml ]]; then
    echo "Downloading 'custom-mimetypes.xml'"
    curl -O https://raw.githubusercontent.com/chrismattmann/geotopicparser-utils/master/mime/org/apache/tika/mime/custom-mimetypes.xml
fi
if [[ ! -f tika-server-standard-2.6.0.jar ]]; then
    echo "Downloading 'tika-server-standard-2.6.0.jar'"
    curl -O https://downloads.apache.org/tika/tika-server-standard-2.6.0.jar
fi