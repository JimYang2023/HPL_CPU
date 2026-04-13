#!/bin/bash
#SBATCH --account=ACD115053
#SBATCH --partition=nycugpu_queue
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --gres=gpu:2
#SBATCH --time=0-00:30:00

echo "Starting job on $(date)"

# Centralized variable management
PROJECT_ID="ACD115053"
CAPTAIN_UN="rayhuang111"
PROJECT_ROOT="/work/${CAPTAIN_UN}/${PROJECT_ID}/HPL_CPU"

SRC="${PROJECT_ROOT}/src"

HPCX_ROOT="${SRC}/hpcx"
HPCX_FILE="./hpcx.tbz"
DOWNLOAD="https://content.mellanox.com/hpc/hpc-x/v2.26_cuda12/hpcx-v2.26-gcc-doca_ofed-redhat8-cuda12-x86_64.tbz"
VERSION="hpcx-v2.26-gcc-doca_ofed-redhat8-cuda12-x86_64"

echo "=== tar HPC-X start ==="

cd $SRC
wget -O $HPCX_FILE $DOWNLOAD
tar -xvf hpcx.tbz
mv $VERSION hpcx
rm -f $SRC/hpcx.tbz

echo "=== tar HPC-X end ==="

echo "=== rebuild openmpi ==="

rm -rf $HPCX_ROOT/hpcx-rebuild

cd $SRC/hpcx
export HPCX_ENABLE_OMPI5=1
$HPCX_ROOT/utils/hpcx_rebuild.sh --with-hcoll

echo "=== rebuild openmpi ==="
echo "Job finished on $(date)"
