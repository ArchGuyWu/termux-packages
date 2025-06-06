TERMUX_PKG_HOMEPAGE=https://github.com/vi/websocat
TERMUX_PKG_DESCRIPTION="Command-line client for WebSockets, like netcat (or curl) for ws:// with advanced socat-like functions"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.14.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/vi/websocat/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=919ee83c961074c176a129874a77c02889401f3548c2536a84c4427f97cfeb26
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_rust

	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	cargo vendor
	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/traitobject \
		-exec rm -rf '{}' \;

	patch --silent -p1 \
		-d ./vendor/traitobject/ \
		< "$TERMUX_PKG_BUILDER_DIR"/traitobject-rust-1.87.diff

	echo "" >> Cargo.toml
	echo '[patch.crates-io]' >> Cargo.toml
	echo 'traitobject = { path = "./vendor/traitobject" }' >> Cargo.toml
}

termux_step_make() {
	termux_setup_rust

	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/websocat
}
