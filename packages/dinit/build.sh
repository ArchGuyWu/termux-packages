TERMUX_PKG_HOMEPAGE=https://github.com/davmac314/dinit
TERMUX_PKG_DESCRIPTION="Service monitoring / "init" system"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.19.4
TERMUX_PKG_SRCURL=git+https://github.com/davmac314/dinit.git
TERMUX_PKG_GIT_BRANCH=r${TERMUX_PKG_VERSION}
TERMUX_PKG_BUILD_DEPENDS="make, clang, m4, binutils-is-llvm, git"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS="--disable-shutdown"

termux_step_host_build() {
	cd src
	./configure --prefix=${TERMUX_PREFIX} --sbindir=${TERMUX_PREFIX}/bin --disable-shutdown
	make
}

termux_step_post_make_install() {
	mkdir -p ${TERMUX_PREFIX}/etc/profile.d/
	install $TERMUX_PKG_BUILDER_DIR/start-dinit.sh ${TERMUX_PREFIX}/etc/profile.d
	mkdir -p ${TERMUX_PREFIX}/etc/dinit.d
	install $TERMUX_PKG_BUILDER_DIR/boot ${TERMUX_PREFIX}/etc/dinit.d
	install $TERMUX_PKG_BUILDER_DIR/local.target ${TERMUX_PREFIX}/etc/dinit.d
	install $TERMUX_PKG_BUILDER_DIR/network.target ${TERMUX_PREFIX}/etc/dinit.d
	mkdir -p ${TERMUX_PREFIX}/etc/dinit.d/service.d
}

termux_step_create_debscripts() {
	{
	echo "#!$TERMUX_PREFIX/bin/sh"
	echo "echo \"Adding 'dinitctl shutdown' in .bash_logout\""
	echo "echo \"to shutdown services properly\""
	echo "echo \"dinitctl shutdown\" >> \"\$HOME/.bash_logout\""
	echo "exit 0"
	} > postinst
	chmod 0700 postinst
}
