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
CAPTAIN_UN="<captains-username>"
PROJECT_ROOT="/work/${CAPTAIN_UN}/${PROJECT_ID}"
SRC_DIR="${PROJECT_ROOT}/src"
OPT_DIR="${PROJECT_ROOT}/opt"

echo "=== Starting OpenBLAS compilation ==="
# Configure(if needed), compile and insall commends
# ...

cd ${SRC}/OpenBLAS-0.3.32

make clean
make -j 8 BINARY=64
make install PREFIX=${OPT_DIR}/openblas-0.3.32

echo "=== OpenBLAS compilation complete ==="

echo "Job finished on $(date)"
