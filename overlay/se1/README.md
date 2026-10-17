# GB Neo UI package (`...activities.se1`)

All GB Neo custom UI lives in this package. Nothing else in the app may be
edited for UI purposes.

## Rules (merge-safety)

1. **New screens go here.** Never edit `ControlCenterv2`, `DashboardFragment`,
   `DevicesFragment`, or any other upstream UI class in place.
2. **Subclass, don't fork.** New activities/fragments extend the upstream
   `AbstractGBActivity` / `AbstractGBFragment` / `AbstractSettingsActivityV2`
   bases. Device behavior goes through a `Se1DeviceCoordinator extends
   AdvanWatchSE1AICoordinator` (in `devices/`), overriding only capability
   methods.
3. **Embed, don't copy.** Where an upstream screen is good enough (charts,
   device settings), launch or embed the upstream fragment/activity from here.
4. **Settings stay XML-driven.** Visual regrouping = new root-screen XMLs that
   `<include>` existing `devicesettings_*` files; upstream handler code is
   untouched.
5. **Launcher switch is the only upstream touch-point.** `AndroidManifest.xml`
   points the launcher intent at `Se1MainActivity` (this package). That file
   plus `app/build.gradle` are the only upstream files expected to conflict
   on rebase — both trivially resolvable.

## Planned contents (phases)

- Phase 1: `Se1MainActivity` (4-tab bottom nav), theming (`ChartStyle` M3 helper)
- Phase 2: dashboard cards (steps, HR, SpO2, stress, sleep, water)
- Phase 3: sports tab (OSM map, live workout UI, session detail)
- Phase 4: settings polish + profile

See `~/workspace/gadgetbridge/fork-plan/03-ui-rework.md` for the full plan.
