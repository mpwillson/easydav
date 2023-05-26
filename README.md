# EasyDAV - A simple to deploy WSGI webdav implementation.

This project is a port of easydav-0.5-dev to Python 3 (as
EasyDav-0.5-3). In addition, the templating engine, kid, has been
replaced by mako.

Main aim is to work with OpenBSD's httpd, using FCGI. Tested using
orgzly as a client (Android app).

## License

Copyright 2010-2012 Petteri Aimonen <jpa at wd.mail.kapsi.fi>

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

   1. Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.

   2. Redistributions in binary form must reproduce the above
      copyright notice, this list of conditions and the following
      disclaimer in the documentation and/or other materials provided
      with the distribution.

## Dependencies

For OpenBSD, install the following packages:

python3
py3-flup
py3-mako

## Setup

First create a configuration file for the script by copying
webdavconfig.py.example to webdavconfig.py. You must set (at least)
**root_dir** in this file. This is the filesystem path to the root
folder that will contain the files accessible through WebDAV.

You will also need to configure **chroot**, **effective_user** and
**socket_file**. See below.

EasyDAV-0.5-3 only supports operation as a FCGI server, operating under
OpenBSD's ```httpd(8)``` web server.

Add the location of the webdav files to the server configuration in
```/etc/httpd.conf```. For example:

```
    location "/webdav/*" {
        authenticate with "/var/htpasswd.db"
        fastcgi {
                socket "/var/run/webdav.sock"
        }
    }
```

Authentication is required via an ```htpasswd(1)``` created
authentication file, specified relative to the chroot.. The socket
specified in the fastcgi setting must match the value in the
```webdavconfig.py``` file, omitting the httpd chroot directory
(```/var/www``` in this example).

Start the EasyDav server as root:

``` shell
doas python webdav.py
```

The shell script ```webdav.sh``` provides an example and could be run
from ```/etc/rc.local``` on boot (after changing EASYDAV_DIR).

## Configuration File

The configuration file, **webdavconfig.py**, has the following settings:
- **root_dir:** The file system path to the directory where files will
  be stored. This directory must be owned by effective_user.
- **root_url:** Complete url to the repository on web, or None to decide
  automatically.
- **chroot:** Directory to chroot the Easydav process. This must be the same
  as the httpd chroot, normally /var/www.
- **effective_user:** The user name of the effective id EasyDav should
  operate as. This will normally be the same as the web server
  (httpd), 'www'.
- **socket_name:** The pathname of the socket file, used for FCGI
  communication with the web server. The effective_user must have write 
  access to this directory.
- **restrict_access:** List of file name patterns that can not be
  accessed at all, not read not written. They also won't show up in
  directory listings.
- **restrict_write:** List of files that cannot be written. These will
  show up in directory listing.  They cannot be directly copied or
  removed, but can be when the action is performed on a whole
  directory.
- **unicode_normalize:** Normalization of unicode characters used in
  file names. Ensures that all clients threat semantically equivalent
  filenames as logically equivalent.
- **lock_db:** SQLite database file to store acquired locks. Set to None
  to disable locking.
- **lock_max_time:** Maximum expire time of locks, in seconds.
- **lock_wait:** Time to wait for access to lock database, in seconds.
- **log_file:** Log file name relative to webdav.py location.
- **log_level:** Numerical value, 0 for maximum amount of debug
  messages.

## Security

You should protect access to the WebDAV repository by using the HTTP
authentication offered by ```httpd``` (see sample configuration,
above). Most WebDAV clients support HTTPS and Digest authentication,
so use either of them so that passwords are not transmitted in plain
text.

Every effort has been taken to protect the script from accessing files
outside **root_dir**. The worst the WebDAV users can do is fill up the
hard drive.

When the root directory is accessible through web server (like when
managing web pages through WebDAV), users might upload an executable
file. The default configuration prohibits writing to .py, .php, .pl,
.cgi and .fcgi files. You should add any other extensions recognized
by your web server.

## Defects

- File timestamps are not preserved while uploading. May depend on
  client.

- Test capability has not been implemented.
