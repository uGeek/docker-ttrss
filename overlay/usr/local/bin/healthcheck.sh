#!/bin/sh

set -eo pipefail
URL=http://localhost

wget --quiet --tries=1 --spider ${URL}
[ $? -ne 0 ] && exit 1

CONTENT=$(wget --quiet -O - ${URL})
case "$CONTENT" in
  *Exception*) exit 1 ;;
  *alert-*alert-*SELF_URL_PATH*) exit 1 ;;
  *alert-*SELF_URL_PATH*alert-*) exit 1 ;;
  *SELF_URL_PATH*alert-*alert-*) exit 1 ;;
esac

exit 0
