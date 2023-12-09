#! /usr/bin/env bash
set -euo pipefail


echo "Traditional UNIX filesystems have two major components: the data pool and the database that organizes the data pool"
echo "The database utilizes data structures called inodes provide metadata of files/dirs in the file system"
echo "There's an inode table that contains the list of inodes that either point to the inode data block or file content data block depending on the type."
echo "You can view the inode table with \"ls -il\" which will provide the inode number for each item and the # of links"
echo ""

mkdir ~/Desktop/tmp_dir
touch ~/Desktop/tmp_file_a
ls -il ~/Desktop

echo ""
echo "The first number is the inode number, the second is the # of links"
echo "File inodes typically have one link, but if you make a hard-link to another file, the underlying data is re-used, so we'd increment the # of links for that inode"
echo ""

# Create a hard-link from a to a new file b
ln ~/Desktop/tmp_file_a ~/Desktop/tmp_file_b
ls -il ~/Desktop

echo ""
echo "Notice that file a and b have the same inode number - they point to the same inode in the data pool."
echo "Similarly if you remove a file, the # of links for that inode will decrease. Note that if this hits 0, the kernel would remove the inode and its assosicated data"

rm ~/Desktop/tmp_file_a
ls -il ~/Desktop


# Cleanup
rm -rf ~/Desktop/tmp_*
