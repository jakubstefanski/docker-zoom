#!/bin/bash

set -e

if [ ! -f /.dockerenv ]; then
	echo "$0 should only be run in Docker container" 1>&2
	exit 1
fi

user_name=${USER_NAME:-zoom}
user_uid=${USER_UID:-1000}
user_gid=${USER_GID:-1000}

create_user() {
	if ! getent group "${user_name}" > /dev/null; then
		groupadd --force --gid "${user_gid}" "${user_name}"
	fi

	if ! getent passwd "${user_name}" > /dev/null; then
		adduser --disabled-login --uid "${user_uid}" --gid "${user_gid}" \
			--gecos "${user_name}" "${user_name}"
	fi

	chown "${user_name}:${user_name}" -R "/home/${user_name}"
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
			usermod -a -G ${video_group} "${user_name}"
			break
		fi
	done
}

launch_zoom() {
	cd "/home/${user_name}"
	exec sudo -HEu "${user_name}" PULSE_SERVER=/run/pulse/native QT_GRAPHICSSYSTEM=native "$@"
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
