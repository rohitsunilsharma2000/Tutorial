The error **"failed to download openapi: Get 'https://127.0.0.1:53684/openapi/v2?timeout=32s': dial tcp 127.0.0.1:53684: connect: connection refused"** indicates that **kubectl cannot connect to the Kubernetes API server**. This typically happens when **Minikube or Docker Desktop Kubernetes is not running**.

---

## **🔹 Steps to Fix the Issue**

### **1️⃣ Check If Kubernetes Is Running**
Run:
```sh
kubectl cluster-info
```
If you see an error, **Kubernetes is not running**.

---

### **2️⃣ Restart Minikube (If Using Minikube)**
If you are using **Minikube**, start it:
```sh
minikube start
```
Then try again:
```sh
kubectl apply -f pod.yaml
```

To ensure Minikube is using the correct context:
```sh
kubectl config use-context minikube
```

If the issue persists, **delete and restart Minikube**:
```sh
minikube delete
minikube start
```

---

### **3️⃣ Restart Docker Desktop Kubernetes (If Using Docker Desktop)**
If you are using **Kubernetes with Docker Desktop**, restart Docker:

1. **Quit Docker Desktop** (`Command + Q`)
2. **Reopen Docker Desktop**
3. **Enable Kubernetes** in Docker Desktop Settings (`Preferences` → `Kubernetes` → `Enable Kubernetes`)
4. Wait for Kubernetes to start, then retry:
   ```sh
   kubectl apply -f pod.yaml
   ```

---

### **4️⃣ Check Kubernetes Context**
Make sure `kubectl` is using the correct context:
```sh
kubectl config get-contexts
```
If Minikube or Docker Desktop is not the active context, switch to it:
```sh
kubectl config use-context minikube  # If using Minikube
kubectl config use-context docker-desktop  # If using Docker Desktop
```

---

### **5️⃣ Bypass Validation (Temporary Fix)**
If you **just want to apply the YAML file without validation**, use:
```sh
kubectl apply -f pod.yaml --validate=false
```
*(This is not a long-term fix but helps for debugging.)*

---

## **✅ Summary**
✔ **Check if Kubernetes is running (`kubectl cluster-info`)**  
✔ **Restart Minikube (`minikube start`) or delete and restart it (`minikube delete && minikube start`)**  
✔ **Restart Docker Desktop Kubernetes (`Preferences` → `Enable Kubernetes`)**  
✔ **Use the correct Kubernetes context (`kubectl config use-context minikube`)**  
✔ **Bypass validation (`kubectl apply -f pod.yaml --validate=false`)**  

The **`ImagePullBackOff`** error means Kubernetes **is unable to pull the container image `demo:latest`**. This happens because:

1. **The image does not exist in a public registry like Docker Hub.**
2. **The image is only available locally and not accessible by Kubernetes.**
3. **The image name in `pod.yaml` is incorrect.**
4. **You are using Minikube, which requires loading local images manually.**

---

## **🔹 Steps to Fix It**

### **1️⃣ Check If the Image Exists Locally**
Run:
```sh
docker images | grep demo
```
If no output appears, the image **does not exist**. You need to build it.

### **2️⃣ Build the Image (If Missing)**
```sh
docker build -t demo:latest .
```

---

### **3️⃣ Load the Image into Minikube (If Using Minikube)**
If you are running Kubernetes in **Minikube**, it **cannot access** local images automatically. You need to load the image into Minikube:

```sh
minikube image load demo:latest
```

Then, restart the pod:
```sh
kubectl delete pod demo-pod
kubectl apply -f pod.yaml
```

---

### **4️⃣ Push the Image to Docker Hub (If Not Using Minikube)**
If you are **not using Minikube**, you need to **push the image to Docker Hub** so Kubernetes can pull it.

#### **Re-tag the Image with Your Docker Hub Username**
```sh
docker tag demo:latest meghnadsaha/demo:latest
docker push meghnadsaha/demo:latest
```

#### **Update `pod.yaml` to Use Docker Hub Image**
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
kubectl delete pod demo-pod
kubectl apply -f pod.yaml
```

---

### **5️⃣ Set `imagePullPolicy: Never` for Local Images**
If you only want to use the **local image**, modify **`pod.yaml`**:

```yaml
spec:
  containers:
    - name: demo-container
      image: demo:latest
      imagePullPolicy: Never  # Prevents Kubernetes from trying to pull from Docker Hub
```

Apply it:
```sh
kubectl delete pod demo-pod
kubectl apply -f pod.yaml
```

---

### **6️⃣ Delete and Restart Pod**
If you've made changes, restart the pod:
```sh
kubectl delete pod demo-pod
kubectl apply -f pod.yaml
```

---

## **✅ Summary**
✔ **Ensure the image exists locally (`docker images | grep demo`)**  
✔ **Load the image into Minikube (`minikube image load demo:latest`)**  
✔ **Use the correct Docker Hub tag (`docker tag demo:latest meghnadsaha/demo:latest`)**  
✔ **Push the image (`docker push meghnadsaha/demo:latest`)**  
✔ **Set `imagePullPolicy: Never` for local images**  
✔ **Restart the pod (`kubectl delete pod demo-pod && kubectl apply -f pod.yaml`)**  

Now, your pod should start successfully! 🚀 Let me know if you need further help.

# **🔹 Deploying Containerized Workloads as Kubernetes Pods & Deployments** 🚀  

### **✅ Overview**
Kubernetes (**K8s**) is an **orchestration platform** for **deploying, scaling, and managing** containerized applications.  
This guide covers:
✅ **Deploying a single container as a Pod**  
✅ **Using Deployments to manage replicas & updates**  
✅ **Exposing services via Kubernetes networking**  

---

# **📌 1️⃣ Deploying a Simple Kubernetes Pod**
A **Pod** is the smallest deployable unit in Kubernetes.  
It contains **one or more containers** and shares **networking & storage**.

### **🔹 Step 1: Create a `pod.yaml`**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: demo-pod
  labels:
    app: demo
spec:
  containers:
    - name: demo-container
      image: demo:latest  # Change to your image
      ports:
        - containerPort: 8080
```

### **🔹 Step 2: Deploy the Pod**
```sh
kubectl apply -f pod.yaml
```

### **🔹 Step 3: Verify the Pod is Running**
```sh
kubectl get pods
```

### **🔹 Step 4: Check Logs & Debug**
```sh
kubectl logs demo-pod
kubectl describe pod demo-pod
```

✅ **Pods are great for running single-instance applications**.  
❌ **Not ideal for scaling** → Use **Deployments** instead.

---

# **📌 2️⃣ Deploying Workloads as a Kubernetes Deployment**
A **Deployment** manages multiple **replica Pods**, ensuring **scalability & high availability**.

### **🔹 Step 1: Create `deployment.yaml`**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: demo-deployment
  labels:
    app: demo
spec:
  replicas: 3  # Run 3 instances of the application
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
          image: demo:latest  # Replace with your container image
          ports:
            - containerPort: 8080
```

### **🔹 Step 2: Deploy to Kubernetes**
```sh
kubectl apply -f deployment.yaml
```

### **🔹 Step 3: Check Running Deployments**
```sh
kubectl get deployments
kubectl get pods -l app=demo
```

### **🔹 Step 4: Scale Up or Down**
```sh
kubectl scale deployment demo-deployment --replicas=5
```

✅ **Deployments auto-heal failed Pods**  
✅ **Easy to scale workloads**  
✅ **Supports rolling updates**  

---

# **📌 3️⃣ Exposing the Deployment with a Kubernetes Service**
Pods are ephemeral. To expose them, **use a Service**.

### **🔹 Step 1: Create `service.yaml`**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: demo-service
spec:
  selector:
    app: demo
  ports:
    - protocol: TCP
      port: 80  # External port
      targetPort: 8080  # Container port
  type: LoadBalancer  # For cloud environments (or use "NodePort")
```

### **🔹 Step 2: Deploy the Service**
```sh
kubectl apply -f service.yaml
```

### **🔹 Step 3: Check Service Details**
```sh
kubectl get services
```

### **🔹 Step 4: Test the Service**
If using **Minikube**:
```sh
minikube service demo-service
```
Otherwise:
```sh
curl http://<external-ip>:80
```

✅ **The Service load-balances requests across Pods**  
✅ **Pods can be replaced without breaking access**  

---

# **📌 4️⃣ Rolling Updates & Rollbacks**
Kubernetes **Deployments allow zero-downtime updates**.

### **🔹 Step 1: Update the Image**
```sh
kubectl set image deployment/demo-deployment demo-container=demo:v2
```

### **🔹 Step 2: Check Update Status**
```sh
kubectl rollout status deployment/demo-deployment
```

### **🔹 Step 3: Rollback If Needed**
```sh
kubectl rollout undo deployment/demo-deployment
```

✅ **Ensures smooth updates without breaking running instances**  

---

# **📌 5️⃣ Deleting the Deployment & Resources**
To remove the deployment and services:
```sh
kubectl delete -f deployment.yaml
kubectl delete -f service.yaml
```
To delete everything:
```sh
kubectl delete all --all
```

✅ **This cleans up all resources from the cluster**.

---

# **✅ Summary: Kubernetes Deployment Process**
| **Task** | **Command** |
|----------|------------|
| **Deploy a Pod** | `kubectl apply -f pod.yaml` |
| **Deploy a Scalable App** | `kubectl apply -f deployment.yaml` |
| **Check Running Pods** | `kubectl get pods` |
| **Expose App with a Service** | `kubectl apply -f service.yaml` |
| **Scale the Deployment** | `kubectl scale deployment demo-deployment --replicas=5` |
| **Update the Deployment** | `kubectl set image deployment/demo-deployment demo-container=demo:v2` |
| **Rollback an Update** | `kubectl rollout undo deployment/demo-deployment` |
| **Delete All Resources** | `kubectl delete all --all` |

---
# **🔹 Deploying Containerized Workloads Using Helm Charts in Kubernetes** 🚀  

## **✅ Overview**
Helm is a **package manager** for Kubernetes that simplifies:
✅ **Application deployment & version control**  
✅ **Configurable deployments using Helm values**  
✅ **Easier application upgrades & rollbacks**  

This guide covers:
✔ Installing Helm  
✔ Creating a Helm Chart  
✔ Deploying a Spring Boot app with PostgreSQL using Helm  
✔ Upgrading and rolling back a release  

---

## **📌 1️⃣ Install Helm**
### **Step 1: Install Helm**
For Linux/macOS:
```sh
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```
For Windows (using Chocolatey):
```sh
choco install kubernetes-helm
```

### **Step 2: Verify Helm Installation**
```sh
helm version
```
✔ Helm should output a version like `v3.11.0`.

---

## **📌 2️⃣ Create a Helm Chart**
A Helm chart is a **package** that includes:
- **Deployments**
- **Services**
- **Configurable values (via `values.yaml`)**

### **Step 1: Create a Chart**
```sh
helm create demo-chart
cd demo-chart
```
Helm creates this structure:
```
demo-chart/
├── charts/
├── templates/
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── _helpers.tpl
├── values.yaml
├── Chart.yaml
```

---

## **📌 3️⃣ Define the Spring Boot Deployment**
### **Step 1: Edit `templates/deployment.yaml`**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}-app
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      app: {{ .Release.Name }}
  template:
    metadata:
      labels:
        app: {{ .Release.Name }}
    spec:
      containers:
        - name: spring-boot
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          ports:
            - containerPort: {{ .Values.service.port }}
          env:
            - name: DB_HOST
              value: "{{ .Values.database.host }}"
            - name: DB_USER
              value: "{{ .Values.database.user }}"
            - name: DB_PASSWORD
              value: "{{ .Values.database.password }}"
            - name: DB_NAME
              value: "{{ .Values.database.name }}"
```

---

## **📌 4️⃣ Define the PostgreSQL Database**
### **Step 1: Edit `templates/postgres.yaml`**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}-postgres
spec:
  replicas: 1
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
        - name: postgres
          image: postgres:latest
          env:
            - name: POSTGRES_USER
              value: "{{ .Values.database.user }}"
            - name: POSTGRES_PASSWORD
              value: "{{ .Values.database.password }}"
            - name: POSTGRES_DB
              value: "{{ .Values.database.name }}"
          ports:
            - containerPort: 5432
```

---

## **📌 5️⃣ Define the Kubernetes Service**
### **Step 1: Edit `templates/service.yaml`**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: {{ .Release.Name }}-service
spec:
  selector:
    app: {{ .Release.Name }}
  ports:
    - protocol: TCP
      port: {{ .Values.service.port }}
      targetPort: {{ .Values.service.targetPort }}
  type: {{ .Values.service.type }}
```

---

## **📌 6️⃣ Define the Configurable Values**
### **Step 1: Edit `values.yaml`**
```yaml
replicaCount: 3

image:
  repository: demo
  tag: latest

service:
  type: LoadBalancer
  port: 80
  targetPort: 8080

database:
  host: demo-postgres
  user: demo_user
  password: demo_pass
  name: demo_db
```
✔ These values allow **customization** without modifying YAML files.  

---

## **📌 7️⃣ Deploy the Helm Chart**
### **Step 1: Package the Helm Chart**
```sh
helm package demo-chart
```

### **Step 2: Deploy to Kubernetes**
```sh
helm install demo-release demo-chart
```

### **Step 3: Check Running Services**
```sh
kubectl get deployments
kubectl get pods
kubectl get services
```

---

## **📌 8️⃣ Upgrade the Helm Release**
To upgrade the **image version**:
```sh
helm upgrade demo-release demo-chart --set image.tag=v2
```
✔ This updates the **Spring Boot application** without downtime.

---

## **📌 9️⃣ Rollback If Needed**
If something goes wrong:
```sh
helm rollback demo-release 1
```
✔ This restores the **previous working version**.

---

## **📌 🔟 Uninstall the Helm Release**
To remove all deployed resources:
```sh
helm uninstall demo-release
```

---

# **✅ Summary: Kubernetes Deployment Using Helm**
| **Task** | **Command** |
|----------|------------|
| Install Helm | `curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash` |
| Create a Helm Chart | `helm create demo-chart` |
| Package the Chart | `helm package demo-chart` |
| Deploy with Helm | `helm install demo-release demo-chart` |
| Check Running Pods | `kubectl get pods` |
| Upgrade the Deployment | `helm upgrade demo-release demo-chart --set image.tag=v2` |
| Rollback to Previous Version | `helm rollback demo-release 1` |
| Uninstall the Release | `helm uninstall demo-release` |

---
This **automates Kubernetes deployments** with Helm! 🚀🔥  

Would you like to **add CI/CD (GitHub Actions or Jenkins) for Helm deployment?** 😊