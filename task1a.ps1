#################################### 1st Script ####################################

<#
    This script could be used to monitor disk usage and clean it from unnecessary files
    you can use the script regularly and compare the results with each other to find potential bugs
#>

$CM = "TEST_DEVICE_NAME"                                                        # creates local string variable called "TEST_DEVICE_NAME"

Invoke-Command -ComputerName $CM -ScriptBlock {                                 # runs the script on "TEST_DEVICE_NAME" computer
    "Free space before: {0:N2} GB" -f ((                                        # prints text in "" marks and inserts object value in with {0:N2} format
        Get-CimInstance -ClassName Win32_LogicalDisk -filter "DeviceID='C:'" |  # gets  CIM instance of Win32_LogicalDisk class with "DeviceID='C:'" filter // retrieves information about a computer discs and shows only C: drive
        Select-Object Freespace).                                               # selects "Freespace" property
            FreeSpace/1GB);                                                     # shows only number in gigabytes
    write-host "";                                                              # writes empty line to host, propably to separate the outputs

    "Size of C:\Windows\Logs\CBS - {0:N2} GB" -f ((                             # prints text in "" marks and inserts object value in with {0:N2} format
        Get-ChildItem C:\Windows\Logs\CBS\ -Recurse |                           # gets items of "C:\Windows\Logs\CBS\" directory, -Recurse paremeter gets items in all child directories              
        Measure-Object -Property Length -Sum -ErrorAction Stop).                # calculates the sum of the lengths(size) of the objects in "C:\Windows\Logs\CBS\" directory, stops sctipt if any error appear,
            Sum/1GB);                                                           # shows only number of Sum value in gigabytes 
    Remove-Item C:\Windows\Logs\CBS\*.* -Confirm;                               # removes all files of all extensions without removing directories and asks for confirmation before running
    write-host "";                                                              # writes empty line to host

    "Size of BranchCache: {0:N2} GB" -f (                                       # prints text in "" marks and inserts object value in with {0:N2} format
        (Get-BCDataCache |                                                      # gets object from BranchCache
        Select-Object CurrentSizeOnDiskAsNumberOfBytes).                        # selects "CurrentSizeOnDiskAsNumberOfBytes" property
            CurrentSizeOnDiskAsNumberOfBytes/1GB);                              # shows only number in gigabytes
    Clear-BCCache -Confirm;                                                     # deletes everything in all data cache files and hash cache files and asks for confirmation before running
    write-host "";                                                              # writes empty line to host

"Free space after: {0:N2} GB" -f ((                                             # prints text in "" marks and inserts object value in with {0:N2} format 
        Get-CimInstance -ClassName Win32_LogicalDisk -filter "DeviceID='C:'" |  # gets  CIM instance of Win32_LogicalDisk class with "DeviceID='C:'" filter
        Select-Object Freespace).                                               # selects "Freespace" property
            FreeSpace/1GB) }                                                    # shows only number in gigabytes