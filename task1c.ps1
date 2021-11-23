#################################### 3rd Script ###################################

<#
    Script helps manage the drivers, with this you can pull out a list of drivers with a few important parameters
#>

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned       # sets policy to require that all scripts and configs are singed by a trusted publisher 

Get-WmiObject -Query "SELECT * FROM Win32_PnPSignedDriver WHERE DeviceClass IS NOT NULL AND DriverProviderName IS NOT NULL" | # gets WMI instance of Win32_PnPSignedDriver class with value in DeviceClass and DriverProviderName filter (done by sql query)
  ForEach-Object { 
    $info = [ordered]@{};                               # creates ordered dictionary (shortcut of OrderedDictionary class)

    $info.DeviceClass = $_.DeviceClass;                 # sets info's variable DeviceClass value same as DeviceClass of current object
    $info.DeviceName = $(                               # sets info's variable DeviceName value same as ...
      if ($_.FriendlyName) {$_.FriendlyName}                # FriendlyName of current object is exist or ...
      else {$_.Description});                               # as current object Description in the rest of cases

    $info.DriverProvider = $_.DriverProviderName;       # sets info's variable DriverProvider value same as DriverProvider of current object
    $info.DriverDate = $(                               # sets info's variable DriverDate value same as ...
      if ($_.DriverDate) {$_.DriverDate.Substring(0,4)      #
        +"-"+$_.DriverDate.Substring(4,2)+"-"               # DriverDate of current object in yyyy-mm-dd format or...
        +$_.DriverDate.Substring(6,2)}                      #
      else {""});                                           # leaves empty in rest of cases

    $info.DriverVersion = $_.DriverVersion;             # sets info's variable DriverVersion value same as DriverVersion of current object
    $(New-Object –TypeName PSObject –Prop $info);} |    # creates a .NET PSObject object using $info properties
      Sort-Object -Property DeviceClass, DeviceName |   # sorts objects by DeviceClass and DeviceName
      Format-Table -AutoSize                            # formats output as a table adjusting the column size based on date instead based by the view