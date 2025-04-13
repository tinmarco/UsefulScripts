param([string]$path)
# Define the path to search for duplicate files

Write-Output $path
# Get all files in the directory and subdirectories
$files = Get-ChildItem -Path $path -Recurse -File

# Create a hashtable to store file hashes
$hashTable = @{}

# Loop through each file and calculate its hash
foreach ($file in $files) {
    $hash = Get-FileHash -Path $file.FullName -Algorithm SHA256
    if ($hashTable.ContainsKey($hash.Hash)) {
        # If the hash already exists, add the file to the list of duplicates
        $hashTable[$hash.Hash].Add($file.FullName)
    } else {
        # If the hash does not exist, create a new entry
        $hashTable[$hash.Hash] = New-Object System.Collections.Generic.List[string]
        $hashTable[$hash.Hash].Add($file.FullName)
    }
}

# Display the duplicate files
foreach ($hash in $hashTable.Keys) {
    if ($hashTable[$hash].Count -gt 1) {
        Write-Output "Duplicate files with hash $hash :"
        $hashTable[$hash] | ForEach-Object { Write-Output $_ }
        Write-Output ""
    }
}
