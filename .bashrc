#module load python/2.7.3
# .bashrcs
# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi
source $HOME/.secrets #Things I don't need on github
# provides my_lab, slackMessageID, slackName
shopt -s direxpand

MODULEPATH="${my_lab}working/software/eb/modules/all:${my_lab}working/software/modules/all:${MODULEPATH}";
export MODULEPATH;

export my_working=${my_lab}working/$USER/
export my_html=${my_lab}www/$USER/public_html/LIVE/
export my_emailname="gavin.kelly"
export my_scratch=${my_lab}scratch/$USER/
export my_webspace=https://shiny-bioinformatics.crick.ac.uk/~$USER/
export my_r_package=${my_working}code/R/crick.kellyg
export MY_R_PACKAGE=${my_working}code/R/crick.kellyg # I used to name this capitalised
export my_projects=${my_working}projects/
#export EDITOR="~/bin/bin/emacs -nw"
source $HOME/.bash.slurm #load slurm aliases

# Completions
complete -f -X '!*.[r|R]' er

# User specific aliases and function
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias l='ls -lrt'
alias rout='tail *.Rout'
alias screen='screen -U'
alias prompt='unset PROMPT_COMMAND; stty igncr -echo'
alias rm="rm -i"
export PS1="[\h \W]\$ "
alias xt="srun --ntasks=1 --x11  xterm"
alias cdw="cd $my_working"
alias r='R --no-save --no-restore'
alias rx="module load R/3.3.1-foss-2016b-libX11-1.6.3; R"
alias rbc="module load R/3.3.1-foss-2016b-bioc-3.3-libX11-1.6.3; R"
function em ()
{
    srun --ntasks=1 --x11 -D $PWD emacs $@ &
    }


################################################################
#### Interact with project directories
################################################################
#Find all project directories that confirm to standard format, filtering by possible argument to function
function lpro ()
{
find $my_projects -maxdepth 3 -mindepth 3 -type d -not -path '*/\.*' -printf '%P\n' | column -t -s '/.' | grep ${1:-.}
}

#cd to project directory that matches the first argument
function cdpro ()
{
cd $my_projects$(find $my_projects -maxdepth 3 -mindepth 1 -type d -not -path  '*/\.*' -iname \*$1\* -printf '%P\n' | tail -1)
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
