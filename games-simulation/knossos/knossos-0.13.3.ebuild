# Copyright 2019 Alexander Olofsson
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils

DESCRIPTION="A simple mod manager for FreeSpace 2 Open"
HOMEPAGE="https://github.com/ngld/knossos"
SRC_URI="https://github.com/ngld/${PN}/archive/v${PV}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
SLOT="0"

RDEPEND="
	app-arch/p7zip[rar]
	media-libs/libsdl2
	media-libs/openal
	dev-python/PyQt5
	dev-python/semantic_version
	dev-python/requests-toolbelt"

DEPEND="$RDEPEND
	dev-utils/ninja
	sys-apps/yarn"

RESTRICT="mirror"

# S="${WORKDIR}"

src_prepare() {
	yarn install
}

src_configure() {
	python configure.py
}

src_compile() {
	ninja resources
}

src_install() {
	python setup.py install --root="${D}" --optimize=1

	dobin "${FILESDIR}/${PN}"

	insinto /usr/share/applications
	doins "${FILESDIR}/${PN}.desktop"
}
