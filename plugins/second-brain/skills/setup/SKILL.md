---
name: setup
description: Set up a second brain in the user's Documents folder or main work folder, then scan OneDrive and SharePoint to map their active work. Adds CLAUDE.md and INDEX.md without moving any files.
disable-model-invocation: true
---

# Second brain setup

Set up the current work folder, which is the folder where the user keeps most of the files they work on. Don't ask the user to make choices or fill anything in. Work it out, set it up, and tell them what you did, because most people running this just want a working second brain.

Never move, rename, or overwrite an existing file or folder. This folder holds real work, and the second brain should fit around how the user already organizes it. If something already exists, keep it and add only what's missing.

## 1. Confirm the work folder

Most people should use their Documents folder, because that's where their computer and company tools put their files.

1. Tell the user which folder this session is using.
2. On Windows, find their Documents folder with `[Environment]::GetFolderPath('MyDocuments')`. Companies often redirect it into OneDrive, which can leave `C:\Users\<name>\Documents` nearly empty. On macOS, it's `~/Documents`.
3. If this session is in that folder, continue. Otherwise, ask whether this folder holds most of their work files. If it doesn't, tell them to start a new session in the right folder and run setup there.
4. Note whether the folder syncs, and to what. Later steps depend on this.
   - **OneDrive:** the path usually contains `OneDrive`. On macOS, OneDrive folders are under `~/Library/CloudStorage/`.
   - **iCloud Drive (macOS):** iCloud can sync Documents without changing its path. Treat `~/Documents` as synced to iCloud if `~/Library/Mobile Documents/com~apple~CloudDocs/Documents` exists, and treat any folder inside `~/Library/Mobile Documents/` as synced.

If `CLAUDE.md` or `INDEX.md` already exists, treat this as a repeat setup.

## 2. Check Microsoft 365

Check whether Microsoft 365 tools are available in this session. If they aren't, tell the user to click **+** next to the prompt box, select **Connectors**, and connect Microsoft 365, then run setup again in a new session. A Microsoft Entra admin may need to approve it first, and personal Outlook or Hotmail accounts can't connect.

If they can't connect it yet, continue. The scan will cover only the files on this computer.

## 3. Find the user's details

Don't ask for these. Use the connector's `get_me` tool for the user's name and job title. Take the company from their OneDrive folder name, such as `OneDrive - Contoso` (`OneDrive-Contoso` on macOS), or from their email domain, and the time zone from this computer.

## 4. Create the files

Create only what's missing:

| Path | Source |
|---|---|
| `CLAUDE.md` | `${CLAUDE_SKILL_DIR}/assets/CLAUDE-template.md` |
| `INDEX.md` | `${CLAUDE_SKILL_DIR}/assets/INDEX-template.md` |

Replace each placeholder in square brackets. If you don't have a value, remove it rather than guessing. Then set the two sync lines in `CLAUDE.md`, one under **Where things live** and the Grep line under **Safety**:

- **Syncs to OneDrive:** keep both.
- **Syncs to iCloud Drive:** keep the Grep line, and replace the OneDrive line with: `This folder syncs to iCloud Drive. The Microsoft 365 connector can't see it, so search it with the search skill's local script, which skips files that are only in iCloud.`
- **Doesn't sync:** remove both.

## 5. Prevent mass downloads

If the work folder syncs to OneDrive or a similar service, add these rules to `permissions.deny` in `.claude/settings.json`, keeping every existing setting:

```json
["Grep", "Bash(grep *)", "Bash(rg *)", "Bash(findstr *)"]
```

Tell the user why: those commands open every file, and opening an online-only file downloads it. The `search` skill reaches OneDrive files through the Microsoft 365 connector instead, and its local script skips online-only files.

## 6. Set up the compaction log

Don't ask about this. Add a small script that saves Claude's summary to `Session Summary.md` when a long conversation is compacted. It runs only in this folder and sends nothing anywhere.

- **Windows:** copy `${CLAUDE_SKILL_DIR}/assets/hooks/log-compaction.ps1` to `.claude/hooks/`, and merge `${CLAUDE_SKILL_DIR}/assets/hooks/settings-windows.json` into `.claude/settings.json`.
- **macOS or Linux:** copy `${CLAUDE_SKILL_DIR}/assets/hooks/log-compaction.sh` to `.claude/hooks/`, and merge `${CLAUDE_SKILL_DIR}/assets/hooks/settings-unix.json` into `.claude/settings.json`.

Merge by adding to `hooks.PostCompact`. Keep every existing setting and hook, and don't add this hook twice.

## 7. Prepare Outlook desktop links

On Windows only. Search answers can add an **Open in Outlook** link next to each email, which opens it in classic Outlook instead of the browser. Windows turns that link type off by default, so turning it on is the user's choice. Don't import anything into the registry.

Run this to write the two registry files the user would need:

```text
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "${CLAUDE_SKILL_DIR}/scripts/make-outlook-link-files.ps1" -OutDir "<work folder>/.claude"
```

It writes `outlook-links-enable.reg` and `outlook-links-disable.reg` and never overwrites them. It writes nothing if it prints `NO CLASSIC OUTLOOK` or `ALREADY ENABLED`.

## 8. Scan

Tell the user you're scanning their work and that it can take a few minutes. Then run the `index` skill in Build mode. It finds their active work, writes `INDEX.md`, and asks them to correct anything wrong.

## 9. Finish

Check that `.claude/settings.json`, if you changed it, is valid JSON. Then tell the user:

1. What was created or skipped
2. To start a new session in this folder, so the new settings load
3. To try a question about their work
4. If step 7 wrote or kept the registry files: double-clicking `.claude/outlook-links-enable.reg` turns on **Open in Outlook** links, and `outlook-links-disable.reg` turns them off. Microsoft turns this link type off by default because a crafted link from another app or web page could pass extra options to Outlook, such as starting a new message with a local file attached. Outlook still sends nothing unless they click Send.
