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
    ignore_list = ['o', 'null', 'hdf-eos', 'third_party', 'scripts']
    for cur, _, files in os.walk(gdalsrc_dir):
        if 'GNUmakefile' in files:
            if os.path.lexists(os.path.join(cur, 'CMakeLists.txt')):
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


def create_links(as_symlink=False):
    """create symlinks of CMakeLists in each project folders"""
    for cur, _, files in os.walk(listpath):
        if 'CMakeLists.txt' in files:
            target = os.path.join(parent_dir, os.path.relpath(cur, start=listpath))
            target_file = os.path.join(target, 'CMakeLists.txt')
            if os.path.exists(target_file):
                os.unlink(target_file)
            if as_symlink:
                os.symlink(os.path.abspath(os.path.join(cur, 'CMakeLists.txt')), target_file)
            else:
                os.link(os.path.abspath(os.path.join(cur, 'CMakeLists.txt')), target_file)


def main(arg=None):
    parser = argparse.ArgumentParser(prog='package.py', description='cmake for gdal packager',
                                     formatter_class=argparse.RawTextHelpFormatter, add_help=True)
    parser.add_argument("-t", "--test", action='store_true', help="Check CmakeLists.txt existence for gdal source trees.")
    parser.add_argument("-r", "--remove", action='store_true', help="Remove all linked CMakeLists.txt in the gdal project")
    parser.add_argument("-s", "--symlink", action='store_true', help="Create symbolic links instead of hard links(recommend)")
    args = parser.parse_args(arg)

    if args.test:
        check_folders()
    elif args.remove:
        remove_links()
    else:
        create_links(args.symlink)
    return 0


if __name__ == "__main__":
    main()
