CMake for GDAL
==============

Cmake script set for GDAL developer, who can use modern IDEs such as CLion, VS, VSCode and XCode.


How to use
----------

1. Clone and place cmake scripts using deploy.py. It create symlinks from cmake4gdal/cmakelists/* to
   target directories.

.. block-code::

  $ git clone https://github.com/osgeo/gdal.git
  $ cd gdal
  $ git clone https://github.com/miurahr/cmake4gdal
  $ python cmake4gdal/deploy.py

2. Check integrity of cmake scripts

.. block-code::

  $ cd gdal
  $ python cmake4gdal/deploy.py -t
    There is no missing new driver for cmake build.

If there are any new driver directory cmake4gdal unknown, it is a chance to update!


3. Open GDAL project with your favorite IDE.


License
-------

CMake4GDAL project is redictributed on X/MIT license, except for some modules
which is on 3-Clause BSD license.
