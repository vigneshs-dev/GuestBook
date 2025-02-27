from flask import render_template, request, redirect, url_for
from app import app, redis

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        name = request.form['name']
        message = request.form['message']
        redis.rpush('messages', f'{name}: {message}')
        return redirect(url_for('index'))
    
    messages = redis.lrange('messages', 0, -1)
    return render_template('index.html', messages=messages)