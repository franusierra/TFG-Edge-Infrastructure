#!/bin/bash
kubectl apply -f namespaces
kubectl apply -f secrets
kubectl apply -f deployment --recursive
kubectl apply -f monitoring