#!/bin/bash
#
# Update Icons in Jenkins from Git repo
#
# Rename and copy
#   $WORKSPACE/icons/*.png $JENKINS_HOME/userContent/customIcon

src="${WORKSPACE}/icons"
dst="${JENKINS_HOME}/userContent/customIcon"

mkdir -p ${dst}

# Update icons on Jenkins server
for Icon in $(ls -1 ${src}/*.png); do
  filename=$(basename $Icon)
  echo "Processing image: $filename"
  if [[ $filename =~ ^(.+)-logo ]]; then
    name=${BASH_REMATCH[1]}
    #echo "MATCH: logo: ${name}"
  elif [[ $filename =~ ^(.+)-[0-9]+ ]]; then
    name=${BASH_REMATCH[1]}
    #echo "MATCH: -[0-9]+: ${name}"
  else
    echo "WARNING: Unknown image name: ${filename}"
    continue
  fi
  echo "copy ${filename} ${name}.png"
  cp ${src}/${filename} ${dst}/${name}.png
done

# Generate a HTML page of the available icons
# Display both the image and the filename
(
for filepath in $(ls -1 ${JENKINS_HOME}/userContent/customIcon/*.png); do
  file=$(basename ${filepath})
  echo "<img title=${file} style=\"width: 32px; height: 32px;\" alt=${file} src=\"/userContent/customIcon/${file}\"/>"
done
) > icons.html
