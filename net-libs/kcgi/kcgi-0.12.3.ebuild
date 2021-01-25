# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multiprocessing toolchain-funcs

DESCRIPTION="minimal CGI library for web applications"
HOMEPAGE="https://kristaps.bsd.lv/kcgi/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/kristapsdz/kcgi"
else
	SRC_URI="https://kristaps.bsd.lv/kcgi/snapshots/${P}.tgz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="ISC"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="sys-devel/bmake"
DEPEND="
	test? ( net-misc/curl[static-libs] )
"

src_configure() {
	./configure PREFIX="${EPREFIX}/usr" \
		MANDIR="${EPREFIX}/usr/share/man" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		SBINDIR="${EPREFIX}/usr/bin" || die
}

src_compile() {
	bmake -j$(makeopts_jobs) \
		CC="$(tc-getCC)" || die
}

src_test() {
	bmake -j$(makeopts_jobs) \
		CC="$(tc-getCC)" regress || die
}

src_install() {
	bmake -j$(makeopts_jobs) \
		CC="$(tc-getCC)" \
		DESTDIR="${D}" \
		MANDIR=/usr/share/man \
		install || die
}
