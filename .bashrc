#module load python/2.7.3
# .bashrcs
# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi
source $HOME/.secrets #Things I don't need on github
# provides my_lab, slackMessageID, slackName


export my_working=${my_lab}working/$USER/
export my_html=${my_lab}www/$USER/public_html/LIVE/
export my_scratch=${my_lab}scratch/$USER/
export my_webspace=https://shiny-bioinformatics.crick.ac.uk/~$USER/
export my_r_package=${my_working}code/R/crick.kellyg
export MY_R_PACKAGE=${my_working}code/R/crick.kellyg # I used to name this capitalised
export my_projects=${my_working}projects/
#export EDITOR="~/bin/bin/emacs -nw"
source $HOME/.slurm.sh #load slurm aliases

# Completions7
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

alias r='R --no-save --no-restore'
alias rx="module load R/3.3.1-foss-2016b-libX11-1.6.3; R"
alias rbc="module load R/3.3.1-foss-2016b-bioc-3.3-libX11-1.6.3; R"

#Find all project directories that confirm to standard format, filtering by possible argument to function
function lpro ()
{
find $my_projects -maxdepth 3 -mindepth 3 -type d -not -path '*/\.*' -printf '%P\n' | column -t -s '/.' | grep ${1:-.}
}
#cd to project directory that matches the first argument
function cdpro ()
{
cd $my_projects$(find $my_projects -maxdepth 3 -mindepth 1 -type d -not -path  '*/\.*' -iname \*$1\* -printf '%P\n')
}
#Make function directory
function startpro()
{
cp -r ${my_working}code/R/template/* $1; git init $1
}


function em ()
{
    srun --ntasks=1 --x11 -D $PWD emacs $@ &
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


if [[ "$PWD" == ~ ]] 
then
    cd $my_working
fi
