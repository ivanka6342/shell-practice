
ARCHIVES=" package1_0-1.1.1.default.zip package2_0-2.2.2.default.zip package3_0-3.3.3.default.zip "
BLD_OPT='Verbose=yes'
SERVER_WD='/home/builduser/workdir'
SERVER_REPO="${SERVER_WD}/myrepo"
SERVER_TMP="${SERVER_WD}/tmp"
BUILD_DIR="${SERVER_REPO}/builddir/pack/"
HASHES_FILE="${SERVER_TMP}/pkghash.txt"


function clean_pkgs {
    for tar in $ARCHIVES; do
        short_filter="$(echo $tar | cut -d'_' -f1)"
        make ${BLD_OPT} clean $short_filter
        make ${BLD_OPT} cleanmeta $short_filter
    done
}


function build_n_pack_pkgs {
    for tar in $ARCHIVES; do
        short_filter="$(echo $tar | cut -d'_' -f1)"
        make ${BLD_OPT} build $short_filter
        make ${BLD_OPT} deploy $short_filter
    done
}


function prepare_sha1 {
    cd $BUILD_DIR

    pkgs_full=" "
    pkg_archives=" "
    pkg_sha1_hashes=" "

    for tar in $ARCHIVES; do
        if [ ! -f $tar ]; then
            continue
        fi
        str=$(sha1sum $tar | cut -d. -f-4)
        sha1_sum=$(echo $str | cut -d' ' -f1)
        short_filter="$(echo $tar | cut -d'_' -f1)"
        pkg_name=$(echo $str | egrep -o "$short_filter.*")

        pkgs_full="${pkgs_full}${tar} "
        pkg_archives="${pkg_archives}${pkg_name} "
        pkg_sha1_hashes="${pkg_sha1_hashes}${sha1_sum} "
        cp $tar ${SERVER_TMP}/
    done

    echo "PKGS_FULL='$pkgs_full'" > $HASHES_FILE
    echo "PKG_ARCHIVES='$pkg_archives'" >> $HASHES_FILE
    echo "PKG_SHA1_HASHES='$pkg_sha1_hashes'" >> $HASHES_FILE
}



####################
# start of execution
####################

cd $SERVER_REPO

clean_pkgs
build_n_pack_pkgs
prepare_sha1

