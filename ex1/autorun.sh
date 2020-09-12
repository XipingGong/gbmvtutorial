#!/bin/bash

CHARMM='/home/ping/share/charmm_latest/build/c45by/charmm'

# 1. **CPU**

echo "running CPU-GBMV (it takes a few mins)"
echo "$CHARMM pdbid=3gb1 gb=gbmv gamma=0.005 openmm=0 -i gbmv2.inp > cpuGbmv2.out"
      $CHARMM pdbid=3gb1 gb=gbmv gamma=0.005 openmm=0 -i gbmv2.inp > cpuGbmv2.out

# 2. **GPU(CUDA)**

echo "running CUDA-GBMV"
echo "$CHARMM pdbid=3gb1 gb=gbmv gamma=0.005 openmm=1 -i gbmv2.inp > gpuGbmv2.out"
      $CHARMM pdbid=3gb1 gb=gbmv gamma=0.005 openmm=1 -i gbmv2.inp > gpuGbmv2.out

## Analysis of output files

# 1. Initial energies (CPU vs. GPU)

echo "1. Initial energies (CPU vs. GPU)"
echo "CPU-GBMV"
grep "ENER>" cpuGbmv2.out
echo "CUDA-GBMV"
grep "ENER>" gpuGbmv2.out

# 2. Initial forces (CPU vs. GPU)

echo "2. Initial forces (CPU vs. GPU)"
echo "CPU-GBMV"
grep " PRO0 " cpuGbmv2.out | awk '{printf "%f\n %f\n %f\n", $5,$6,$7}' | head -6
echo "CUDA-GBMV"
grep " PRO0 " gpuGbmv2.out | awk '{printf "%f\n %f\n %f\n", $5,$6,$7}' | head -6

# 3. Energy conservation (CPU vs. GPU)

echo "3. Energy conservation (CPU vs. GPU)"
echo "CPU-GBMV"
grep "DYNA>" cpuGbmv2.out
echo "CUDA-GBMV"
grep "DYNA>" gpuGbmv2.out


