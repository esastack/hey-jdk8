#! /bin/bash

GIT='git'
WHICH_GIT=`which git`
if [ ! -e ${WHICH_GIT} ]; then
  echo "Can not find valid 'git' command, please install it first."
  exit 1
fi

REPOS='hotspot jaxp jaxws jdk langtools corba nashorn'

if [ ! -d ${PWD}/.git ]; then
  echo "Please enter openjdk source root and execute this script."
  echo "Maybe this is not a git repository, please check it again."
  exit 2
fi

REMOTEURL=`${GIT} config --get remote.origin.url`
REPOURL=`echo ${REMOTEURL} | sed -e 's;\(.*\)/[^/].*;\1;'`
REPOBASE=`echo ${REMOTEURL} | sed -e 's;^.*/\(.*\)[0-9]\.git;\1;'`

for i in ${REPOS}; do
  if [ -d ${i} -a -d ${i}/.git ]; then
    echo "The repo ${i} is exist now, skip it."
    cd ${i}
    ${GIT} pull
    cd -
    continue
  fi
  SUBREPOURL=${REPOURL}/${REPOBASE}_${i}.git
  echo "Download sub repo: ${REPOBASE}_${i} into ${i} ..."
  ${GIT} clone ${SUBREPOURL} ${i}
  if [ $? != 0 ]; then
    echo "Download ${REPOBASE}_${i} failed, maybe you do not have access."
    echo "to it, please the administrator."
    exit 1
  fi 
done

echo "Download all openjdk dependencies, you can build it normally."
exit 0
