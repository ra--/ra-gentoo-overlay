# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: 

inherit flag-o-matic

DESCRIPTION="Utility for viewing/manipulating the MAC address of network interfaces"
#OUI_DATE="20051212"
#OUI_FILE="OUI.list-${OUI_DATE}"
HOMEPAGE="http://www.alobbs.com/macchanger"
SRC_URI="mirror://gnu/macchanger/${P}.tar.gz"
#		 mirror://gentoo/${OUI_FILE}.gz"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""
SLOT="0"

DEPEND="virtual/libc"

src_unpack() {
	unpack ${P}.tar.gz
	cp -ap ${FILESDIR}/OUI.list ${S}/data/ || die 'Failed to copy OUI.list'
#	zcat ${DISTDIR}/${OUI_FILE}.gz >${S}/data/OUI.list || die "Failed to update OUI list"
	cd "${S}"
	epatch "${FILESDIR}/random.patch" || die 'patch failed'
}

src_compile() {
	# Shared data is installed below /lib, see Bug #57046
	econf \
		--bindir=/sbin \
		--datadir=/lib \
		|| die "configure failed"
	emake || die "build failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"

	dodoc AUTHORS ChangeLog NEWS README

	dodir /usr/bin
	dosym /sbin/macchanger /usr/bin/macchanger
	dosym /lib/macchanger /usr/share/macchanger
}
