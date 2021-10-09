### Middlware '21 benchmarks: A Fresh Look at the Architecture and Performance of Contemporary Isolation Platforms
This repository contains the scripts used for our Middleware '21 paper: "A Fresh Look at the Architecture and Performance of Contemporary Isolation Platforms".

### Running the benchmarks
This repository contains Bash scripts for the all the benchmarks as presented in our Middleware '21 paper. There is one folder per benchmark, and each of these folders contain a `run-benchmark.sh` Bash script. Invoking this script with `./run-benchmark.sh` will recurse into each of the subfolders and run its `run.sh` script containing the actual code to execute the benchmark for that platform.

The benchmarks have been conducted on a Ubuntu 20.04 installation. 
**Note**: the scripts assume that all of these isolation platforms are installed (e.g. Docker, Kata-runtime, OSv, etc.). For installation instructions and their dependencies we would like to refer to the corresponding installation instructions for that isolation platform.

Cloning this repository with the `--recurse-submodules` is recommended as this also pulls in the OSv, YCSB and Firecracker benchmarking repositories.
