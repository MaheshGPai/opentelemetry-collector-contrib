#! /bin/bash

TAG=$1
unset GREP_OPTIONS
unset GREP_COLOR
if [ "${TAG}" == "" ]
then
  echo
  echo Unable to retrive the version
  echo
  exit 1
fi

function createTag() {
    git tag -d ${TAG}
    git push --delete intuit_remote ${TAG}
    
    git tag ${TAG}
    git push intuit_remote ${TAG}

    echo
    echo Generating tags for extensions....
    for extension in `ls -1 extension | grep jaegerremotesampling`
    do
      git tag -d extension/${extension}/${TAG}
      git push --delete intuit_remote extension/${extension}/${TAG}

      git tag extension/${extension}/${TAG}
      git push intuit_remote extension/${extension}/${TAG}
    done

    echo
    echo Generating tags for connectors....
    for processor in `ls -1 connector | grep spanmetricsconnector`
    do
      git tag -d connector/${processor}/${TAG}
      git push --delete intuit_remote connector/${processor}/${TAG}

      git tag connector/${processor}/${TAG}
      git push intuit_remote connector/${processor}/${TAG}
    done
}

createTag
