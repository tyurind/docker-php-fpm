#!/bin/sh

FILE_LOCK=/etc/init-worker.lock
FILE_WORKNAME=/etc/workuser

# SUDO_UID=1000

# create user
#
# Usage:
#
#     su_useradd <user_name> <user_home>
#
su_useradd()
{
    local user_name=$1
    local user_home=$2

    useradd  --user-group --shell /bin/bash --create-home -r -d "${user_home}" "${user_name}"
    rm -f "/home/${user_home}/.bash_history"

    # chown -R "root:${user_name}" "${user_home}"
    chmod -R g+w "${user_home}"
}


su_install()
{
    local user_name="$1"
    if [ "x${user_name}" != "x" ]; then
        echo "${user_name}" | tee "${FILE_WORKNAME}" > /dev/null
    fi

    groupadd -f --system dev
    echo "%dev   ALL=(root) NOPASSWD: /sbin/init-go-work.sh, NOPASSWD: /usr/sbin/init-go-work.sh" >> /etc/sudoers
}

# usermod id
#
# Usage:
#
#     su_usermod <user_name> <user_new_id>
#
su_usermod()
{
    if [ $# -lt "2" ] ; then
        echo "Error su_usermod"
        exit 1
    fi

    local user_name="$1"
    local uid="$2"
    local old_uid=$(id -u "${user_name}")
    local user_home=""

    if [ "${old_uid}" != "${uid}" ]; then
        # echo "usermod -u $uid -o ${user_name} 2> /dev/null"
        usermod -u "$uid" -o "${user_name}"
        usermod -a -G dev "${user_name}"

        user_home=$(sed -n "/^${user_name}:/p" /etc/passwd | cut --delimiter=":" -f6 | sed -n '/^\/home\//p')
        if [ "x${user_home}" != "x" ]; then
            chown -R "$uid" "$user_home"
            # echo "chown -R $uid $user_home"
        fi
    fi
}

__init_work()
{
    local workuser="${WORKNAME}"
    if [ "x${workuser}" = "x" -a -f "${FILE_WORKNAME}" ]; then
        workuser=$( cat "${FILE_WORKNAME}" )
    fi

    if [ "x${workuser}" != "x" -a ! -f "${FILE_LOCK}" ]; then
        if [ "$(id -u)" != "0" ]; then
            local dir_source=$( cd $( dirname "$0" ) && pwd )
            local sh_source=$( basename "$0" )

            # echo "sudo sh ${dir_source}/${sh_source} -i ${workuser}"

            sudo sh "${dir_source}/${sh_source}" -i "${workuser}"
            return 1
        fi

        stat_dir=$(pwd)
        uid=$(stat -c '%u' $stat_dir)


        user_name=$( id -u -n "${workuser}" 2>/dev/null )
        if [ "x${user_name}" = "x" ]; then
            su_useradd "${user_name}" "/home/${user_name}"
        fi

        su_usermod "${user_name}" "${uid}"

        # echo "${user_name} ${FILE_LOCK}"

        id -u "${user_name}" | tee "${FILE_LOCK}" > /dev/null
        # echo "id -u ${user_name} | tee ${FILE_LOCK} > /dev/null"
    fi
}


## Example:
##     $ sudo init-go-work.sh  --install www-data
if [ $# -eq "1" -a "${1}" = "--help" ] ; then
    cat <<EOF

Usage:

    Инициализирует пользовательскую группу
    $ sudo ${0} --install

    Инициализирует пользовательскую группу и установить пользователя по умолчанию
    $ sudo ${0} --install www-data


    $ sudo ${0} -i www-data

    Установит права пользователю WORKUSER, если они еще не установлены, перед выполнением команды
    $ ${0} <command> [args...]

EOF
    exit 0
fi



## Example:
##     $ sudo init-go-work.sh  --install www-data
if [ $# -ge "1" -a "${1}" = "--install" ] ; then
    su_install "$2"
    exit $?
fi


## Example:
##     $ sudo init-go-work.sh -i www-data
if [ $# -eq "2" -a "${1}" = "-i" -a "x${2}" != "x" ] ; then
    # echo "sudo $1 $2"
    WORKNAME="$2"
    __init_work
    exit $?
else
    __init_work
fi
# =======================

## Example:
##     $ init-go-work.sh php-fpm
if [ $# -ge "1" ] ; then
    exec "$@"
fi
