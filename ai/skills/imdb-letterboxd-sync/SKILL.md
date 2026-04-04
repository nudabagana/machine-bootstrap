---
name: imdb-letterboxd-sync
description: Use when the user wants Codex to drive a browser with Playwright MCP to export their IMDb ratings CSV, wait for manual login when needed, then open Letterboxd and import that CSV.
---

# IMDb to Letterboxd Sync

Use this skill when the user wants an interactive browser-driven sync from IMDb to Letterboxd.

## Required tools

- Playwright MCP browser tools must be available in the current session.

## Workflow

1. Confirm the Playwright browser tools are callable before starting.
2. Open IMDb in a visible browser tab.
3. Navigate to the ratings export flow.
4. If the user is not logged in, stop and explicitly tell them to log in themselves.
5. After login, click the `Export` button on the ratings page.
6. If IMDb opens an `Exporting` dialog, follow its `Open exports page` link.
7. On the exports page, identify the newest `Your ratings` export row. If multiple `Your ratings` rows exist, use the first/newest row only.
8. Wait for that newest `Your ratings` row to change from `In progress` to `Ready`.
9. Download the CSV only from that newest `Your ratings` row when its `export-status-button` becomes clickable.
10. Open Letterboxd in the same session.
11. Navigate to the import page for external data / IMDb-compatible CSV import.
12. If the user is not logged in, stop and explicitly tell them to log in themselves.
13. Upload the exported CSV.
14. Review the import summary for unmatched titles or obvious bad matches.
15. Unless the user clearly asked for a fully automatic run, pause before the final irreversible import confirmation and ask whether to proceed.

## Operating rules

- Never ask the user for raw credentials.
- Never type passwords or secrets into the browser.
- Prefer a visible browser flow so the user can intervene during login, 2FA, or captcha steps.
- Treat login, 2FA, captcha, consent, and suspicious-account prompts as manual checkpoints.
- Keep the browser on the actual exports page while polling IMDb export status. Do not drift onto `watch history`, `ratings`, or other summary links.
- On IMDb exports, target the `Your ratings` row specifically. Do not infer export status from neighboring rows.
- If multiple `Your ratings` export rows exist, always treat the first/newest row as the source of truth and ignore older ready rows.
- Never use an older `Ready` export just because it is available faster when a newer `Your ratings` export is still `In progress`.
- Poll IMDb export readiness every 30 seconds, not continuously.
- Use a hard refresh / full page reload while polling the exports page.
- Allow up to 10 minutes for the newest export row to become `Ready` before timing out.
- Prefer stable selectors over text-only clicks when available. On IMDb, use `data-testid="export-status-button"` for the ready/download control.
- If download handling requires a local path, save the CSV in the current workspace or `.playwright-mcp/` rather than only `/tmp`.
- If the Letterboxd file chooser rejects a path outside allowed roots, upload the downloaded CSV from the workspace copy in `.playwright-mcp/`.
- If IMDb or Letterboxd changes their UI, inspect the current page snapshot and adapt instead of assuming selectors from previous runs still work.
- If the import page offers multiple formats, choose the IMDb-compatible import path first.
- On the Letterboxd import summary page, note whether `Create diary entries based on watched dates` and `Import ratings` are checked before continuing.
- If unmatched films remain and the user approved skipping them, proceed without trying to repair every mismatch.
- If the site presents an irreversible final confirmation, summarize what is about to happen before proceeding.

## Default run shape

Use this sequence unless the user asks for a different variation:

1. Open IMDb.
2. Wait for manual login if needed.
3. Start export from the ratings page.
4. Move to the exports page and select the newest `Your ratings` export row.
5. Wait for that newest row to become `Ready`.
6. Download the CSV from that newest row into the workspace-accessible Playwright download area.
7. Open Letterboxd.
8. Wait for manual login if needed.
9. Upload CSV.
10. Pause before final confirmation.

## Failure handling

- If the Playwright MCP is unavailable, say that clearly and stop.
- If a download fails, verify whether IMDb still shows `In progress`, `Ready`, or an error before retrying.
- If the export is still `In progress`, hard refresh only the exports page and re-check the newest `Your ratings` row every 30 seconds.
- If an older `Your ratings` row is `Ready` but the newest one is still `In progress`, keep waiting for the newest row.
- If 10 minutes pass and the newest row is still not `Ready`, stop and report that IMDb export generation timed out.
- If the uploaded file reaches the Letterboxd preview page, treat that as success for the upload step even if the page title is generic.
- If the Letterboxd import page rejects the file, report the exact rejection shown in the page UI.
