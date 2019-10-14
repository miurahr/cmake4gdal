#!/usr/bin/env python3

import os


if __name__ == "__main__":
    cur_dir = os.path.dirname(os.path.abspath(__file__))
    listpath = os.path.join(cur_dir, 'cmakelists')
    parent_dir = os.path.dirname(cur_dir)
    for cur, _, files in os.walk(listpath):
        if 'CMakeLists.txt' in files:
            target = os.path.join(parent_dir, os.path.relpath(cur, start=listpath))
            os.symlink(os.path.join(cur, 'CMakeLists.txt'), os.path.join(target, 'CMakeLists.txt'))
