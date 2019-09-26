# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi
source $HOME/.secrets #Things I don't need on github
# provides my_lab, SLACK_URL
shopt -s direxpand

#source ${my_lab}working/software/modulepath_new_software_tree_2018-08-13
module purge
module unuse /camp/stp/babs/working/software/modules/all /camp/stp/babs/working/software/eb/modules/all
module use /camp/apps/eb/dev/modules/all /camp/apps/eb/intel-2017a/modules/all /camp/apps/eb/modules/all /camp/apps/misc/stp/babs/manual/modules/all /camp/apps/misc/stp/babs/easybuild/modules/all


export my_working=${my_lab}working/$USER/
w=${my_working}
l=${my_lab}
export PYTHONPATH=$PYTHONPATH:${my_lab}working/patelh/code/PYTHON/
export NXF_HOME=${my_working}code/nextflow
export JULIA_PKGDIR=${my_working}code/julia/library
export JULIA_DEPOT_PATH=${my_working}code/julia/library
export BIN=${my_working}code/bin
export PATH=$BIN/tex/bin/x86_64-linux:$BIN:$PATH:$HOME/bin:.
export my_emailname="gavin.kelly"
export my_webspace=https://shiny-bioinformatics.crick.ac.uk/~$USER/
export my_r_package=${my_working}code/R/crick.kellyg
export MY_R_PACKAGE=${my_working}code/R/crick.kellyg # I used to name this capitalised
export my_projects=${my_working}projects/
p=${my_projects}
export TERM=gnome

export DICPATH=/camp/stp/babs/working/docs/spell
export ALTERNATE_EDITOR=""
export EDITOR="/camp/stp/babs/working/kellyg/code/bin/emacsclient  -nw"                  # $EDITOR opens in terminal
export VISUAL="/camp/stp/babs/working/kellyg/code/bin/emacsclient -c "                      # $VISUAL opens in GUI mode
(
    if [[ $(ps -ef | grep $USER".*emacs --daemon" | wc -l) == 1 ]]
    then 
	module -q load hunspell
	module -q load Emacs/25.1-foss-2016b
	module -q load git/2.14.2-foss-2016b
#	module -q load XZ/.5.2.2-GCC-5.4.0-2.26
#	module -q load Pango/1.40.3-foss-2016b
	/camp/stp/babs/working/kellyg/code/bin/emacs --daemon
    fi
)
    
function ed ()
{
#if [[ $HOSTNAME == babs* ]] 
#then
if [[ $(ps -ef | grep $USER".*emacs --daemon" | wc -l) == 1 ]]
then 
    module -q load hunspell
    module -q load Emacs/25.1-foss-2016b
    module -q load git/2.14.2-foss-2016b
    #   module -q load XZ/.5.2.2-GCC-5.4.0-2.26
    #   module -q load Pango/1.40.3-foss-2016b
    /camp/stp/babs/working/kellyg/code/bin/emacs --daemon
fi
#    module -q load XZ/.5.2.2-GCC-5.4.0-2.26
/camp/stp/babs/working/kellyg/code/bin/emacsclient -c $@ &
# else
#     srun --ntasks=1 --x11 -D $PWD emacs $@ &
# fi
}


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
alias cdw="cd $my_working"
alias r='R --no-save --no-restore'
alias dirs='dirs -v | sed "s;$my_projects;;g"'
alias duh="du -d 1 -h | sort -h"


function tout ()
{
    tail $@*.out
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




if [[ "$PWD" == ~ ]] 
then
    cd $my_working
fi

function Rscript ()
{
    if test -f R-*-local; then
	source R-*-local
	command Rscript "$@"
    else
	module use /camp/apps/misc/stp/babs/manual/modules/all
	module load R
	command Rscript "@"
    fi
}

function R ()
{
    if test -f R-*-local; then
	source R-*-local
	command R "$@"
    else
	module use /camp/apps/misc/stp/babs/manual/modules/all
	module load R/3.6.0-foss-2016b-BABS
	command R "@"
    fi
}



function wd ()
{
    MY_PATH=$(readlink -f $1)
    NEW_PATH=${MY_PATH/\/camp\/stp/data.thecrick.org}
    echo \\\\${NEW_PATH//\//\\}
}
