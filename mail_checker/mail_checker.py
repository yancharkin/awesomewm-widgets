#!/usr/bin/env python

import os
import sys
import subprocess
import imaplib

ACCOUNTS_DIR = sys.path[0] + "/accounts/"
PASSWD_DIR = ACCOUNTS_DIR + "passwords/"

ACCOUNTS = []
with open(ACCOUNTS_DIR + "list", "r") as f:
    ACC_LIST = f.readlines()
for line in ACC_LIST:
    ACCOUNTS.append(line.strip().split(", "))

def count_all_unread():
    """Returns number of unread messages in all mailboxes"""
    all_unread = 0
    def get_passwd(file_path):
        """Gets password from password file. Decrypt with gpg if encrypted."""
        passwd = ""
        if os.path.splitext(file_path)[1] == ".gpg":
            passwd = subprocess.check_output(['gpg', '-qd', file_path]).strip().decode("utf-8")
        else:
            with open(file_path, "r") as f:
                passwd = f.readline().strip()
        return passwd

    for account in ACCOUNTS:
        passwd = get_passwd(PASSWD_DIR + account[1])
        mail = imaplib.IMAP4_SSL(account[2], account[3])
        mail.login(account[0], passwd)
        status, count = mail.status("INBOX", "(MESSAGES UNSEEN)")
        count = int(count[0].split()[4][:-1])
        if status == "OK":
            all_unread += count

    print(all_unread)
    return all_unread

if __name__ == "__main__":
    count_all_unread()
