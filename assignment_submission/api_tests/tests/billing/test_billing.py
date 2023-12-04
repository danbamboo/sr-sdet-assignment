import pytest
import requests
from lib.utils import get_JSON_file, validate_date_format
import os
import json


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
    
    if "non200" not in test:  #For expected 200 calls, we custom validate the json response; otherwise direct compare of jsonx
        custom_validate_billing_responses(response.text, test["expected_response"])
    else:
        assert response.text  == test["expected_response"]
    assert response.headers["Content-Type"].lower() == test["expected_content_header"].lower()
    
    
def custom_validate_billing_responses(got, expected):
    """custom_validate__responses runs custom compare of response, mainly to account for variable date times.
       Validates all fields equal except datetime just validates the the format is correct

    Args:
        got (_type_): The raw json text from the response
        expected (_type_): The provided expected raw json text from test data
    """
    got = json.loads(got)
    expected = json.loads(expected)
    
    assert got["user_id"] == expected["user_id"]
    assert got["price_cents"] == expected["price_cents"]
    #Since date times are random, best we can do is ensure they are always returned in expected date format (see date_format variable)
    date_format = "%m/%d/%Y"
    assert validate_date_format(got["renewal_date"], date_format)
    assert validate_date_format(expected["renewal_date"], date_format)