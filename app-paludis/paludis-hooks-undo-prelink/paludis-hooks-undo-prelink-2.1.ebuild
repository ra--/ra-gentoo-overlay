# Copyright
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Author of hook: undo-prelink
# --------------------------------------
# dleverton

inherit paludis-hooks

DESCRIPTION="Hook undo-prelink prevents Paludis from leaving prelinked binaries lying around (because it thinks they've been modified) when you uninstall the package."

KEYWORDS="~amd64 ~x86 ~sparc"

DEPEND="sys-devel/prelink"

RDEPEND="${DEPEND}"

src_install() {
	dohook undo-prelink.bash install_post install_fail merger_check_pre unmerger_unlink_pre
}
