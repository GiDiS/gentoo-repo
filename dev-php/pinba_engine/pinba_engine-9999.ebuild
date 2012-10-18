# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools confutils eutils git-2

DESCRIPTION="Pinba is a realtime monitoring/statistics server for PHP using MySQL as a read-only interface"
HOMEPAGE="http://pinba.org/wiki/Main_Page"
LICENSE="GPL"
SLOT="0"

EGIT_REPO_URI="git://github.com/tony2001/pinba_engine.git"

KEYWORDS="~x86 ~amd64"

DEPEND="
    dev-libs/protobuf
    dev-libs/libevent
    dev-libs/judy
    >=virtual/mysql-5.1
"
RDEPEND="${DEPEND}"

pkg_setup() {
    MYSQL_PLUGINDIR="$(mysql_config --plugindir)"
    MYSQL_PACKAGE="$(best_version "dev-db/mysql" || best_version "dev-db/mariadb")";
    MYSQL_SOURCES="${PORTAGE_TMPDIR}/portage/${MYSQL_PACKAGE}/work/mysql"

    einfo "Current mysql installation: ${MYSQL_PACKAGE}"
    einfo "Try use ${MYSQL_SOURCES} as mysql sources"
    if [[ ! -d "${MYSQL_SOURCES}" ]]; then
        eerror "Can't find mysql sources. Please, rebild mysql with FEATURES=\"keepwork\""
        die "Can't find mysql sources"
    fi
}

src_configure() {
    buildconf.sh
    econf --with-mysql="${MYSQL_SOURCES}" \
          --with-judy=/usr \
          --with-protobuf=/usr \
          --with-event=/usr \
          --libdir="${MYSQL_PLUGINDIR}"
}

src_install() {
    emake install DESTDIR="${D}" || die "emake install failed"
    dodir /usr/share/pinba/
    insinto /usr/share/pinba/
    doins default_tables.sql
}

pkg_postinst() {
    einfo "You need to execute the following command on mysql server"
    einfo "so pinba works properly:"
    elog "mysql> INSTALL PLUGIN pinba SONAME 'libpinba_engine.so';"
    elog "mysql> CREATE DATABASE pinba;"
    elog "mysql -D pinba < /usr/share/pinba/default_tables.sql"
}

