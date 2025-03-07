## 🚀 **Accessing Minikube**
Minikube is a **lightweight Kubernetes cluster** for local development. Below are the steps to **access, manage, and troubleshoot Minikube**.

---

## **1️⃣ Start Minikube**
To start Minikube, run:
```sh
minikube start
```
You can specify the driver (e.g., Docker, VirtualBox, Hyperkit):
```sh
minikube start --driver=docker
```

---

## **2️⃣ Verify Minikube Status**
To check if Minikube is running:
```sh
minikube status
```
If it’s not running, restart it:
```sh
minikube stop
minikube start
```

---

## **3️⃣ Access Minikube Cluster**
### **🔹 Check Running Nodes**
```sh
kubectl get nodes
```
Expected output:
```
NAME       STATUS   ROLES           AGE   VERSION
minikube   Ready    control-plane   1m    v1.28.0
```

### **🔹 Check Cluster Information**
```sh
kubectl cluster-info
```

---

## **4️⃣ Access Minikube Dashboard**
Minikube has a built-in **Kubernetes Dashboard**.

Enable the dashboard:
```sh
minikube dashboard
```
This will **open the Kubernetes dashboard** in your web browser.

---

## **5️⃣ Access Minikube Services**
To list all running services:
```sh
kubectl get svc
```

To access a specific service:
```sh
minikube service <service-name>
```
Example:
```sh
minikube service myapp
```
This will **open the service URL in your browser**.

To get the service’s URL manually:
```sh
minikube service myapp --url
```

---

## **6️⃣ SSH into Minikube Node**
To open a shell inside the Minikube VM:
```sh
minikube ssh
```
Exit the Minikube VM:
```sh
exit
```

---

## **7️⃣ Mount Local Files to Minikube**
To share files from your local system with Minikube:
```sh
minikube mount /path/to/local/folder:/mnt/data
```
Now, inside Minikube:
```sh
ls /mnt/data
```
✅ **Your local files are now accessible inside Minikube!** 📂  

---

## **8️⃣ Deploy Applications on Minikube**
Deploy a sample **nginx** app:
```sh
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=NodePort
```
Check if it's running:
```sh
kubectl get pods
```

Find the service’s external IP:
```sh
minikube service nginx --url
```
✅ **Now you can access your deployed application!** 🎯  

---

## **9️⃣ Stopping & Deleting Minikube**
To **stop** the Minikube cluster:
```sh
minikube stop
```
To **delete** the cluster completely:
```sh
minikube delete
```

---

## **🔧 Troubleshooting Minikube Issues**
### **🔹 Error: "minikube not found"**
Fix:
```sh
brew install minikube
```

### **🔹 Error: "Docker is not running"**
Fix:
```sh
open -a Docker
minikube start --driver=docker
```

### **🔹 Error: "Cluster is not ready"**
Fix:
```sh
minikube delete
minikube start
```

---

# 🚀 **Recap**
✅ **Start Minikube:** `minikube start`  
✅ **Access Dashboard:** `minikube dashboard`  
✅ **Deploy & Expose Apps:** `kubectl create deployment`  
✅ **SSH into Minikube:** `minikube ssh`  
✅ **Stop & Delete Minikube:** `minikube stop` / `minikube delete`  

# 🚀 **Kubernetes Building Blocks**
Kubernetes is made up of several **core components** that work together to manage containerized applications. These **building blocks** can be categorized into:
1. **Control Plane Components** 🛠️  
2. **Worker Node Components** 🏗️  
3. **Kubernetes Objects** 🎯  

---

## **1️⃣ Control Plane Components (Master Node)**
The **Control Plane** manages the Kubernetes cluster and ensures the desired state of the applications.

### **🔹 API Server (`kube-apiserver`)**
✅ **Handles all Kubernetes requests** (kubectl, UI, other APIs).  
✅ Exposes the **Kubernetes API** for communication.  
✅ Acts as the **gateway** to the Kubernetes cluster.  

```sh
kubectl cluster-info
```

---

### **🔹 Scheduler (`kube-scheduler`)**
✅ Assigns workloads (Pods) to available worker nodes.  
✅ Makes scheduling decisions based on **CPU, Memory, and Policies**.  

```sh
kubectl describe nodes
```

---

### **🔹 Controller Manager (`kube-controller-manager`)**
✅ Manages **controllers** like:
   - **Node Controller** (Handles node failures).  
   - **Replication Controller** (Ensures the desired number of pods).  
   - **Service Controller** (Maintains service states).  

```sh
kubectl get nodes
```

---

### **🔹 etcd (Cluster State Storage)**
✅ Stores **cluster configuration, secrets, and state**.  
✅ A distributed **key-value store**.  
✅ Highly available and fault-tolerant.  

To inspect etcd:
```sh
kubectl get etcd -n kube-system
```

---

## **2️⃣ Worker Node Components**
Each worker node runs workloads (containers) and communicates with the **Control Plane**.

### **🔹 Kubelet**
✅ Ensures **containers are running** on the node.  
✅ Talks to the API Server to report health.  

```sh
kubectl get nodes
```

---

### **🔹 Kube Proxy**
✅ Manages **networking** for inter-pod communication.  
✅ Implements **IP masquerading, NAT, and load balancing**.  

To check networking:
```sh
kubectl get services
```

---

### **🔹 Container Runtime (Docker, containerd, CRI-O)**
✅ Runs containerized workloads on nodes.  
✅ Kubernetes supports:
   - **Docker**
   - **containerd**
   - **CRI-O**  

To check the runtime:
```sh
kubectl get nodes -o wide
```

---

## **3️⃣ Kubernetes Objects**
Kubernetes objects define **how workloads run inside the cluster**.

### **🔹 Pods (Basic Unit of Kubernetes)**
✅ Smallest deployable unit in Kubernetes.  
✅ A **Pod** can have **one or more containers**.  

```sh
kubectl get pods
```
Example YAML:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
  - name: nginx
    image: nginx
```
Apply it:
```sh
kubectl apply -f my-pod.yaml
```

---

### **🔹 Deployments (Manages ReplicaSets)**
✅ Ensures **high availability & auto-recovery**.  
✅ Manages **updates & rollbacks**.  

```sh
kubectl create deployment myapp --image=nginx
```
Example YAML:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: nginx
        image: nginx
```

Apply it:
```sh
kubectl apply -f myapp.yaml
```

---

### **🔹 Services (Networking for Pods)**
✅ Exposes **Pods** to other services or external users.  
✅ Types of Services:
   - **ClusterIP** (Internal service)
   - **NodePort** (Accessible via node IP)
   - **LoadBalancer** (Cloud Load Balancer)
   - **ExternalName** (DNS redirection)

To expose a deployment:
```sh
kubectl expose deployment myapp --type=NodePort --port=80
```

---

### **🔹 Ingress (Routing External Traffic)**
✅ Routes external HTTP/S traffic to services.  
✅ Acts as an **API Gateway**.

Example YAML:
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-ingress
spec:
  rules:
  - host: myapp.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: myapp
            port:
              number: 80
```
Apply it:
```sh
kubectl apply -f my-ingress.yaml
```

---

### **🔹 ConfigMaps & Secrets (External Configurations)**
✅ **ConfigMaps** store **non-sensitive** configurations.  
✅ **Secrets** store **sensitive** data securely.

Create a ConfigMap:
```sh
kubectl create configmap my-config --from-literal=env=production
```

Create a Secret:
```sh
kubectl create secret generic my-secret --from-literal=password=secure123
```

Use them in a Pod:
```yaml
env:
  - name: ENV_MODE
    valueFrom:
      configMapKeyRef:
        name: my-config
        key: env
  - name: DB_PASSWORD
    valueFrom:
      secretKeyRef:
        name: my-secret
        key: password
```

---

## **🎯 Recap**
| **Component** | **Purpose** |
|--------------|------------|
| **API Server** | Manages cluster API requests |
| **Scheduler** | Assigns Pods to worker nodes |
| **Controller Manager** | Ensures system is in the desired state |
| **etcd** | Stores cluster configuration & data |
| **Kubelet** | Runs on worker nodes & manages Pods |
| **Kube Proxy** | Manages networking between Pods |
| **Container Runtime** | Runs containers (Docker, containerd) |
| **Pods** | Smallest deployable unit (1+ containers) |
| **Deployments** | Ensures desired state of Pods |
| **Services** | Enables networking between Pods |
| **Ingress** | Routes external traffic to services |
| **ConfigMaps & Secrets** | Manages environment variables & credentials |

# 🚀 **Kubernetes Services: Networking & Communication**
Kubernetes **Services** enable communication between different parts of an application (Pods, external clients, and the internet). 

### ✅ **Why Do We Need Services?**
- **Pods are ephemeral**: When a Pod is deleted, its IP address changes.
- **Pods need to communicate** with each other and external users.
- **Load balancing** is needed for distributed applications.

---

## **1️⃣ Types of Kubernetes Services**
| **Service Type** | **Description** | **Use Case** |
|----------------|--------------|--------------|
| **ClusterIP** (default) | Exposes service **internally** within the cluster | Internal app communication |
| **NodePort** | Exposes service **externally** on each node’s IP at a static port | Simple external access |
| **LoadBalancer** | Exposes service externally with a **Cloud Provider Load Balancer** | Production deployments |
| **ExternalName** | Maps a service to a **DNS name** (outside cluster) | Redirecting to external services |

---

## **2️⃣ Creating a Service**
### **🔹 Step 1: Deploy an Application**
```sh
kubectl create deployment myapp --image=nginx
kubectl get pods
```

### **🔹 Step 2: Create a Service (ClusterIP - Default)**
```sh
kubectl expose deployment myapp --port=80 --target-port=80 --name=myapp-service
```
Check the service:
```sh
kubectl get svc
```
Expected output:
```
NAME             TYPE        CLUSTER-IP    PORT(S)   AGE
myapp-service   ClusterIP   10.1.2.3      80/TCP    5s
```
✅ **Pods can now communicate using `myapp-service` inside the cluster.**

---

## **3️⃣ NodePort Service (Expose to External Users)**
A **NodePort Service** exposes the service **on all nodes** at a static port (e.g., `30080`).

```sh
kubectl expose deployment myapp --type=NodePort --port=80
```
Find the external port:
```sh
kubectl get svc
```
Example output:
```
NAME             TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)
myapp-service   NodePort   10.1.2.3       <none>        80:30080/TCP
```
✅ **Now access the app from outside:**
```sh
minikube service myapp-service --url
```
Or manually:
```sh
http://<NODE-IP>:30080
```

---

## **4️⃣ LoadBalancer Service (Production-Ready External Access)**
For **Cloud Environments** (AWS, GCP, Azure), `LoadBalancer` assigns an **external IP**.

```sh
kubectl expose deployment myapp --type=LoadBalancer --port=80
```
Check the service:
```sh
kubectl get svc
```
Example output:
```
NAME             TYPE           CLUSTER-IP     EXTERNAL-IP      PORT(S)
myapp-service   LoadBalancer   10.1.2.3       34.125.78.90     80/TCP
```
✅ **Now access the service using:**
```sh
http://34.125.78.90
```
(Replace with your **EXTERNAL-IP** from the output.)

---

## **5️⃣ ExternalName Service (DNS Mapping)**
Instead of a normal service, `ExternalName` maps requests to an **external domain**.

### **Example: Redirect to External Database**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: external-db
spec:
  type: ExternalName
  externalName: db.example.com
```
Apply it:
```sh
kubectl apply -f external-db.yaml
```
✅ **Now, internal pods can use** `external-db` **as a hostname.**

---

## **6️⃣ Service YAML Examples**
### **🔹 ClusterIP Service (Internal Communication)**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: myapp-service
spec:
  selector:
    app: myapp
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
```
```sh
kubectl apply -f myapp-clusterip.yaml
```

---

### **🔹 NodePort Service (Expose to External Users)**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: myapp-service
spec:
  type: NodePort
  selector:
    app: myapp
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
      nodePort: 30080
```
```sh
kubectl apply -f myapp-nodeport.yaml
```

---

### **🔹 LoadBalancer Service (Cloud Provider External Access)**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: myapp-service
spec:
  type: LoadBalancer
  selector:
    app: myapp
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
```
```sh
kubectl apply -f myapp-loadbalancer.yaml
```

---

### **🔹 ExternalName Service (DNS Redirection)**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: external-db
spec:
  type: ExternalName
  externalName: db.example.com
```
```sh
kubectl apply -f external-db.yaml
```

---

## **7️⃣ Check and Debug Services**
### **🔹 List All Services**
```sh
kubectl get svc
```

### **🔹 Get Service Details**
```sh
kubectl describe svc myapp-service
```

### **🔹 Check If Service is Accessible**
```sh
kubectl run curl --image=radial/busyboxplus:curl -it --rm -- curl http://myapp-service:80
```

### **🔹 Delete a Service**
```sh
kubectl delete svc myapp-service
```

---

# 🚀 **Recap**
✅ **ClusterIP:** Internal communication.  
✅ **NodePort:** External access via a static port.  
✅ **LoadBalancer:** Cloud provider external access.  
✅ **ExternalName:** Maps a service to an external domain.  

# 🚀 **Deploying a Stand-Alone Application in Kubernetes**
A **stand-alone application** is a single **containerized app** running in Kubernetes without complex dependencies. Below, we'll deploy an **NGINX web server** as a stand-alone app.

---

## **1️⃣ Create a Kubernetes Deployment**
A **Deployment** ensures that a Pod with our application **keeps running** even if failures occur.

### **🔹 Step 1: Create a Deployment**
Run the following command to create an NGINX deployment:
```sh
kubectl create deployment myapp --image=nginx
```
Check if the deployment is created:
```sh
kubectl get deployments
kubectl get pods
```
✅ This creates a **Pod** running an **NGINX** container.

---

## **2️⃣ Exposing the Application (Using a Service)**
The application needs to be **accessible** inside and outside the cluster.

### **🔹 Step 2: Expose the Deployment**
```sh
kubectl expose deployment myapp --type=NodePort --port=80
```
Check the service:
```sh
kubectl get svc
```
Expected output:
```
NAME       TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)
myapp      NodePort   10.1.2.3         <none>        80:32000/TCP
```
✅ The application is now accessible **via port 32000** on the cluster node.

---

## **3️⃣ Accessing the Stand-Alone Application**
To access the application:
```sh
minikube service myapp --url
```
Or manually:
```sh
http://<NODE-IP>:32000
```

---

## **4️⃣ Deploying via YAML Manifest**
Instead of `kubectl create`, we can use YAML for better **control**.

### **🔹 Step 1: Create a YAML File (`myapp.yaml`)**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  replicas: 1
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: myapp
spec:
  type: NodePort
  selector:
    app: myapp
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
      nodePort: 32000
```

### **🔹 Step 2: Deploy the Application**
```sh
kubectl apply -f myapp.yaml
```

### **🔹 Step 3: Verify the Deployment**
```sh
kubectl get deployments
kubectl get pods
kubectl get svc
```

### **🔹 Step 4: Access the Application**
```sh
minikube service myapp --url
```
Or manually:
```sh
http://<NODE-IP>:32000
```

---

## **5️⃣ Scaling the Application**
To increase the number of Pods:
```sh
kubectl scale deployment myapp --replicas=3
```
Check running Pods:
```sh
kubectl get pods
```
✅ Now, **3 Pods** are running for high availability.

---

## **6️⃣ Deleting the Stand-Alone Application**
To remove the application:
```sh
kubectl delete deployment myapp
kubectl delete svc myapp
```

---

# 🚀 **Recap**
✅ **Created a stand-alone application** (`nginx`).  
✅ **Exposed the application** using a `NodePort` service.  
✅ **Accessed the application** using `minikube service`.  
✅ **Deployed via YAML for better control**.  
✅ **Scaled the application** to multiple replicas.  

# 🚀 **Kubernetes Volume Management**
Kubernetes **Volumes** provide **persistent storage** to **Pods**, ensuring data remains available even if a container restarts.

---

## **1️⃣ Why Use Kubernetes Volumes?**
✅ **Containers are ephemeral** – Data is lost when a Pod restarts.  
✅ **Persistent data storage** – Maintain logs, databases, and configurations.  
✅ **Shared storage** – Multiple Pods can access the same data.

---

## **2️⃣ Types of Kubernetes Volumes**
| **Volume Type**   | **Description** |
|------------------|--------------|
| **emptyDir** | Temporary storage; deleted when Pod stops. |
| **hostPath** | Uses a directory from the worker node. |
| **PersistentVolume (PV)** | Stores data externally (NFS, AWS EBS, etc.). |
| **PersistentVolumeClaim (PVC)** | Request storage from PV dynamically. |
| **ConfigMap & Secret** | Store config files or sensitive data as volumes. |

---

## **3️⃣ Basic Volumes (emptyDir & hostPath)**
### **🔹 `emptyDir` Volume (Temporary Storage)**
✅ Data is lost when the Pod stops.

Example YAML:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: emptydir-pod
spec:
  containers:
  - name: app
    image: nginx
    volumeMounts:
    - mountPath: "/data"
      name: my-volume
  volumes:
  - name: my-volume
    emptyDir: {}
```
Apply it:
```sh
kubectl apply -f emptydir-pod.yaml
```
✅ The container can write files to **`/data`**, but the data **disappears** after the Pod stops.

---

### **🔹 `hostPath` Volume (Node Storage)**
✅ Data persists as long as the **node exists**.

Example YAML:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: hostpath-pod
spec:
  containers:
  - name: app
    image: nginx
    volumeMounts:
    - mountPath: "/data"
      name: my-volume
  volumes:
  - name: my-volume
    hostPath:
      path: "/var/data"
```
Apply it:
```sh
kubectl apply -f hostpath-pod.yaml
```
✅ The container writes files to `/data`, and they **persist as long as the node is active**.

---

## **4️⃣ Persistent Storage with PersistentVolumes (PV)**
A **PersistentVolume (PV)** is **pre-provisioned storage** (e.g., NFS, AWS EBS, Google Cloud Disk).

### **🔹 Step 1: Define a PersistentVolume**
Example YAML (`pv.yaml`):
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: my-pv
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/mnt/data"
```
Apply it:
```sh
kubectl apply -f pv.yaml
```
✅ **A 1GB storage volume is now available**.

---

## **5️⃣ Claiming Storage with PersistentVolumeClaim (PVC)**
A **PersistentVolumeClaim (PVC)** **requests storage** from the available PVs.

### **🔹 Step 2: Define a PersistentVolumeClaim**
Example YAML (`pvc.yaml`):
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 500Mi
```
Apply it:
```sh
kubectl apply -f pvc.yaml
```
✅ **A 500MB claim is made against available PVs**.

---

## **6️⃣ Using PVC in a Pod**
Now, we attach the **PVC** to a Pod.

Example YAML (`pod-with-pvc.yaml`):
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pvc-pod
spec:
  containers:
  - name: app
    image: nginx
    volumeMounts:
    - mountPath: "/data"
      name: my-storage
  volumes:
  - name: my-storage
    persistentVolumeClaim:
      claimName: my-pvc
```
Apply it:
```sh
kubectl apply -f pod-with-pvc.yaml
```
✅ **Now the Pod uses persistent storage!**

---

## **7️⃣ Dynamic Volume Provisioning**
Instead of creating PVs manually, **StorageClasses** dynamically provision storage.

### **🔹 Step 1: Define a StorageClass**
Example YAML (`storageclass.yaml`):
```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: fast-storage
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp2
```
Apply it:
```sh
kubectl apply -f storageclass.yaml
```
✅ **Now, Kubernetes can automatically create PVs when needed.**

---

### **🔹 Step 2: Request Storage via PVC**
Example YAML (`pvc-dynamic.yaml`):
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: dynamic-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 2Gi
  storageClassName: fast-storage
```
Apply it:
```sh
kubectl apply -f pvc-dynamic.yaml
```
✅ **Now Kubernetes provisions storage automatically!** 🎯

---

## **8️⃣ Check & Troubleshoot Volumes**
### **🔹 List PersistentVolumes**
```sh
kubectl get pv
```
### **🔹 List PersistentVolumeClaims**
```sh
kubectl get pvc
```
### **🔹 Describe Volume Details**
```sh
kubectl describe pv my-pv
kubectl describe pvc my-pvc
```
### **🔹 Delete PVC or PV**
```sh
kubectl delete pvc my-pvc
kubectl delete pv my-pv
```

---

# 🚀 **Recap**
✅ **emptyDir** – Temporary storage, lost on pod restart.  
✅ **hostPath** – Uses node storage, persists as long as node exists.  
✅ **PersistentVolume (PV)** – Pre-provisioned storage.  
✅ **PersistentVolumeClaim (PVC)** – Request storage dynamically.  
✅ **StorageClass** – Automates volume provisioning.  

# 🚀 **Kubernetes ConfigMaps & Secrets**
Kubernetes **ConfigMaps** and **Secrets** are used to manage configuration and sensitive data **separately** from application code.

---

## **1️⃣ Why Use ConfigMaps & Secrets?**
✅ **Decouple configuration from application code**  
✅ **Make applications portable across environments**  
✅ **Securely store sensitive information**  

| **Feature** | **ConfigMap** | **Secret** |
|------------|--------------|-----------|
| **Purpose** | Stores non-sensitive configuration | Stores sensitive data (passwords, API keys) |
| **Data Type** | Plain text | Base64 encoded |
| **Security** | Not encrypted | Encrypted at rest |
| **Usage** | Environment variables, volumes, command args | Same as ConfigMaps |

---

# **2️⃣ ConfigMaps**
A **ConfigMap** stores application configuration **as key-value pairs**.

### **🔹 Step 1: Create a ConfigMap**
#### **Method 1: From Literal Key-Value Pairs**
```sh
kubectl create configmap my-config --from-literal=ENV=production --from-literal=LOG_LEVEL=debug
```
Check it:
```sh
kubectl get configmap my-config -o yaml
```

---

#### **Method 2: From a File**
Create a file `config.properties`:
```
ENV=production
LOG_LEVEL=debug
```
Now create a ConfigMap:
```sh
kubectl create configmap my-config --from-file=config.properties
```
Check it:
```sh
kubectl describe configmap my-config
```

---

### **🔹 Step 2: Use ConfigMap in a Pod**
Modify a Pod definition to use the ConfigMap.

#### **Method 1: Use ConfigMap as Environment Variables**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-configmap
spec:
  containers:
  - name: my-container
    image: nginx
    env:
    - name: ENV_MODE
      valueFrom:
        configMapKeyRef:
          name: my-config
          key: ENV
    - name: LOG_LEVEL
      valueFrom:
        configMapKeyRef:
          name: my-config
          key: LOG_LEVEL
```
Apply it:
```sh
kubectl apply -f pod-configmap.yaml
```
Check logs:
```sh
kubectl logs pod-configmap
```

---

#### **Method 2: Use ConfigMap as a Volume**
Modify `myapp.yaml`:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-config-volume
spec:
  containers:
  - name: my-container
    image: nginx
    volumeMounts:
    - name: config-volume
      mountPath: "/etc/config"
  volumes:
  - name: config-volume
    configMap:
      name: my-config
```
Apply it:
```sh
kubectl apply -f pod-config-volume.yaml
```
✅ **Now, the ConfigMap is mounted at `/etc/config` inside the container.**

---

# **3️⃣ Kubernetes Secrets**
A **Secret** stores **sensitive data** like API keys, passwords, and TLS certificates.

### **🔹 Step 1: Create a Secret**
#### **Method 1: From Literal Values**
```sh
kubectl create secret generic my-secret --from-literal=DB_USER=admin --from-literal=DB_PASSWORD=supersecret
```
Check it:
```sh
kubectl get secret my-secret -o yaml
```
Output:
```yaml
data:
  DB_PASSWORD: c3VwZXJzZWNyZXQ=
  DB_USER: YWRtaW4=
```
(Note: Data is **Base64 encoded** for security.)

---

#### **Method 2: From a File**
Create a file `db_credentials.txt`:
```
DB_USER=admin
DB_PASSWORD=supersecret
```
Now create a Secret:
```sh
kubectl create secret generic my-secret --from-file=db_credentials.txt
```
Check it:
```sh
kubectl describe secret my-secret
```

---

### **🔹 Step 2: Use Secret in a Pod**
Modify a Pod to **inject Secret values**.

#### **Method 1: Use Secret as Environment Variables**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-secret
spec:
  containers:
  - name: my-container
    image: nginx
    env:
    - name: DB_USER
      valueFrom:
        secretKeyRef:
          name: my-secret
          key: DB_USER
    - name: DB_PASSWORD
      valueFrom:
        secretKeyRef:
          name: my-secret
          key: DB_PASSWORD
```
Apply it:
```sh
kubectl apply -f pod-secret.yaml
```
✅ **Now, the application can access the credentials securely.**

---

#### **Method 2: Use Secret as a Volume**
Modify `pod-secret-volume.yaml`:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-secret-volume
spec:
  containers:
  - name: my-container
    image: nginx
    volumeMounts:
    - name: secret-volume
      mountPath: "/etc/secret"
  volumes:
  - name: secret-volume
    secret:
      secretName: my-secret
```
Apply it:
```sh
kubectl apply -f pod-secret-volume.yaml
```
✅ **Now, the Secret is mounted at `/etc/secret`.**

---

# **4️⃣ Check & Troubleshoot ConfigMaps & Secrets**
### **🔹 List ConfigMaps & Secrets**
```sh
kubectl get configmaps
kubectl get secrets
```

### **🔹 View ConfigMap Data**
```sh
kubectl get configmap my-config -o yaml
```

### **🔹 Decode Secret Data**
```sh
kubectl get secret my-secret -o jsonpath="{.data.DB_PASSWORD}" | base64 --decode
```

### **🔹 Delete ConfigMaps & Secrets**
```sh
kubectl delete configmap my-config
kubectl delete secret my-secret
```

---

# 🚀 **Recap**
✅ **ConfigMaps** – Store **non-sensitive configurations**.  
✅ **Secrets** – Store **sensitive data securely** (Base64 encoded).  
✅ **Used in Pods** as **environment variables or mounted volumes**.  
✅ **Supports automatic injection into applications**.  

# 🚀 **Kubernetes Ingress: Exposing Services Externally**
**Ingress** is a **Kubernetes API object** that **routes external HTTP/S traffic** to Services inside the cluster. It acts as an **API Gateway** and provides:
✅ **Path-based & Host-based routing**  
✅ **TLS/SSL termination** (HTTPS)  
✅ **Load balancing** for services  
✅ **Rewrite & Redirect rules**  

---

## **1️⃣ Ingress vs Other Methods**
| **Method** | **Use Case** | **External IP?** | **TLS Support?** |
|------------|------------|---------------|---------------|
| **NodePort** | Basic external access | ❌ (Only on Node IP) | ❌ |
| **LoadBalancer** | Cloud provider load balancing | ✅ | ✅ (Depends on provider) |
| **Ingress** | API Gateway for multiple services | ✅ | ✅ |

---

## **2️⃣ Setting Up Ingress**
### **🔹 Step 1: Enable Ingress Controller**
Ingress requires an **Ingress Controller** to process traffic.  
For Minikube, enable the built-in controller:
```sh
minikube addons enable ingress
```
For cloud environments, install **NGINX Ingress Controller**:
```sh
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
```
Check if it's running:
```sh
kubectl get pods -n ingress-nginx
```
✅ **Ingress Controller is now active!** 🎯

---

### **🔹 Step 2: Deploy Sample Applications**
Create two simple **NGINX-based services**.

#### **Backend 1: `service-a`**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: service-a
spec:
  replicas: 2
  selector:
    matchLabels:
      app: service-a
  template:
    metadata:
      labels:
        app: service-a
    spec:
      containers:
      - name: nginx
        image: nginx
---
apiVersion: v1
kind: Service
metadata:
  name: service-a
spec:
  selector:
    app: service-a
  ports:
    - port: 80
      targetPort: 80
```
Apply it:
```sh
kubectl apply -f service-a.yaml
```

#### **Backend 2: `service-b`**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: service-b
spec:
  replicas: 2
  selector:
    matchLabels:
      app: service-b
  template:
    metadata:
      labels:
        app: service-b
    spec:
      containers:
      - name: nginx
        image: nginx
---
apiVersion: v1
kind: Service
metadata:
  name: service-b
spec:
  selector:
    app: service-b
  ports:
    - port: 80
      targetPort: 80
```
Apply it:
```sh
kubectl apply -f service-b.yaml
```
✅ **Now both services are running inside the cluster!**

---

### **🔹 Step 3: Create an Ingress Resource**
We will expose `service-a` and `service-b` on different paths.

#### **ingress.yaml**
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: myapp.local
    http:
      paths:
      - path: /service-a
        pathType: Prefix
        backend:
          service:
            name: service-a
            port:
              number: 80
      - path: /service-b
        pathType: Prefix
        backend:
          service:
            name: service-b
            port:
              number: 80
```
Apply it:
```sh
kubectl apply -f ingress.yaml
```
Check ingress:
```sh
kubectl get ingress
```
Output:
```
NAME          CLASS    HOSTS         ADDRESS        PORTS
my-ingress    <none>   myapp.local   192.168.49.2   80
```
✅ **Ingress is now routing requests!** 🎯

---

### **🔹 Step 4: Test Ingress**
Since Ingress uses **host-based routing**, update `/etc/hosts` on your local machine:
```sh
echo "$(minikube ip) myapp.local" | sudo tee -a /etc/hosts
```
Now, test in a browser or via `curl`:
```sh
curl http://myapp.local/service-a
curl http://myapp.local/service-b
```
✅ **Requests are now routed to the correct services!** 🔄

---

## **3️⃣ Enabling HTTPS (TLS) with Ingress**
To secure Ingress with **SSL/TLS**, we need to:
1. **Create a TLS Certificate**  
2. **Use the certificate in Ingress**  

---

### **🔹 Step 1: Generate a Self-Signed TLS Certificate**
```sh
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=myapp.local"
```
Store it in a **Kubernetes Secret**:
```sh
kubectl create secret tls my-tls-secret --key=tls.key --cert=tls.crt
```
✅ **TLS certificate is now stored securely!** 🔐

---

### **🔹 Step 2: Update Ingress for HTTPS**
Modify `ingress-tls.yaml`:
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-ingress
spec:
  tls:
  - hosts:
    - myapp.local
    secretName: my-tls-secret
  rules:
  - host: myapp.local
    http:
      paths:
      - path: /service-a
        pathType: Prefix
        backend:
          service:
            name: service-a
            port:
              number: 80
```
Apply it:
```sh
kubectl apply -f ingress-tls.yaml
```
✅ **Now Ingress supports HTTPS!** 🔐  

---

### **🔹 Step 3: Test HTTPS**
```sh
curl -k https://myapp.local/service-a
```
✅ **Traffic is now securely encrypted with TLS!** 🔐

---

## **4️⃣ Advanced Ingress Features**
### **🔹 Redirect HTTP to HTTPS**
Add this annotation:
```yaml
annotations:
  nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
```
✅ **All HTTP traffic is now redirected to HTTPS!** 🔄

---

### **🔹 Load Balancing Across Multiple Pods**
Ingress automatically distributes traffic to multiple pods **(round-robin by default)**.

---

### **🔹 Rate Limiting**
Prevent **DDoS attacks** using rate limits:
```yaml
annotations:
  nginx.ingress.kubernetes.io/limit-rps: "5"
```
✅ **Limits each IP to 5 requests per second!** 🔄

---

## **5️⃣ Troubleshooting Ingress Issues**
### **🔹 Check Ingress Controller Logs**
```sh
kubectl logs -n ingress-nginx -l app.kubernetes.io/name=ingress-nginx
```

### **🔹 Describe Ingress Resource**
```sh
kubectl describe ingress my-ingress
```

### **🔹 Check if Service is Reachable**
```sh
kubectl get svc
```

---

# 🚀 **Recap**
✅ **Ingress routes external HTTP/S traffic to services**  
✅ **Path-based & Host-based routing** for multiple services  
✅ **Supports HTTPS with TLS certificates**  
✅ **Load Balancing, Redirects, and Rate Limiting**  

# 🚀 **Advanced Kubernetes Networking: Ingress Controllers, Service Mesh, and API Gateways**
Now that we have explored **Ingress basics**, let’s dive into:
1. **Ingress Controllers: NGINX vs. Traefik** 🌐  
2. **Service Mesh with Istio: Secure, Manage, and Monitor Traffic** 🔄  
3. **API Gateways (Kong, Ambassador, and Gloo)** 🔑  

---

# **1️⃣ Ingress Controllers: NGINX vs. Traefik**
An **Ingress Controller** is required to process Ingress rules.

| **Feature** | **NGINX Ingress Controller** | **Traefik Ingress Controller** |
|------------|----------------------------|-----------------------------|
| **Performance** | High (Optimized for scale) | Medium |
| **Load Balancing** | Yes | Yes |
| **TLS Termination** | Yes | Yes |
| **Traffic Routing** | Path & Host-based | Path & Host-based |
| **Service Discovery** | Kubernetes-native | Kubernetes-native |
| **Dynamic Config Reload** | Reload required | Hot reloading (faster updates) |
| **Monitoring** | Basic Metrics | Built-in Dashboard & Metrics |

### **🔹 Install NGINX Ingress Controller**
```sh
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
```
Verify:
```sh
kubectl get pods -n ingress-nginx
```
✅ **Now, NGINX is ready to process Ingress rules!** 🌍

---

### **🔹 Install Traefik Ingress Controller**
Traefik provides **hot configuration reloads** and an **internal dashboard**.
```sh
helm repo add traefik https://traefik.github.io/charts
helm install traefik traefik/traefik
```
Verify:
```sh
kubectl get pods -n default
```
✅ **Traefik is now handling Ingress requests dynamically!** 🚀

---

# **2️⃣ Service Mesh with Istio**
A **Service Mesh** manages traffic between microservices inside a cluster.

✅ **Features of Istio**:
- **Zero-trust networking** (mTLS encryption) 🔐  
- **Observability & Monitoring** 📊  
- **Traffic Routing & Load Balancing** 🔄  
- **Resilience (Retries, Timeouts, Circuit Breaking)** ⏳  

---

### **🔹 Step 1: Install Istio**
Download Istio CLI:
```sh
curl -L https://istio.io/downloadIstio | sh -
cd istio-*
export PATH=$PWD/bin:$PATH
```
Install Istio:
```sh
istioctl install --set profile=demo -y
```
Verify:
```sh
kubectl get pods -n istio-system
```
✅ **Istio is now managing your microservices!** 🕸️

---

### **🔹 Step 2: Enable Istio in a Namespace**
```sh
kubectl label namespace default istio-injection=enabled
```
Now, all Pods in this namespace get an **Istio sidecar proxy**.

---

### **🔹 Step 3: Deploy an Istio VirtualService**
Example YAML (`virtualservice.yaml`):
```yaml
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: myapp-vs
spec:
  hosts:
  - myapp.local
  gateways:
  - my-gateway
  http:
  - route:
    - destination:
        host: myapp-service
        port:
          number: 80
```
Apply it:
```sh
kubectl apply -f virtualservice.yaml
```
✅ **Now Istio is routing traffic intelligently!** 🔄

---

### **🔹 Step 4: Monitor Traffic with Kiali**
```sh
kubectl apply -f https://github.com/istio/istio/releases/latest/download/samples/addons/kiali.yaml
kubectl port-forward svc/kiali 20001:20001 -n istio-system
```
Open **http://localhost:20001** for a **real-time traffic graph!** 📊

✅ **Now Istio provides full network observability!** 🕵️‍♂️

---

# **3️⃣ API Gateways (Kong, Ambassador, and Gloo)**
An **API Gateway** controls external traffic with:
- **Rate Limiting**  
- **Authentication (OAuth, JWT, API Keys)**  
- **Logging & Monitoring**  

| **API Gateway** | **Best For** |
|--------------|-------------|
| **Kong** | High-performance, API security |
| **Ambassador** | Developer-friendly, Kubernetes-native |
| **Gloo** | Serverless & API integration |

---

### **🔹 Step 1: Install Kong API Gateway**
```sh
helm repo add kong https://charts.konghq.com
helm install kong kong/kong --set ingressController.installCRDs=false
```
Verify:
```sh
kubectl get pods -n default
```
✅ **Kong is now managing your APIs!** 🔑

---

### **🔹 Step 2: Define an API Route**
Example YAML (`kong-ingress.yaml`):
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: myapi-ingress
  annotations:
    konghq.com/strip-path: "true"
spec:
  rules:
  - host: api.myapp.local
    http:
      paths:
      - path: /v1
        pathType: Prefix
        backend:
          service:
            name: myapi-service
            port:
              number: 80
```
Apply it:
```sh
kubectl apply -f kong-ingress.yaml
```
✅ **Now, Kong is routing external API traffic!** 🌎

---

### **🔹 Step 3: Enable Rate Limiting in Kong**
Add a **Rate-Limiting Plugin**:
```sh
kubectl apply -f - <<EOF
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: rate-limit
config:
  minute: 10
  policy: local
EOF
```
✅ **Now, Kong limits each client to 10 requests per minute!** 🚦

---

# **🚀 Recap**
✅ **NGINX vs. Traefik Ingress Controllers** for traffic routing  
✅ **Istio Service Mesh** for **zero-trust networking & monitoring**  
✅ **Kong API Gateway** for **authentication & rate limiting**  

# 🚀 **Advanced Kubernetes Topics - Overview**  
Here’s a **comprehensive list** of advanced Kubernetes topics categorized for easy exploration.

---

## **1️⃣ Networking & Traffic Management 🌐**
- **Ingress Controllers (NGINX, Traefik, HAProxy)**
- **Service Mesh (Istio, Linkerd, Consul)**
- **API Gateways (Kong, Ambassador, Gloo)**
- **Multi-Cluster Networking (Submariner, Cilium)**
- **Traffic Mirroring & Shadow Testing**
- **mTLS (Mutual TLS) for Secure Communication**
- **eBPF for Kubernetes Network Observability**

---

## **2️⃣ Kubernetes Security & Compliance 🔐**
- **RBAC (Role-Based Access Control) Best Practices**
- **Pod Security Policies & Security Context**
- **Zero Trust Security with Istio**
- **Network Policies & Firewall Rules**
- **TLS Certificates & Automated Renewal (cert-manager)**
- **Secrets Management (Vault, Sealed Secrets, SOPS)**
- **Supply Chain Security (Software Bill of Materials - SBOM, Sigstore)**
- **Kubernetes Security Scanning (Trivy, Falco, Kube-bench)**
- **Pod Sandboxing (gVisor, Kata Containers)**

---

## **3️⃣ Kubernetes Storage & Data Management 📦**
- **Dynamic Volume Provisioning (StorageClass)**
- **Persistent Volume & Persistent Volume Claims**
- **CSI (Container Storage Interface)**
- **Rook & Ceph for Distributed Storage**
- **Longhorn & OpenEBS for Cloud-Native Storage**
- **Data Backup & Disaster Recovery (Velero, Kasten)**
- **Database Operators (MySQL, PostgreSQL, MongoDB on Kubernetes)**

---

## **4️⃣ Kubernetes Performance Optimization ⚡**
- **Horizontal Pod Autoscaler (HPA)**
- **Vertical Pod Autoscaler (VPA)**
- **Cluster Autoscaler (AWS, GCP, Azure)**
- **Node Resource Management (CPU, GPU, Memory Limits)**
- **NUMA-Aware Scheduling for High-Performance Computing**
- **Real-Time Kubernetes Workloads (Low-Latency Systems)**
- **Kubernetes Bottleneck Detection (Kubernetes Dashboard, Prometheus, Loki, Jaeger)**

---

## **5️⃣ Advanced Deployment Strategies & CI/CD 🚀**
- **GitOps (ArgoCD, Flux)**
- **Canary Deployments & Progressive Delivery**
- **Blue-Green Deployments**
- **Feature Flags (Flagger, Unleash)**
- **Continuous Deployment with Jenkins, Tekton, Spinnaker**
- **Kubernetes Release Strategies (Helm vs Kustomize)**
- **Automated Rollbacks & Self-Healing Apps**
- **CI/CD for Machine Learning Models (Kubeflow Pipelines, MLflow)**

---

## **6️⃣ Multi-Cluster & Multi-Cloud Kubernetes ☁️**
- **Kubernetes Federation (Kubefed)**
- **Multi-Cluster Service Discovery (Istio, Cilium)**
- **Cross-Cloud Load Balancing**
- **KubeEdge for Edge Computing**
- **5G & Kubernetes for IoT Deployments**
- **Anthos, OpenShift, Rancher for Multi-Cluster Management**
- **Cluster Mesh & Inter-Cluster Communication**

---

## **7️⃣ Kubernetes Observability & Monitoring 📊**
- **Prometheus & Grafana for Cluster Monitoring**
- **Distributed Tracing (Jaeger, OpenTelemetry)**
- **Logging with ELK Stack (Elasticsearch, Logstash, Kibana)**
- **Kubernetes Events Monitoring & Alerting**
- **Kube-State-Metrics & Custom Metrics API**
- **Kubernetes Chaos Engineering (LitmusChaos, Chaos Mesh)**

---

## **8️⃣ Kubernetes AI/ML & High-Performance Workloads 🤖**
- **Kubeflow for AI/ML Model Training & Serving**
- **GPU Scheduling & Kubernetes for Deep Learning**
- **TensorFlow Serving & NVIDIA Triton Inference Server**
- **Jupyter Notebooks on Kubernetes**
- **AI Workload Auto-Tuning with KServe**
- **Federated Learning & AI/ML in Multi-Cluster Kubernetes**
- **AI-Based Kubernetes Optimization (Kepler, StormForge)**

---

## **9️⃣ Kubernetes for Enterprise & FinTech 💰**
- **High-Frequency Trading (HFT) on Kubernetes**
- **Event-Driven Microservices with Kafka & Kubernetes**
- **Blockchain & Smart Contracts on Kubernetes (Ethereum, Hyperledger)**
- **Kubernetes for Banking, Insurance, and Payment Processing**
- **Kubernetes & GDPR/PCI-DSS Compliance**
- **Enterprise Kubernetes (Red Hat OpenShift, Tanzu, Anthos)**

---

## **🔟 Kubernetes for Special Use Cases 🔄**
- **Serverless Kubernetes (Knative, OpenFaaS)**
- **Edge Computing with Kubernetes (K3s, MicroK8s)**
- **Kubernetes for Robotics & Autonomous Systems**
- **Kubernetes in Space (NASA, Satellites, SpaceX Use Cases)**
- **Quantum Computing & Kubernetes**
- **Digital Twin Simulations using Kubernetes**
- **Self-Healing Kubernetes Clusters**

---

## **💡 Kubernetes Community & Contribution**
Kubernetes is an **open-source project**, and the community plays a huge role in its development.

### **🔹 How to Get Involved?**
- **Join Kubernetes Slack**: [slack.k8s.io](https://slack.k8s.io/)
- **Participate in Kubernetes SIGs (Special Interest Groups)**
  - SIG Architecture
  - SIG Network
  - SIG Security
  - SIG AI/ML
- **Contribute to Kubernetes GitHub**: [github.com/kubernetes](https://github.com/kubernetes/)
- **Attend KubeCon (Kubernetes Community Conference)**
- **Write Kubernetes Blogs, Create YouTube Tutorials**
- **Answer Kubernetes Questions on Stack Overflow & Kubernetes Forum**
- **Help Improve Kubernetes Docs**: [kubernetes.io/docs](https://kubernetes.io/docs/)

---

# 🎯 **Next Steps**
Would you like to explore **Kubernetes Advanced Security, Service Mesh Deep Dive, or Kubernetes for AI Workloads?** 🚀