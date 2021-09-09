# Copyright (c) 2020
# Licensed under the GNU General Public License v3.0
# 
# This script uses the "Have I Been Pwned?" API developed by Troy Hunt
# to determine if a password is in the "Pwned Password" list.
# 
# In order to protect the confidentiality of the given password, 
# the script first hashes the password using a SHA-1 algorithm and extracts
# the first 5 characters of the hash for searching the DB. If the query
# returns a list of hashes, it means that there's a huge possibility that
# the password has been compromised.
#
# More info on the Passwords DB: https://haveibeenpwned.com/Passwords
# 
# Usage example:
# .\Verify-Password.ps1 "Password123"
#
# ***** IMPORTANT *****
# Pleaase do consider PowerShell history and logging while typing your
# passwords in a PowerShell window.

# Place the password in a variable and initialize the base URI
Param(
    [string] $someString = "melobie"
)
$uri = 'https://api.pwnedpasswords.com/range/'

# Hash the password using SHA-1
$sha1 = New-Object -TypeName System.Security.Cryptography.SHA1CryptoServiceProvider
$utf8 = New-Object -TypeName System.Text.UTF8Encoding
$hash = [System.BitConverter]::ToString($sha1.ComputeHash($utf8.GetBytes($someString)))
$hash = $hash.Replace("-","")
$someString = $null
Write-Host "Password SHA1 hash: $hash`n"

# Split the hash in prefix and suffix
$prefix = $hash.Substring(0,5)
$suffix = $hash.Substring(5)

# Append the prefix to the search URI and go fetch the results
Write-Host "Getting pwned passwords starting with $prefix...`n"
$uri = $uri + $prefix
$searchResult = Invoke-WebRequest $uri

# If the response contains the given suffix, the hash has been found!
# The number of times it has been found appears after the : symbol.
if ($searchResult.Content.Contains($suffix)) {
    $foundString = $searchResult.Content.Substring($searchResult.Content.IndexOf($suffix))
    $foundString = $foundString.Substring(0,$foundString.indexof("`n"))
    $howMany = $foundString.Substring($foundString.IndexOf(":"))
    Write-Host "The given password has been pwned!"
    Write-Host "Instances found $howMany"
}
else {
    Write-Host "Congratulations! Password not found in DB."
}

# Close with a fair warning
Write-Host "`nMake sure to run 'Clear-History' after verifying your passwords.`n" -ForegroundColor Yellow
