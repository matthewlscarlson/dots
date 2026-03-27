#!/bin/sh
#
# menu

main() {
	xmenu << EOF | sh &
 Programs
	 Web Browser		"${BROWSER}"
	 File Viewer		"${TERMINAL}" -c "${FILE_VIEWER}" -e "${FILE_VIEWER}"
	 Text Editor		"${TERMINAL}" -c "${EDITOR}" -e "${EDITOR}"
	 Music Player		"${HOME}/.local/bin/bar/music.sh" -o
	 Mail Client		"${HOME}/.local/bin/bar/mail.sh" -o
	 RSS Reader		"${HOME}/.local/bin/bar/rss.sh" -o
	 Torrent Client	"${HOME}/.local/bin/bar/torr.sh" -o
	 Image Editor		"${IMAGE_EDITOR}"
 Tools
	 Terminal			"${TERMINAL}"
	 Screenshot		"${HOME}/.local/bin/shot.sh"
	 Password Manager	"${HOME}/.local/bin/pass.sh"
	 Wifi Menu			iwd-dmenu
	 Mixer				"${HOME}/.local/bin/bar/vol.sh" -o
 System
	 Lock		"${HOME}/.local/bin/lock.sh"
	 Shutdown	doas shutdown -h now
	 Restart	doas shutdown -r now
EOF
}

main "${@}"
