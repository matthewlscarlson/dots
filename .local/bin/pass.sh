#!/bin/sh
#
# pass

# named pass in order to just werk when switching from popular pass program
CREDENTIALS_DIR="${XDG_DATA_HOME:-${HOME}/.local/share/}/pass"

NEWLINE='
'

get_credential() {
    # awk statement takes everything after the first colon
    credential="$(printf '%s\n' "${credentials}" | grep "\<${1}\>" | awk -F ':' '{ st = index($0, ":"); print substr($0, st + 1) }')"
    credential="${credential%\'}"
    credential="${credential#\'}"
}

main() {
    while :; do
        i=0
        for site in "${CREDENTIALS_DIR}"/*.gpg; do
            site="${site%.*}"
            if [ ${i} -eq 0 ]; then sites="${sites}${site##*/}"
            else sites="${sites}${NEWLINE}${site##*/}"
            fi
            i=$((i+1))
        done

        site="$(printf '%s\n' "${sites}" | dmenu -c -l 10)"
        [ -z "${site}" ] && break
        if ! printf '%s\n' "${sites}" | grep -iqx "${site}"; then
            unset sites && continue
        fi

        credentials="$(gpg -dq "${CREDENTIALS_DIR}"/"${site}".gpg)"
        [ -z "${credentials}" ] && unset sites && continue

        credential_types="$(printf '%s\n' "${credentials}" | awk -F ':' '{ print $1 }')"

        squestions="$(printf '%s\n' "${credential_types}" | grep -c 'squestion*')"

        credential_options="$(printf '%s\n' "${credential_types}" | ( while read -r type; do
            case "${type}" in
                'uname')      printf 'Username\n'          ;;
                'pw')         printf 'Password\n'          ;;
                'email')      printf 'Email\n'             ;;
                'squestion'*) i=1
                              while [ ${i} -le ${squestions} ]; do
                                  printf '%s\n' "Security Question ${i}"
                                  i=$((i+1))
                              done
                              break
                              ;;
                'recovery')   printf 'Recovery\n'          ;;
            esac
        done
        printf '%s\n' "${credential_options}" ))"

        if { ! credential_option="$(printf '%s\n' "${credential_options}" | dmenu -c -l 10 -p 'Credentials')" ; } ||
           { ! printf '%s\n' "${credential_options}" | grep -iqx "${credential_option}" ; }; then
            unset sites credential_options && continue
        fi

        if printf '%s\n' "${credential_option}" | grep -q '\<[0-9]\>'; then num="$(printf '%s\n' "${credential_option}" | awk '{ print $3 }')" ; fi

        case "${credential_option}" in
            'Username')                 get_credential 'uname'         ;;
            'Password')                 get_credential 'pw'            ;;
            'Email')                    get_credential 'email'         ;;
            "Security Question ${num}") get_credential "sanswer${num}" ;;
            'Recovery')                 get_credential 'recovery'      ;;
        esac

        if printf '%s\n' "${credential}" | xclip -selection clipboard; then { herbe "${credential_option} for "${site}" copied to clipboard" & } ; fi
        break
    done
}

main "${@}"
