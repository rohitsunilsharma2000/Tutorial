from flask import Flask
import redis
import os

app = Flask(__name__)

# Connect to Redis
redis_host = os.getenv("REDIS_HOST", "redis")  # Use service name in Swarm
redis_client = redis.Redis(host=redis_host, port=6379, decode_responses=True)

@app.route("/")
def counter():
    count = redis_client.incr("hits")
    return f"Hello! This page has been viewed {count} times."

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)  # Running on port 8000
