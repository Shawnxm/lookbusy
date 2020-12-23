# lookbusy
lookbusy is a synthetic load generator for Linux systems, whose original author is Devin Carraway (<lookbusy@devin.com>). A new feature which allows specifying different loads for different cores was added by Chaoqun Yue (<chaoqun.yue@uconn.edu>).

This repository provides an additonal script for cross-compiling lookbusy for **Android** with Android NDK.

Before building, set TOOLCHAIN, TARGET, and the NDK path. If Android Studio is installed, usually it is located inside the SDK folder (`$Sdk/ndk-bundle`).
```
./build-android.sh
```
For basic installation (e.g., on Linux), please run
```
./configure
make
make install
```

Usage:
```shell
lookbusy -n [num of cores] -z [the load of each core, separator: comma] -r [cpu mode]
# example: data/tmp/lookbusy  -n 4 -z 20,20,80,80 -r fixed -q
```

## Description
This is lookbusy, a tool for making systems busy.  It uses relatively simple techniques to generate CPU activity, memory and disk utilization and traffic. lookbusy is not a benchmarking tool, or a realistic load simulator.  While it attempts to produce load factors which are exhibited by real applications, the exact operations used are not modelled on real applications, and at the low level, the exact hardware operations are not identical.

### Process Structure
One lookbusy process is forked for each load-generation task -- that is, one process per CPU, one for memory usage, and one for each file on disk being used, plus a toplevel parent process.  Errors in or termination of any process will trigger a shutdown in all others.  It's safe to use ^C from a terminal, or to kill processes remotely.

### CPU Usage Modes
Two CPU usage modes are provided.  The first, 'fixed', attempts to keep total CPU utilization at a particular level, using up any balance in idle time between the other processes on the host and the preferred level (if other processes are themselves able to exceed the chosen level, obviously, lookbusy can't fix that situation but will drop its own usage to near zero and wait for load to drop.)

The second mode, 'curve', produces utilization levels which vary over a chosen range, over a given interval.  The simplest (and the default) usage is to modulate usage smoothly over the course of a 24-hour period, peaking at local midnight and bottoming out at local noon.  Options are provided to adjust all these settings -- see lookbusy(1).

### CPU Concurrency
lookbusy has basic awareness of multiprocessor and multi-logical-CPU systems; it will attempt to keep cumulative system usage at the chosen level by forking multiple instances of itself, one per CPU.  CPUs with a nonzero physical-id, such as are found on hyperthreaded i386 CPUs, are ignored when counting.  The CPU utilization algorithm uses a tight arithmetic loop, which should be entirely register-based on most CPUs, incurring no memory traffic.

### Portability
As of 1.0, lookbusy claims support only for Linux systems.  Most of its implementation is entirely portable to other UNIX systems; memory and disk usage should work as-is.  CPU utilization will almost certainly need porting work, as concerns use of the /proc filesystem and handling of SMP.
