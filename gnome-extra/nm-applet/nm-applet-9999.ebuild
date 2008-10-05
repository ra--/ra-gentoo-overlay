# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit subversion autotools gnome2 eutils

DESCRIPTION="Gnome applet for NetworkManager."
HOMEPAGE="http://people.redhat.com/dcbw/NetworkManager/"
SRC_URI=""
ESVN_REPO_URI="svn://svn.gnome.org/svn/network-manager-applet/trunk"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc libnotify"

RDEPEND=">=dev-libs/dbus-glib-0.72
	>=sys-apps/hal-0.5
	sys-apps/iproute2
	>=dev-libs/libnl-1.0_pre6
	>=net-misc/dhcdbd-1.4
	>=net-misc/networkmanager-0.7.0
	>=net-wireless/wireless-tools-28_pre9
	>=net-wireless/wpa_supplicant-0.4.8
	>=dev-libs/glib-2.10
	libnotify? ( >=x11-libs/libnotify-0.4.3 )
	>=x11-libs/gtk+-2.10
	>=gnome-base/libglade-2
	>=gnome-base/gnome-keyring-0.4
	>=gnome-base/gconf-2
	>=gnome-base/libgnomeui-2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=dev-util/intltool-0.35"

DOCS="AUTHORS COPYING ChangeLog INSTALL NEWS README"
USE_DESTDIR="1"
MAKEOPTS="${MAKEOPTS} -j1"

G2CONF="${G2CONF} \
	--disable-more-warnings \
	--localstatedir=/var \
	--with-dbus-sys=/etc/dbus-1/system.d \
	$(use_with libnotify notify)"

# FIXME
# predepend gvfs with gnome-keyring use flag enabled ?
#

src_unpack() {
	subversion_src_unpack
	cd "${S}"
	epatch "${FILESDIR}/${PN}-${PV}-confchanges.patch"
}

src_compile() {
	./autogen.sh || die 'autogen.sh failed!'
	gnome2_src_configure
	emake || die 'compile failure'
}

src_install() {
	gnome2_src_install
}

pkg_postinst() {
	gnome2_pkg_postinst
	elog "Your user needs to be in the plugdev group in order to use this"
	elog "package.  If it doesn't start in Gnome for you automatically after"
	elog 'you log back in, simply run "nm-applet --sm-disable"'
	elog "You also need the notification area applet on your panel for"
	elog "this to show up."
}
