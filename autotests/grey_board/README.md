## "greyboard" autotests based on `expect` CLI utility

Files:
* **main** - script which run tests from **test_list.txt**
* **test_list.txt** - lists all tests with right order, number, flags
* **test1_os_boot** - check the boot process: u-boot, kernel and system login
* **test3_sd_card** - check is SD-card can be readed and verified. Start test from the user space on device (system loaded)
