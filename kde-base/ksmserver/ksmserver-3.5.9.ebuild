# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/ksmserver/ksmserver-3.5.9.ebuild,v 1.7 2008/05/18 15:18:57 maekke Exp $

KMNAME=kdebase
EAPI="1"
inherit kde-meta eutils

DESCRIPTION="The reliable KDE session manager that talks the standard X11R6"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="dbus hal kdehiddenvisibility"

KMEXTRACTONLY="kdm/kfrontend/themer/"
KMCOMPILEONLY="kdmlib/"
KMNODOCS=true

DEPEND="dbus? ( sys-apps/dbus )
		hal? ( sys-apps/hal )"

PATCHES="${FILESDIR}/${P}-ksmserver_suspend.diff
		 ${FILESDIR}/${P}-suspend_configure.diff"

src_compile() {
   myconf="${myconf}
		   $(use_enable hal)
		   $(use_enable dbus)"

   kde-meta_src_compile
}

pkg_setup() {
	if ! built_with_use --missing true sys-apps/hal laptop; then
			eerror "Please re-emerge sys-apps/hal with the \"laptop\" USE flag."
			die "Fix use flag and re-emerge."
	fi
}

pkg_postinst() {
   kde_pkg_postinst

   if use dbus && use hal ; then
      echo
      elog "If you don't see any icons next to the suspend/hibernate buttons,"
      elog "make sure you use an iconset that provides the files"
      elog "\"suspend.png\" and \"hibernate.png\"."
      echo
   fi
}
