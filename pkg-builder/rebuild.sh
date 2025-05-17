
SERVER_SSH="BuildServer"
SERVER_WD='/home/builduser/workdir'
SERVER_TMP="${SERVER_WD}/tmp"
BLD_SCRIPT_NAME="bld.sh"
HASHES_FILE="pkghash.txt"

SD_MNT_BASE='/media/user1/'

BLD_METHOD="server"
UPD_METHOD="ssh"

# change if update via SSH - not via SD-card + serial console
# add this to arguments if non-default
USER='root'
PASS='root'
TARGET_IP='192.168.100.17'
DIR='/var/psm/tmp'

TARGET_SYS_PATH="/root"
UPD_SCRIPT_NAME="upd.sh"


function usage {
cat <<EOF
Usage : $0 [-b server|local] [-m ssh|sd] [-c SD-card]
This script is designed to update packages for you

Options:
    -h (--help)                     show help page and exit
    -b (--bld-method)   BLD_METHOD  method to build packages (server default)
    -m (--upd-method)   UPD_METHOD  method to update packages after build done (ssh default)
    -c (--card)         PATH        SD-card mount path
    -u (--user)         USER        SSH user (root default)
    -p (--pass)         PASS        SSH password (root default)
    -i (--ip)           TARGET_IP   SSH device ip (192.168.1.1 default)

Example:    ./$0 -m ssh
            ./$0 ssh
            ./$0 -u admin -p Secret-Phrase123
            ./$0 -m sd -c /media/user1/
EOF
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
            -b|--bld-method)
                shift
                BLD_METHOD="$1"
                ;;
            -m|--upd-method)
                shift
                UPD_METHOD="$1"
                ;;
            -c|--card)
                shift
                SD_MNT_BASE=$1
                ;;
            -u|--user)
                shift
                USER=$1
                ;;
            -p|--pass)
                shift
                PASS=$1
                ;;
            -i|--ip)
                shift
                TARGET_IP=$1
                ;;
            *)
                UPD_METHOD="$1"
                ;;
        esac
        shift
    done
}


function prepare_upd_script {
    # create arrays of sha1 and filenames and prepend it to upd script

    scp ${SERVER_SSH}:${SERVER_TMP}/${HASHES_FILE} ./tmp/
    pkg_archive=`grep PKGS_FULL ./tmp/${HASHES_FILE} | cut -f2 -d' '`
    scp ${SERVER_SSH}:${SERVER_TMP}/${pkg_archive} ./tmp/

    TMPFILE=`mktemp /tmp/${UPD_SCRIPT_NAME}.XXXXXX`
    cat ./tmp/$HASHES_FILE > $TMPFILE
    # orig upd script
    cat ./$UPD_SCRIPT_NAME >> $TMPFILE

    # prepared copy of upd script
    cp $TMPFILE ./tmp/$UPD_SCRIPT_NAME
    chmod 755 ./tmp/$UPD_SCRIPT_NAME
    rm $TMPFILE
}


function ssh_to_target_cmd {
    command="$1"
    result="$2"

    expect -i <<EOF
        spawn ${command}
        set timeout 10
        expect {
            "${USER}@${TARGET_IP}'s password: " { send "${PASS}\r\n"; exp_continue }
            "100%" { puts "\ncommand done\n\r" }
            timeout { puts "SCP - TIME OUT\n"; close; exit 1 }
        }
        close;
EOF
}


function upd_via_ssh {
    ssh-keygen -R "$TARGET_IP"

    # copy upd script to target via ssh
    ssh_to_target_cmd "scp -o StrictHostKeyChecking=accept-new ./tmp/${UPD_SCRIPT_NAME} ${USER}@${TARGET_IP}:${TARGET_SYS_PATH}/" "${UPD_SCRIPT_NAME}"

    # copy package archive to target via ssh
    pkg_archive=`grep PKGS_FULL ./tmp/${HASHES_FILE} | cut -f2 -d' '`
    ssh_to_target_cmd "scp -o StrictHostKeyChecking=accept-new ./tmp/${pkg_archive} ${USER}@${TARGET_IP}:${TARGET_SYS_PATH}/" "${pkg_archive}"

    ssh_to_target_cmd "ssh -o StrictHostKeyChecking=accept-new '${TARGET_SYS_PATH}/${UPD_SCRIPT_NAME} -m ssh > /root/upd.log'" "done"
}


function upd_via_sd_card {
    flash_name="$(ls $SD_MNT_BASE)"
    if [ -z "$flash_name" ]; then
        echo "no flash card"
        exit 1
    fi

    flash_dir="${SD_MNT_BASE}${flash_name}"
    cp ./tmp/${UPD_SCRIPT_NAME} $flash_dir/
    pkg_archive=`grep PKGS_FULL ./tmp/${HASHES_FILE} | cut -f2 -d' '`
    cp ./tmp/${pkg_archive} $flash_dir/
}


function build {
    if [ "$BLD_METHOD" = "server" ]; then
        echo "build on the server"
        scp ./${BLD_SCRIPT_NAME} ${SERVER_SSH}:${SERVER_TMP}/
        ssh ${SERVER_SSH} "${SERVER_TMP}/${BLD_SCRIPT_NAME}"
    elif [ "$BLD_METHOD" = "local" ]; then
        echo "build locally"
        # run local build
        # ./${BLD_SCRIPT_NAME}
    fi
}


function update {
    if [ "$UPD_METHOD" = "ssh" ]; then
        echo "update via ssh"
        upd_via_ssh
    elif [ "$UPD_METHOD" = "sd" ]; then
        echo "update via sd-card"
        upd_via_sd_card
    fi
}



####################
# start of execution
####################
cd `dirname $0`
mkdir -p tmp
clear
parse_options $@

build
prepare_upd_script
update
