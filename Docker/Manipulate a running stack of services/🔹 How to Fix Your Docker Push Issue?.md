For security reasons, **never** share your Docker Hub username and password in public or with anyone. 

### **🔹 How to Fix Your Docker Push Issue?**
Since your **Docker Hub username is an email (`meghnadsaha422@gmail.com`)**, Docker requires you to use your **Docker Hub username (not your email)** when pushing images.

---

### **1️⃣ Get Your Correct Docker Hub Username**
Run:
```sh
docker info | grep "Username"
```
or check it manually in **Docker Hub** ([https://hub.docker.com/settings](https://hub.docker.com/settings)).

Your username is **not** your email; it's usually your **Docker ID**.

---

### **2️⃣ Logout and Log in with Correct Credentials**
If you previously logged in with your email, log out:
```sh
docker logout
```
Then log in again using your **Docker Hub username** (not email):
```sh
docker login
```
Enter:
- **Username:** (Your Docker ID, e.g., `meghnadsaha422`)
- **Password:** (Your Docker Hub password)

---

### **3️⃣ Re-Tag and Push the Image**
#### **Re-tag the Image with Your Username**
```sh
docker tag flask-redis-app:latest meghnadsaha422/flask-redis-app:v2
```
#### **Push the Image**
```sh
docker push meghnadsaha422/flask-redis-app:v2
```

---

### **4️⃣ If You Forgot Your Username**
If you're unsure of your username, reset your password or check your Docker profile:  
👉 [https://hub.docker.com/settings](https://hub.docker.com/settings)

---

### **✅ Summary**
✔ **Use Docker Hub username (not email) to push images**  
✔ **Log in with the correct username (`docker login`)**  
✔ **Re-tag and push with the correct username (`docker tag flask-redis-app:latest <your-username>/flask-redis-app:v2`)**  

Now, **Docker push should work!** 🚀 Let me know if you need further help.