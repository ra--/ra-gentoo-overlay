# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $

inherit eutils

DESCRIPTION="small and fast paludis helper tools written in C"
HOMEPAGE="http://www.gentoo.org/ http://drzile.dyndns.org/pe-doc"

SRC_URI="mirror://paludis-extras/${P}.tar.bz2
		 mirror://paludis-extras/${PV}-overlay-and-optional-paludis-support.tar.bz2
		 mirror://truc/${P}.tar.bz2
		 mirror://truc/${PV}-overlay-and-optional-paludis-support.tar.bz2
		 mirror://zxy/${P}.tar.bz2
		 mirror://zxy/${PV}-overlay-and-optional-paludis-support.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""
RESTRICT="test"

PDEPEND="app-paludis/paludis-hooks-q-qlop
		 app-paludis/paludis-hooks-q-reinitialize"

src_unpack() {
	unpack ${A}
	cd ${P}
	epatch ${WORKDIR}/overlay-support.patch
	epatch ${WORKDIR}/portage2paludis.patch
	epatch ${FILESDIR}/${P}.patch
}

src_install() {
	dobin q || die "dobin failed"
	doman man/*.[0-9]
	for applet in $(< applet-list) ; do
		dosym q /usr/bin/${applet}
	done

	exeinto "/usr/bin"
	doexe ${WORKDIR}/palsearch
}
