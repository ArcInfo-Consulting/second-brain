# IT admin guide

This guide helps IT and security teams review Second Brain for company use.

## What it is

Second Brain is an open-source Claude Code plugin. It contains instructions, one subagent definition, templates, and small scripts. It has no server, no installer, and no telemetry of its own.

It runs in the folder where each person keeps most of their work files, usually Documents. Claude can read the files in that folder, and it asks before changing them unless the user changes the permission mode. Setup adds a few files and doesn't move or rename existing ones. It then scans the user's OneDrive and SharePoint to find their active work.

## Requirements

- Claude desktop app with Claude Code enabled for your organization
- The Microsoft 365 connector, approved by a Microsoft Entra admin
- Microsoft 365 work accounts in an Entra tenant

Each person connects their own account. The connector uses delegated permissions, so Claude can only reach data that person can already access.

## What runs on the computer

| Component | Behavior |
|---|---|
| `search-files.ps1` or `.sh` | Searches local `.docx`, `.xlsx`, `.pptx`, `.md`, `.txt`, and `.csv` files when they aren't in OneDrive or the connector isn't available. The Windows and macOS scripts skip online-only files |
| `log-compaction.ps1` or `.sh` | Appends a summary to one local file after compaction |
| `outlook-desktop-link.ps1` | Turns Outlook web links into `outlook:` links for search answers, if that link type is turned on |
| `make-outlook-link-files.ps1` | Writes two per-user registry files to the work folder during setup. It doesn't import them |
| `update` skill | Asks Claude to download the latest version from GitHub after the user approves |
| Transcription tool | Optional third-party tool. It isn't included in this plugin |

On Windows, the bundled commands run PowerShell with `-ExecutionPolicy Bypass`. This setting doesn't override a policy set through Group Policy. If your policy blocks the scripts, local search falls back to file names, the compaction log stays off, and answers use web links only. Everything else still works.

## Where data goes

| Data | Location |
|---|---|
| Connector results and local files Claude reads | Sent to Claude under your organization's Claude terms |
| `CLAUDE.md`, `INDEX.md`, `STATUS.md`, transcripts, and summaries | The user's work folder |
| Scan results | File and folder names, dates, and short search snippets pass through Claude. `INDEX.md` stores only folder names, paths, and dates |
| Recordings | Stay local with the recommended transcription setup, unless an OpenAI key is configured |

If the work folder syncs to OneDrive, these files follow your OneDrive policies. The index can contain names of private files and channels.

## Recommended controls

**Block connector actions you don't want.** Claude Code asks users to approve connector actions by default. For a stricter rule, use your organization's connector tool controls to set send, post, edit, and delete tools to `blocked`. In the desktop app's local sessions, `ask` isn't enforced for connector tools, while `blocked` removes the tool. Blocking also removes it from chat.

**Review how plugins may load.** Skills-folder installs are skipped with no error if managed settings use `strictPluginOnlyCustomization`, or use `strictKnownMarketplaces` without this entry:

```json
{ "source": "skills-dir" }
```

**Decide on Outlook desktop links.** On Windows with classic Outlook, setup writes `outlook-links-enable.reg`, which registers the `outlook:` link type under `HKCU\Software\Classes\outlook`. Users import it themselves. Microsoft leaves this link type off by default because a crafted link can pass extra options to Outlook. If you don't want it, block that key or `.reg` imports with your usual policy tools. Search answers then use web links only.

**Use an approved copy for wider rollouts.** Fork the repository, review it, and register your fork in managed settings. Each computer needs Git and read access if your fork is private.

```json
{
  "extraKnownMarketplaces": {
    "arcinfo": {
      "source": {
        "source": "github",
        "repo": "your-org/second-brain"
      },
      "autoUpdate": true
    }
  },
  "enabledPlugins": {
    "second-brain@arcinfo": true
  }
}
```

The key must match the `name` in your fork's `.claude-plugin/marketplace.json`.

## Limits

- Claude's instructions are guidance, not a security boundary. Use permission rules and connector controls for anything that must be enforced.
- Prompt injection can't be removed completely when Claude reads outside content.
- Local search covers text in `.docx`, `.xlsx`, `.pptx`, `.md`, `.txt`, and `.csv` files. It doesn't read password-protected files, older Office formats, or text inside images.
- In a synced folder, Claude searches through the connector, and setup blocks `grep`-style search commands because opening an online-only file downloads it. This reduces mass downloads, but other commands can still open files.
