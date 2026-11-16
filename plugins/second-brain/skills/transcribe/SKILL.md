---
name: transcribe
description: Turn voice memos, meeting audio, or Teams meeting transcripts into a transcript and summary in a project's transcripts folder. Use when the user shares or mentions a recording or voice memo.
---

# Transcribe

Create two files in the `transcripts/` folder inside the project's folder, which is on its `Local` line in `INDEX.md`. If it has no `Local` line, use a folder named after the project in the work folder, and add the line:

- `YYYY-MM-DD-topic-transcript.md`
- `YYYY-MM-DD-topic-summary.md`

If no project is clear, ask. Never overwrite an existing transcript: add a number to the new file name instead.

Recordings can contain confidential material, so keep audio on this computer unless the user clearly agrees to send it to an outside service.

## For a Teams meeting

If the user means a Teams meeting, no audio file is needed:

1. Find the meeting in the Outlook calendar.
2. Open the event and use its meeting transcript link with the Microsoft 365 connector.
3. If no transcript exists, say so. Don't rebuild the meeting from chat messages.
4. Write the two files.

## For an audio file

1. Check for a transcription tool, such as `transcribe_file` from the `whisper-transcribe` server. If there isn't one, read `${CLAUDE_SKILL_DIR}/references/setup.md` and offer to help set it up.
2. Call `list_models` if it's available, and check which backend is active. If it's OpenAI, tell the user their audio would leave this computer, and continue only if they agree.
3. Transcribe the file using its full path. Don't turn on post-processing unless the user agrees, because it sends the transcript to an outside model.
4. Write the two files.

## Transcript format

```markdown
# <topic> transcript

- Date: YYYY-MM-DD
- Source: <audio file path or Teams meeting name>
- Speakers: <names, or "not identified">

<transcript text>
```

Don't correct, shorten, or tidy the wording. If a passage is unclear, keep it as it came out and mark it `[unclear]`.

## Summary format

```markdown
# <topic> summary

- Date: YYYY-MM-DD
- Transcript: <transcript file name>

## Summary

## Decisions

## Commitments

## Open questions
```

Only include what the recording says. If it doesn't name an owner or date, write `unknown`.

After writing the files, offer to run the `wrap-up` skill so the decisions reach the project's `STATUS.md`.
