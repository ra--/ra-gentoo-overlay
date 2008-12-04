# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $

inherit paludis-hooks eutils

DESCRIPTION="small and fast paludis helper tools written in C"
HOMEPAGE="http://www.gentoo.org/ http://drzile.dyndns.org/pe-doc"

SRC_URI="mirror://paludis-extras/${P}.tar.bz2 mirror://paludis-extras/${PV}-overlay-and-optional-paludis-support.tar.bz2"
SRC_URI="${SRC_URI} mirror://truc/${P}.tar.bz2 mirror://truc/${PV}-overlay-and-optional-paludis-support.tar.bz2"
SRC_URI="${SRC_URI} mirror://zxy/${P}.tar.bz2 mirror://zxy/${PV}-overlay-and-optional-paludis-support.tar.bz2"


LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""
RESTRICT="test"

DEPEND=""

src_unpack() {
	unpack ${A}
	cd ${P}
	epatch ${WORKDIR}/overlay-support.patch
	epatch ${WORKDIR}/portage2paludis.patch
}

src_install() {
	dobin q || die "dobin failed"
	doman man/*.[0-9]
	for applet in $(<applet-list) ; do
		dosym q /usr/bin/${applet}
	done

	exeinto "/usr/bin"
	doexe ${WORKDIR}/palsearch

	dohook ${WORKDIR}/q-reinitialize.bash sync_all_post
	dohook ${WORKDIR}/qlop-hook.bash install_pre install_all_post install_fail

	puthookconfig ${WORKDIR}/q-reinitialize.conf
}

pkg_postinst() {
	install_hook_using_eselect
	einfo "${ROOT}/usr/share/paludis/hooks/sync_all_post/q-reinitialize.bash been installed for convenience"
	einfo "Normally this should only take a few seconds to run but file systems such as ext3 can take a lot longer."
	einfo "If ever you find this to be an inconvenience simply delete ${ROOT}/usr/share/paludis/hooks/sync_all_post/q-reinitialize.bash"
}
