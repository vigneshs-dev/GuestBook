from flask import Flask
from redis import Redis
from app import routes  # Move this import to the top

app = Flask(__name__)
redis = Redis(host='redis-service', port=6379)