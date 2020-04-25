#!/usr/bin/env python3

import argparse
import os


cur_dir = os.path.abspath(os.path.dirname(os.path.abspath(__file__)))
parent_dir = os.path.abspath(os.path.dirname(cur_dir))
listpath = os.path.join(cur_dir, 'cmakelists')
gdalsrc_dir = os.path.join(parent_dir, 'gdal')
autotest_dir = os.path.join(parent_dir, 'autotest')


def check_folders():
    """traverse project folders and check."""
    ok = True
    ignore_list = ['o']
    for cur, _, files in os.walk(gdalsrc_dir):
        if 'GNUMakefile' in files:
            if os.path.lexists(os.path.join('CMakeLists.txt')):
                continue
            else:
                head, tail = os.path.split(cur)
                if tail in ignore_list:
                    continue
                else:
                    print('Untreated project directory found: {}'.format(cur))
                    ok = False
    if ok:
        print('There is no missing new driver for cmake build.')


def remove_links():
    """remove links of CMakeLists in each project folders"""
    for cur, _, files in os.walk(parent_dir):
        if 'CMakeLists.txt' in files:
            os.unlink(os.path.join(cur, 'CMakeLists.txt'))


def create_links():
    """create symlinks of CMakeLists in each project folders"""
    for cur, _, files in os.walk(listpath):
        if 'CMakeLists.txt' in files:
            target = os.path.join(parent_dir, os.path.relpath(cur, start=listpath))
            target_file = os.path.join(target, 'CMakeLists.txt')
            if os.path.exists(target_file):
                os.unlink(target_file)
            os.link(os.path.abspath(os.path.join(cur, 'CMakeLists.txt')), target_file)


def main(arg=None):
    parser = argparse.ArgumentParser(prog='package.py', description='cmake for gdal packager',
                                     formatter_class=argparse.RawTextHelpFormatter, add_help=True)
    parser.add_argument("-t", "--test", action='store_true', help="Check cmakefile integrity.")
    parser.add_argument("-r", "--remove", action='store_true', help="Remove all linked CMakeLists.txt")
    args = parser.parse_args(arg)

    if args.test:
        check_folders()
    elif args.remove:
        remove_links()
    else:
        create_links()
    return 0


if __name__ == "__main__":
    main()
