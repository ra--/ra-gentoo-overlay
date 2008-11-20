# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libkdcraw/libkdcraw-0.1.1.ebuild,v 1.5 2007/09/30 13:10:15 pylon Exp $

inherit kde

IUSE=""
DESCRIPTION="KDE Image Plugin Interface: a dcraw library wrapper"
HOMEPAGE="http://www.kipi-plugins.org"
SRC_URI="mirror://sourceforge/kipi/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc sparc x86"

RDEPEND="media-gfx/dcraw"
DEPEND="${RDEPEND}"

need-kde 3.5
