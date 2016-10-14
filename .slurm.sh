function rslurm ()
{
local myName="$@"
sbatch -e $myName.err.log \
       -o $myName.out.log \
       <<EOF
#!/bin/bash
#SBATCH -J $myName
module load R
srun Rscript $@
EOF
}

function prepend ()
{
    awk 'BEGIN {print "#!/bin/bash\n'$@'"} {print "srun " $0}'
}


