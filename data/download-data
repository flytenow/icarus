#!/bin/sh

wget -S -O - www.asias.faa.gov/pls/apex/f?p=100:11:11909836031811:FLOW_EXCEL_OUTPUT_R10467849238746298_en > ./faa.txt
curl http://www.ntsb.gov/aviationquery/download.ashx?type=csv > ./ntsb.txt

sudo cp ./faa.txt ./ntsb.txt /tmp
sudo chown mysql:mysql /tmp/faa.txt /tmp/ntsb.txt
rm -rf ./faa.txt ./ntsb.txt

cat ./create-tables.sql | mysql -u root icarus --skip-column-names
