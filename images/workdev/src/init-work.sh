#!/bin/sh

FILE_LOCK=/etc/workuser.lock
WORKUSER=${WORKUSER-workuser}

__init_work()
{
    local user_name="${WORKUSER}"
    #local    user_name=$( id -u -n "${workuser}" 2>/dev/null )

    local stat_dir=$(pwd)
    local uid=$(stat -c '%u' $stat_dir)
    local old_uid=$(id -u "${user_name}")
    local user_home=""

    # if [ "${uid}" = "0" ]; then
    #     exit 0
    # fi

    if [ "${old_uid}" != "${uid}" ]; then
        # echo "usermod -u $uid -o ${user_name} 2> /dev/null"
        usermod -u "$uid" -o "${user_name}"

        user_home=$(sed -n "/^${user_name}:/p" /etc/passwd | cut --delimiter=":" -f6 | sed -n '/^\/home\//p')
        if [ "x${user_home}" != "x" ]; then
            chown -R "$uid" "$user_home"
        fi
    fi

    id -u "${user_name}" | tee "${FILE_LOCK}" > /dev/null
}

if [ ! -f "${FILE_LOCK}" ]; then
    __init_work
fi

if [ "x${PHP_INSTALL_XDEBUG}" = "xtrue" ]; then
    phpenmod xdebug
fi

exit 0
