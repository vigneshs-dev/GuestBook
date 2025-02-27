from flask import Flask
from redis import Redis

app = Flask(__name__)
redis = Redis(host='redis-service', port=6379)

from app import routes