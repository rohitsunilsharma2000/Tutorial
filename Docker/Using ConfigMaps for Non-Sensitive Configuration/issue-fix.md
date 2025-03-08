### **🚨 Issue: `ErrImageNeverPull` in Kubernetes Pods**
The **`ErrImageNeverPull`** error occurs because Kubernetes is trying to use a **local image (`demo:latest`)** but cannot find it. Your deployment likely has:

```yaml
image: demo:latest
imagePullPolicy: Never
```

Since **`imagePullPolicy: Never`** tells Kubernetes **not to pull the image from a registry**, Kubernetes expects the image to exist **on the node** running the pod (e.g., Minikube or Docker Desktop).

---

## **🔹 Steps to Fix the Issue**

### **1️⃣ Check If the Image Exists Locally**
Run:
```sh
docker images | grep demo
```
If **no output appears**, the image does not exist, and you need to build it.

#### **Build the Image (If Missing)**
```sh
docker build -t demo:latest .
```

---

### **2️⃣ Load the Image into Minikube (If Using Minikube)**
If you are running Kubernetes with **Minikube**, the local Docker images **are not automatically available** inside Minikube. You need to load the image:

```sh
minikube image load demo:latest
```

Then restart the deployment:
```sh
kubectl delete deployment demo-deployment
kubectl apply -f deployment.yaml
```

---

### **3️⃣ Set `imagePullPolicy: IfNotPresent`**
If you want Kubernetes to pull the image **only if it does not exist locally**, update your **`deployment.yaml`**:

```yaml
containers:
  - name: demo-container
    image: demo:latest
    imagePullPolicy: IfNotPresent  # Only pull if the image is missing locally
```
Then reapply:
```sh
kubectl apply -f deployment.yaml
```

---

### **4️⃣ Use Docker Hub (If You Want a Public Image)**
If you prefer Kubernetes to pull the image from **Docker Hub**, push it first:

#### **Re-tag and Push to Docker Hub**
```sh
docker tag demo:latest meghnadsaha/demo:latest
docker push meghnadsaha/demo:latest
```

#### **Update `deployment.yaml` to Use Docker Hub**
Change:
```yaml
image: demo:latest
```
To:
```yaml
image: meghnadsaha/demo:latest
```
Then reapply:
```sh
kubectl apply -f deployment.yaml
```

---

### **5️⃣ Restart the Deployment**
After fixing the image issue, restart the deployment:
```sh
kubectl rollout restart deployment demo-deployment
```
Then check the pod status:
```sh
kubectl get pods
```

---

## **✅ Summary**
✔ **Ensure the image exists locally (`docker images | grep demo`)**  
✔ **Load the image into Minikube (`minikube image load demo:latest`)**  
✔ **Use `imagePullPolicy: IfNotPresent` instead of `Never`**  
✔ **Push the image to Docker Hub and update the deployment**  
✔ **Restart the deployment (`kubectl rollout restart deployment demo-deployment`)**  

Now, your pods should start successfully! 🚀 Let me know if you need further help.

### **🚨 Issue: `kubectl exec -it <pod> -- env | grep APP_ENV` Shows Nothing**
If running the command:
```sh
kubectl exec -it demo-deployment-74687d4db7-hm64w -- env | grep APP_ENV
```
returns **nothing**, it means that the **environment variable `APP_ENV` is not set** in the container. 

---

## **🔹 Steps to Fix the Issue**

### **1️⃣ Verify That the Pod Is Running**
Check if the pod is running properly:
```sh
kubectl get pods
```
If the pod is **not in `Running` state**, describe it for errors:
```sh
kubectl describe pod demo-deployment-74687d4db7-hm64w
```

---

### **2️⃣ Check If `APP_ENV` Is Set in the Deployment**
Your `deployment.yaml` must explicitly define `APP_ENV` inside the **`env`** section.

#### **Check the Current Deployment Configuration**
Run:
```sh
kubectl get deployment demo-deployment -o yaml | grep -A5 env
```
If `APP_ENV` is **missing**, update your deployment YAML.

#### **Add `APP_ENV` to Your Deployment**
Modify **`deployment.yaml`**:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: demo-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: demo
  template:
    metadata:
      labels:
        app: demo
    spec:
      containers:
      - name: demo-container
        image: demo:latest
        env:
        - name: APP_ENV
          value: production  # Change this value as needed
```

Apply the changes:
```sh
kubectl apply -f deployment.yaml
```
Then, restart the deployment:
```sh
kubectl rollout restart deployment demo-deployment
```

---

### **3️⃣ If Using a ConfigMap for `APP_ENV`**
If `APP_ENV` is defined in a **ConfigMap**, make sure it exists.

#### **Check If the ConfigMap Exists**
```sh
kubectl get configmaps
```
If missing, create it:
```sh
kubectl create configmap app-config --from-literal=APP_ENV=production
```
Then, modify **`deployment.yaml`** to reference the ConfigMap:
```yaml
env:
  - name: APP_ENV
    valueFrom:
      configMapKeyRef:
        name: app-config
        key: APP_ENV
```
Apply the changes and restart:
```sh
kubectl apply -f deployment.yaml
kubectl rollout restart deployment demo-deployment
```

---

### **4️⃣ Verify Again**
After restarting the deployment, check the pod’s environment variables again:
```sh
kubectl exec -it $(kubectl get pods -l app=demo -o jsonpath="{.items[0].metadata.name}") -- env | grep APP_ENV
```
*(This automatically picks the first pod from the deployment.)*

---

## **✅ Summary**
✔ **Ensure the pod is running (`kubectl get pods`)**  
✔ **Check if `APP_ENV` is in the deployment (`kubectl get deployment demo-deployment -o yaml | grep -A5 env`)**  
✔ **Add `APP_ENV` in `deployment.yaml` and reapply (`kubectl apply -f deployment.yaml`)**  
✔ **Restart the deployment (`kubectl rollout restart deployment demo-deployment`)**  
✔ **Check if `APP_ENV` exists after restart (`kubectl exec -it <pod> -- env | grep APP_ENV`)**  

Now, your environment variable should appear! 🚀 Let me know if you need further assistance.