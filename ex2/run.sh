#!/bin/bash
#SBATCH --job-name="trex-aaqaa3"       # job name # XXX
#SBATCH --time=30-00:00:00       # time
#SBATCH --nodes=2              # number of nodes # XXX
#SBATCH -p slow                # partition
#SBATCH -o job%j.log   # without -e, combine stdout/err
#SBATCH -e job%j.err


# programs
# --------
export CHARMMEXEC=/home/ping/programs/charmm_latest/build/c45by/charmm
export CHARMMDATA=/home/ping/programs/charmm_latest/toppar
AAREX=/home/ping/programs/mmtsb_latest/perl/aarex.pl

# run simulation
# -----------------
at=`date +%s`
pdbid=aaqaa3
workdir=/home/ping/work/$pdbid/trex/ex0         # XXX
cd $workdir/run                                  # -> $PWD
dyntstep=0.002   # 2 fs/step # XXX
dynstep=1000     # 2 ps/exchange # XXX
ncycle=50
psf=${pdbid}atctrl.psf      # psf file # XXX
natpdb=${pdbid}atctrl.pdb   # pdb file # XXX
$AAREX   -hosts hostlist \
         -charmmexec $CHARMMEXEC \
         -gpu 4 \
         -n $ncycle \
         -temp 8:269:363 \
         -custom setup setup.str \
         -dir trex \
         -mdpar dynsteps=$dynstep,dyntstep=$dyntstep \
         -mdpar lang=1,langfbeta=0.1,nogb,nocut \
         -mdpar param=tpstr \
         -mdpar tpstr=toppar.str \
         -par archive,psf=$psf \
         -par natpdb=$natpdb \
         -charmmlog charmm.log \
         -log rex.log \
         ${pdbid}atctrl.crd

# timing for one simulation
bt=`date +%s`
duration1=`echo "($bt-$at)/60"   | bc -l`
duration2=`echo "($bt-$at)/3600" | bc -l`
perf=`echo "$dyntstep*$dynstep*$ncycle/$duration2*24/1000" | bc -l`
echo "Run time is $duration1 minutes (i.e., $duration2 hours)"
echo "Performance is $perf ns/day"
