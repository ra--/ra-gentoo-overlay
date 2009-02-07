# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="recorded brain-wave viewing application"
HOMEPAGE="http://uazu.net/bwview/"
SRC_URI="http://uazu.net/bwview/${P}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="sci-libs/fftw
		media-libs/libsdl"
RDEPEND="${DEPEND}"

src_compile() {
	cd "${S}"/src
	./mk || die 'Building failed!'
}

src_install() {
	exeinto /usr/bin
	doexe bwview
	insinto /etc
	doins bwview.cfg
}

