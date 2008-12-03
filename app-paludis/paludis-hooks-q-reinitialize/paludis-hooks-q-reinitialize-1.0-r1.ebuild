# Copyright
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Author of hook: samlt, creidiki

NEED_PALUDIS="0.26_alpha13"

inherit paludis-hooks

DESCRIPTION="q-reinitialize hook for use with patched portage utils"

KEYWORDS="~amd64 ~x86 ~sparc ~x86-fbsd"

DEPEND=">=app-portage/portage-utils-20070504-r3"
RDEPEND="${DEPEND}"

src_install() {
	dohook q-reinitialize.hook auto
}

