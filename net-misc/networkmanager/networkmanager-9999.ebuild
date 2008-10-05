# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:

inherit subversion autotools gnome2 eutils

# NetworkManager likes itself with capital letters
MY_P=${P/networkmanager/NetworkManager}

DESCRIPTION="Network configuration and management in an easy way. Desktop environment independent."
HOMEPAGE="http://www.gnome.org/projects/NetworkManager/"
SRC_URI=""
ESVN_REPO_URI="svn://svn.gnome.org/svn/NetworkManager/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="crypt doc gnome kde"

RDEPEND=">=sys-apps/dbus-0.60
	>=sys-apps/hal-0.5.10
	>=sys-auth/policykit-0.7
	sys-apps/iproute2
	>=dev-libs/libnl-1.1
	~net-dialup/ppp-2.4.4
	>=net-misc/dhcdbd-1.4
	>=net-wireless/wireless-tools-28_pre9
	>=net-wireless/wpa_supplicant-0.5.10
	>=dev-libs/glib-2.8
	gnome? ( >=x11-libs/gtk+-2.10
		>=gnome-base/libglade-2
		>=gnome-base/gnome-keyring-0.4
		>=gnome-base/gconf-2
		>=gnome-base/libgnomeui-2 )
	crypt? ( dev-libs/libgcrypt )
	gnome-base/gvfs
	>=dev-libs/dbus-glib-0.74-r1"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool"

PDEPEND="gnome? ( =gnome-extra/nm-applet-9999 )
		 kde?   ( =kde-misc/knetworkmanager-9999 )"

DOCS="AUTHORS ChangeLog NEWS README"
USE_DESTDIR="1"

G2CONF="${G2CONF} \
	`use_with crypt gcrypt` \
	`use_with gnome` \
	`use_with doc docs` \
	--disable-more-warnings \
	--localstatedir=/var \
	--with-distro=gentoo \
	--with-dbus-sys=/etc/dbus-1/system.d \
	--enable-notification-icon"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if built_with_use sys-apps/iproute2 minimal ; then
		eerror "Please rebuild sys-apps/iproute2 without the minimal useflag."
		die "Fix iproute2 first."
	fi
}

src_unpack () {
	subversion_src_unpack ${A}
	cd "${S}" || die
	# Use the kernel headers
	epatch "${FILESDIR}/${PN}-use-kernel-headers.patch"
	# Fix the resolv.conf permissions
	epatch "${FILESDIR}/${PN}-${PV}-resolvconf-perms.patch"
	# Fix up the dbus conf file to use plugdev group
	epatch "${FILESDIR}/${PN}-${PV}-confchanges.patch"

	intltoolize --force || die
	eautoreconf
}

src_install() {
	gnome2_src_install
	# Need to keep the /var/run/NetworkManager directory
	keepdir /var/run/NetworkManager
}

pkg_postinst() {
	gnome2_icon_cache_update
	elog "You need to be in the plugdev group in order to use NetworkManager"
	elog "Problems with your hostname getting changed?"
	elog ""
	elog "Add the following to /etc/dhcp/dhclient.conf"
	elog 'send host-name "YOURHOSTNAME";'
	elog 'supersede host-name "YOURHOSTNAME";'

	elog "You will need to restart DBUS if this is your first time"
	elog "installing NetworkManager."
}
