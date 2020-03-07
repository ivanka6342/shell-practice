#### Document content:
+ Keywords
+ Principle of work
+ Project structure
    + "post/"
    + "work_ftp/"
    + "ztmp/"
    + "systemd/"
+ Installation help

#### Keywords
  `SCRIPT` : "*unpack_target.script*" <br/>
  `RECEIVER` : "*archive_rcv*" script <br/>
  `SERVICE` : "*checking_archives.service*" <br/>
  `ARCHIVE` : "*arhcivename.tar.gz*" archive for processing <br/>
  `FTP` : sintecs ftp-server <br/>
  `DOWNLOADS` : skype downloads folder <br/>


----
## Principle of work
+ `/opt/archive_rcv` - checks for ARCHIVEs on the FTP and in DOWNLOADS
	if it exist, runs SCRIPT
+ `/opt/unpack_target.script` - unpacks archives to /tmp/ and saves the processing result to **/uexchange/ztmp/result_XXXXX**

The next systemd units designed for scripts autorun:
+ `checking_archives.service` - service that runs RECEIVER when network is available
+ `checking_archives.timer` - runs the SERVICE every 30 minutes


----
## Project structure

+ #### "ztmp/"
	+ ***unpack_target.script***

> For more information try "**bash unpack_target.script --help**" <br/>

+ #### "post/"
	+ ***post_config***
	+ ***revaliases.txt***
	+ ***ssmtp.txt***

> *SCRIPT* uses MTA(SSMTP) to send post mails <br/>
> "*revaliases.txt*" and "*ssmtp.txt*" are main config files for this utility <br/>
> *post_config* is a script designed to configure work of ssmtp, using files above <br/>

+ #### "work_ftp/"
	+ ***archive_rcv***
	+ ***conf***

> Before running the SCRIPT RECEIVER must check FTP and DOWNLOADS for new ARCHIVEs. For this target it uses lftp-utility and systemd-units <br/>
> *conf* - installs lftp and creates systemd units(service and timer) for autostart and time-to-time executing archive-checking script <br/>
> *archive_rcv* - this script copying to /usr/bin/ and checks for appearance of archives on ftp-server or in skype-downloads(data from ASML) <br/>

+ #### "systemd/"
	+ ***checking_archives.service***
	+ ***checking_archives.timer***

> It's an example of configured systemd units <br/>


----
## Installation help
Copy SCRIPT and RECEIVER to it's working directory
* **ztmp/unpack_target.script** -> **/opt/unpack_target.script**
* **work_ftp/archive_rcv** -> **/opt/archive_rcv**
Configure of post-client
* type: `bash post/post_config`
(i) accept installing ssmtp. Type your login and password for edality-email

Then configure systemd units and ftp:
* type: bash `work_ftp/conf`
(i) accept installing lftp. Type login and password to Syntecs FTP-server(it also used in FileZilla)