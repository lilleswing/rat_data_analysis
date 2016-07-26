from __future__ import division
from os import listdir
from os.path import isfile
from scipy.stats import norm
import datetime
import os
import pandas as pandas
import re
import sys


# Folder where reports are stored
BASE_DIR = "/Users/Glennon/Documents/erins_data"

# Attempt to make folder if not exist
try:
  os.mkdir(BASE_DIR)
except:
  pass


def get_data_from_file(filename):
    """
    You wrote this!  Good Job!
    We changed it to have a "return" instead of a "side effect" of printing
    Args:
        filename (string): absolute or local path to a file with csv data
    Returns:
        dict: All the needed information from aggregating the csv data
    """
    data = open(filename).readlines()
    data = [[float(y) for y in x.split()] for x in data]
    df = pandas.DataFrame(data)

    response = df[:][3]

    hit = sum(1 for item in response if item == (1.0))
    miss = sum(1 for item in response if item == (2.0))
    if miss is 0:
        miss = miss + 1
        print("miss was zero")
    false = sum(1 for item in response if item == (3.0))
    if false is 0:
        false = false + 1
        print("false was zero")
    withold = sum(1 for item in response if item == (4.0))

    detection = (hit / (hit + miss) * 100)
    discrimination = (false / (false + withold) * 100)

    d1 = norm.ppf(detection/100)
    d2 = norm.ppf(discrimination/100)

    dprime = d1 - d2

    return {
        "hit": hit,
        "miss": miss,
        "false": false,
        "withold": withold,
        "detection": detection,
        "discrimination": discrimination,
        "dprime": dprime
    }


def parse_filename(filename):
    """
    I wrote this one for you.  It uses a tool called regular expressions
    https://en.wikipedia.org/wiki/Regular_expression
    Basically pattern matching on a String to pull out parts you care about
    Args:
        filename (string): absolute or local path to a file with csv data
    Returns:
        dict: All the needed information from parsing the filename
    """
    PATTERN = r"(?P<date>\d\d_\d\d_\d\d)_(?P<animal>.+) (?P<program>.*).csv"
    filename = os.path.basename(filename)
    m = re.match(PATTERN, filename)
    d = m.groupdict()

    # We want the date to be a date object so we can sort it nicely :)
    d['date'] = datetime.datetime.strptime(d['date'], "%m_%d_%y")
    return d


def append_row(dataframe, data_dictionary):
    """
    TODO(ERIN)
    Args:
        dataframe (DataFrame): DataFrame with all animal data up to now
        data_dictionary (Dict): Dictionary with new data to append to Dataframe
    Returns:
        DataFrame: A new Dataframe with data_dictionary appended
    """
    updated = pandas.concat(dataframe, data_dictionary)
    print updated
    return updated


def save_to_file(out_folder, animal_name, dataframe):
    """
    TODO(ERIN)
    Time to save our results!
    This function has the Side Effect of creating a file in
    <out_folder>/<animal_name>.csv with the contents of dataframe

    Args:
        out_folder (String): folder which we want to save our data to
        animal_name (String): Name of the animal who this data is on
        dataframe (DataFrame): DataFrame containing all the data
    Returns:
        None:
    """
    file_name = "%s.csv" % (animal_name)
    DataFrame.to_csv("/Users/Glennon/Documents/erins_data", file_name)
    return



def get_all_data_as_dict(filename):
    """
    TODO(ERIN)
    This function aggegates all the data from a single file
    It should call "parse_filename" and "get_data_from_file"
    and join the results into a single dictionary
    Args:
        filename (String): filename which we want to get data on
    Returns:
        dict: Dictionary with all data from parse_filename and
              get_data_from_file
    """
    filedata = parse_filename(filename)
    data = get_data_from_file(filename)
    data_dictionary = filedata.copy()
    data_dictionary.update(data)
    return {data_dictionary}


def get_all_files_in_folder(folder):
    """
    TODO(ERIN)
    Returns a List of Strings which contain every filename in a folder
    Args:
        folder (String): Folder Path which we want files in
    Returns:
        list<String>: List of filenames in folder
    """
    folder = os.listdir("/Users/Glennon/Documents/erins_reports_test")
    return [folder]


def main(in_folder, out_folder):
    files = get_all_files_in_folder(in_folder)
    dataframes = {}
    for f in files:
        f = os.path.join(in_folder, f)
        d = get_all_data_as_dict(f)
        if d['animal'] not in dataframes:
            dataframes[d['animal']] = pandas.DataFrame([], columns=d.keys())
        df = append_row(dataframes[d['animal']], d)
        dataframes[d['animal']] = df

    for animal_name, df in dataframes.iteritems():
        save_to_file(out_folder, animal_name, df)


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("python analyze.py <csv_input_folder> <output_folder>")
        sys.exit(1)
    main(sys.argv[1], sys.argv[2])
