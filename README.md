# A.I. Second Brain

Free AI tools and videos from [ArcInfo A.I.](https://arcinfo.ai)

## About ArcInfo A.I.

ArcInfo A.I. builds AI that does real work inside the systems your business already runs on. We design, build and support AI agents, cloud platforms and business applications for companies on AWS, Salesforce and Microsoft 365.

AI development is our strong suit. We pair it with deep AWS and Salesforce experience, so what we build connects to your data and holds up in production.

### What we do

- **AI agents:** agents that search, draft, sort and act across your business systems, including agents built on Amazon Bedrock AgentCore.
- **Agentic software development:** helping engineering teams build and ship software with AI agents in the loop.
- **Private and on-prem AI:** local models running on your own hardware, for data that has to stay in-house.
- **AWS architecture and integration:** cloud design, serverless applications and integrations on AWS.
- **Amazon Connect:** contact center implementations and integrations.
- **Salesforce:** development, administration and integration with the rest of your systems.
- **Custom software:** applications built around how your team actually works.

ArcInfo A.I. is based in El Segundo, California. To talk about a project, visit [arcinfo.ai](https://arcinfo.ai) or email [sales@arcinfo.ai](mailto:sales@arcinfo.ai).

## The Second Brain series

Short videos that show how to put AI to work on your own email and files, one step at a time. Each episode comes with a free download here on GitHub. Watch them on [our YouTube channel](https://www.youtube.com/@ArcInfoAI).

- **Episode 1: Second Brain.** Give Claude a memory of your work across Microsoft 365 and your local files. Download: the Second Brain plugin, below.
- **Episode 2: Your First AI Agent.** Your second brain remembers, and your agent acts on it. Download: coming soon.
- **Episode 3: Teach AI Your Process.** Show AI a process once and turn it into a skill you can reuse. Download: coming soon.

[Subscribe on YouTube](https://www.youtube.com/@ArcInfoAI) to catch new episodes.

## The Second Brain plugin

Second Brain turns Claude Code in the Claude desktop app into a searchable assistant for your work. It helps Claude find information across Outlook, SharePoint, OneDrive, Teams, and your local project folders, then answer with sources. Your files stay where they are, and your notes stay in plain files that you own.

Second Brain is a free plugin from ArcInfo A.I.

This is an independent project. It isn't affiliated with or endorsed by Anthropic or Microsoft.

### Download

[second-brain.zip](https://github.com/ArcInfo-Consulting/second-brain/releases/latest/download/second-brain.zip) is the Second Brain plugin. It runs in the **Code** tab of the Claude desktop app, on Windows and macOS.

### What you need

- The Claude desktop app, with a paid plan that includes Claude Code
- A Microsoft 365 work account connected to Claude
- Your Documents folder, or whichever folder holds most of the files you work on
- A Microsoft Entra admin to approve the connector, if your company hasn't already

Personal Outlook and Hotmail accounts can't connect.

### Install

Open the **Code** tab, start a local session, and paste this:

```text
Download https://github.com/ArcInfo-Consulting/second-brain/releases/latest/download/second-brain.zip
and extract it into ~/.claude/skills. Confirm that
~/.claude/skills/second-brain-main/.claude-plugin/plugin.json exists.
```

Then start a new session.

### Set up

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

### For IT and security teams

The [IT admin guide](docs/IT-ADMIN.md) explains what runs on the computer, where data goes, and the controls you can set.

### What's new

See the [changelog](CHANGELOG.md).

## Help

Report a problem or ask a question through [GitHub Issues](https://github.com/ArcInfo-Consulting/second-brain/issues).

To report a security problem privately, open this repository's **Security** tab and select **Report a vulnerability**.

## Work with us

Want an AI agent, an AWS build or a Salesforce integration made for your business? Visit [arcinfo.ai](https://arcinfo.ai) or email [sales@arcinfo.ai](mailto:sales@arcinfo.ai).

## License

[MIT](LICENSE)
