# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Open source video player"
HOMEPAGE="http://www.getmiro.com/"
#SRC_URI="http://ftp.osuosl.org/pub/pculture.org/miro/src/Miro-${PV}.tar.gz"
SRC_URI="http://participatoryculture.org/nightlies/Miro-${PV/_/-}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

#TODO: This is simply rewritten from setup.cfg. Adding version requirements is strongly recommended.
DEPEND="dev-lang/python
	    dev-libs/nss
	    dev-util/devhelp
	    dev-python/gnome-python-extras
		dev-python/dbus-python
		dev-libs/boost
		dev-python/pysqlite
		media-libs/xine-lib
		media-libs/libfame
	    dev-python/pyrex
	    <sys-libs/db-4.5
	    dev-util/pkgconfig
		dev-util/subversion"

src_compile() {
	./Miro-${PV/_/-}/platform/gtk-x11/setup.py build 
}

src_install() {
	./Miro-${PV/_/-}/platform/gtk-x11/setup.py install --root "${D}"
}

pkg_postinst() {
	elog ""
	elog "To increase the font size of the main display area, add:"
	elog "user_pref(\"font.minimum-size.x-western\", 15);"
	elog ""
	elog "to the following file:"
	elog "/usr/lib64/python2.4/site-packages/miro/mozsetup.py"
	elog ""
	elog "Be sure to substitute \"lib64\" and \"python2.4\" with your correct paths."
	elog ""
}

