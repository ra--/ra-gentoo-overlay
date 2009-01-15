# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Author of hook: collision-protect
# ----------------------------------
# dleverton

NEED_PALUDIS="0.26_alpha13"

inherit paludis-hooks

DESCRIPTION="Hook collision-protect provides collision protect functionality for Paludis."

KEYWORDS="~amd64 ~x86 ~sparc"
IUSE=''
DEPEND=''
RDEPEND=''

src_install() {
	dohook collision-protect.hook auto
}
