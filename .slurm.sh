function rslurm ()
{
local myName="$@"
sbatch -e $myName.err.log \
       -o $myName.out.log \
       <<EOF
#!/bin/bash
#SBATCH -J $myName
module load R
Rscript $@
EOF
}
