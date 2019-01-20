#!/bin/bash

set -e

if [ ! -f /.dockerenv ]; then
	echo "$0 should only be run in Docker container" 1>&2
	exit 1
fi

username=${USERNAME:-zoom}
uid=${UID:-1000}
gid=${GID:-1000}

create_user() {
	if ! getent group "${username}" > /dev/null; then
		groupadd --force --gid "${gid}" "${username}"
	fi

	mkdir -p "/home/${username}"
	if ! getent passwd "${username}" > /dev/null; then
		useradd --uid "${uid}" --gid "${gid}" "${username}"
	fi

	chown "${username}:${username}" -R "/home/${username}"
}

grant_video_devices() {
	for device in /dev/video*; do
		if [[ -c $device ]]; then
			video_gid=$(stat -c %g "$device")
			video_group=$(stat -c %G "$device")
			if [[ ${video_group} == "UNKNOWN" ]]; then
				video_group=custom_video
				groupadd -g "${video_gid}" "${video_group}"
			fi
			usermod -a -G ${video_group} "${username}"
			break
		fi
	done
}

launch_zoom() {
	cd "/home/${username}"
	exec sudo -HEu "${username}" PULSE_SERVER=/run/pulse/native QT_GRAPHICSSYSTEM=native "$@"
}

create_user
grant_video_devices

case "$1" in
	zoom)
		launch_zoom "$@"
		;;
	*)
		exec "$@"
		;;
esac
