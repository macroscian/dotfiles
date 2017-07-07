# function rslurm ()
# {
# local myName="$@"
# sbatch -e $myName.err.log \
#        -o $myName.out.log \
#        <<EOF
# #!/bin/bash
# #SBATCH -J $(basename $PWD)/$myName
# module load R/3.3.1-foss-2016b-bioc-3.3-libX11-1.6.3
# srun Rscript $@
# EOF
# }

function prepend ()
{
    awk 'BEGIN {print "#!/bin/bash\n'$@'"} {print "srun " $0}'
}


function myq ()
{
squeue -u kellyg -o  "%.28j %.6i %.9P %.2t %.10M %.6D %R"
}

function rslurm ()
{
local myName="$@"
runR="Rscript"
numberR=`ls R-*-local | wc -l`
if [ $numberR -eq 1 ]; then
   source R-*-local
else
   echo "Too many R versions" 1>&2
   return 1
fi
sbatch -e $myName.err.log \
       -o $myName.out.log \
       <<EOF
#!/bin/bash
#SBATCH -J $(basename $PWD)/$myName
srun Rscript $@
EOF
}
