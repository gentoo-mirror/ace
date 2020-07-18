# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils unpacker

MY_PN="${PN%-bin}"

DESCRIPTION="The Choria Orchestrator Server and Broker"
HOMEPAGE="https://choria.io"
SRC_URI="
	amd64? ( https://packagecloud.io/${MY_PN}/release/packages/ubuntu/bionic/${MY_PN}_${PV}_amd64.deb/download.deb -> ${MY_PN}_${PV}_amd64.deb )"

LICENSE="Apache-2.0"
KEYWORDS="~amd64"
RDEPEND=""
SLOT="0"

RESTRICT="mirror"

QA_PREBUILT="
	usr/bin/choria"

S="${WORKDIR}"

src_unpack() {
	unpack_deb "${A}"
}

src_install() {
	insinto /
	doins -r *

	fperms +x /usr/bin/${MY_PN}
}
