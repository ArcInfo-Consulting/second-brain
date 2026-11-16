# Changelog

## 0.1.3

- The plug-in now downloads as its own zip file from the Releases page, with only the files it needs.
- Update installs the latest release.
- The publisher name is now ArcInfo A.I.

## 0.1.2

- macOS: local search skips online-only OneDrive and iCloud files instead of downloading them.
- macOS: setup recognizes OneDrive folders under `~/Library/CloudStorage/` and Documents folders synced by iCloud Drive.
- macOS: the compaction log can use perl, so it no longer triggers Apple's developer tools prompt on Macs without jq.

## 0.1.1

- Search answers on Windows add an **Open in Outlook** link next to each cited email, which opens it in classic Outlook instead of the browser.
- Setup writes two registry files that turn those links on and off. It doesn't import them, so turning the links on stays the user's choice.
- Update now tells users to run setup again whenever setup changed.
- Update no longer offers to replace a copy with an older version from GitHub.
- The README explains how to install from a zip file you were given.

## 0.1.0

First release.

- Added setup, search, index, wrap-up, transcribe, and update skills.
- Added a read-only subagent for searching one source.
- Added local file search for Office, Markdown, text, and CSV files.
- Added a compaction log.
