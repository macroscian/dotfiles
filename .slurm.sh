function rslurm ()
{
local myName="$@"
sbatch -e $myName.err.log \
       -o $myName.out.log \
       <<EOF
#!/bin/bash
#SBATCH -J $myName
module load R/3.3.1-foss-2016b-bioc-3.3-libX11-1.6.3
srun Rscript $@
EOF
}

function prepend ()
{
    awk 'BEGIN {print "#!/bin/bash\n'$@'"} {print "srun " $0}'
}


