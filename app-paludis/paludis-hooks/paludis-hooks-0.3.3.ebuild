# Copyright
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Authors of hooks:
# -----------------
# ask : zxy, truc
# check-security-updates:
# collision-protect : dlverton
# compress-man : pdouble
# nice : zxy
# undo-prelink : dlverton
# update-eix : truc, pioto
# sync-disks : zxy

# Author of this ebuild:
# ----------------------
# zxy, truc, dleverton(eclass)

# For help and usage instructions see:
# ------------------------------------
# * ebuild homepage:
#	http://drzile.dyndns.org/pe-doc/

# * Paludis Support Thread on Gentoo Forums:
#	http://forums.gentoo.org/viewtopic-t-518298.html

# * Paludis Wiki:
#	http://gentoo-wiki.com/HOWTO_Use_Portage_alternative_-_Paludis


inherit eutils paludis-hooks

DESCRIPTION="This is a collection of various hooks used with Paludis."

SRC_URI=""

KEYWORDS="~amd64 ~x86 ~sparc"

IUSE="${IUSE} paludis_hooks_ask"
IUSE="${IUSE} paludis_hooks_eselect"
IUSE="${IUSE} paludis_hooks_check-security-updates"
IUSE="${IUSE} paludis_hooks_collision-protect"
IUSE="${IUSE} paludis_hooks_compress-man"
IUSE="${IUSE} paludis_hooks_nice"
IUSE="${IUSE} paludis_hooks_undo-prelink"
IUSE="${IUSE} paludis_hooks_update-eix"
IUSE="${IUSE} paludis_hooks_sync-disks"

DEPEND="!sys-apps/paludis-hooks
	${DEPEND}
	paludis_hooks_check-security-updates? ( app-paludis/paludis-hooks-check-security-updates )
	paludis_hooks_compress-man? ( app-paludis/paludis-hooks-compress-man )
	paludis_hooks_collision-protect? ( app-paludis/paludis-hooks-collision-protect )
	paludis_hooks_eselect? ( app-admin/eselect-paludis-hooks )
	paludis_hooks_undo-prelink? ( app-paludis/paludis-hooks-undo-prelink )
	paludis_hooks_update-eix? ( app-paludis/paludis-hooks-update-eix )
	paludis_hooks_nice? ( app-paludis/paludis-wrapper )
	paludis_hooks_ask? ( app-paludis/paludis-hooks-ask )
	paludis_hooks_sync-disks? ( app-paludis/paludis-hooks-sync-disks ) "

RDEPEND="${DEPEND}"


pkg_postinst() {
	true
}
