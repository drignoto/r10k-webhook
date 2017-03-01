#!/usr/bin/env python
# coding=utf-8

## EolDavix
## Version: 0.1.0

import sys
import web
import json
import subprocess
import shlex
import threading
from multiprocessing.pool import ThreadPool


# Tupla r10k
urls = (
    '/r10k', 'deploy_r10k',
)

app = web.application(urls, globals())


# Excepciones
class CommandNotAllowed(Exception):
    def __init__(self, value):
        self.value = value
    def __str__(self):
        return repr(self.value)

# Métodos
def run():
    command = "r10k deploy environment -pv"
    args=shlex.split(command)
    popen = subprocess.Popen(args, stdout=subprocess.PIPE, shell=False)
    popen.communicate()
    return popen.returncode


# Clases de ejecución
class deploy_r10k():
    def OPTIONS(self):
        web.header('Access-Control-Allow-Origin', '*')
        web.header('Access-Control-Allow-Methods', 'POST')
        web.header('Content-Type', 'application/json')

    def POST(self):
        # apikey = web.input(key='key').key

        web.header('Access-Control-Allow-Origin', '*')
        web.header('Access-Control-Allow-Methods', 'POST')
        web.header('Content-Type', 'application/json')

        # descr = web.input(descr='descr').descr

        payload = web.data()

        secret = json.loads(payload)["secret"]

        if secret != sys.argv[2]:
            return '{"success": false}'

        else:
            #t = threading.Thread(target=run)
            pool = ThreadPool(processes=1)

            try:
                # t.start()
                async_result = pool.apply_async(run)
                return_val = async_result.get()
                if return_val == 0:
                    return '{"success": true}'
                else:
                    message="409: Bad syntax error. Check container logs"
                    raise web.Conflict(message)
            except KeyboardInterrupt:
                pass

if __name__ == "__main__":
    app.run()
