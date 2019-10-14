#!/usr/bin/env python3

import argparse
import os
import tarfile


project_root_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def add_cmakelists(target):
    cmakelists = 'CMakeLists.txt'
    gdal_root_dir = os.path.join(project_root_dir, 'gdal')
    for cur, _, _ in os.walk(gdal_root_dir):
        if os.path.exists(os.path.join(cur, cmakelists)):
            target.add(os.path.join(cur, cmakelists))
    autotest_root_dir = os.path.join(project_root_dir, 'autotest')
    for cur, _, _ in os.walk(autotest_root_dir):
        if os.path.exists(os.path.join(cur, cmakelists)):
            target.add(os.path.join(cur, cmakelists))
    target.add(os.path.join(project_root_dir,  cmakelists))


def is_project_root():
    if os.path.exists(os.path.join(project_root_dir, 'README.md')):
        with open(os.path.join(project_root_dir, 'README.md'), 'r') as f:
            first_line = f.readline()
            if first_line.startswith('GDAL - Geospatial Data Abstraction Library'):
                return True
    return False


def main(arg=None):
    parser = argparse.ArgumentParser(prog='package.py', description='cmake for gdal packager',
                                     formatter_class=argparse.RawTextHelpFormatter, add_help=True)
    parser.add_argument("-c", "--create", action='store_true', help="Create archive file.")
    parser.add_argument("-x", "--extract", action='store_true', help="Create archive file.")

    if not is_project_root():
        parser.print_help()
        return 1

    args = parser.parse_args(arg)
    if args.create:
        arcfile = os.path.join(os.path.dirname(__file__), 'package.tar.xz')
        with tarfile.open(arcfile, 'w:xz') as target:
            add_cmakelists(target)
    elif args.extract:
        arcfile = os.path.join(os.path.dirname(__file__), 'package.tar.xz')
        with tarfile.open(arcfile, 'r:xz') as arc:
            arc.extractall(project_root_dir)
    else:
        parser.print_help()

    return 0


if __name__ == "__main__":
    exit(main())


