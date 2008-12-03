# Copyright
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PALUDIS="0.26_alpha13"

inherit eutils paludis-hooks

DESCRIPTION="Hook update-eix makes eix work with Paludis."

KEYWORDS="~amd64 ~x86 ~sparc ~x86-fbsd"

DEPEND="app-portage/eix"

RDEPEND="${DEPEND}"


src_install() {
        epatch "${FILESDIR}/${PV}/${P}-fix-name.patch"

        dodir /etc/paludis/hooks/config
        insinto /etc/paludis/hooks/config || die "update-eix.conf: insinto failed"
        doins update-eix.conf || die "update-eix.conf: doins failed"

        dohook update-eix.hook auto
}

