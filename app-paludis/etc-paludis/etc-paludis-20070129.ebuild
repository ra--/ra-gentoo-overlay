# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="etc-update modified to work with Paludis, the other package mangler"
HOMEPAGE="http://drzile.dyndns.org/pe-doc/"
SRC_URI="mirror://zxy/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~sparc ~x86 ~x86-fbsd"

IUSE=""

DEPEND=""

RDEPEND=">=sys-apps/paludis-0.16.2"


src_install() {
	insinto /etc
	doins "${S}"/etc-paludis.conf

	exeinto /usr/sbin/
	doexe "${S}"/etc-paludis

	doman "${S}"/etc-paludis.1

	dodoc "${S}"/ChangeLog

}

pkg_postinst() {
	einfo "The \"etc-paludis\" script provided with this package is equivalent to \"etc-update\""
	einfo "from Portage except that etc-paludis uses Paludis instead of Portage."
}
