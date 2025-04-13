param([string]$path)
# Define the path to search for duplicate files

Write-Output "Scanning directory: $path"
# Get all files in the directory and subdirectories
$files = Get-ChildItem -Path $path -Recurse -File

# Create a hashtable to store file hashes
$hashTable = @{}

# Loop through each file and calculate its hash
foreach ($file in $files) {
    $hash = Get-FileHash -Path $file.FullName -Algorithm SHA256
    if ($hashTable.ContainsKey($hash.Hash)) {
        # If the hash already exists, delete the duplicate file
        Write-Output "Deleting duplicate file: $($file.FullName)"
        Remove-Item -Path $file.FullName -Force
    } else {
        # If the hash does not exist, create a new entry
        $hashTable[$hash.Hash] = $file.FullName
    }
}

Write-Output "Duplicate removal complete."
