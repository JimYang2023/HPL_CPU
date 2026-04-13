#!/bin/bash
#SBATCH --account=ACD115035
#SBATCH --partition=nycugpu_queue
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=32
#SBATCH --gpus-per-node=8
#SBATCH --time=0-01:00:00

echo "Starting job on $(date)"

PROJECT_ID="ACD115053"
CAPTAIN_UN="rayhuang"
PROJECT_ROOT="/work/${CAPTAIN_UN}/${PROJECT_ID}/HPL_CPU"
export UCX_LOG_LEVEL=ERROR
export UCX_IB_GPU_DIRECT_RDMA=yes
export UCX_TLS=self,sm,rc,dc
export HPCX_ENABLE_OMPI5=1
source $PROJECT_ROOT/src/hpcx/hpcx-rebuild.sh
hpcx_load

OPT_DIR="${PROJECT_ROOT}/opt"

export LD_LIBRARY_PATH=$OPT_DIR/openblas-0.3.32/lib:$LD_LIBRARY_PATH

echo "=== Starting HPL Benchmark ==="

mpirun -np 64 \
       --map-by ppr:32:node \
       --bind-to core \
       -x LD_LIBRARY_PATH \
       -x UCX_NET_DEVICES=mlx5_0:1 \
       -x HCOLL_MAIN_IB=mlx5_0:1 \
       -mca coll_hcoll_enable 1 \
       -mca coll_hcoll_np 32 \
       $PROJECT_ROOT/opt/hpl-2.3/xhpl -dat ./HPL.dat

echo "=== Benchmark Finished ==="
echo "Job finished on $(date)"
