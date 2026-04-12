# HPL_CPU

## Environment Setting

```
mkdir ./opt ./opt/openblas-0.3.32 ./opt/hpl-2.3
cd ./src
tar -xzf OpenBLAS-0.3.32.tar.gz
tar -xzf hpl-2.3.tar.gz
```

```
sbatch build_hpcx.slurm
sbatch build_openblas.slurm
sbatch build_hpl.slurm
```

需要改 src/hpcx/rebuild.sh 的 MPI 的路徑


