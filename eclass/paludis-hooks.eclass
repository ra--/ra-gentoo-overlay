# Copyright
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Authors of this eclass:
# ----------------------
# zxy, samlt, creidiki
# big contributor: dleverton

# For help and usage instructions see:
# ------------------------------------
# * ebuild homepage:
#	http://drzile.dyndns.org/pe-doc/

# * Paludis Support Thread on Gentoo Forums:
#	http://forums.gentoo.org/viewtopic-t-518298.html

# * Paludis Wiki:
#	http://gentoo-wiki.com/HOWTO_Use_Portage_alternative_-_Paludis

RESTRICT="primaryuri"

HOMEPAGE="http://drzile.dyndns.org/pe-doc"

SRC_URI="mirror://paludis-extras/${P}.tar.bz2 mirror://niki/${P}.tar.bz2 mirror://zxy/${P}.tar.bz2"

LICENSE="GPL-2"

SLOT="0"

IUSE="paludis_hooks_eselect"

VERSION="-${NEED_PALUDIS:-0.24.0}"

DEPEND=">=sys-apps/paludis${VERSION}
		paludis_hooks_eselect? ( app-admin/eselect-paludis-hooks )"

RDEPEND="${DEPEND}"

if [[ -z "${HOOK_NAME}" ]]; then
	HOOK_NAME="${PN##paludis-hooks-}"
fi

dohook() {
	local hookfile="${1}"
	local hookname="${hookfile##*/}"
	local hooksdir="/usr/share/paludis/hooks"
	local esdfn="${PN##*paludis-hooks-}"
	local esf="${WORKDIR}/${esdfn}"

	shift

	dodir "${hooksdir}/common" || die "dodir failed"
	exeinto "${hooksdir}/common" || die "exeinto failed"
	doexe "${hookfile}" || die "doins failed"
	if use paludis_hooks_eselect ; then
		echo "# eselect definition file for ${P}" >> ${esf}
		echo "common/${hookname} ${@}" >> ${esf}

		insinto "${hooksdir}/eselect" || die "insinto failed"
		doins "${esf}" || die "doins failed"
	else
		for hooktype in "$@"; do
			dodir "${hooksdir}/${hooktype}" || die "dodir failed"
			dosym "${hooksdir}/common/${hookname}" "${hooksdir}/${hooktype}" || die "dosym failed"
		done
	fi
}

dohookconf() {
	insinto "/etc/paludis/hooks/config" || die "insinto failed"
	doins "${1}" || die "doins failed"
}

paludis-hooks-disable() {
	einfo "Using eselect to disable the hook: ${HOOK_NAME}"
	eselect paludis-hook disable "${HOOK_NAME}" || die "eselect disable failed"
}

paludis-hooks-enable() {
	einfo "Using eselect to enable the hook: ${HOOK_NAME}"
	eselect paludis-hook enable "${HOOK_NAME}" || die "eselect enable failed"
}

paludis-hooks-get-status() {
	if [[ "$(eselect paludis-hook list | grep -c "${HOOK_NAME}.*enabled")" != "0" ]]; then
		HOOK_STATUS="enabled"
	elif [[ "$(eselect paludis-hook list | grep -c "${HOOK_NAME}.*disabled")" != "0" ]]; then
		HOOK_STATUS="disabled"
	fi
}

paludis-hooks-clean-symlinks() {
	ebegin "Looking for stray hook symlinks"
	pushd "${ROOT}/usr/share/paludis/hooks" &>/dev/null
	for hookdir in "$(ls)"; do
		if [[ -d "${hookdir}" ]]; then
			for hookfile in "$(ls ${hookdir})"; do
				if [[ -L "${hookdir}/${hookfile}" && ! -e "${hookdir}/${hookfile}" ]]; then
					einfo " found ${hookdir}/${hookfile}"
					rm "${hookdir}/${hookfile}"
				fi
			done
		fi
	done
	popd &>/dev/null
}

#
# Standard function redefintions
#

paludis-hooks_pkg_setup() {
	ewarn "Unfortunaly, Paludis only reads hook file locations at startup."
	ewarn "If paludis reports errors with hooks and fails, simply resuming"
	ewarn "the interrupted installation should fix the problem."
	ewarn "We apologize for the inconvenience."
	if use paludis_hooks_eselect ; then
		paludis-hooks-get-status
		if [[ "${HOOK_STATUS}" == "enabled" ]]; then
			paludis-hooks-disable
		fi
		if [[ -n "${HOOK_STATUS}" ]]; then
			HOOK_INSTALLED="true"
		fi
	fi
	paludis-hooks-clean-symlinks
}

paludis-hooks_pkg_postinst() {
	if use paludis_hooks_eselect && \
		[[ "${HOOK_STATUS}" != "disabled" ]]; then
		paludis-hooks-enable
	fi
	paludis-hooks-clean-symlinks
}

paludis-hooks_pkg_prerm() {
	if use paludis_hooks_eselect ; then
		if [[ -z "${HOOK_INSTALLED}" ]];then
			paludis-hooks-get-status
			if [[ "${HOOK_STATUS}" == "enabled" ]]; then
				paludis-hooks-disable
			fi
		fi
	fi
	paludis-hooks-clean-symlinks
}

EXPORT_FUNCTIONS pkg_setup pkg_postinst pkg_prerm
