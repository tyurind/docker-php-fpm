#!/usr/bin/python
# -*- coding: UTF-8 -*-
import os
import re
import sys
import subprocess


site_file_path = "/etc/apache2/sites-available/default"
pid_file_path = "/var/run/apache2.pid"

eol = os.linesep

try:
    act = sys.argv[1]
except Exception, e:
    act = "update"

def main():
    if act == "update":
        return act_update()

    if act == "list":
        return act_list()

    return act_help()
    print "Бля, Бля, Бля"


"""
ACTION Functions
===================================
"""

def act_help():
    print "Usage: <command>"
    print "\nCommands:"
    print "    help     справка"
    print "    update   обновить список хостов и перезапустить apache (only root)"
    print "    list     список принятых хостов"

def act_list():
    return 1

def act_update():
    if is_root() == 0:
        print "Error! root only\n"
        return

    print "Updating Apache2 virtual hosts using /var/www catalogs"

    hosts = get_virtual_hosts_names()
    file_content = get_site_file_content(hosts)
    open(site_file_path, "w").write(file_content)

    print "Hosts successfully added:\n * {0}.loc\n".format(".loc\n * ".join(hosts))
    if os.path.exists(pid_file_path):
        os.system("service apache2 restart")

"""
PUBLIC Functions
===================================
"""


def get_virtual_hosts_names():
    hosts = []
    www_dir = "/var/www"
    for name in os.listdir(www_dir):
        if os.path.isdir(os.path.join(www_dir, name)):
            hosts.append(name)
    return hosts


def get_site_file_content(hosts):
    config_content = open(site_file_path, "r").read()
    our_pattern = r"#\n+#\s*Vhosts\s+begin.+?#\s*Vhosts\s+end\n+#"
    config_content = re.sub(our_pattern, "", config_content, flags=re.DOTALL)
    config_content = config_content.strip()

    our_section = "\n\n#\n# Vhosts begin\n#\n"
    for host in hosts:
        our_section += "Use VHost {0}.loc /var/www/{0}\n".format(host)
    our_section += "#\n# Vhosts end\n#\n\n"
    config_content += our_section

    return config_content


def is_root():
    PIPE = subprocess.PIPE
    p = subprocess.Popen('id -u', shell=True, stdin=PIPE, stdout=PIPE, stderr=subprocess.STDOUT)
    id = p.stdout.read().strip()
    if id == "0":
        return 1
    return 0

if __name__ == "__main__":
    main()
