# AGENTS

## Primary Rules
- Follow `ARCHITECTURE.md` for MVVM and navigation structure.
- Views must own their ViewModels and initialize them in the View constructor.
- Views talk only to their ViewModels; ViewModels talk only to Service protocols.
- Services must emit data via `AsyncStream`.
- All models live in `Models` and are `public` with public initializers.
- Top-level TabView views must be suffixed with `Scene` and declare navigation destinations.

## Project Layout
- `MyHealth/Scenes`
- `MyHealth/ViewModels`
- `MyHealth/Services`
- `MyHealth/Models`
