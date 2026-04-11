import os
import srsly
from pymongo import MongoClient


def get_files_dir(dir_path: str) -> list:
    files = [f.name for f in os.scandir(dir_path) if f.is_file()]
    return files

def save_mongodb(docs: list, threshold: int = 100000):
    pass


