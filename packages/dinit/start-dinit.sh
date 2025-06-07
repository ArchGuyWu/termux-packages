mkdir -p "$PREFIX/var/run/user"
export DINIT_SOCKET_PATH="$PREFIX/var/run/user/dinitctl"
start-stop-daemon -S -x "$PREFIX/bin/dinit" -b -- -d "$PREFIX/etc/dinit.d/user" -p "$PREFIX/var/run/user/dinitctl"
