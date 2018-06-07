#!/bin/bash

# Create Dicomproxy Hierarchy
mkdir -p DicomProxy/mysql
mkdir -p DicomProxy/etc
mkdir -p DicomProxy/etc/scripts
mkdir -p DicomProxy/dcm4chee
mkdir -p DicomProxy/bin
mkdir -p DicomProxy/tmp
mkdir -p DicomProxy/jetty
mkdir -p DicomProxy/log
mkdir -p DicomProxy/lib
mkdir -p DicomProxy/lib/plugins
mkdir -p DicomProxy/webapps
mkdir -p DicomProxy/resources
mkdir -p DicomProxy/resources/annotations
mkdir -p DicomProxy/resources/dicom
mkdir -p DicomProxy/resources/download
mkdir -p DicomProxy/resources/fileupload
mkdir -p DicomProxy/resources/files
mkdir -p DicomProxy/resources/download
mkdir -p DicomProxy/resources/schema
mkdir -p DicomProxy/resources/templates
mkdir -p DicomProxy/resources/upload

# Download the war, if it doesn't exist
if [ ! -f "DicomProxy/webapps/ePad.war" ]; then
    wget --directory-prefix=DicomProxy/webapps/ ftp://epad-distribution.stanford.edu/ePad.war
fi

# Download the jar, if it doesn't exist
if [ ! -f "DicomProxy/lib/epad-ws-1.1-jar-with-dependencies.jar" ]; then
    wget --directory-prefix=DicomProxy/lib/ ftp://epad-distribution.stanford.edu/epad-ws-1.1-jar-with-dependencies.jar
fi
