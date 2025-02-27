# Define Kubernetes apply and delete commands
KUBE_APPLY = kubectl apply -f
KUBE_DELETE = kubectl delete -f

# Deployment files
REDIS_DEPLOYMENT = k8s/redis-deployment.yml 
REDIS_SERVICE = k8s/redis-service.yml

FLASK_DEPLOYMENT = k8s/flask-deployment.yml 
FLASK_SERVICE = k8s/flask-service.yml

.PHONY: redis flask all expose delete run_argocd update_node_port_argocd get_secret_argocd expose_argocd

# Deploy Redis Leader
redis:
	$(KUBE_APPLY) $(REDIS_DEPLOYMENT)
	$(KUBE_APPLY) $(REDIS_SERVICE)


# Deploy Flask
flask:
	$(KUBE_APPLY) $(FLASK_DEPLOYMENT)
	$(KUBE_APPLY) $(FLASK_SERVICE)

# Deploy everything line by line
all: redis flask

expose:
	minikube service flask-service --url

# Delete all deployments and services
delete:
	$(KUBE_DELETE) $(REDIS_DEPLOYMENT) 
	$(KUBE_DELETE) $(REDIS_SERVICE) 
	
	$(KUBE_DELETE) $(FLASK_DEPLOYMENT)
	$(KUBE_DELETE) $(FLASK_SERVICE)


run_argocd:
	kubectl create namespace argocd
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml 

update_node_port_argocd:
	kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'

get_secret_argocd:
	kubectl get secrets -n argocd argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d

expose_argocd:
	 minikube service argocd-server -n argocd