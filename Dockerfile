FROM rubinlab/epad

# docker build -t srcc/epad:epad -f Dockerfile.epad .

# Add install script to do the same
COPY ./epad-install.sh /epad-install.sh

# Create /root/DicomProxy Hierarchy
RUN mkdir -p /root/DicomProxy/mysql && \
    mkdir -p /root/DicomProxy/etc  && \
    mkdir -p /root/DicomProxy/etc/scripts  && \
    mkdir -p /root/DicomProxy/etc/scripts/so  && \
    mkdir -p /root/DicomProxy/dcm4chee  && \
    mkdir -p /root/DicomProxy/bin  && \
    mkdir -p /root/DicomProxy/tmp && \
    mkdir -p /root/DicomProxy/jetty  && \
    mkdir -p /root/DicomProxy/log && \
    mkdir -p /root/DicomProxy/lib && \
    mkdir -p /root/DicomProxy/lib/plugins && \
    mkdir -p /root/DicomProxy/webapps && \
    mkdir -p /root/DicomProxy/resources && \
    mkdir -p /root/DicomProxy/resources/annotations && \
    mkdir -p /root/DicomProxy/resources/dicom && \
    mkdir -p /root/DicomProxy/resources/download && \
    mkdir -p /root/DicomProxy/resources/fileupload && \
    mkdir -p /root/DicomProxy/resources/files && \
    mkdir -p /root/DicomProxy/resources/download && \
    mkdir -p /root/DicomProxy/resources/schema && \
    mkdir -p /root/DicomProxy/resources/templates && \
    mkdir -p /root/DicomProxy/resources/upload  && \
    wget --directory-prefix=/root/DicomProxy/webapps/ ftp://epad-distribution.stanford.edu/ePad.war  && \
    wget --directory-prefix=/root/DicomProxy/lib/ ftp://epad-distribution.stanford.edu/epad-ws-1.1-jar-with-dependencies.jar && \
    chmod u+x /epad-install.sh

EXPOSE 8080
