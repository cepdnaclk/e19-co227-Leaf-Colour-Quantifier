import json
import os
from pathlib import Path
from typing import Dict

def get_config() -> Dict:
    """ Get Config Json"""
    with open(str(Path(
            __file__).parent.parent) + os.sep + "config" + os.sep + "conf.json",
              'r') as fp:
        return json.load(fp)
    

class ProjectSettings:
    """ Project Configuration"""
    __DATA = get_config()['PROJECT_CONF']
    PROJECT_NAME = __DATA["PROJECT_NAME"]
    PROJECT_DESCRIPTION = __DATA["PROJECT_DESCRIPTION"]
    API_VERSION = __DATA["API_VERSION"]
    API_VERSION_PATH = __DATA["API_VERSION_PATH"]
    SERVER_NAME = __DATA["SERVER_NAME"]
    SERVER_HOST = __DATA["SERVER_HOST"]
    BACKEND_CORS_ORIGINS = __DATA["BACKEND_CORS_ORIGINS"]
    ACCESS_TOKEN_EXPIRE_MINUTES = __DATA["ACCESS_TOKEN_EXPIRE_MINUTES"]
    SESSION_TOKEN_EXPIRE_SECONDS = __DATA["SESSION_TOKEN_EXPIRE_SECONDS"]