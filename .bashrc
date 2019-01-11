#module load python/2.7.3
# .bashrcs
# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi
source $HOME/.secrets #Things I don't need on github
# provides my_lab, slackMessageID, slackName
shopt -s direxpand
module use -a /camp/apps/eb/dev/modules/all
module use -a /camp/apps/eb/intel-2017a/modules/all
module use -a ${my_lab}working/kellyg/code/eb/modules/all
module use -a ${my_lab}working/software/modules/all
module use -a ${my_lab}working/software/eb/modules/all

export my_working=${my_lab}working/$USER/
w=${my_working}
l=${my_lab}
export PYTHONPATH=$PYTHONPATH:${my_lab}working/patelh/code/PYTHON/
export NXF_HOME=${my_working}code/nextflow
export JULIA_PKGDIR=${my_working}code/julia/library
export PATH=/camp/stp/babs/working/kellyg/code/bin/tex/bin/x86_64-linux:/camp/stp/babs/working/kellyg/code/bin:$PATH # So local R can be found in directories
export my_emailname="gavin.kelly"
export my_webspace=https://shiny-bioinformatics.crick.ac.uk/~$USER/
export my_r_package=${my_working}code/R/crick.kellyg
export MY_R_PACKAGE=${my_working}code/R/crick.kellyg # I used to name this capitalised
export my_projects=${my_working}projects/
p=${my_projects}
export TERM=gnome

export ALTERNATE_EDITOR=""
export EDITOR="emacs -nw"                  # $EDITOR opens in terminal
export VISUAL="emacs"                      # $VISUAL opens in GUI mode
function em ()
{
if [[ $HOSTNAME == lifcpu* ]] ||[[ $HOSTNAME == ca170* ]] ||[[ $HOSTNAME == ca193* ]] 
then
    module load Emacs
    module load git
    emacs $@ &
else
    srun --ntasks=1 --x11 -D $PWD emacs $@ &
fi
}

source $HOME/.bash.slurm #load slurm aliases

# Completions
complete -f -X '!*.[r|R]' er
_cycle_dirs()
{
    local cur=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=($PWD)
}

#complete - F _cycledir cd


# User specific aliases and function
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias l='ls -Hlrt'
alias lr='ls -Hlrt *.@(r|R|rmd|Rmd)'
alias lscr='ls -Hlrt *.@(r|R|rmd|Rmd|sh|nf|py)'
alias lnscr='ls -Hlrtd  !(*.r|*.R|*.Rmd|*.sh|*.nf|*.py) | egrep -v ^d'
alias ll='ls -lrt -I VERSION -I CHANGES -I SESSION_INFO -I README'
alias screen='screen -U'
alias prompt='unset PROMPT_COMMAND; stty igncr -echo'
alias rm="rm -i"
export PS1="[\h \W]\$ "
alias xt="srun --ntasks=1 --x11  xterm &"
alias cdw="cd $my_working"
alias r='R --no-save --no-restore'
alias rx="module load R/3.3.1-foss-2016b-libX11-1.6.3; R"
alias rbc="module load R/3.3.1-foss-2016b-bioc-3.3-libX11-1.6.3; R"
alias template="cp -n /camp/stp/babs/working/kellyg/code/R/template/* ."
alias dirs='dirs -v | sed "s;$my_projects;;g"'
alias duh="du -d 1 -h | sort -h"


function rout ()
{
    tail $@*.{err,out}.log
}

alias queue='ml R; Rscript -e "library(tidyr);library(dplyr); read.table(pipe(\"squeue -o \\\"%.7i %.9P %.8j %.8u %.2t %.10M %.6D %C\\\"\"), sep=\"\", header=TRUE) %>% group_by(USER, ST) %>% summarise(n=n(), cpu=sum(CPUS)) %>% arrange(desc(ST), desc(cpu)) %>% as.data.frame()"'

################################################################
#### Interact with project directories
################################################################
#Find all project directories that confirm to standard format, filtering by possible argument to function
function lpro ()
{
    if [ "$#" -eq 1 ]; then
find $my_projects -maxdepth 3 -mindepth 3 -type d -not -path '*/\.*'  | cut -f2 -d$'\t' |  grep ${1:-.}
else
    find $my_projects -maxdepth 3 -mindepth 3 -type d -not -path '*/\.*' -printf '%T+\t%P\n' | sort | cut -f2 -d$'\t' | column -t -s '/.' | grep ${1:-.}
    fi
}

#cd to project directory that matches the first argument
function cdpro ()
{
cd $my_projects$(find $my_projects -maxdepth 3 -mindepth 1 -type d -not -path  '*/\.*' -iname \*$1\* -printf '%P\n' | tail -1)
}

function pushdpro ()
{
pushd $my_projects$(find $my_projects -maxdepth 3 -mindepth 1 -type d -not -path  '*/\.*' -iname \*$1\* -printf '%P\n' | tail -1)
}

#Make function directory
function startpro()
{
mkdir -p $1
cp -r ${my_working}code/R/template/* $1
git init --template=${my_working}code/R/template/.git_template $1
}




source $HOME/.bash.slack #load slack functions

if [[ "$PWD" == ~ ]] 
then
    cd $my_working
fi

function Rscript ()
{
source R-*-local
command Rscript "$@"
}
function R ()
{
source R-*-local
command R $@
}


function knit ()
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
rnwinput=$1
fileName=${rnwinput%.*}
echo "library(knitr); knit(input='$rnwinput');" | R --no-save --no-restore
pandoc -o ${fileName}.pdf ${fileName}.md
}

function wd ()
{
    MY_PATH=$(readlink -f $1)
    NEW_PATH=${MY_PATH/\/camp\/stp/data.thecrick.org}
    echo \\\\${NEW_PATH//\//\\}
}
