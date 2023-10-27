import json

def read_data_from_file(filename):
    with open(filename, 'r') as file:
        data = json.load(file)
    return data
