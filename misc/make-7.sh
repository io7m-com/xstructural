#!/bin/sh -ex

pushd com.io7m.xstructural.xml/src/main/xsl/com/io7m/xstructural/xml/s7

rm -f xstructural7* xstructural8*

cp ../s8/* .

for FILE in *.xsl
do
  FILE_TO=$(echo "${FILE}" | sed -e 's/xstructural8/xstructural7/g')
  mv "${FILE}" "${FILE_TO}"
done

rm xstructural7-blocks-epub.xsl
rm xstructural7-epub.xsl
rm xstructural7-epub-package.xsl

for FILE in *.xsl
do
  FILE_TMP="${FILE}.tmp"
  sed -e 's/urn\:com\.io7m\.structural\:8\:0/urn:com.io7m.structural:7:0/g; s/xstructural8/xstructural7/g' < "${FILE}" > "${FILE_TMP}"
  mv "${FILE_TMP}" "${FILE}"
done

