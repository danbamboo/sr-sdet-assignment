import pytest
import requests
from lib.utils import get_JSON_file, validate_date_format
import os
import json


@pytest.fixture(scope="module", autouse=True)
def setup(config_env):
    """_summary_ Setup variables 'baseURL'for use throughout the test_user module
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
def test_all_calendar(test):
    """test_all_calendar will loop through all tests defined in the test configuration (set in get_test_data() based on test environment)
    See data/env/<>/test.json for the list of test cases that run
    """
    print(test["test_description"])
    response = requests.get("{}{}".format(baseURL, test["uri"]))
    
    assert response.status_code == test["expected_status"]
    assert response.headers["Content-Type"].lower() == test["expected_content_header"].lower()
    
    # Skip invalid tests (i.e. expected bad response) marked in test.json file to not attempt to compare response JSON response body since no body will be returned ()
    if "invalid_test" not in test:
        validate_calendar_responses(response.text, test["expected_response"])
    
def validate_calendar_responses(got, expected):
    """validate_calendar_responses runs custom compare of response, mainly to account for variable date times.
       Validates all fields equal except datetime just validates the the format is correct

    Args:
        got (_type_): The raw json text from the response
        expected (_type_): The provided expected raw json text from test data
    """
    date_format = "%m/%d/%Y, %H:%M:%S %p"
    got_obj = json.loads(got)
    expected_obj = json.loads(expected)
    
    for got,expected in zip(got_obj["events"], expected_obj["events"]):
        assert got["attendees"] == expected["attendees"]
        assert got["id"] == expected["id"]
        assert got["name"] == expected["name"]
        assert got["duration"] == expected["duration"]
        assert got["timeZone"] == expected["timeZone"]
        #Since date times are random, best we can do is ensure they are always returned in expected date format (see date_format variable)
        assert validate_date_format(got["date"], date_format)
        assert validate_date_format(expected["date"], date_format)

    