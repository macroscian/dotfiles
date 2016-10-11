module load python/2.7.3
# .bashrcs
# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

export MY_WORKING=~/projects
export MY_HTML=~/public_html/LIVE/results
export MY_SCRATCH=/farm/scratch/rs-bio-lif/kelly02/projects
export MY_WEBSPACE=https://bioinformatics.crick.ac.uk/~kelly02/results
export MY_R_PACKAGE=~/myR/crick.kellyg
export PATH=$PATH:/usr/share/tcl8.4:$HOME/.local/bin

export EDITOR="~/bin/bin/emacs -nw"
source $HOME/.secrets #sets slackMessageID and slackName
source $HOME/.slurm.sh #sets slackMessageID and slackName

# Completions
complete -f -X '!*.sh' qsub
complete -f -X '!*.pl' perl
complete -f -X '!*.[r|R]' er

# User specific aliases and function
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias fastqc='java1.6 -classpath /farm/babs/software/FastQC uk.ac.bbsrc.babraham.FastQC.FastQCApplication &'
alias l='ls -lrt'
alias rout='tail *.Rout'
alias r='R --no-save --no-restore'
alias fastqc='java1.6 -classpath /farm/babs/software/FastQC uk.ac.bbsrc.babraham.FastQC.FastQCApplication '
alias screen='screen -U'
alias prompt='unset PROMPT_COMMAND; stty igncr -echo'
alias myq='showq | grep kelly02'
alias myqn='showq -n | grep kelly02'
alias rm="rm -i"
alias lproj="find ~/projects -maxdepth 2 -mindepth 1 -type d -not -path '*/\.*' -printf '%P\n'"
export PS1="[\h \W]\$ "

function em ()
{
    ~/bin/bin/emacs $@ &
    }

function slackJSON ()
{
    echo -n "{\"text\":\"$1\""
    if [[ "$#" -ne 1 ]]
    then
    	echo -n "$text,\
\"attachments\": [{\
\"fallback\":\"$1\",\
\"color\":\"$2\",\
\"author_name\":\"$3\",\
\"title\":\"$4\",\
\"text\":\"$5\""
	if [[ "$#" -ne 5 ]]
	then
	    echo -n "$text,\
\"fields\":[{\
\"title\":\"Status\",\
\"value\":\"$6\",\
\"short\":true}]"
	fi
	echo -n "}]"
    fi
    echo -n "}"       
}

function slackCommand ()
{
    local sMessage=$(slackJSON "$@")
    if [ -t 1 ]
    then
	curl -X POST -H 'Content-type: application/json' \
	     --data "$sMessage" \
	     "https://hooks.slack.com/services/$slackMessageID"
    else
	echo -n "curl -X POST -H 'Content-type: application/json'"
	echo -n " --data '$sMessage'"
	echo -n " https://hooks.slack.com/services/$slackMessageID"
    fi
}


function rsub ()
{
local myName="$@"
local myOut=$PWD"/$@.log"
echo "/farm/babs/redhat6/bin/Rscript $@" | msub -d $PWD -N "$myName" -j oe -o "$myOut"
# $PWD"/.$@msub-log-myName"
}


function cdscratch ()
{
    local newDir=${PWD/#$MY_WORKING/$MY_SCRATCH}
    cd ${newDir/#$MY_HTML/$MY_SCRATCH}
}

function cdworking ()
{
    local newDir=${PWD/#$MY_SCRATCH/$MY_WORKING}
    cd ${newDir/#$MY_HTML/$MY_WORKING}
}
function cdhtml ()
{
    local newDir=${PWD/#$MY_WORKING/$MY_HTML}
    cd ${newDir/#$MY_SCRATCH/$MY_HTML}
}



    
