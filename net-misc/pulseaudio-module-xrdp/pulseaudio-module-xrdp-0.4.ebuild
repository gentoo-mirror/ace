# Copyright 2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils systemd

DESCRIPTION="xrdp sink / source pulseaudio modules"
HOMEPAGE="http://www.xrdp.org/"

PULSE_VER="12.2"
SRC_URI="
	https://github.com/neutrinolabs/${PN}/releases/download/v${PV}.tar.gz
	https://freedesktop.org/software/pulseaudio/releases/pulseaudio-${PULSE_VER}.tar.xz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

RDEPEND="
	net-misc/xrdp:0=
	>=media-sound/pulseaudio-${PULSE_VER}
"

src_prepare() {
	./bootstrap
	cd ../pulseaudio-${PULSE_VER} || die
	./configure
}

src_configure() {
	econf PULSE_DIR=${WORKDIR}/pulseaudio-${PULSE_VER}
}

src_install() {
	default
	prune_libtool_files --all
}

