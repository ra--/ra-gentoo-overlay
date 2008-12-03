# Copyright
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Author of hook: log-mailer
# --------------------------------------
# pilx

inherit eutils paludis-hooks

DESCRIPTION="Sends Paludis elog messages via email."

KEYWORDS="~amd64 ~x86 ~sparc"

src_install() {
	dodir /etc/paludis/hooks/config
	insinto /etc/paludis/hooks/config || die "log-mailer.conf: insinto failed"
	doins log-mailer.conf || die "log-mailer.conf: doins failed"

	dodir /usr/share/paludis/hooks/common
	exeinto /usr/share/paludis/hooks/common || die "log-mailer-send.py: exeinto failed"
	doexe log-mailer-send.py || die "log-mailer.py: doexe failed"

	dohook log-mailer.bash elog einfo ewarn eerror install_post
}
