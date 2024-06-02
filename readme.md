
### set account used when using gcloud sdk cli
```
gcloud auth login
```

### set default account used to connect to google cloud
```
gcloud auth application-default login
```


### when we create the backend of terraform,

```
terraform init
```


### show terraform status:
```
 terraform state pull
```
###
```
gcloud components update
gcloud components install kubectl
gcloud container clusters get-credentials my-gke-cluster --region europe-west1 --project test-terraform-417513
```
* this command will generate the credential token in ~/.kube/config
* it will not erase the current token if we already have on, it will append it, so we can have several connection at the same time. 

```
kubectl get pod --all-namespaces 
```


### remove all the resource i created:

```
terraform destroy
```

### kube deploy 
```
kubectl get pod --all-namespaces
kubectl get namespace
kubectl apply -f ./deployment.yml
```

* only show the content in default namespace
```
kubectl get pod
kubectl get pod -o yaml
```
* log kube
```
kubectl logs [name of the output for kubectl get pod]
```

* tunnelling distant port to localhost
```
k8s kubectl port-forward pod/app-8788f7fb6-vkdvp 8080:80
```

the 8080 is the local port listen to and the 80 is the remote kube port openedup


```
kubectl get deployment
kubectl delete deployment app
```

or  delete something by file name
```
kubectl delete -f service.yml
```

* watch the service status 
```
kubectl get service -w
```


### use my own docker image:

* create a dockerHub in my cluster
* create the docker file

```
gcloud builds submit --project=test-terraform-417513 --tag europe-west1-docker.pkg.dev/test-terraform-417513/app/node:v1 .
```



### kube 



### helm
create help app

`
helm create app
`

for example:

`
helm install mysql
`


`
helm upgrade -f app/values-prod.yml
`
manually deploy k8s
app ./app => means we use which application to deploy;
v1 is the tag for the repository defined in values-prod.yml
`
helm upgrade -f app/values-prod.yml --install --set=image.tag=v1 app ./app
`
list application deployed by helm
`
helm ls
`

show:


REVISION        UPDATED                         STATUS          CHART           APP VERSION     DESCRIPTION     
1               Sun Apr 21 10:54:10 2024        superseded      app-0.1.0       1.16.0          Install complete
2               Sun Apr 21 10:56:16 2024        deployed        app-0.1.0       1.16.0          Upgrade complete


list all history of deployment
`
helm history app
`

roll back to a certain tag (the number of the revision)
`
helm rollback app 2
`



### run image

`
docker run --rm -it cedricguadalupe/terraform-gcloud:latest bash 
`

add nginx for helm
`
helm repo add nginx-stable https://helm.nginx.com/stable
`

and then update the dependencies
`
helm repo update
`

install the package
`
helm upgrade --install nginx-ingress nginx-stable/nginx-ingress 
`

remove the nginx ingress
`
helm uninstall nginx-ingress
`
delete in the actual k8s
`
kubectl delete svc nginx-ingress-controller
`
list all service in kube
`
kubectl get svc
`
list all ingress in kube:
```
 kubectl get ingress
```

delete ingress:
```
 kubectl delete ingress app
```
list all resource in kube:
`
kubectl get crd
`


###
Next step: 
create CI in github.
add a db service and connect from IDE without the connection gcloud

