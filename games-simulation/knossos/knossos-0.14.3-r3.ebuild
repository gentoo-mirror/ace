# Copyright 2019 Alexander Olofsson
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="7"

inherit eutils xdg-utils

DESCRIPTION="A simple mod manager for FreeSpace 2 Open"
HOMEPAGE="https://github.com/ngld/knossos"
SRC_URI="https://github.com/ngld/old-${PN}/archive/v${PV}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
SLOT="0"

RDEPEND="
	app-arch/p7zip[rar]
	media-libs/libsdl2
	media-libs/openal
	dev-python/PyQt5
	dev-python/semantic_version
	dev-python/requests-toolbelt
	dev-python/token-bucket"

DEPEND="$RDEPEND
	dev-util/ninja
	dev-qt/linguist-tools
	sys-apps/yarn"

RESTRICT="mirror network-sandbox"

S="${WORKDIR}/old-${P}"

src_prepare() {
	default
	yarn add es6-shim
	yarn install
}

src_configure() {
	export PATH="$PATH:$(qtpaths5 --binaries-dir)"

	python configure.py
	test -f build.ninja || die 'Failed to configure'
}

src_compile() {
	ninja resources
}

src_install() {
	python setup.py install --root="${D}" --optimize=1

	dobin "${FILESDIR}/${PN}"

	insinto /usr/share/applications
	doins "${FILESDIR}/${PN}.desktop"

	insinto /usr/share/icons/hicolor/256x256/apps
	newins knossos/data/hlp.png knossos.png
}

pkg_postinst() {
	xdg_desktop_database_update
}
