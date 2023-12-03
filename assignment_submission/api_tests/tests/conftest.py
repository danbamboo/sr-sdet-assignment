import os
import pytest
from lib.utils import get_JSON_file 
 
#Fetches config/env file and set as shared environment
@pytest.fixture(scope="session")
def config_env():
    config =  os.environ['TEST_ENV'] if "TEST_ENV" in os.environ else "local"  #Check for target env set in envs, default to local.json 
    CONFIG_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'configs/env/{}/config.json'.format(config))  #Create path to config based on root proj dir
    return get_JSON_file(CONFIG_PATH)
    # with open(CONFIG_PATH) as config_file:
    #     config_data = json.load(config_file)
    # return config_data