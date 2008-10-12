# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/glest/glest-2.0.1.ebuild,v 1.2 2007/11/21 04:19:03 dirtyepic Exp $

inherit autotools eutils games

L_URI="http://www.glest.org/files/contrib/translations"
L_PV="3.0.0"
DESCRIPTION="Cross-platform 3D realtime strategy game"
HOMEPAGE="http://www.glest.org/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-source-${PV}.tar.bz2
	mirror://sourceforge/${PN}/${PN}_data_${PV}.zip
	linguas_de? ( ${L_URI}/german_${L_PV}.zip )
	linguas_el? ( ${L_URI}/greek_${L_PV}.zip )
	linguas_hu? ( ${L_URI}/magyar_${PV}.zip )
	linguas_it? ( ${L_URI}/italiano_${L_PV}.zip )
	linguas_pt_BR? ( ${L_URI}/portugues-brazil_${L_PV}.zip )
	linguas_fr? ( ${L_URI}/francais_${L_PV}-alpha4.zip )"

LICENSE="GPL-2 glest-data"
SLOT="0"
KEYWORDS="~amd64 -ppc ~x86" # ppc: bug #145478
IUSE="linguas_de linguas_el linguas_hu linguas_it linguas_fr linguas_pt_BR editor"

RDEPEND=">=media-libs/libsdl-1.2.5
	media-libs/libogg
	media-libs/libvorbis
	media-libs/openal
	dev-libs/xerces-c
	virtual/opengl
	virtual/glu
	x11-libs/libX11
	x11-libs/libXt
	media-fonts/font-adobe-utopia-75dpi
	editor? ( >=x11-libs/wxGTK-2.6 )"
DEPEND="${RDEPEND}
	app-arch/unzip
	|| ( dev-util/jam dev-util/ftjam )"

S=${WORKDIR}

GAMES_USE_SDL="nojoystick"

src_unpack() {
	unpack ${A}
	cd "${S}/${PN}-source-${PV}"

	local file
	for file in $(find glest_game glest_map_editor mk -type f) ; do
		edos2unix "${file}"
	done

	sed -i \
		-e "s:GENTOO_DATADIR:${GAMES_DATADIR}/${PN}:" \
		glest_game/main/main.cpp \
		|| die "sed main.cpp failed"

	# we change configure.ac, so rebuild
	chmod a+x autogen.sh
	./autogen.sh || die "autogen failed" # FIXME: use autotools.eclass

	sed -i 's:-O3 -g3::' Jamrules || die "sed Jamrules failed"
}

src_compile() {
	cd "${S}/${PN}-source-${PV}"
	egamesconf \
		--with-vorbis=/usr \
		--with-ogg=/usr \
		|| die
	jam -q || die "jam failed"
}

src_install() {
	cd "${S}/${PN}-source-${PV}"
	dogamesbin glest || die "dogamesbin failed"
	if use editor; then
		into ${GAMES_PREFIX}
		dobin glest_editor || die "dogamesbin editor failed"
	fi

	insinto "${GAMES_DATADIR}"/${PN}
	doins glest.ini || die "doins glest.ini failed"
	dodoc README.linux

	cd "${S}/glest_game"
	doins -r data maps scenarios techs tilesets || die "doins data failed"
	dodoc docs/readme.txt

	make_desktop_entry glest Glest /usr/share/pixmaps/${PN}.bmp
	newicon techs/magitech/factions/magic/units/archmage/images/archmage.bmp \
		${PN}.bmp

	dolang() {
		insinto "${GAMES_DATADIR}"/${PN}/data/lang
		doins "${WORKDIR}"/${1} || die "doins ${1} failed"
	}

	cd "${S}"
	use linguas_de && dolang german.lng
	use linguas_hu && dolang magyar_${PV}.lng
	use linguas_it && dolang italiano.lng
	use linguas_fr && dolang francais.lng
	use linguas_el && dolang greek.lng
	use linguas_pt_BR && dolang pt-BR.lng

	prepgamesdirs
}
