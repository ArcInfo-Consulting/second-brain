---
name: update
description: Update a Second Brain install in the skills folder to the latest version from GitHub.
disable-model-invocation: true
---

# Update Second Brain

Replace the plugin's files with the latest release. This doesn't touch the user's work folder, `CLAUDE.md`, projects, or index.

1. Find the install folder, which is two levels above `${CLAUDE_SKILL_DIR}`. Read `.claude-plugin/plugin.json` there to get the current version.
2. If the install folder is inside `.claude/plugins`, Claude Code manages it. Tell the user to run this in a terminal, then stop:

   ```text
   claude plugin update second-brain@arcinfo
   ```

3. If the install folder isn't inside `.claude/skills`, stop and explain that you can't update it safely.
4. Read the latest version from `https://raw.githubusercontent.com/ArcInfo-Consulting/second-brain/main/plugins/second-brain/.claude-plugin/plugin.json`. If it's the same as or older than the current version, say so and stop. A copy installed from a zip file can be newer than GitHub.
5. Show the current and latest versions, link to `https://github.com/ArcInfo-Consulting/second-brain/blob/main/CHANGELOG.md`, and ask for approval.
6. Download `https://github.com/ArcInfo-Consulting/second-brain/releases/latest/download/second-brain.zip` to a new temporary folder and extract it.
7. Confirm that the extracted `.claude-plugin/plugin.json` names `second-brain` and has a newer version than the current one. If it doesn't, stop.
8. Move the current install folder to `~/.claude/second-brain-backups/<today's date>/`, outside the skills folder. A backup left in the skills folder would load as a second copy.
9. Move the extracted folder to the original install location, then confirm that `.claude-plugin/plugin.json` is there.
10. Tell the user to start a new session.

If a step fails after the old folder moves, put the backup back before stopping.

Setup adds files to each work folder, such as hooks and registry files. If `skills/setup/` changed in this release, tell the user to run `/second-brain:setup` again. It keeps their existing files and adds only what's missing.
