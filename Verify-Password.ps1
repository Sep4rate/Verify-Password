Param(
    [string] $someString = "melobie"
)
$uri = 'https://api.pwnedpasswords.com/range/'
$sha1 = New-Object -TypeName System.Security.Cryptography.SHA1CryptoServiceProvider
$utf8 = New-Object -TypeName System.Text.UTF8Encoding
$hash = [System.BitConverter]::ToString($sha1.ComputeHash($utf8.GetBytes($someString)))
$hash = $hash.Replace("-","")
Write-Output "Password SHA1 hash: $hash`n"

$prefix = $hash.Substring(0,5)
$suffix = $hash.Substring(5)

Write-Output "Getting pwned passwords starting with $prefix...`n"
$uri = $uri + $prefix
$searchResult = Invoke-WebRequest $uri

if ($searchResult.Content.Contains($suffix)) {
    $foundString = $searchResult.Content.Substring($searchResult.Content.IndexOf($suffix))
    $foundString = $foundString.Substring(0,$foundString.indexof("`n"))
    $howMany = $foundString.Substring($foundString.IndexOf(":"))
    Write-Output "The given password has been pwned!"
    Write-Output "Instances found $howMany"
}
else {
    Write-Output "Congratulations! Password not found in DB."
}