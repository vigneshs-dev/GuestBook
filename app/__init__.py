from flask import Flask
from redis import Redis

app = Flask(__name__)
redis = Redis(host='redis-service', port=6379)

# Import routes AFTER app and redis are defined
from app import routes  # ✅ Correct placement to avoid circular import
