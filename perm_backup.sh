#!/bin/bash
# Backup linux file permission before changing it for a specific action, then restore old ones

FILE=$1
NEW_PERM=777

# Backup permission
FILE_PERM_ORIGIN=$(getfacl -R ${FILE})
echo -n "File Permission backuped: "
ls -lh ${FILE}

# Change permission
echo -n "File Permission changed:  "
chmod ${NEW_PERM} ${FILE}
ls -lh ${FILE}
# do some stuff

# Restore previous permission
setfacl --set-file=<(echo "${FILE_PERM_ORIGIN}") ${FILE}
echo -n "File Permission restored: "
ls -lh ${FILE}
