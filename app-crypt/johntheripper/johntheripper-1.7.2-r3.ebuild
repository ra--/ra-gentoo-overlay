# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/johntheripper/johntheripper-1.7.2-r3.ebuild,v 1.9 2008/11/04 08:06:54 dragonheart Exp $

inherit eutils flag-o-matic toolchain-funcs pax-utils

MY_PBASE=${P/theripper/}
MY_PNBASE=${PN/theripper/}
S=${WORKDIR}/${MY_PBASE}
DESCRIPTION="fast password cracker"
HOMEPAGE="http://www.openwall.com/john/"
SRC_URI="http://www.openwall.com/john/f/${MY_PBASE}.tar.gz
		ftp://ftp.openwall.com/john/contrib/historical/${MY_PNBASE}-1.7.2-all-7.diff.gz"

# banquise-to-bigpatch-17.patch.bz2"
# based off /var/tmp/portage/johntheripper-1.6.40

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ~mips ppc ppc64 sparc x86"
IUSE="mmx altivec sse2 custom-cflags"

RDEPEND=">=dev-libs/openssl-0.9.7"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${WORKDIR}"/${MY_PNBASE}-1.7.2-all-7.diff

	for p in sha1-memset stackdef.S stackdef-2.S mkdir-sandbox; do
		epatch "${FILESDIR}/${P}-${p}.patch"
	done
	epatch "${FILESDIR}/john-1.7.2_huge_wordlist.patch"
}

src_compile() {
	#
	# upstream request to strip
	# any flags, as he optimize the
	# outputs
	#
	use custom-cflags || strip-flags
	append-flags -fno-PIC -fno-PIE
	append-ldflags -nopie

	cd "${S}"/src

	# Remove default OPT_NORMAL -funroll-loops bug#198659 for unknown archs
	OPTIONS="CPP=$(tc-getCXX) CC=$(tc-getCC) AS=$(tc-getCC) LD=$(tc-getCC) \
		CFLAGS=\"-c -Wall ${CFLAGS} -DJOHN_SYSTEMWIDE \
		-DJOHN_SYSTEMWIDE_HOME=\\\"\\\\\\\"/etc/john\\\\\\\"\\\"\" \
		LDFLAGS=\"${LDFLAGS}\" \
		OPT_NORMAL=\"\""

	if use x86 ; then
		if use sse2 ; then
			eval emake ${OPTIONS} linux-x86-sse2 || die "Make failed"
		elif use mmx ; then
			eval emake ${OPTIONS} linux-x86-mmx || die "Make failed"
		else
			eval emake ${OPTIONS} linux-x86-any || die "Make failed"
		fi
	elif use alpha ; then
		eval emake ${OPTIONS} linux-alpha || die "Make failed"
	elif use sparc; then
		eval emake ${OPTIONS} linux-sparc  || die "Make failed"
	elif use amd64; then
		eval emake ${OPTIONS} linux-x86-64  || die "Make failed"
	elif use ppc64; then
		if use altivec; then
			eval emake ${OPTIONS} linux-ppc32-altivec  || die "Make failed"
		else
			eval emake ${OPTIONS} linux-ppc64  || die "Make failed"
		fi
		# linux-ppc64-altivec is slightly slower than linux-ppc32-altivec for most hash types.
		# as per the Makefile comments
	elif use ppc; then
		if use altivec; then
			eval emake ${OPTIONS} linux-ppc32-altivec  || die "Make failed"
		else
			eval emake ${OPTIONS} linux-ppc32 || die "Make failed"
		fi
	else
		eval emake ${OPTIONS} generic || die "Make failed"
	fi

	# currently broken
	#eval emake bench || die "make failed"
}

src_test() {
	cd run
	if  [ -f /etc/john/john.conf -o -f /etc/john/john.ini  ]; then
		./john --test || die 'self test failed'
	else
		ewarn "selftest requires /etc/john/john.conf or /etc/john/john.ini"
	fi
}

src_install() {
	# executables
	dosbin run/john
	newsbin run/mailer john-mailer

	pax-mark -m "${D}"/usr/sbin/john

	dosym john /usr/sbin/unafs
	dosym john /usr/sbin/unique
	dosym john /usr/sbin/unshadow

	# for EGG only
	dosym john /usr/sbin/undrop

	#newsbin src/bench john-bench

	# config files
	insinto /etc/john
	doins run/john.conf
	doins run/*.chr run/password.lst

	# documentation
	dodoc doc/*
}
