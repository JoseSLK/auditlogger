#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    gum style \
	--foreground 212 --border-foreground 212 --border double \
	--align center --width 50 --margin "1 2" --padding "2 4" \
	'AuditLogger Require Administrator permission. Exiting...'
  exit 1
fi

PATH_TO_LOGS="/var/log/audit/report"
source /usr/local/bin/auditlogger/src/menu/menu.sh

function help_note {
    gum style \
	--foreground 212 --border-foreground 212 --border double \
	--align center --width 50 --margin "1 2" --padding "2 4" \
	'AuditLogger by: Dumar Malpica, Jose Salamanca, Nicolas Tinjaca & Nicolas Sarmiento'

    echo " AuditLogger is a simple Audit Script to review System users acctions. The main features of the script are:
    - Custom and rish command history log ( users, dates, tty and output codes )
    - Session review: Logs that show sessions and their last in seconds. It also show active sessions
    - Rich Error logs and Error reports: Error reports that show metrics like most common errors, users with more errors and more!
    - Command Analysis: Frequency of commands, more used commands
    - Risky Command Analysis: Frequency of risky commands like sudo, kill, curl, and so on.
    USAGE:
    You can select multiple options in the main menu. Select by hit enter. In some options you could decide if apply some audit operation to one user or (All) means a general operation."
}


while true; do
    clear
    header
    options=("History" "Active Sessions" "Command Analysis" "Error Analysis" "All General audit options" "Review Logs" "Exit" "Help")
    selected=$(gum choose --header "Please choose an audit option" --height 15 "${options[@]}")

    case "${selected}" in 

        "History")

            users=($(awk -F: '($3 >= 1000) && ($7 !~ /(nologin|false)$/) {print $1}' /etc/passwd))
            opts=( "All" "${users[@]}" "Go Back")
            hist_sel=$(gum choose --header "Select you option for Command history review" --height 15 "${opts[@]}")
            if [[ ${hist_sel} == "All" ]]; then
                history_log
            elif [[ ${hist_sel} != "Go Back" ]]; then 
                echo "[*] User history loaded in ${PATH_TO_LOGS}/${hist_sel}.log"
                cp -f "/var/log/audit/users/${hist_sel}.log"  "${PATH_TO_LOGS}/${hist_sel}.log"
            else 
               :
            fi
            ;;
        "Active Sessions")
            users=($(awk -F: '($3 >= 1000) && ($7 !~ /(nologin|false)$/) {print $1}' /etc/passwd))
            opts=( "All" "${users[@]}" "Go Back")
            hist_sel=$(gum choose --header "Select you option for Session history review" --height 15 "${opts[@]}")
            if [[ ${hist_sel} == "All" ]]; then
               session 
            elif [[ ${hist_sel} != "Go Back" ]]; then 
                session_by_user ${hist_sel}
            else 
                :
            fi
            ;;
        "Command Analysis")
            users=($(awk -F: '($3 >= 1000) && ($7 !~ /(nologin|false)$/) {print $1}' /etc/passwd))
            opts=( "Overall Users" "${users[@]}" "Go Back")
            hist_sel=$(gum choose --header "Select you option for Command Analysis  review" --height 15 "${opts[@]}")
            if [[ ${hist_sel} == "Overall Users" ]]; then
               freqency 
            elif [[ ${hist_sel} != "Go Back" ]]; then 
               frequency_by_user ${hist_sel}
            else
                :
            fi
            ;;
        "Error Analysis")
            errors
            ;;
        "All General audit options")
            all_general_audit
            ;;   
        "Review Logs")
            loc=
            log=$(gum file ${PATH_TO_LOGS})
            gum pager < ${log}
            ;;
        "Exit")
            gum confirm && break || :
            ;;
        "Help")
            help_note
            ;;
    esac
    opt=$(gum choose --header "Continue?" --height 15  "Main Menu" "Exit" )
    if [[ ${opt} == "Exit" ]]; then
        gum confirm && break || :
    fi
done 