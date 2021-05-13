#!/bin/bash

DEVICE_NAME=

OFFSET_PARTITION=
DESTINATION_FOLDER=
FOLDER_TO_RECOVER_PATTERN_SEARCH=
VERBOSE="echo"
#VERBOSE=":" # To disable print


if [ -z "${DEVICE_NAME}" ]; then
    lsblk
    read -p "Enter the device to recover " DEVICE_NAME
fi

if [ -z "${OFFSET_PARTITION}" ]; then
    mmls ${DEVICE_NAME}
    read -p "Enter the start (offset) of the partition to recover " OFFSET_PARTITION
fi

if [ -z "${FOLDER_TO_RECOVER_PATTERN_SEARCH}" ]; then
    fls -o${OFFSET_PARTITION} ${DEVICE_NAME}  
    read -p "Enter folder name or inode to recover " FOLDER_TO_RECOVER_PATTERN_SEARCH
fi

${VERBOSE} "Pattern researched \"${FOLDER_TO_RECOVER_PATTERN_SEARCH}\""
if [ -z "${FOLDER_TO_RECOVER_PATTERN_SEARCH}" ]; then
    echo "whole disk"
    echo "not tested"
    exit 1
fi

if [ -z "${DESTINATION_FOLDER}" ]; then
    read -p "Enter the destination folder for the recovery " DESTINATION_FOLDER   
fi
mkdir -p "${DESTINATION_FOLDER}"

FOLDER_RES=$(fls -o${OFFSET_PARTITION} ${DEVICE_NAME}  | grep "${FOLDER_TO_RECOVER_PATTERN_SEARCH}")
FOLDER_INODE=$(echo ${FOLDER_RES} | awk '{ print $2}' | sed 's/:$//')
FOLDER_NAME=$(echo ${FOLDER_RES} | sed 's/.\+:\s//') # Spaces managed
${VERBOSE} "Folder Inode ${FOLDER_INODE}"
${VERBOSE} "Folder Name \"${FOLDER_NAME}\""
read -p "Is this correct ? Press a key to continue, CTRL-C to quit "

LIST_ELEMENTS=$(fls -pr -o${OFFSET_PARTITION} ${DEVICE_NAME} ${FOLDER_INODE})
LIST_FILES=$(echo "${LIST_ELEMENTS}" | grep "^r" )
LIST_DIR=$(echo "${LIST_ELEMENTS}" | grep "^d" | sed 's/^d.\+:\t//'  )

# Creating folder structure (spaces in folder's name are managed)
echo "${LIST_DIR}" | while read dir_name; do
    mkdir -p "${DESTINATION_FOLDER}/${FOLDER_NAME}/${dir_name}"
done

if [ -z "${LIST_FILES}" ]; then
    echo "Empty folder"
    exit 0
fi

echo "${LIST_FILES}" | while read file; do
    file_inode=$(echo ${file} | awk '{ print $2}' | sed 's/:$//')
    file_name=$(echo ${file} | sed 's/^r.\+: //' )
    ${VERBOSE} "Recovering ${file_name}"
    icat -o${OFFSET_PARTITION} -r ${DEVICE_NAME} ${file_inode} > "${DESTINATION_FOLDER}/${FOLDER_NAME}/${file_name}"
    unset file_inode
    unset file_name
done 


${VERBOSE} "Recovery finished"
