# Debian - Python - Mod_Wsgi

This is the repo for running a `pypiserver` app under `mod_wsgi` on apache in a docker container.

This repo is to demonstrate or reproduce a bug observed with `uv publish` command on such an environment.
It is inspired from [this repo](https://github.com/carlostighe/apache-flask.git)

Build and run:

 * Download the repo
 * build the image: `docker build -t apache-pypiserver .`
 * Run the docker file: `docker run --rm -d -p 80:80 --name myserver apache-pypiserver`
 * View logs, if needed, with `docker logs -f myserver`
 * Create a python package with uv and try to push
 ```bash
 mkdir mypackage && cd mypackage
 uv init
 uv build
 uv publish --publish-url http://localhost/pip --username "test"
 ```
 Note that we haven't set any authentication on this example pypiserver (see `authenticate =   ".",` in `pypiserver-wsgi.py`), so no password will be asked



#### The docker file runs through the following steps:  

 - get debian bullseye-slim image.
 - create a local pip-repo user with venv
 - install the requirements for python and pypiserver on debian  
 - copy over the `requirements.txt` file and run `pip install` on it  
 - copy over the `pypiserver-wsgi.py` file to apache directory
 - enable the new apache config file and headers
 - dissable the default apache config file  
 - expose port 80
 - point the container to the application directory  
 - the run command. 
