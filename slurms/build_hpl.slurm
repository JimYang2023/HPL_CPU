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
CAPTAIN_UN="jimyang1112"
PROJECT_ROOT="/work/${CAPTAIN_UN}/${PROJECT_ID}"
SRC_DIR="${PROJECT_ROOT}/src"
OPT_DIR="${PROJECT_ROOT}/opt"
HPCX_HOME="${SRC_DIR}/hpcx"

export HPCX_ENABLE_OMPI5=1
source $HPCX_HOME/hpcx-rebuild.sh
hpcx_load
export LD_LIBRARY_PATH=$OPT_DIR/openblas-0.3.32/lib:$LD_LIBRARY_PATH

echo "=== check environment ==="

which mpicc
which mpirun

echo "=== Starting HPL compilation ==="

mv $SRC/slurms/Make.linux $SRC/hpl-2.3/Make.linux

cd $SRC/hpl-2.3

if [ -d bin/linux ]; then
    make -j8 arch=linux clean
fi

make arch=linux startup
make -j8 arch=linux

echo "=== HPL compilation complete ==="

# 檢查編譯是否成功生成 xhpl
if [ -f bin/linux/xhpl ]; then
    echo "=== HPL compilation SUCCESS ==="
    mv $PROJECT_ROOT/src/hpl-2.3/bin/linux/xhpl $PROJECT_ROOT/opt/hpl-2.3/xhpl
else
    echo "=== HPL compilation FAILED ==="
    exit 1
fi

hpcx_unload

echo "Job finished on $(date)"
