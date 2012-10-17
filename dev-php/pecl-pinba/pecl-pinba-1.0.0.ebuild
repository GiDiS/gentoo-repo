# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PHP_EXT_NAME="pinba"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"


USE_PHP="php5-4"
inherit php-ext-pecl-r2


SRC_URI="http://pinba.org/files/pinba_extension-${PV}.tgz"

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Pinba is a realtime monitoring/statistics server for PHP using MySQL as a read-only interface"
LICENSE="PHP-3"
SLOT="0"
IUSE="engine"

DEPEND="dev-libs/protobuf
engine? ( dev-php/pinba_engine )
"
RDEPEND="${DEPEND}"

my_conf="--with-pinba=/usr"