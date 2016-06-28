Benchmarking of antsRegistration
--------------------------------

This is a quick and dirty benchmark of antsRegistration for memory and walltime usage
by registering two high-resolution T1 brain images with varying levels of resampling.

All benchmarking was done in 8-CPU limited SGE parallel environment runs with 32 GB
of ram made available to each job.

To run the benchmark:
```
#First you need two high resolution brains, named brain1_0.3.mnc and brain2_0.3.mnc
#Some are available here http://cobralab.ca/atlases/
#First script with create all the resampled brains, then use qbatch to submit jobs
> ./do_benchmark.sh
#Wait for all registration jobs to finish
> ./collect_stats.sh > stats.csv
> Rscript benchmarking.R
```

# Requirements

This benchmark requires minc-toolkit, ANTs (with MINC support) and R with the
following R packages: ggplot2,doBy,rgl,scatterplot3d,minpack.lm,akima

# Outputs

Figures showing the memory and time usage as a funtion of fixed and moving resolution.

Non-linear fits of memory and walltime for use in registration prediction for clusters.

# Results

You can find results in [Rplots.pdf](Rplots.pdf)
