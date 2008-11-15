# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:

inherit eutils flag-o-matic multilib

DESCRIPTION="User-land utilities for LVM2 (device-mapper) software."
HOMEPAGE="http://sources.redhat.com/lvm2/"
SRC_URI="ftp://sources.redhat.com/pub/lvm2/${PN/lvm/LVM}.${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"

IUSE="readline static clvm cman gulm lvm1 selinux"

DEPEND=">=sys-fs/device-mapper-1.02.27
		clvm? ( >=sys-cluster/dlm-1.01.00
			cman? ( >=sys-cluster/cman-1.01.00 )
			gulm? ( >=sys-cluster/gulm-1.00.00 ) )"

RDEPEND="${DEPEND}
	!sys-fs/lvm-user
	!sys-fs/clvm"

S="${WORKDIR}/${PN/lvm/LVM}.${PV}"

pkg_setup() {
	use nolvmstatic && eerror "USE=nolvmstatic has changed to USE=static via package.use"
	use nolvm1 && eerror "USE=nolvm1 has changed to USE=lvm1 via package.use"
	append-ldflags -Wl,--no-as-needed
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/lvm.conf-2.02.36.patch
}

src_compile() {
	# Static compile of lvm2 so that the install described in the handbook works
	# http://www.gentoo.org/doc/en/lvm2.xml
	# fixes http://bugs.gentoo.org/show_bug.cgi?id=84463
	local myconf
	local buildmode

	# fsadm is broken, don't include it (2.02.28)
	myconf="${myconf} --enable-dmeventd --enable-cmdlib"

	# Most of this package does weird stuff.
	# The build options are tristate, and --without is NOT supported
	# options: 'none', 'internal', 'shared'
	if use static ; then
		einfo "Building static LVM, for usage inside genkernel"
		myconf="${myconf} --enable-static_link"
		buildmode="internal"
	else
		ewarn "Building shared LVM, it will not work inside genkernel!"
		buildmode="shared"
	fi

	# dmeventd requires mirrors to be internal, and snapshot available
	# so we cannot disable them
	myconf="${myconf} --with-mirrors=internal"
	myconf="${myconf} --with-snapshots=internal"

	if use lvm1 ; then
		myconf="${myconf} --with-lvm1=${buildmode}"
	else
		myconf="${myconf} --with-lvm1=none"
	fi

	# disable O_DIRECT support on hppa, breaks pv detection (#99532)
	use hppa && myconf="${myconf} --disable-o_direct"

	if use clvm; then
		myconf="${myconf} --with-cluster=${buildmode}"
		# 4-state! Make sure we get it right, per bug 210879
		# Valid options are: none, cman, gulm, all
		local clvmd=""
		use cman && clvmd="cman"
		use gulm && clvmd="${clvmd}gulm"
		clvmd="${clvmd/cmangulm/all}"
		[ -z "${clvmd}" ] && clvmd="none"
		myconf="${myconf} --with-clvmd=${clvmd}"
		myconf="${myconf} --with-pool=${buildmode}"
	else
		myconf="${myconf} --with-clvmd=none --with-cluster=none"
	fi

	myconf="${myconf} --sbindir=/sbin --with-staticdir=/sbin"
	if ! use static; then
		myconf="${myconf} --libdir=/lib"
	fi

	econf $(use_enable readline) \
		$(use_enable selinux) \
		--libdir=/usr/$(get_libdir) \
		${myconf} \
		CLDFLAGS="${LDFLAGS}" || die
	emake LIBS='-ldevmapper-event -ldl -llvm2cmd -lreadline -lrt' || die "compile problem"
}

src_install() {
	emake DESTDIR="${D}" install
	# TODO: At some point in the future, we need to stop installing the static
	# as the /sbin/lvm name, and have both variants seperate.
	if use static; then
		cp -f "${D}"/sbin/lvm.static "${D}"/sbin/lvm \
			|| die "Failed to copy lvm.static"
	fi

	dodir /$(get_libdir)
	# Put these in root so we can reach before /usr is up
	for i in libdevmapper-event-lvm2mirror liblvm2{format1,snapshot} ; do
		b="${D}"/usr/$(get_libdir)/${i}
		if [ -f "${b}".so ]; then
			mv -f "${b}".so* "${D}"/$(get_libdir) || die
		fi
	done

	dodoc README VERSION WHATS_NEW doc/*.{conf,c,txt}
	insinto /lib/rcscripts/addons
	newins "${FILESDIR}"/lvm2-start.sh-2.02.28-r2 lvm-start.sh || die
	newins "${FILESDIR}"/lvm2-stop.sh-2.02.37 lvm-stop.sh || die
	newinitd "${FILESDIR}"/lvm.rc-2.02.28-r2 lvm || die
	newconfd "${FILESDIR}"/lvm.confd-2.02.28-r2 lvm || die
	if use clvm; then
		newinitd "${FILESDIR}"/clvmd.rc-2.02.28-r3 clvmd || die
	fi

	elog "use flag nocman is deprecated and replaced"
	elog "with cman and gulm use flags."
	elog ""
	elog "use flags clvm,cman and gulm are masked"
	elog "by default and need to be unmasked to use them"
	elog ""
	elog "Rebuild your genkernel initramfs if you are using lvm"
	use nolvmstatic && \
		elog "USE=nolvmstatic has changed to USE=static via package.use"
	use nolvm1 && \
		elog "USE=nolvm1 has changed to USE=lvm1 via package.use"
}

pkg_postinst() {
	elog "lvm volumes are no longer automatically created for"
	elog "baselayout-2 users. If you are using baselayout-2, be sure to"
	elog "run: # rc-update add lvm boot"
	elog "Do NOT add it if you are using baselayout-1 still."
}

src_test() {
	einfo "Testcases disabled because of device-node mucking"
	einfo "If you want them, compile the package and see ${S}/tests"
}
