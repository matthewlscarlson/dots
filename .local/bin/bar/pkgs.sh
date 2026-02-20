#!/bin/sh
#
# pkgs

ICON=''
UPGRADE_ICON=''
UPGRADE_TMP='/tmp/upgrade-pkgs'
AUR_HELPER='paru'
PKGS="${XDG_CACHE_HOME:-${HOME}/.cache}/dots/bar/pkgs"
GET_TMP='/tmp/get-pkgs'
GET_ICON=''

get_os() {
    # oses defined by their pkg managers
    command -v pacman >/dev/null                          && os='arch'
    { command -v apt || command -v apt-get ; } >/dev/null && os='debian'
    command -v emerge >/dev/null                          && os='gentoo'
    command -v xbps-install >/dev/null                    && os='void'
}

upgrade_pkgs() {
    # remove the temp icon when the process is suddenly stopped/killed
    trap 'rm -f ${UPGRADE_TMP}; exit 1' INT TERM

    # for arch-based systems
    upgrade_arch_pkgs() {
        # arch has both pacman and AUR repos; handle them
        upgrade_repo_pkgs() {
            while :; do
                get_pkgs silent

                case "${1}" in
                    # official repos
                    'pacman') repo_type='Official'
                              # grep -c is more accurate than wc -l
                              available_upgrades=$(printf '%s' "${pacman_pkgs}" | grep -c '^')
                              cmd='doas pacman'
                              ;;
                    # aur repo
                    'aur')    repo_type='AUR'
                              available_upgrades=$(printf '%s' "${aur_pkgs}" | grep -c '^')
                              cmd="${AUR_HELPER} -a"
                              ;;
                    *)        return 1 ;;
                esac

                # no available upgrades at the moment
                if [ "${available_upgrades}" -eq 0 ]; then
                    [ "${repo_type}" = 'Official' ] && repo_type="$(printf '%s\n' "${repo_type}" | tr '[:upper:]' '[:lower:]')"
                    printf '%s\n' "No ${repo_type} packages available for upgrade at the moment. Press any key to continue."
                    read -r input
                    return
                else
                    # try the command; pacman and AUR helper will use similar flags
                    # if it fails ask the user to retry
                    if ! ${cmd} -Syu; then
                        printf '%s\n' "${repo_type} packages failed to upgrade. Retry? [Y/n] "
                        read -r input
                        input="$(printf '%s\n' "${input}" | tr '[:upper:]' '[:lower:]')"
                        if [ "${input}" = 'y' ]; then continue
                        else return 1
                        fi
                    else return
                    fi
                fi
            done
        }

        upgrade_repo_pkgs 'pacman'
        upgrade_repo_pkgs 'aur'
    }

    touch "${UPGRADE_TMP}"

    # print pretty banner
    # for some reason printing codes doesn't work in new terminal, so just use tput
    theme=$(tput setaf 2)
    reset=$(tput sgr0)
    printf '%s\n\n' "${theme}██████╗ ██╗  ██╗ ██████╗ ███████╗
██╔══██╗██║ ██╔╝██╔════╝ ██╔════╝
██████╔╝█████╔╝ ██║  ███╗███████╗
██╔═══╝ ██╔═██╗ ██║   ██║╚════██║
██║     ██║  ██╗╚██████╔╝███████║
╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚══════╝${reset}"

    # upgrade pkgs depending on os
    get_os
    case "${os}" in 'arch') upgrade_arch_pkgs ;; esac

    rm -f "${UPGRADE_TMP}"

    # update counter immediately after upgrade
    get_pkgs &
}

get_pkgs() {
    [ "${1}" = 'silent' ] || touch "${GET_TMP}"

    get_os
    case "${os}" in
        'arch') # user will not need to input pass if set up correctly
                # -Sy simply syncs the databases
                doas pacman -Sy >/dev/null 2>&1
                # -Qu will print out the actual upgrades
                pacman_pkgs="$(pacman -Qu 2>/dev/null | grep -v '^.*\[ignored\]$')"
                if command -v "${AUR_HELPER}" >/dev/null; then
                    # print just AUR upgrades with AUR helper
                    aur_pkgs="$("${AUR_HELPER}" -Qum --devel 2>/dev/null | grep -v '^.*\[ignored\]$')"
                fi

                pkgs="$(printf '%s\n' "${pacman_pkgs}")"

                # if there are no pacman pkgs we do not need a newline
                # but we do need a newline if there are
                [ ! "${pkgs}" ] && pkgs="${pkgs}$(printf '%s\n' "${aur_pkgs}")"   \
                                || pkgs="${pkgs}$(printf '\n%s\n' "${aur_pkgs}")"
                ;;
    esac

    # print pkgs to cache
    # cache is useful in case of internet loss, etc.
    # do NOT use newline with printf here or else count will be messed up
    if [ -f "${PKGS}" ]; then
        printf '%s' "${pkgs}" > "${PKGS}"
    else touch "${PKGS}"
    fi

    [ -f "${GET_TMP}" ] && rm -f "${GET_TMP}"
}

bar() {
    # get count from cache, will be updated whenever get_pkgs is called, either manually or from cron, etc.
    [ -f "${PKGS}" ] && pkgs=$(grep -c '^' < "${PKGS}")

    # get icon
    [ -f "${GET_TMP}" ] && printf '%s\n' "${GET_ICON}" && return

    # upgrade icon
    #shellcheck disable=SC2009
    if ps -ef | grep -i '\<upgrade_pkgs\>'| grep -iqv '\<grep\>'; then printf '%s\n' "${UPGRADE_ICON}"
    # icon and count
    else printf '%s\n' "${ICON} ${pkgs}"
    fi
}

open() {
    "${TERMINAL}" -c "${TERMINAL}" -e pkgs.sh upgrade_pkgs
    get_pkgs &
}

main() {
    # called from bar
    [ ${#} -eq 0 ] && bar

    # upgrade_pkgs is argument so function can be run in new terminal
    case "${1}" in upgrade_pkgs) upgrade_pkgs && return 0 ;; esac

    # bar usage
    case ${BLOCK_BUTTON} in
        # pass upgrade_pkgs to new terminal
        1) open     ;;
        2) get_pkgs ;;
    esac

    while getopts 'gou' opt; do
        case "${opt}" in
            # get upgradable pkgs
            g) get_pkgs     ;;
            # upgrade pkgs in new terminal
            o) open         ;;
            # upgrade if called with u flag
            u) upgrade_pkgs ;;
            *) return       ;;
        esac
    done
}

main "${@}"
