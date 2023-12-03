import pytest
import requests
from lib.utils import get_JSON_file 
import os


@pytest.fixture(scope="module", autouse=True)
def setup(config_env):
    """_summary_ Setup variables 'baseURL' for use throughout the test_user module
        Uses the config_env fixture to auto-set these vars based on config files (see tests/conftest.py)
    """
    global baseURL
    baseURL = config_env["base_url"]

def get_test_data():
    global test_data
     # Get test JSON data based on current environment
    test_env = os.environ['TEST_ENV'] if "TEST_ENV" in os.environ else "local"  #Check for target env set in envs, default to local 
    filepath = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'data/env/{}/tests.json'.format(test_env))
    test_data = get_JSON_file(filepath)
    return  test_data["tests"]

@pytest.mark.parametrize("test", get_test_data())
def test_all_billing(test):
    """test_all will loop through all tests defined in the test configuration (set in get_test_data() based on test environment)
    See data/env/<>/test.json for the list of test cases that run
    """
    print(test["test_description"])
    response = requests.get("{}{}".format(baseURL, test["uri"]))
    assert response.status_code == test["expected_status"]
    if "skip_response_validation" not in test:  #For some cases we skip response validation due to very long/irrelevant json output
        assert response.text  == test["expected_response"]
    assert response.headers["Content-Type"].lower() == test["expected_content_header"].lower()