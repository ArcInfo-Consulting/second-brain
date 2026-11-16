<#
Turns Outlook web links into outlook: links that open the same email in classic Outlook for Windows.
This script only converts text. It reads no mail and sends nothing over the network.

Pass one or more web links (https://outlook.office365.com/owa/?ItemID=...) or connector message IDs.
Prints one line per input, in the same order: an outlook: link, or ERROR.
If outlook: links aren't turned on for this user, prints only NOT ENABLED.
#>
param(
    [Parameter(Mandatory = $true, ValueFromRemainingArguments = $true)][string[]]$Link
)

# outlook-links-enable.reg from setup registers this handler. Without it, the links do nothing.
if (-not (Test-Path 'Registry::HKEY_CLASSES_ROOT\outlook\shell\open\command')) {
    'NOT ENABLED'
    exit 0
}

foreach ($item in $Link) {
    try {
        $match = [regex]::Match($item, '[?&]ItemID=([^&]+)', 'IgnoreCase')
        if ($match.Success) {
            $base64 = [Uri]::UnescapeDataString($match.Groups[1].Value)
        } else {
            # Connector message IDs use "_" for "+" and "-" for "/".
            $base64 = $item.Replace('_', '+').Replace('-', '/')
        }
        while ($base64.Length % 4) { $base64 += '=' }
        $bytes = [Convert]::FromBase64String($base64)

        # Layout: 2 bytes, 2-byte mailbox ID length, mailbox ID, 1 byte, 2-byte entry ID length, entry ID.
        $mailboxLength = [BitConverter]::ToUInt16($bytes, 2)
        $lengthAt = 4 + $mailboxLength + 1
        $entryLength = [BitConverter]::ToUInt16($bytes, $lengthAt)
        if ($entryLength -eq 0 -or $lengthAt + 2 + $entryLength -gt $bytes.Length) { throw 'unexpected ID layout' }

        $entry = $bytes[($lengthAt + 2)..($lengthAt + 1 + $entryLength)]
        'outlook:' + (($entry | ForEach-Object { $_.ToString('X2') }) -join '')
    } catch {
        'ERROR'
    }
}
