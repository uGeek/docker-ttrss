#!/bin/sh

set -eo pipefail
URL=http://localhost

wget --quiet --tries=1 --spider ${URL}
[ $? -ne 0 ] && exit 1

CONTENT=$(wget --quiet -O - ${URL})
case "$CONTENT" in
  *Exception*) exit 1 ;;
  *misconfiguration*) exit 1 ;;
esac

exit 0
