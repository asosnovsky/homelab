#!/bin/bash

set -e 

minikube start
minikube addons enable ingress
minikube addons enable dashboard