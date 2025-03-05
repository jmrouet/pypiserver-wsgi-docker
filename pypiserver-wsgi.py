#! /usr/bin/env python

import pypiserver

welcome_msg = "Welcome to internal pypi server"
application = pypiserver.app(
    roots =          [ "/home/pip-repo/packages" ],
    # disable authentication
    authenticate =   ".",
    # password_file =  "/home/pip-repo/.htpasswd",
    welcome_msg =    welcome_msg,
    verbosity =      3, # max value is 3
    log_file =       "/wsgi.log",
    log_stream =     "none",
    cache_control =  3600,
    overwrite =    True, # allow overwrite of existing packages
    backend_arg =    "cached-dir",
    disable_fallback = True, # disable fallback to PyPI
    hash_algo =      None, # None: disable, else sha256 or md5
 )
