# author: Miquel Barceló Roman
# https://github.com/miquelbar

import os
from bottle import route, run, template, view, static_file
from elasticapm.contrib.opentracing import Tracer
from opentracing.propagation import Format
from elasticapm import Client

ENVIRONMENT = os.getenv('ENVIRONMENT', 'local')
DEBUG = True if os.getenv('DEBUG', 'False').lower() == 'true' else False
RELOADER = True if os.getenv('RELOADER', 'False').lower() == 'true' else False

TRACER = Tracer(Client({'SERVICE_NAME': os.environ.get('APM_NAME')}))

@route('/hello/static/<filename:path>')
@route('/static/<filename:path>')
def send_static(filename):
    return static_file(filename, root='./static')

@route('/')
@view('home')
def index():
    with TRACER.start_active_span("index", finish_on_close=True):
        return dict(environment=ENVIRONMENT)

@route('/hello')
@route('/hello/<name>')
@view('hello')
def hello(name='World'):
    with TRACER.start_active_span("hello", finish_on_close=True):
        return dict(name=name, environment=ENVIRONMENT)



run(host='0.0.0.0', port=8080, debug=DEBUG, reloader=RELOADER)
