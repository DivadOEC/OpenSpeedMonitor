#!/bin/bash

if [ -z $bamboo_ci_app_version ]; then
  echo "No version-number found: ${bamboo_ci_app_version}"
  exit 1
else
  echo "Found version-number: ${bamboo_ci_app_version}"

  git config user.email "jenkins@seu.hh.iteratec.de"
  git config user.name "jenkins@seu"

  git add --all
  git commit -m "[${bamboo_ci_app_version}] version update"

  git status

  git tag $bamboo_ci_app_version
  git pull --rebase
  git config push.default simple
  git remote add github ${bamboo.planRepository.repositoryUrl}
  git push github ${bamboo.planRepository.branch}
fi
