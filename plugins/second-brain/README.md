# Second Brain for Claude Code

Second Brain turns Claude Code in the Claude desktop app into a searchable assistant for your work. It helps Claude find information across Outlook, SharePoint, OneDrive, Teams, and your local project folders, then answer with sources. Your notes stay in plain files that you own.

This is an independent project. It isn't affiliated with or endorsed by Anthropic or Microsoft.

## What it adds

| Command or skill | What it does | How it runs |
|---|---|---|
| `/second-brain:setup` | Scans your work and adds `CLAUDE.md` and an index around your existing folders | You run it once |
| `search` | Searches your sources in parallel and cites what it finds | Claude uses it automatically |
| `/second-brain:index` | Scans OneDrive, SharePoint, mail, and chat to map your active work | Setup runs it. Run it again or schedule it to refresh |
| `wrap-up` | Saves decisions and next steps to a project's `STATUS.md` | Ask Claude to wrap up |
| `transcribe` | Turns recordings or Teams transcripts into a transcript and summary | Share a recording or ask |
| `/second-brain:update` | Installs the latest version | You run it |

## What you need

- The Claude desktop app, with a paid plan that includes Claude Code
- A Microsoft 365 work account connected to Claude
- Your Documents folder, or whichever folder holds most of the files you work on
- A Microsoft Entra admin to approve the connector, if your company hasn't already

Personal Outlook and Hotmail accounts can't connect. It works on Windows and macOS. **Open in Outlook** links are Windows only.

## Install

Open the **Code** tab, start a local session, and paste this:

```text
Download https://github.com/ArcInfo-Consulting/second-brain/releases/latest/download/second-brain.zip
and extract it into ~/.claude/skills. Confirm that
~/.claude/skills/second-brain-main/.claude-plugin/plugin.json exists.
```

If you already have the zip file, paste this instead, with the zip's location:

```text
Extract <where you saved the zip> into ~/.claude/skills. Confirm that
~/.claude/skills/second-brain-main/.claude-plugin/plugin.json exists.
```

On a Mac, Safari may unzip the file for you. If so, ask Claude to move the `second-brain-main` folder into `~/.claude/skills` instead.

Then start a new session.

<details>
<summary>Install it yourself</summary>

1. Download [second-brain.zip](https://github.com/ArcInfo-Consulting/second-brain/releases/latest/download/second-brain.zip), or use the zip file you were given.
2. Extract the zip.
3. Move the `second-brain-main` folder into `%USERPROFILE%\.claude\skills\`. On a Mac, use `~/.claude/skills/`, and press **Cmd+Shift+.** in Finder to show the hidden `.claude` folder.
4. Check that the `.claude-plugin` folder sits directly inside `second-brain-main`. Windows can add an extra folder level when extracting.
5. Start a new session.

</details>

<details>
<summary>Install with the Claude Code terminal</summary>

This option needs the Claude Code command line and Git:

```text
claude plugin marketplace add ArcInfo-Consulting/second-brain
claude plugin install second-brain@arcinfo
```

The desktop app's local sessions use the same plugin settings. To get updates automatically, run `/plugin` in a terminal session, open **Marketplaces**, select this marketplace, and select **Enable auto-update**.

</details>

## Set up

1. In the desktop app, click **+** next to the prompt box, select **Connectors**, and connect Microsoft 365.
2. Start a local Code session in your Documents folder. If you keep most of your work files somewhere else, use that folder instead. This is your work folder.
3. Run `/second-brain:setup`. It finds your details and active work on its own, so there's nothing to fill in. Claude may ask you to approve a few steps. The scan can take a few minutes, and it doesn't move anything.
4. Check the active work it found, and correct anything that's wrong.
5. Start a new session in the same folder.

Then ask questions in plain language:

- "What did we promise Acme about the go-live date?"
- "Find the latest statement of work for Project Falcon."
- "What's still open from last week's steering committee meeting?"
- "Wrap up this session."

## Your work folder

Your files stay where they are. Setup adds a few files around them:

```text
Documents/                     Or your own work folder
├── CLAUDE.md                  Your instructions for Claude
├── INDEX.md                   Where each project's information lives
├── Session Summary.md         Log of compacted conversations
├── .claude/settings.json      Settings for this folder
├── .claude/outlook-*.reg      Turn Open in Outlook links on or off (Windows)
└── Clients/Acme/              An existing project folder, at any depth
    ├── STATUS.md              Added when you first wrap up this project
    └── transcripts/           Added when you first transcribe for it
```

If your folder syncs to OneDrive, Claude searches and reads its documents through the Microsoft 365 connector, so online-only files stay online. On a Mac, if iCloud Drive syncs your Documents folder, Claude searches it with the local script instead, because the connector can't see iCloud. The script skips files that are only in iCloud.

Start a new session for each unrelated task. Your knowledge lives in these files, so nothing is lost when a conversation ends.

### Open emails in Outlook

On Windows with classic Outlook, answers can add an **Open in Outlook** link next to each email, so it opens in Outlook instead of the browser. Windows turns that link type off by default, so setup only prepares it. To turn it on, double-click `.claude\outlook-links-enable.reg` in your work folder and accept the prompt. To turn it off, use `outlook-links-disable.reg`. Microsoft turns this link type off by default because a link from another app or web page could pass extra options to Outlook, such as starting a new message with a file attached. Outlook still sends nothing unless you click Send.

## Privacy and safety

- **Your access stays the same:** the Microsoft 365 connector can only see what you can already see.
- **Claude works in your folder:** it can read the files in your work folder, and it asks before changing them unless you turn that off.
- **Your data stays under your account:** this plugin has no server and collects nothing. Content Claude reads is handled under your Claude plan's terms.
- **Scripts stay local:** the bundled scripts only read files or write to your work folder. The `update` skill contacts GitHub, and transcription may download a speech model if you set it up.
- **You approve actions:** Claude asks before it sends, posts, edits, or deletes anything through a connector. Read each request before you approve it.
- **The scan keeps names, not contents:** it looks at file and folder names, dates, and short search snippets. `INDEX.md` stores only folder names, paths, and dates.
- **Your index is personal:** it can include names of private files and channels, so don't share it with people who lack the same access.
- **Outside text isn't trusted:** Claude treats emails and documents as information, not instructions. This reduces the risk of hidden instructions but can't remove it.

Only record and transcribe conversations when you have the right to do so.

For company review, see the [IT admin guide](https://github.com/ArcInfo-Consulting/second-brain/blob/main/docs/IT-ADMIN.md).

## Update or remove

Run `/second-brain:update` to update. The [changelog](https://github.com/ArcInfo-Consulting/second-brain/blob/main/CHANGELOG.md) lists what changed in each version.

To remove the plugin, delete the `second-brain-main` folder from your skills folder. Your work folder, notes, and index stay where they are.

## Troubleshooting

| Problem | What to try |
|---|---|
| `/second-brain:` doesn't appear | Start a new session, and check that `.claude-plugin` sits directly inside `second-brain-main`. If it still doesn't appear, ask IT whether plugins in the skills folder are blocked. |
| Claude can't find your files | Start the session in the folder that holds them. On many company computers, Documents is inside OneDrive, so use the folder File Explorer opens. |
| Microsoft 365 isn't available | Connect it from **+ > Connectors**. If it won't connect, ask your Microsoft Entra admin to complete setup. |
| A recent file isn't found | SharePoint and OneDrive can take time to index new files. Ask Claude to check the project's folder on your computer. |
| Local file search is blocked | Your company may restrict PowerShell scripts. Claude can still find files by name and open them. |
| Some local files are skipped | Local search skips online-only files so it doesn't download them. For OneDrive, the Microsoft 365 connector searches them instead, so check that it's connected. For iCloud on a Mac, download the folder in Finder first if you want it searched. |
| `Session Summary.md` isn't created | It's only written when a long conversation compacts. |
| No **Open in Outlook** links, or they do nothing | They need classic Outlook on Windows. Double-click `.claude\outlook-links-enable.reg` in your work folder. If that file is missing, run `/second-brain:setup` again. New Outlook and Outlook on the web can't open these links. |

## Help

If the troubleshooting table doesn't solve it, report the problem or ask a question through [GitHub Issues](https://github.com/ArcInfo-Consulting/second-brain/issues).

To report a security problem privately, open the repository's **Security** tab and select **Report a vulnerability**.

## License

[MIT](LICENSE)
