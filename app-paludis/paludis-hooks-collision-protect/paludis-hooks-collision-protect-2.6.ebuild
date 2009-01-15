# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Author of hook: collision-protect
# ----------------------------------
# dleverton

DESCRIPTION="Hook collision-protect provides collision protect functionality for Paludis."

KEYWORDS="~amd64 ~x86 ~sparc"
IUSE=''
DEPEND='>=sys-apps/paludis-0.26_alpha13'
RDEPEND="${DEPEND}"
SLOT='0'

src_unpack() {
	cd "${WORKDIR}"
	tar xfj "${FILESDIR}"/"${PN}"-"${PV}".tar.bz2 || die
}

src_install() {
	local hookfile="collision-protect.hook"
	local hookname="${hookfile##*/}"
	local hooksdir="/usr/share/paludis/hooks"
	local esdfn="${PN##*paludis-hooks-}"
	local esf="${WORKDIR}/${esdfn}"

	shift

	dodir "${hooksdir}/common" || die "dodir failed"
	exeinto "${hooksdir}/common" || die "exeinto failed"
	doexe "${hookfile}" || die "doins failed"
	dodir "${hooksdir}"/auto || die "dodir failed"
	dosym "${hooksdir}"/common/"${hookname}" "${hooksdir}"/auto || die "dosym failed"
}
