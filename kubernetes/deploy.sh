#!/bin/bash

# This is a pretty hacky script for (manual) deployment / testing of deploy on GCE

function usage() {
   echo "Usage:
           ./deploy.sh PROJECT CLUSTERNAME ZONE

         1. You should already have a cluster created! If not, see
         https://cloud.google.com/kubernetes-engine/docs/how-to/creating-a-cluster

         2. To write this script I am mimicking the following tutorial:
         https://cloud.google.com/kubernetes-engine/docs/tutorials/guestbook
         "
}

# Must have two arguments, project and cluster name

if [ $# -eq 0 ]; then
    usage()
    exit 1
fi

# Make sure you have kubectl

test `which kubectl` && echo "Found kubectl" || echo "Cannot find kubectl" && exit

project="srcc-nero-dev"; 
cluster_name="epad-dev-test-2018-6-6"; 
zone="us-west1-c";

while true; do
    case ${1:-} in
        -h|--help|help)
            usage
            exit 0
        ;;
        -p|--project)
            shift
            project="${1:-}"
            shift
        ;;
        -z|--zone)
            shift
            zone="${1:-}"
            shift
        ;;
        -c|--cluster)
            shift
            cluster_name="${1:}"
            shift
        ;;
        \?) printf "illegal option: -%s\n" "$option" >&2
            usage
            exit 1
        ;;
        -*)
            printf "illegal option: -%s\n" "$option" >&2
            usage
            exit 1
        ;;
        *)
            break;
        ;;
    esac
done

echo ""
echo "project: ${project}"
echo "cluster: $cluster_name}"
echo "zone   : ${zone}"
echo ""

# Make sure we are logged in
gcloud auth login ${project}
gcloud config set project ${project}
gcloud config set compute/zone ${zone}

echo "Getting credentials for ${cluster_name}"
gcloud container clusters get-credentials ${cluster_name} --project ${project} --zone ${zone}


################################################################################
# Persistent Volume
################################################################################


echo "To see configuration details:"
echo "gcloud container clusters describe $cluster_name"

echo "Deploying Persistent Volume dicomproxy..."
kubectl create -f dicomproxy-persistentvolumeclaim.yaml
kubectl get pvc


################################################################################
# MYSQL
################################################################################


echo "Deploying mysql..."
kubectl create -f mysql-deployment.yaml
pod_mysql=$(basename `kubectl get pods -o=name`)
echo "To see logs:"
echo "kubectl logs ${pod_mysql}"
echo "To delete:"
echo "kubectl delete --filename mysql-deployment.yaml"
echo "To connect to an interactive session"
echo "kubectl exec -it "${pod_mysql}" -- /bin/bash"

sleep 10
echo "Running install steps for mysql"
kubectl exec -it ${pod_mysql} -- /bin/sh /home/install.sh

# We probably also might want a persistent volume for mysql
# https://kubernetes.io/docs/tasks/run-application/run-single-instance-stateful-application/#deploy-mysql


################################################################################
# Dcm4chee
################################################################################

#echo "Creating dcm4chee deployment..."
#kubectl create -f epad-dcm4chee-deployment.yaml
#kubectl create -f dcm4chee-service.yaml


################################################################################
# eXist
################################################################################

echo "Creating eXist-db deployment..."
kubectl create -f exist-deployment.yaml
kubectl create -f exist-service.yaml


################################################################################
# epad
################################################################################

echo "Creating epad deployment..."
kubectl create -f epad-deployment.yaml
kubectl create -f epad-service.yaml


################################################################################
# Both?
################################################################################

#echo "Creating epad-dcm4chee deployment..."
#kubectl create -f epad-dcm4chee-deployment.yaml
#kubectl create -f dcm4chee-service.yaml
