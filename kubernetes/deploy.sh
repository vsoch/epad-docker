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
# Cluster Generation
################################################################################

echo "To see configuration details:"
echo "gcloud container clusters describe $cluster_name"

echo "Deploying epad Pod..."
kubectl create -f epad-dcm4chee-mysql-deployment.yaml
pod_name=$(basename `kubectl get pods -o=name | grep epad-dcm4chee-mysql`)
echo "To see logs:"
echo "kubectl logs ${pod_name} [container]"
echo "To delete:"
echo "kubectl delete --filename epad-dcm4chee-mysql-deployment.yaml"
echo "To connect to an interactive session"
echo "kubectl exec -it "${pod_name}" -c [container] -- /bin/bash"

# Ingress

echo "Deploying epad ingress..."
kubectl create -f epad-ingress.yaml

# Install MySql Tables

sleep 10
echo "Running install steps for mysql"
kubectl exec -it ${pod_name} -c mysql -- /bin/sh /home/install.sh
sleep 10

# Download epad war file and jar
echo "Creating e-pad web"
kubectl exec -it ${pod_name} -c epad-web -- /bin/bash /epad-install.sh

# This is nonsense, but it's what worked with docker-compose
sleep 10
kubectl exec -it ${pod_name} -c mysql -- /bin/sh /home/install.sh
sleep 10
kubectl exec -it ${pod_name} -c epad-web -- sh /root/epad/bin/epad-server-start.sh
