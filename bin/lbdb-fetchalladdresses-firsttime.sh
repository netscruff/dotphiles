#!/bin/bash
#
# lbdb-fetchalladdresses-firsttime
# Release 0.3
# Latest version is always available at <a href="http://www.ruwenzori.net/code/lbdb-fetchalladdresses-firsttime/">http://www.ruwenzori.net/code/lbdb-fetchalladdresses-firsttime/</a>

#
# What :
#
# Fetches all addresses contained in the messages in a maildir
# hierarchy and stores them in the lbdb m_inmail database

#
# Dependancies :
#
# Developped and tested on a Debian 'Testing' system.
# Should work anywhere that has Unix-ish paths, Bash or a bash like shell,
# lbdb and the dependancies thereof.

#
# Author : Jean-Marc Liotier
#

# Changes :
#
# 0.3 - 20060523
# - Unicity is now handled by 'sort' instead of 'uniq'.
# - Better sort criterias (-u -d -f -i -k 1,1).
#
# 0.2 - 20060321
# - Extraneous 'ls' and nested loop removed for faster performance
# - Now works with Maildir names containing spaces
# - Supressed bad root folder path in subfolder loop
# - Does not try to cat directories
#
# 0.1 - 20060222
# - Initial release
#

# License :
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or (at
# your option) any later version.

#############################################
#
# User editable parameters
#
home=/home/dtb17
lbdbdir=$home/.lbdb
maildir=$home/mail/work/Inbox
# excluded_maildirs must be a regular expression understood by 'grep'
# and enclosed in quotes
#excluded_maildirs=".Diffusion.\|.=Spam\|.=Search"
#
# No user editable parameters below this line
#
##############################################


# Creates the lbdb directory if it does not exists
if [ -d "$home/.lbdb" ]
   then
      sleep 0
   else
      mkdir $home/.lbdb
   fi

chmod 700 $home/.lbdb &


find $maildir/cur | while read zemessage
   do
      if [ -f "$zemessage" ]
         then
            cat "$zemessage" | lbdb-fetchaddr -a
      fi
   done

find $maildir/.*/cur | grep -v "$excluded_maildirs" | sed s/\ /\\"\ "/g | grep -v /./ | while read zemessage
   do
      if [ -f "$zemessage" ]
         then
            cat "$zemessage" | lbdb-fetchaddr -a
      fi
   done

rm -f $lbdbdir/m_inmail.list.tmp

mv $lbdbdir/m_inmail.list $lbdbdir/m_inmail.list.tmp
sort -u -d -f -i -k 1,1 $lbdbdir/m_inmail.list.tmp > $lbdbdir/m_inmail.list

rm -f $lbdbdir/m_inmail.list.tmp
chmod 600 $lbdbdir/m_inmail.list

rm -f $lbdbdir/m_inmail.list.dirty
