# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Author of hook: log-mailer
# --------------------------------------
# pilx

DESCRIPTION="Sends Paludis elog messages via email."

KEYWORDS="~amd64 ~x86 ~sparc"

DEPEND='sys-apps/paludis'
RDEPEND="${DEPEND}"
IUSE=''
SLOT='0'

src_unpack() {
	cd "${WORKDIR}"
	tar xfj "${FILESDIR}"/"${PN}"-"${PV}".tar.bz2 || die
}

src_install() {
	dodir /etc/paludis/hooks/config
	insinto /etc/paludis/hooks/config || die "log-mailer.conf: insinto failed"
	doins log-mailer.conf || die "log-mailer.conf: doins failed"

	dodir /usr/share/paludis/hooks/common
	exeinto /usr/share/paludis/hooks/common || die "log-mailer-send.py: exeinto failed"
	doexe log-mailer-send.py || die "log-mailer-send.py: doexe failed"
	doexe log-mailer.bash || die "log-mailer.bash: doexe failed"

	local hookfile="log-mailer.bash"
	local hookname="${hookfile##*/}"
	local hooksdir="/usr/share/paludis/hooks"
	local esdfn="${PN##*paludis-hooks-}"
	local esf="${WORKDIR}/${esdfn}"
	dodir "${hooksdir}/elog" || die "dodir failed"
	dosym "${hooksdir}/common/${hookname}" "${hooksdir}"/elog || die "dosym failed"
	dodir "${hooksdir}/einfo" || die "dodir failed"
	dosym "${hooksdir}/common/${hookname}" "${hooksdir}"/einfo || die "dosym failed"
	dodir "${hooksdir}/ewarn" || die "dodir failed"
	dosym "${hooksdir}/common/${hookname}" "${hooksdir}"/ewarn || die "dosym failed"
	dodir "${hooksdir}/eerror" || die "dodir failed"
	dosym "${hooksdir}/common/${hookname}" "${hooksdir}"/eerror || die "dosym failed"
	dodir "${hooksdir}/install_post" || die "dodir failed"
	dosym "${hooksdir}/common/${hookname}" "${hooksdir}"/install_post || die "dosym failed"
}
