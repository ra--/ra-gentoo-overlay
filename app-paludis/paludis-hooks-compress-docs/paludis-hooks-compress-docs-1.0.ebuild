# Copyright (C) 2008 Daniel J Reidy <dubkat@gmail.com>
# Distributed under the terms of the GNU General Public License v2
# $Id: paludis-hooks-compress-docs-1.0.ebuild 46 2008-03-17 20:50:07Z dubkat $

# Based on compress-man by pdouble
# -----------------------------

# Author of this ebuild:
# ----------------------
# dubkat

inherit eutils paludis-hooks

DESCRIPTION="Hook compresses docs if the package itself does not."
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~sparc ~x86-fbsd"

DEPEND="${DEPEND}
    >=sys-apps/paludis-0.20.0
	app-admin/eselect
	app-misc/symlinks"

RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
}
src_install() {
	dohook compress-docs.bash ebuild_install_post
}
