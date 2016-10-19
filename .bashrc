#module load python/2.7.3
# .bashrcs
# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

export MY_LAB=/camp/stp/babs/
export MY_WORKING=${MY_LAB}working/$USER/
export MY_HTML=~/public_html/LIVE/results
export MY_SCRATCH=${MY_LAB}scratch/$USER/
export MY_WEBSPACE=${MY_LAB}ww/
export MY_R_PACKAGE=${MY_WORKING}code/R/
export MY_PROJECTS=${MY_WORKING}projects/

export EDITOR="~/bin/bin/emacs -nw"
source $HOME/.secrets #sets slackMessageID and slackName
source $HOME/.slurm.sh #sets slackMessageID and slackName

# Completions
complete -f -X '!*.sh' qsub
complete -f -X '!*.pl' perl
complete -f -X '!*.[r|R]' er

# User specific aliases and function
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias l='ls -lrt'
alias rout='tail *.Rout'
alias r='R --no-save --no-restore'
alias screen='screen -U'
alias prompt='unset PROMPT_COMMAND; stty igncr -echo'
alias rm="rm -i"
alias lproj="find $MY_PROJECTS -maxdepth 3 -mindepth 3 -type d -not -path '*/\.*' -printf '%P\n' | column -t -s '/'"
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




