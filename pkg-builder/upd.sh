# PKG_ARCHIVES=" package1_0-1.1.1.default.zip package2_0-2.2.2.default.zip package3_0-3.3.3.default.zip "
# PKG_SHA1_HASHES=" sha1sum-1 sha1sum-2 sha1sum-3 "

PKG_NAME=""
PKG_ARCHIVE=""
SHA1SUM=""
DIR='/srv/instdir/'
UPD_METHOD="local"
SCRIPT_NAME=`basename $0`


function usage {
	echo "usage: ./upd.sh <PKG-NAME> <sha1sum>";
	echo "usage: ./upd.sh -m sd";
	echo "usage: ./upd.sh -m sd <PKG-NAME> <sha1sum>";
	echo "usage: ./upd.sh package1_0-1.1.1.default 3e8fd2b7e34eb6ce7ac6e0a2bf2c0b2170a7483d";
}


function parse_options {
    if [ "$#" -lt 1 ]; then
        echo "$0: missing operand"
        echo "Try './$0 --help' for more information"
        exit
    fi

    while [ -n "$1" ]; do
        case "$1" in
            -h|--help)
                usage
                ;;
            -m|--upd-method)
                shift
                UPD_METHOD="$1"
                ;;
            -p|--package)
                shift
                PKG_NAME="$1"
                ;;
            -c|--check)
                shift
                SHA1SUM="$1"
                ;;
            *)
				# default for local - with no flags
				PKG_NAME="$1"
				SHA1SUM="$2"
				exit
                ;;
        esac
        shift
    done
}


function update {
	PKG_NAME=$1
	PKG_ARCHIVE="${PKG_NAME}.zip"
	SHA1SUM=$2
	echo "update PKG_ARCHIVE: $PKG_ARCHIVE SHA1SUM: $SHA1SUM"

	rm -f /var/run/psm-instpkg.fatal
	cp ${PKG_ARCHIVE} ${DIR}

	BASE_NAME="$(echo ${PKG_NAME} | cut -d_ -f1)"
	PKG_LINK="/Packages/${BASE_NAME}_0"

	OLD_PKG=$(find /Packages/ -type d -name "${BASE_NAME}*" -maxdepth 1)
	OLD_PKG_MV="/Packages/${BASE_NAME}_0-0.0.1.default"

	rm ${PKG_LINK}
	mv ${OLD_PKG} ${OLD_PKG_MV}
	ln -s ${OLD_PKG_MV} ${PKG_LINK}

	cd ${DIR}
	psm-instpkg ${PKG_ARCHIVE} ${SHA1SUM}
}


function check_hash {
	PKG_ARCHIVE=$1
	SHA1SUM=$2

	if [ "$SHA1SUM" = "$(openssl dgst -sha1 ${PKG_ARCHIVE} | cut -f2 -d' ')" ]; then
		echo "check hashsum - OK"
		return 0
	else
		exit 1
	fi
}


function mount_n_copy {
	FILE=$1

	mount /dev/sda1 /mnt/
	cp /mnt/${FILE} ./
	umount /dev/sda1
}


function main {
	if [ "$UPD_METHOD" = "ssh" ] ; then
		# for ssh this arrays must be already included in current script
		if [ -z "$PKG_ARCHIVES" ] || [ -z "$PKG_SHA1_HASHES" ] ; then
			echo "ssh upd fail OR SD card way choosen"
			exit 1
		fi

		for name in $PKG_ARCHIVES ; do
			PKG_NAME="$name"
			PKG_ARCHIVE="${PKG_NAME}.zip"

			for hash in $PKG_SHA1_HASHES ; do
				SHA1SUM="$hash"
				check_hash $PKG_ARCHIVE $SHA1SUM
				if [ $? ] ; then
					echo "run ssh upd"
					update $PKG_NAME $SHA1SUM
				fi
			done
		done
		exit 1 # if we achieved this point this is bad

	elif [ "$UPD_METHOD" = "local" ] || [ ! -z "$PKG_NAME" ] || [ ! -z "$SHA1SUM" ] ; then
		PKG_ARCHIVE="${PKG_NAME}.zip"
		check_hash $PKG_ARCHIVE $SHA1SUM
		if [ $? ] ; then
			echo "run ssh upd"
			update $PKG_NAME $SHA1SUM
		fi

	elif [ "$UPD_METHOD" = "sd" ] ; then
		# first start - copy new script
		if [ -z "$PKG_NAME" ] || [ -z "$PKG_ARCHIVES" ] || [ -z "$PKG_SHA1_HASHES" ] ; then
			mount_n_copy $SCRIPT_NAME
			echo "script updated. now restart script manually to update the package: $SCRIPT_NAME -m sd"
		fi

		for name in $PKG_ARCHIVES ; do
			PKG_NAME="$name"
			PKG_ARCHIVE="${PKG_NAME}.zip"
			mount_n_copy $PKG_ARCHIVE

			for hash in $PKG_SHA1_HASHES ; do
				SHA1SUM="$hash"
				check_hash $PKG_ARCHIVE $SHA1SUM
				if [ $? ] ; then
					echo "run sd upd"
					update $PKG_NAME $SHA1SUM
				fi
			done
		done
		exit 1 # if we achieved this point this is bad

	else
		usage
		exit 1;
	fi
}



####################
# start of execution
####################

cd `dirname $0`
clear
parse_options $@
main






