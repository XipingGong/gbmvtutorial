============================================

Author: Xiping Gong, PhD student, UMass Amherst

Email:  xipinggong@umass.edu

Date:   12/13/2019 (Xiping; first version)
Date:   09/12/2020 (Xiping)

============================================

# Example 1: CPU/CUDA Energies, forces and molecular dynamics


## Executable CHARMM (included GBMV2)

Before running the following the examples, please install the
CHARMM with GPU-GBMV2 plugin (version > c45). Also, please run a
test file included to make sure your installation is correct.


## Running CHARMM input file

CHARMM='the path of an executable CHARMM program'

E.g., CHARMM='/home/ping/share/charmm_latest/build/c45by/charmm'

0. An autorun.sh bash shell script provided for the following commands

1. **CPU**

$CHARMM pdbid=3gb1 gb=gbmv gamma=0.005 openmm=0 -i gbmv2.inp | tee cpuGbmv2.out

2. **GPU(CUDA)**

$CHARMM pdbid=3gb1 gb=gbmv gamma=0.005 openmm=1 -i gbmv2.inp | tee gpuGbmv2.out

## Analysis of output files

1. Initial energies (CPU vs. GPU)

$ grep "ENER>" cpuGbmv2.out

$ grep "ENER>" gpuGbmv2.out

""
Please see the difference
""

2. Initial forces (CPU vs. GPU)

$ grep " PRO0 " cpuGbmv2.out | awk '{printf "%f\n %f\n %f\n", $5,$6,$7}' | head -6

$ grep " PRO0 " gpuGbmv2.out | awk '{printf "%f\n %f\n %f\n", $5,$6,$7}' | head -6

""
Please look at the min and max (CPU-GPU).
In theory, the max value should be closer to zero, but some errors happened.
You can find out the answer if you run the vacuum calculations with GBMV2/SA term.
The similar errors can be found in the vacuum calculations.
""

3. Energy conservation (CPU vs. GPU)

$ grep "DYNA>" cpuGbmv2.out
$ grep "DYNA>" gpuGbmv2.out

""
This is 1ps NVE simulations, please increase the nstep to 300 ps to see any difference between cpu and gpu.
Also, one additional case can be explored.
Set the timestep = 2fs, do the same simulations and look at the difference
""

## Questions

1. How to run the CPU/GPU-GBMV2 simulations, and the meaning of SASA term?

Tips> GBMV2 means the SASA term will not considered, meaning the SASA term should be turn off or set to zero
Please change the keyword SA. Do you know which energy term the SA represents?

2. How to run the CPU/GPU-GBMV2 simulations with ion effects?

Tips> please look at the meaning of KAPPA keyword and play with it,
does it have the same meaning as that of [GBSW model][GBSW website]?

3. What are meanings of these parameters (BETA, P3, WATR, SHIFT, SLOPE, P6, WTYP, NPHI, etc.)?

Tips> please look at [the reference for their meanings][GBMV2/SA website].

4. What are the input radii and why do we need to optimize them?

Tips> please look at [the reference for the details][GBMV2/SA optimizing paper].

5. What is the difference between running CPU- and GPU- simulations.

Tips> at present, GBMV2/SA only has CUDA implementation.
Please look at the input file given and descriptions of OpenMM in CHARMM website.

6. Try more examples and then look at the similar conclusions can be observed?

Tips> Four PDB files can be found in the current directory.
Also, please record the simulations time and compare cpu and gpu performance.

7. How to comfirm that the CUDA-GBMV was used correctly?

Tips> 1, CUDA-GBMV should be much faster than CPU-GBMV calculations;
2, the keyword "CHARMM> Only OpenMM CUDA platform available for GBMV method" can be searched
in your output, which means CUDA-GBMV was called.
3, compare the CPU- and CUDA-GBMV energy, make sure that there is no big difference between them.

8. Extra points for CUDA-GBMV calculations

* using the attached radii_c36gbmvop.str as a default radius input, which is optimized.
* GPU-GBMV does not work for energy minimization, you can minimize the structures using CPU-GBMV.
* It is a good choice to check the GPU and CPU energy before running the dynamics.

## Common questions

1. I cannot find out the keyword "CHARMM> Only OpenMM CUDA platform available for GBMV method" in the output.

One potential point is that you set up the "OMM" command before "GBMV" command.
Because when running the "OMM" command, the OpenMM will read some GBMV parameters, if the "GBMV" was not called before, the OpenMM
will not run the CUDA-GBMV calculations. Please see the input provided in this example

2. How to set up CUDA-GBMV calculations?

I highly suggest you use the following GBMV setting, "OMM" command must be after "GBMV" command.

--------------------------------------------------------------------------

    ! setup the input radii for GBMV calculations.

    set wmain radii

    stream radii_c36gbmvop.str

    ! set up CUDA-GBMV parameters

    GBMV BETA -12  P3 0.65 WATR 1.4  SHIFT -0.102 SLOPE 0.9085  P6 8 SA 0.005 -

         WTYP 2 NPHI 26 CUTNUM 50 KAPPA 0.0 weight

    ! OpenMM omm setting

    omm platform CUDA precision single deviceid 0

    omm on

--------------------------------------------------------------------------

## Reference

[GBSW website]: https://www.charmm.org/charmm/documentation/by-version/c40b1/params/doc/gbsw/

[GBMV2/SA website]: https://www.charmm.org/charmm/documentation/by-version/c40b1/params/doc/gbmv/

[GBMV2/SA optimizing paper]: https://onlinelibrary.wiley.com/doi/full/10.1002/jcc.24734

[GPU-GBMV2/SA paper]: https://onlinelibrary.wiley.com/doi/full/10.1002/jcc.26133

## Acknowledgement

We thanked the Zhuang Liu and Qiang Cui (QC) who gave us feedback on the CUDA-GBMV calculations.

