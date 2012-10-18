# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
PHP_EXT_NAME="pinba"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="NEWS README CREDITS"
USE_PHP="php5-3 php5-4"

inherit php-ext-source-r2 git-2

DESCRIPTION="Pinba is a realtime monitoring/statistics server for PHP using MySQL as a read-only interface"
HOMEPAGE="http://pinba.org/"

EGIT_REPO_URI="git://github.com/tony2001/pinba_extension.git"

LICENSE="PHP-3"

SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="engine"

DEPEND="
    dev-lang/php
    dev-libs/protobuf
    engine? ( dev-php/pinba_engine )
"
RDEPEND="${DEPEND}"

my_conf="--with-pinba"

src_install() {
    php-ext-source-r2_src_install
    php-ext-source-r2_addtoinifiles "pinba.enabled" "1"
    php-ext-source-r2_addtoinifiles ";pinba.server" "localhost"
}