import json

def get_JSON_file(file_path):
    with open(file_path) as config_file:
        return json.load(config_file)