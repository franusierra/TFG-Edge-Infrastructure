#!/bin/bash
# Infrastructure setup script 
#
# ARG_OPTIONAL_SINGLE([host-ip], [i], [Select the ip of the host with passwordless ssh configured from your machine])
# ARG_OPTIONAL_BOOLEAN([local], , [Deploy the cluster on localhost (Overrides ip)])
# ARG_OPTIONAL_BOOLEAN([no-monitoring], , [Disables the kube-metrics monitoring])
# ARG_HELP([Script for inicialization of the infrastructure])
# ARGBASH_GO

# [ <-- needed because of Argbash


# Check for kubectl installation
if ! command -v "kubectl" &> /dev/null
then
    echo "Error: Kubectl needs to be installed for the installation script"
    echo "You can get info on the installation proccess on: "
    echo "  https://kubernetes.io/es/docs/tasks/tools/install-kubectl/"
    exit 1
fi
# Check for k3sup installation
if ! command -v "k3sup" &> /dev/null
then
    echo "Error: K3sup needs to be installed for the installation script"
    echo "You can get info on the installation proccess on: "
    echo "  https://kubernetes.io/es/docs/tasks/tools/install-kubectl/"
    exit 1
fi

# Local installation
if [ $_arg_local ]
then
  k3sup install --local-path=~/.kube/config --local
  
  
  if [ ! $_arg_no-monitoring ]
    echo "Deploying monitoring resources... "
    kubectl apply -f monitoring/
    echo "Waiting for grafana to be ready..."
    kubectl wait --for=condition=available --timeout=600s deployment/prometheus-grafana -n monitoring
    echo "You can now access grafana metrics on localhost/monitoring"
  fi
  kubectl apply -f namespaces/
  kubectl apply -f deployment/

else
  if [$_arg_host-ip]
  then
    echo "Error: Option not yet supported :("
    exit 1
  else
    echo "Error: You need to specify the host-ip"
    exit 1
  fi
fi


# ] <-- needed because of Argbash