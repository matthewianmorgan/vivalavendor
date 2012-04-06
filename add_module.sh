#!/bin/bash

if [ "$#" != "1" ]; then
  echo "Usage: add_module.sh {path.to.compressed.module}"
  exit 1
fi

filename=$(basename ${1})
extension=${filename##*.}

dir="sites/default/modules"

case ${extension} in
  "gz")
    command="tar zxf ${1} -C ${dir}"
    ;;
  "zip")
    command="unzip ${1} -d ${dir}"
    ;;
  *)
    echo "Unknown compression type: ${extension}"
    exit 1
    ;;
esac

# get the module name
NAME=$(echo "${filename}" | cut -d'.' -f1)
NAME=$(echo "${NAME}" | cut -d'-' -f1)

git checkout modules
${command}
git add "${dir}/${NAME}"
git commit -m "Add module ${NAME}"
git push origin modules
git checkout production
git merge modules