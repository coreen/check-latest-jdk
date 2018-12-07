#!/bin/sh

# Coreen Yuen
# created to work with https://github.com/vjkoskela/jdk-wrapper as autoupdate notification when building project
# checks current version in .jdkw with newest released version of jdk/jre from oracle to see if up-to-date

# grab newest version
# resource: http://stackoverflow.com/questions/12952699/java-check-latest-version-programatically
STR=`curl -s https://java.com/en/download/installed8.jsp | grep latest8Version`

SUBSTR=${STR##* }
LEN=${#SUBSTR}

VERSION=${SUBSTR:1:LEN-4}

MAJOR=${VERSION:2:1}
MINOR=${VERSION##*_}

NEWEST_VERSION=${MAJOR}u${MINOR}

# grab current version if exists in either .jdkw file or environment variable
if [ -f ".jdkw" ]; then
	source ./.jdkw
fi
if [ -z "${JDKW_VERSION}" ]; then
	printf "Required JDKW_VERSION (e.g. 8u65) environment variable not set\\n" 1>&2
	exit 1
fi
CURRENT_VERSION=$JDKW_VERSION

# output if versions differ to stderr, otherwise to stdout with good to go
if [[ "$CURRENT_VERSION" != "$NEWEST_VERSION" ]]; then
	# wrapper around warning for red color highlighting in shell
	printf "\033[0;31mWARNING:\033[0m Project is on an older version of jdk/jre, please visit\\n" 1>&2
	printf "http://www.oracle.com/technetwork/java/javase/downloads/index.html\\n" 1>&2
	printf "to update your .jdkw file or run command with the latest version\\n" 1>&2
	exit 1
else
	printf "Project is on the latest jdk/jre version.\\n"
	exit 0
fi
