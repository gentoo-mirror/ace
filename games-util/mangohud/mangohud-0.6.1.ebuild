# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..11} )

inherit meson distutils-r1 multilib-minimal flag-o-matic

DESCRIPTION="A Vulkan and OpenGL overlay for monitoring FPS, temperatures, CPU/GPU load and more."
HOMEPAGE="https://github.com/flightlessmango/MangoHud"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/flightlessmango/MangoHud.git"
	SRC_URI=""
else
	SRC_URI="https://github.com/flightlessmango/MangoHud/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="-* ~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="+dbus glvnd +X xnvctrl wayland video_cards_nvidia"
REQUIRED_USE="
	xnvctrl? ( video_cards_nvidia )
"

BDEPEND="dev-python/mako[${PYTHON_USEDEP}]"
DEPEND="
	dev-util/glslang
	>=dev-util/vulkan-headers-1.2
	media-libs/vulkan-loader[${MULTILIB_USEDEP}]
	glvnd? (
		media-libs/libglvnd[${MULTILIB_USEDEP}]
	)
	dbus? ( sys-apps/dbus[${MULTILIB_USEDEP}] )
	X? ( x11-libs/libX11[${MULTILIB_USEDEP}] )
	video_cards_nvidia? (
		x11-drivers/nvidia-drivers[${MULTILIB_USEDEP}]
		xnvctrl? ( x11-drivers/nvidia-drivers[static-libs] )
	)
	wayland? ( dev-libs/wayland[${MULTILIB_USEDEP}] )
"

RDEPEND="${DEPEND}"

src_unpack() {
	if ! [[ "${PV}" == "9999" ]]; then
		unpack ${A}
		mv MangoHud-${PV} mangohud-${PV}
	else
		git-r3_src_unpack
	fi
}

multilib_src_configure() {
	local emesonargs=(
		-Dappend_libdir_mangohud=false
		-Duse_system_vulkan=enabled
		-Dinclude_doc=false
		$(meson_feature video_cards_nvidia with_nvml)
		$(meson_feature xnvctrl with_xnvctrl)
		$(meson_feature X with_x11)
		$(meson_feature wayland with_wayland)
		$(meson_feature dbus with_dbus)

	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_install() {
	meson_src_install
}

multilib_src_install_all() {
	dodoc "${S}/bin/MangoHud.conf"

	einstalldocs
}

pkg_postinst() {
	if ! use xnvctrl; then
		einfo ""
		einfo "If mangohud can't get GPU load, or other GPU information,"
		einfo "and you have an older Nvidia device."
		einfo ""
		einfo "Try enabling the 'xnvctrl' useflag."
		einfo ""
	fi
}
