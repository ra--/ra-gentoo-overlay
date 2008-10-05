# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: 

inherit gnome2 eutils

#MY_PV=${PV/_*/}

DESCRIPTION="Gnome applet for NetworkManager."
HOMEPAGE="http://people.redhat.com/dcbw/NetworkManager/"
#SRC_URI="http://ftp.gnome.org/pub/gnome/sources/network-manager-applet/0.6/network-manager-applet-0.6.5.tar.gz"
SRC_URI="http://people.redhat.com/dcbw/NetworkManager/0.6.6/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="cisco debug doc libnotify openvpn"

RDEPEND=">=sys-apps/dbus-0.60
	>=sys-apps/hal-0.5
	sys-apps/iproute2
	>=net-misc/dhcdbd-1.4
	>=net-misc/networkmanager-0.6.5_p20080130
	>=net-wireless/wireless-tools-28_pre9
	>=net-wireless/wpa_supplicant-0.4.8
	>=dev-libs/glib-2.10
	libnotify? ( >=x11-libs/libnotify-0.4.3 )
	>=x11-libs/gtk+-2.10
	>=gnome-base/libglade-2
	>=gnome-base/gnome-keyring-0.4
	>=gnome-base/gconf-2
	>=gnome-base/libgnomeui-2
	cisco? ( net-misc/networkmanager-vpnc )
	openvpn? ( net-misc/networkmanager-openvpn )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=dev-util/intltool-0.35"

DOCS="AUTHORS COPYING ChangeLog INSTALL NEWS README"
USE_DESTDIR="1"

G2CONF="${G2CONF} \
	--disable-more-warnings \
	--localstatedir=/var \
	--with-dbus-sys=/etc/dbus-1/system.d \
	$(use_with libnotify notify)"

#S=${WORKDIR}/${PN}-${MY_PV}
pkg_setup() {
	if use openvpn && ( ! built_with_use net-misc/networkmanager gnome || \
		! built_with_use net-misc/networkmanager-openvpn gnome ); then
		eerror ""
		eerror "To make use of the openvpn feature you have to compile"
		eerror "net-misc/networkmanager and net-misc/networkmanager-openvpn"
		eerror "with the \"gnome\" USE flag."
		eerror ""
		die "Fix use flag and re-emerge."
	fi
	if use cisco && ( ! built_with_use net-misc/networkmanager gnome || \
		! built_with_use net-misc/networkmanager-vpnc gnome ); then
		eerror ""
		eerror "To make use of the cisco feature you have to compile"
		eerror "net-misc/networkmanager and net-misc/networkmanager-vpnc"
		eerror "with the \"gnome\" USE flag."
		eerror ""
		die "Fix use flag and re-emerge."
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PN}-0.6.5-confchanges.patch"
}

pkg_postinst() {
	gnome2_pkg_postinst

	if ! built_with_use sys-auth/pambase gnome-keyring; then
		elog ""
		elog "To get rid of the password prompt for the gnome keyring you need"
		elog "to compile sys-apps/pambase with the gnome-keyring use flag and"
		elog "configure the pam settings of your login manager."
		elog ""
	fi

	elog "Your user needs to be in the plugdev group in order to use this"
	elog "package.  If it doesn't start in Gnome for you automatically after"
	elog 'you log back in, simply run "nm-applet --sm-disable"'
	elog "You also need the notification area applet on your panel for"
	elog "this to show up."
}
