CMake for GDAL
==============

.. |macos| image:: https://dev.azure.com/miurahr/github/_apis/build/status/miurahr.cmake4gdal?branchName=master&jobName=macOS
   :target: https://dev.azure.com/miurahr/github/_build/latest?definitionId=15&branchName=master
.. |ubuntu1804gcc| image:: https://dev.azure.com/miurahr/github/_apis/build/status/miurahr.cmake4gdal?branchName=master&jobName=Ubuntu_1804_gcc
   :target: https://dev.azure.com/miurahr/github/_build/latest?definitionId=15&branchName=master
.. |ubuntu1804clang| image:: https://dev.azure.com/miurahr/github/_apis/build/status/miurahr.cmake4gdal?branchName=master&jobName=Ubuntu_1804_clang
   :target: https://dev.azure.com/miurahr/github/_build/latest?definitionId=15&branchName=master
.. |windows64| image:: https://dev.azure.com/miurahr/github/_apis/build/status/miurahr.cmake4gdal?branchName=master&jobName=Windows
   :target: https://dev.azure.com/miurahr/github/_build/latest?definitionId=15&branchName=master


================== ======================
Jobs               Azure CI build Status
------------------ ----------------------
Mac                |macos|
Ubuntu18.04(gcc)   |ubuntu1804gcc|
Ubuntu18.04(clang) |ubuntu1804clang|
Windows            |windows64|
================== ======================

Cmake script set for GDAL developer, who can use modern IDEs such as CLion, VS, VSCode and XCode.


How to use
----------

1. Clone and place cmake scripts using deploy.py. It create symlinks from cmake4gdal/cmakelists/* to
   target directories.

.. code-block:: console

  git clone https://github.com/osgeo/gdal.git
  cd gdal
  git clone https://github.com/miurahr/cmake4gdal
  python cmake4gdal/deploy.py

2. Check integrity of cmake scripts

.. code-block:: console

  cd gdal
  python cmake4gdal/deploy.py -t
  
    There is no missing new driver for cmake build.

If there are any new driver directory cmake4gdal unknown, it is a chance to update!


3. Open GDAL project with your favorite IDE.


Docker image and development environment
----------------------------------------

A project prepares docker image for CI and development.
A base image recipe is in ci/dockerhub/Dockerfile
You can use an image as `miurahr/ubuntu-gdal-dev:latest`

You can also use docker image as a your development environment.


License
-------

CMake4GDAL project is distributed under X/MIT license, except for some modules
which is on 3-Clause BSD license.
