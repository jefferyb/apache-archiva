# jefferyb/apache-archiva

Apache Archiva image built to run on Openshift/Kubernetes/Docker environment.

## Using Openshift template

```bash
# Create a new project
$ oc new-project apache-archiva
# Do the deploy
# P.S: replace archiva.example.com with your own url

### With PersistentVolume
$ oc new-app \
  --name=apache-archiva \
  --file=https://raw.githubusercontent.com/jefferyb/apache-archiva/master/openshift-templates/apache-archiva-openshift-template.yaml \
  -p APPLICATION_URL=archiva.example.com

### Without PersistentVolume
$ oc new-app \
  --name=apache-archiva \
  --file=https://raw.githubusercontent.com/jefferyb/apache-archiva/master/openshift-templates/apache-archiva-openshift-template-ephemeral.yaml \
  -p APPLICATION_URL=archiva.example.com

### After a few min. you should be able to access it at the url you set APPLICATION_URL to, archiva.example.com
```

## Using Openshift CLI

```bash
# Deploy Apache Archiva
$ oc new-app --name=apache-archiva jefferyb/apache-archiva

# Expose the service
$ oc expose svc/apache-archiva
```

## Using Docker

```bash
# With Persistent Volume
$ docker run -itd --name apache-archiva -p 8080:8080 -v /opt/apache-archiva:/opt/app-root/archiva-base jefferyb/apache-archiva

# Without Persistent Volume
$ docker run -itd --name apache-archiva -p 8080:8080 jefferyb/apache-archiva

### After a few min. you should be able to access it at port 8080
```
