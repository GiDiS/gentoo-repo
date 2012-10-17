# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools confutils eutils multilib


SRC_URI="http://pinba.org/files/pinba_engine-${PV}.tar.gz"

KEYWORDS="~amd64"

DESCRIPTION="Pinba is a realtime monitoring/statistics server for PHP using MySQL as a read-only interface"
HOMEPAGE="http://pinba.org/wiki/Main_Page"
LICENSE="GPL"
SLOT="0"

DEPEND="dev-libs/protobuf
    >=dev-libs/libevent-1.4.0
    >=dev-libs/judy-1.0.4
    >=virtual/mysql-5.1
"
RDEPEND="${DEPEND}"

pkg_setup() {
	MYSQL_ATOM="dev-db/mysql"
	MYSQL_PLUGINDIR="$(mysql_config --plugindir)"
	MYSQL_INCLUDE="$(mysql_config --include)"
	MYSQL_PACKAGE="$(best_version $MYSQL_ATOM)";
	MYSQL_EBUILD="${PORTDIR}/${MYSQL_PACKAGE/mysql/mysql/mysql}.ebuild"
	ewarn ${MYSQL_EBUILD}
#	ebuild "${MYSQL_EBUILD}" prepare
}

src_prepare() {
    sed -i -e 's|HEADERS="include/my_dir.h include/mysql/plugin.h include/mysql.h include/mysql_version.h"|HEADERS="my_dir.h plugin.h mysql.h mysql_version.h"|' configure.in
    sed -i -e 's|HEADERS="include/my_dir.h include/mysql/plugin.h include/mysql.h include/mysql_version.h"|HEADERS="my_dir.h plugin.h mysql.h mysql_version.h"|' configure
    sed -i -e 's|$with_mysql/include|$with_mysql|' configure
    sed -i -e 's|$with_mysql/include|$with_mysql|' configure.in

    sed -i -e 's|include/mysql_version.h|mysql_version.h|' \
           -e 's|mysql/plugin.h|plugin.h|' src/ha_pinba.cc
}

src_configure() {
  econf --with-mysql="${MYSQL_INCLUDE#-I}" \
        --with-judy=/usr \
        --with-protobuf=/usr \
        --with-event=/usr \
        --libdir="${MYSQL_PLUGINDIR}"
}

src_install() {
    cd pinba_engine-${PV}
    emake install DESTDIR="${D}" || die "emake install failed"
    dodir /usr/share/pinba/
    insinto /usr/share/pinba/
    doins default_tables.sql
}

pkg_postinst() {
    ebuild "${MYSQL_EBUILD}" clean

    einfo "You need to execute the following command on mysql server"
    einfo "so pinba works properly:"
    elog "mysql> INSTALL PLUGIN pinba SONAME 'libpinba_engine.so';"
    elog "mysql> CREATE DATABASE pinba;"
    elog "mysql -D pinba < /usr/share/pinba/default_tables.sql"
}


