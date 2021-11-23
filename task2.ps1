#################################### Task 2 ####################################

for ($i=1; $i -le 20; $i++)         # creates 20 folders in C:\temp\
{
    New-Item -ItemType Directory -Force -Path "C:\temp\$i"
}

<#

done manually

New-Item -Path "C:\temp\" -Name "empty.txt" -ItemType "file" -Value ""

#>

for ($i=1; $i -le (Get-ChildItem -Path "C:\temp\" -Directory).Count; $i++ ) # copies empty.txt file from C:\temp\ to every 1-20 folder
{
    Copy-Item -Path "C:\temp\empty.txt" -Destination "C:\temp\$i"
    "copied empty.txt to C:\temp\$i folder"
}


Get-ChildItem -Path "C:\temp\" -Recurse -Directory -Depth 2 |               # generates csv with only folders structure       
    Select-Object Name, FullName |
    Sort-Object {[int]$_.Name} |
    Export-Csv -Path "C:\temp\directories.csv" -NoTypeInformation


Get-ChildItem -Path "C:\temp\" -Recurse -Depth 2 |                          # generates csv with only folders and files structure  
    Select-Object -Property FullName, Name | 
    Sort-Object -Property FullName | 
    Export-Csv -path "C:\temp\directories_files.csv" -noTypeInfo


tree C:\temp\ /f /a > tree.csv                                              # generates tree version of folders and files structure