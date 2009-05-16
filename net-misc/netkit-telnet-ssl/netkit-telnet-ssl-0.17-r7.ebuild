# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:
# /var/cvsroot/gentoo-x86/net-misc/netkit-telnet-ssl/netkit-telnet-ssl-0.17-r7.ebuild,v 1.2 2008/02/02 00:00:00 solar Exp $

inherit eutils toolchain-funcs

PATCHLEVEL=14
DESCRIPTION="Standard Linux telnet client + SSL"
HOMEPAGE="ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/"
# http://packages.debian.org/stablesource/netkit-telnet-ssl
# http://packages.debian.org/testing/source/netkit-telnet-ssl
SRC_URI="http://ftp.debian.org/debian/pool/main/n/netkit-telnet-ssl/netkit-telnet-ssl_0.17.24+0.1.orig.tar.gz
http://ftp.debian.org/debian/pool/main/n/netkit-telnet-ssl/netkit-telnet-ssl_0.17.24+0.1-${PATCHLEVEL}.diff.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 sparc x86"
IUSE=""

DEPEND=">=sys-libs/ncurses-5.2"

src_unpack() {
	unpack ${A}
	mv "netkit-telnet-ssl-0.17.24+0.1.orig" "${S}"
	cd ${S}
	# Patch: [0]
	# Gentoo lacks a maintainer for this package right now. And a 
	# security problem arose. While reviewing our options for how 
	# should we proceed with the security bug we decided it would be 
	# better to just stay in sync with debian's own netkit-telnet 
	# package. Lots of bug fixes by them over time which were not in 
	# our telnetd.
	epatch "${WORKDIR}/netkit-telnet-ssl_0.17.24+0.1-${PATCHLEVEL}.diff" || die
}

src_compile() {
	./configure --prefix=/usr || die

	sed -i \
		-e "s:-pipe -O2:${CFLAGS}:" \
		-e "s:-Wpointer-arith::" \
		-e "s:^CC=.*:CC=$(tc-getCC):" \
		-e "s:^CXX=.*:CXX=$(tc-getCXX):" \
		MCONFIG

	cd libtelnet
	make || die
	cd ../telnet
	make || die
	mv telnet ../telnet-ssl
	mv telnet.1 ../telnet-ssl.1
	cd ..
	
#	cd telnetlogin
#	make || die
}

src_install() {
	dobin telnet-ssl || die
	doman telnet-ssl.1
	
}
