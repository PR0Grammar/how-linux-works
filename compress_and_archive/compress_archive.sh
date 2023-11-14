#! /usr/bin/env bash

# Create test files
rm test_* 2> /dev/null
rm arch* 2> /dev/null
touch test_a.txt test_b.txt test_c.txt 
cat large_file.txt | tee test_a.txt test_b.txt test_c.txt > /dev/null

# Compress and decompress a test file
gzip test_a.txt
echo -e "_____________Printing zipped file with size"
ls -ls | grep test_a
echo -e "_____________Printing unzipped file with size"
gunzip test_a.txt.gz
ls -ls | grep test_a

# Creating archive
tar cvf arch.tar test_*.txt > /dev/null
echo -e "_____________Created archive file"
ls -ls | grep *.tar
echo "_______________Zipped archive"
gzip arch.tar
ls -ls | grep *.gz
rm -rf arch*
echo "________________Creating zipped archive with tar zcvf"
tar zcvf arch.tar.gz test_*.txt > /dev/null
ls -ls | grep arch.tar

# Cleanup
rm test_* 2> /dev/null
rm arch* 2> /dev/null
