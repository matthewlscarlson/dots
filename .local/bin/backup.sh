#!/bin/bash
#
# backup

BACKUP_DIR='/mnt/backup'
LOG='/var/log/backup.log'
stamp="$(date +%Y-%m-%d\ %I:%M\ %p)"

main() {
    if df | grep -q "${BACKUP_DIR}"; then
        [ ! -e "${LOG}" ] && touch "${LOG}"
        # shellcheck disable=SC3009
        rsync -aAXHv --delete --exclude={"/mnt/","/proc/","/sys/"} --exclude="media/" / "${BACKUP_DIR}"
        printf '%s\n' "${stamp} - System backup complete." >> "${LOG}"
    else printf '%s\n' "${stamp} - ${BACKUP_DIR} is not a mount point. Not backing up system." >> "${LOG}"
    fi
}

main "${@}"
