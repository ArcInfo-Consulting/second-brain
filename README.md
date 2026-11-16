# A.I. Second Brain
An A.I. Second Brain for use with Claude

Second Brain turns Claude Code in the Claude desktop app into a searchable assistant for your work. It helps Claude find information across Outlook, SharePoint, OneDrive, Teams, and your local project folders, then answer with sources. Your files stay where they are, and your notes stay in plain files that you own.

Second Brain is a free plug-in from ArcInfo A.I.

This is an independent project. It isn't affiliated with or endorsed by Anthropic or Microsoft.

## What you can download

| Download | What it is | Where it runs |
|---|---|---|
| [second-brain.zip](https://github.com/ArcInfo-Consulting/second-brain/releases/latest/download/second-brain.zip) | The Second Brain plug-in | The **Code** tab of the Claude desktop app, on Windows and macOS |

## What you need

- The Claude desktop app, with a paid plan that includes Claude Code
- A Microsoft 365 work account connected to Claude
- Your Documents folder, or whichever folder holds most of the files you work on
- A Microsoft Entra admin to approve the connector, if your company hasn't already

Personal Outlook and Hotmail accounts can't connect.

## Install

Open the **Code** tab, start a local session, and paste this:

```text
Download https://github.com/ArcInfo-Consulting/second-brain/releases/latest/download/second-brain.zip
and extract it into ~/.claude/skills. Confirm that
~/.claude/skills/second-brain-main/.claude-plugin/plugin.json exists.
```

Then start a new session.

## Set up

1. In the desktop app, click **+** next to the prompt box, select **Connectors**, and connect Microsoft 365.
2. Start a local Code session in your Documents folder. If you keep most of your work files somewhere else, use that folder instead.
3. Run `/second-brain:setup`. It finds your details and active work on its own, so there's nothing to fill in. Claude may ask you to approve a few steps. The scan can take a few minutes, and it doesn't move anything.
4. Check the active work it found, and correct anything that's wrong.
5. Start a new session in the same folder.

Then ask questions in plain language:

- "What did we promise Acme about the go-live date?"
- "Find the latest statement of work for Project Falcon."
- "What's still open from last week's steering committee meeting?"

The [full guide](plugins/second-brain/README.md) covers everything else: what each command does, other ways to install, privacy and safety, updating, removing, and troubleshooting.

## For IT and security teams

The [IT admin guide](docs/IT-ADMIN.md) explains what runs on the computer, where data goes, and the controls you can set.

## What's new

See the [changelog](CHANGELOG.md).

## Help

Report a problem or ask a question through [GitHub Issues](https://github.com/ArcInfo-Consulting/second-brain/issues).

To report a security problem privately, open this repository's **Security** tab and select **Report a vulnerability**.

## License

[MIT](LICENSE)
