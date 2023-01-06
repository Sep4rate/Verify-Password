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
