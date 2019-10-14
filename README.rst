CMake for GDAL
==============

.. |macos| image:: https://dev.azure.com/miurahr/github/_apis/build/status/miurahr.cmake4gdal?branchName=master&jobName=macOS
   :target: https://dev.azure.com/miurahr/github/_build/latest?definitionId=15&branchName=master
.. |ubuntu1804| image:: https://dev.azure.com/miurahr/github/_apis/build/status/miurahr.cmake4gdal?branchName=master&jobName=Ubuntu_1804
   :target: https://dev.azure.com/miurahr/github/_build/latest?definitionId=15&branchName=master
.. |ubuntu1604gcc| image:: https://dev.azure.com/miurahr/github/_apis/build/status/miurahr.cmake4gdal?branchName=master&jobName=Ubuntu_1604_gcc
   :target: https://dev.azure.com/miurahr/github/_build/latest?definitionId=15&branchName=master
.. |ubuntu1604clang| image:: https://dev.azure.com/miurahr/github/_apis/build/status/miurahr.cmake4gdal?branchName=master&jobName=Ubuntu_1604_clang
   :target: https://dev.azure.com/miurahr/github/_build/latest?definitionId=15&branchName=master
.. |mingw| image:: https://dev.azure.com/miurahr/github/_apis/build/status/miurahr.cmake4gdal?branchName=master&jobName=MinGW
   :target: https://dev.azure.com/miurahr/github/_build/latest?definitionId=15&branchName=master
.. |windows32| image:: https://dev.azure.com/miurahr/github/_apis/build/status/miurahr.cmake4gdal?branchName=master&jobName=Windows32
   :target: https://dev.azure.com/miurahr/github/_build/latest?definitionId=15&branchName=master
.. |windows64| image:: https://dev.azure.com/miurahr/github/_apis/build/status/miurahr.cmake4gdal?branchName=master&jobName=Windows64
   :target: https://dev.azure.com/miurahr/github/_build/latest?definitionId=15&branchName=master


+--------+------------------------+
| Jobs   | Mac                    |
|        | Ubuntu 18.04           |
|        | Ubuntu 16.04 (GCC)     |
|        | Ubuntu 16.04 (CLang)   |
|        | Windows 32bit          |
|        | Windows 64bit          |
+--------+------------------------+
| Status | |macos|                |
|        | |ubuntu1804|           |
|        | |ubuntu1604gcc|        |
|        | |ubuntu1604clang|      |
|        | |windows32|            |
|        | |windows64|            |
+--------+------------------------+

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
