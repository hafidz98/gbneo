# GB Neo — Gadgetbridge fork for Advan SE1

GB Neo is a UI/UX rework of Gadgetbridge focused on the Advan SE1
smartwatch (Jieli / CRP-BLE). The goal is a modern app that feels like the
vendor app (4 tabs: dashboard, sports, device, profile) while keeping the
full Gadgetbridge protocol core.

## Architecture: pinned core + overlay

Upstream Gadgetbridge is a monolithic Android app, not a library, so a
black-box "untouched dependency" wrapper is not feasible. The closest
achievable equivalent is a **source overlay with strict merge-safety rules**:

- **GB core = pinned upstream.** The `upstream` git remote tracks
  `https://codeberg.org/Freeyourgadget/Gadgetbridge.git`. Upstream updates
  only ever touch the GB side via `git fetch upstream` + merge.
- **GB Neo = overlay.** All custom UI and SE1-specific features live in
  `app/src/main/java/nodomain/freeyourgadget/gadgetbridge/activities/se1/`
  (and a future `Se1DeviceCoordinator extends AdvanWatchSE1AICoordinator`
  in `devices/`). Upstream files are never edited for UI purposes.
- **The only sanctioned upstream touch-points** are `AndroidManifest.xml`
  (launcher activity) and `app/build.gradle` (dependencies). Both are
  trivially resolvable on rebase.

**Rule: never edit an upstream file unless unavoidable — put it in the
`se1` package instead.** If you must touch upstream, note it here in
FORK.md with the reason.

## Remotes

| Remote     | URL                                                       | Purpose                    |
|------------|-----------------------------------------------------------|----------------------------|
| `upstream` | `https://codeberg.org/Freeyourgadget/Gadgetbridge.git`    | Pinned GB core (read-only) |
| `origin`   | *(to be set — your GB Neo fork repo)*                     | Our fork (push target)     |

Pinned upstream commit at fork creation:

```
0be3c1f029 Merge pull request 'Garmin: decode GarminJson TYPE_CHAR (0x13) and TYPE_BYTE_ARRAY (0x14)' (#7089)
```

Record the new pinned commit here every time you rebase onto upstream.

## Update procedure (monthly rebase recommended)

```bash
git fetch upstream
git merge upstream/master        # or: git rebase upstream/master
# Resolve conflicts — expect them only in AndroidManifest.xml / build.gradle.
# The se1/ package has no upstream counterpart and never conflicts.
# After merging, record the new pinned commit hash in this file.
./gradlew assembleDebug          # must stay green
```

## Merge-safety rules (from `~/workspace/gadgetbridge/fork-plan/03-ui-rework.md`)

1. New UI lives in `...activities.se1/` — never edit upstream UI classes in place.
2. Subclass, don't fork, coordinators (`Se1DeviceCoordinator extends
   AdvanWatchSE1AICoordinator`, capability overrides only).
3. Settings stay XML-driven — new root XMLs `<include>` existing
   `devicesettings_*` files; upstream handlers untouched.
4. Rebase cadence: monthly; conflicts concentrate in the two sanctioned files.

## License

AGPLv3 (inherited from upstream — see `LICENSE`). The fork stays
open-source; publish the full source from the first shared binary. Do not
strip license headers. Protocol improvements (not UI) should go back
upstream via Codeberg PR.

## Research docs

Full plans live outside this repo (not part of the build):

- `~/workspace/gadgetbridge/fork-plan/01-osm-sports.md` — OSM sports tab
- `~/workspace/gadgetbridge/fork-plan/02-health-connect.md` — Health Connect mapping
- `~/workspace/gadgetbridge/fork-plan/03-ui-rework.md` — UI rework plan + these rules
- `~/workspace/gadgetbridge/fork-plan/04-custom-watchface.md` — slot-8 custom faces
- `~/workspace/gadgetbridge/fork-plan/05-weather.md` — OpenWeather + GPS-off fallback

Protocol reference: `~/workspace/your_files/dafit-crp-protocol/SPEC.md` (v22).
