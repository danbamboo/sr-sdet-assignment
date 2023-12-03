import json
import datetime


def get_JSON_file(file_path):
    with open(file_path) as config_file:
        return json.load(config_file)

def validate_date_format(date_string, format):
    return datetime.datetime.strptime(date_string, format)