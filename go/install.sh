#!/bin/bash

GOVERSION=${1}
if [ -z "${GOVERSION}" ]; then
	GOVERSION=1.17.7
fi

if [ -d ${HOME}/.go/${GOVERSION} ]; then
	echo "go ${GOVERSION} is already installed."
	exit 1
fi

rm -rf ${GOHOME}/pkg
mkdir -p ${HOME}/.go/${GOVERSION}
curl https://storage.googleapis.com/golang/go${GOVERSION}.darwin-arm64.tar.gz \
	| tar xvzf - -C ${HOME}/.go/${GOVERSION}/ --strip-components=1
echo $GOVERSION > ${HOME}/.go/.goversion

