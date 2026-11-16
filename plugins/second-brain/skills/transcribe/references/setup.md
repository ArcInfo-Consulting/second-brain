# Set up local transcription

Claude can't listen to audio files on its own, so transcription needs a separate tool. This guide uses [`whisper-transcribe-mcp`](https://pypi.org/project/whisper-transcribe-mcp/), an open-source tool from a third party. It isn't part of Second Brain, so review it and follow your company's software rules before installing it.

You can skip this if you only need Teams meeting transcripts.

## What you need

Install `uv` from a terminal:

```text
winget install astral-sh.uv
```

On macOS or Linux, follow the instructions at [astral.sh/uv](https://docs.astral.sh/uv/).

## Add the tool to your work folder

Create a file named `.mcp.json` in your work folder, or add this entry to the existing file:

```json
{
  "mcpServers": {
    "whisper-transcribe": {
      "command": "uvx",
      "args": ["whisper-transcribe-mcp[local]"],
      "env": {
        "WHISPER_MODEL": "base"
      }
    }
  }
}
```

Start a new session. Claude Code asks you to approve a project server the first time it finds one.

If Claude Code can't find `uvx`, replace `uvx` with its full path. On Windows, that's usually `C:\\Users\\<your name>\\.local\\bin\\uvx.exe`.

## What to expect

- The first run downloads a speech model from Hugging Face. After that, transcription runs on your computer.
- Larger models are more accurate but slower. Set `WHISPER_MODEL` to `tiny`, `base`, `small`, `medium`, or `large-v3`.
- Examples of supported formats include `mp3`, `wav`, `m4a`, `ogg`, `flac`, and `webm`.

## Keep audio local

The tool sends audio to OpenAI if an `OPENAI_API_KEY` is set, and its optional post-processing sends the transcript to an OpenAI model. Don't set that key if recordings must stay on your computer, and leave post-processing off.
