# Persian Latin TTS (Text-to-Speech)

A small **Delphi** desktop application (2007) that converts **Persian text written in Latin script** (e.g. Finglish / Pinglish) into speech using diphone-based synthesis.

## Overview

- **Language:** Delphi (Borland Developer Studio)
- **Input:** Persian text typed with Latin characters
- **Output:** Synthesized speech (wave generation, played via MediaPlayer)
- **Status:** **Archived** — no longer maintained or developed.

## Features

- Sentence and word analysis (syllable types: CV, CVC, CVCC, etc.)
- Number and symbol conversion to spoken form
- Diphone-based concatenative synthesis
- GUI: load/save text, options, play generated speech

## Project Structure

- `TextToDiphone.dpr` — main program
- `main.pas` / `main.dfm` — main form and TTS logic
- `Options.pas` — options form
- `Unit1.pas`, `Unit2.pas` — additional forms
- Data files: `Vowels.txt`, `Consonants.txt`, `Alpha*.txt`, `Numbers.txt`, `Symbol*.txt`, etc.
- `samples/` — sample Persian (Latin) text files

## Building

Open `TextToDiphone.bdsproj` (or `TextToDiphone.dpr`) in Borland Delphi / BDS 2006 and build. The project references `..\Unit Test\Func.pas`; you may need to add that unit or adjust the path.

## License

No license file is included. The code is offered as-is; you may use and adapt it as you wish. No warranty.

---

*Archived project — not actively developed.*
