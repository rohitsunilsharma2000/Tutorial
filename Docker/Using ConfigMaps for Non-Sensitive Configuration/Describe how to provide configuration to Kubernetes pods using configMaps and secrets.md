# **🔹 Providing Configuration to Kubernetes Pods Using ConfigMaps & Secrets** 🚀  

Kubernetes provides two primary ways to **externalize configuration** for Pods:  
✅ **ConfigMaps** → Store **non-sensitive** configuration data (e.g., environment variables, config files).  
✅ **Secrets** → Store **sensitive** data (e.g., passwords, API keys, tokens) **securely**.

---

# **📌 1️⃣ Using ConfigMaps for Non-Sensitive Configuration**
### **Scenario**:  
A **Spring Boot app** needs a configuration file and environment variables.

### **🔹 Step 1: Create a ConfigMap**
A **ConfigMap** can be created **from a file**, **from a literal value**, or using a YAML manifest.

#### **Option 1: Create a ConfigMap from a Literal Value**
```sh
kubectl create configmap demo-config \
  --from-literal=APP_ENV=production \
  --from-literal=LOG_LEVEL=info
```
✔ This stores **key-value pairs** as configuration.

#### **Option 2: Create a ConfigMap from a File**
```sh
echo "app.name=DemoApp" > application.properties
kubectl create configmap app-config --from-file=application.properties
```
✔ This allows **mounting the config file inside the container**.

#### **Option 3: Define a ConfigMap in a YAML File (`configmap.yaml`)**
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: demo-config
data:
  APP_ENV: "production"
  LOG_LEVEL: "info"
  application.properties: |
    app.name=DemoApp
    app.version=1.0.0
```
Apply it:
```sh
kubectl apply -f configmap.yaml
```

---

### **🔹 Step 2: Use ConfigMap in a Pod**
Modify `deployment.yaml` to use **ConfigMap as environment variables**:
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
          envFrom:
            - configMapRef:
                name: demo-config  # Reference ConfigMap
          volumeMounts:
            - name: config-volume
              mountPath: /app/config  # Mount ConfigMap as a file
      volumes:
        - name: config-volume
          configMap:
            name: demo-config
```

### **🔹 Step 3: Verify Configurations**
Deploy the application:
```sh
kubectl apply -f deployment.yaml
```

Check if the **ConfigMap is correctly applied** inside the Pod:
```sh
kubectl exec -it <pod_name> -- env | grep APP_ENV
```
✔ **Expected Output**:
```
APP_ENV=production
LOG_LEVEL=info
```

Check if the **mounted file exists**:
```sh
kubectl exec -it <pod_name> -- cat /app/config/application.properties
```
✔ **Expected Output**:
```
app.name=DemoApp
app.version=1.0.0
```

---

# **📌 2️⃣ Using Secrets for Sensitive Data**
### **Scenario:**  
The **Spring Boot app** needs a **database password** stored securely.

### **🔹 Step 1: Create a Secret**
#### **Option 1: Create a Secret from a Literal Value**
```sh
kubectl create secret generic db-secret \
  --from-literal=DB_USER=demo_user \
  --from-literal=DB_PASSWORD=supersecret
```

#### **Option 2: Create a Secret from a File**
```sh
echo -n "supersecret" > password.txt
kubectl create secret generic db-secret --from-file=password.txt
```

#### **Option 3: Define a Secret in a YAML File (`secret.yaml`)**
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: db-secret
type: Opaque
data:
  DB_USER: ZGVtb191c2Vy  # Base64-encoded "demo_user"
  DB_PASSWORD: c3VwZXJzZWNyZXQ=  # Base64-encoded "supersecret"
```
Apply it:
```sh
kubectl apply -f secret.yaml
```

---

### **🔹 Step 2: Use Secret in a Pod**
Modify `deployment.yaml` to **inject Secrets** as environment variables:
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
            - name: DB_USER
              valueFrom:
                secretKeyRef:
                  name: db-secret
                  key: DB_USER
            - name: DB_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: db-secret
                  key: DB_PASSWORD
          volumeMounts:
            - name: secret-volume
              mountPath: /app/secrets  # Mount Secret as a file
              readOnly: true
      volumes:
        - name: secret-volume
          secret:
            secretName: db-secret
```

### **🔹 Step 3: Verify Secret Injection**
Deploy the updated app:
```sh
kubectl apply -f deployment.yaml
```

Check if the **Secrets are correctly injected**:
```sh
kubectl exec -it <pod_name> -- env | grep DB_
```
✔ **Expected Output**:
```
DB_USER=demo_user
DB_PASSWORD=supersecret
```

Check if the **mounted Secret file exists**:
```sh
kubectl exec -it <pod_name> -- cat /app/secrets/DB_PASSWORD
```
✔ **Expected Output**:
```
supersecret
```

---

# **📌 3️⃣ Differences Between ConfigMaps & Secrets**
| **Feature** | **ConfigMap** | **Secret** |
|------------|------------|------------|
| **Purpose** | Stores **non-sensitive** configuration | Stores **sensitive** data like passwords |
| **Storage Format** | Plain text | Base64-encoded |
| **Usage** | Environment variables, mounted files | Environment variables, mounted files |
| **Encryption** | Not encrypted | Can be encrypted via K8s providers |
| **Access Control** | General access | Restricted via RBAC |

---

# **✅ Summary of Steps**
| **Task** | **Command** |
|----------|------------|
| **Create a ConfigMap (CLI)** | `kubectl create configmap demo-config --from-literal=APP_ENV=production` |
| **Create a Secret (CLI)** | `kubectl create secret generic db-secret --from-literal=DB_PASSWORD=supersecret` |
| **Apply ConfigMap from YAML** | `kubectl apply -f configmap.yaml` |
| **Apply Secret from YAML** | `kubectl apply -f secret.yaml` |
| **Check ConfigMap Values** | `kubectl get configmap demo-config -o yaml` |
| **Check Secret Values (Base64 Encoded)** | `kubectl get secret db-secret -o yaml` |
| **Check Secret Decoded Value** | `kubectl get secret db-secret -o jsonpath="{.data.DB_PASSWORD}" | base64 --decode` |
| **Verify ConfigMap in Pod** | `kubectl exec -it <pod_name> -- env | grep APP_ENV` |
| **Verify Secret in Pod** | `kubectl exec -it <pod_name> -- env | grep DB_` |
| **Delete ConfigMap** | `kubectl delete configmap demo-config` |
| **Delete Secret** | `kubectl delete secret db-secret` |

---
This setup **securely manages environment variables** and **configuration files** for Kubernetes Pods! 🚀🔥  

Would you like to integrate **Persistent Volumes for database storage** next? 😊