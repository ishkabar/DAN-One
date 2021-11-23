#################################### 2st Script ####################################

<#
    This script can easily retrieve big e-mail databases
#>

$Group = Get-ADGroupMember -identity “test group” -Recursive    # puts members of "test group" group (including members of child groups) in Group variable

$group |                                    
    get-aduser -Properties mail |                               # gets list of users from variable with their mail properties
    Select-Object name,samaccountname,mail |                    # selects "name", "samaccountname" and "mail" properties
    export-csv -path C:\output\test.csv -NoTypeInformation      # saves object as test.csv in "C:\output\" without comments