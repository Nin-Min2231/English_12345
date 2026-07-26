# Sprint 3 (P2) implementation plan — lop2_english_app

Bản sao lưu lại trong project của kế hoạch đã được duyệt (plan mode) ngày 2026-07-23, để phiên
Claude Code mới đọc được (kế hoạch gốc nằm ở `C:\Users\NguyenNC\.claude\plans\` — chỉ máy này có,
không đưa vào git). Cập nhật tiến độ ở đây khi xong từng phase; nội dung kế hoạch bên dưới giữ
nguyên như lúc duyệt.

## Tiến độ

- [x] **Phase 0 — Shared plumbing** (2026-07-23): `_gameTypes`→`kGameTypeOrder` (public), `kUnitGames`
  suy ra từ map `gameDefsByType` (không còn 2 danh sách độc lập), `isCheckpointUnlocked`,
  `_maxStarsByGameType` (chuẩn bị cho G10 sao tối đa 2), `checkpoints.dart` (Checkpoint,
  kFunTimeCheckpoints, kBossQuizCheckpoints, extraGamesForUnit), `badge_defs.dart` (4 huy hiệu
  placeholder), 3 màu mới `AppColors.successDark/secondaryDark/errorDark`.
- [x] **Phase 1 — G09 Fun Time** (2026-07-23): sinh `g09_memory.json` từ `g01_flashcard.json` (đã lọc
  bỏ từ không có audio — phát hiện `g01_flashcard.json` KHÔNG tự lọc như giả định ban đầu, phải lọc
  tay theo `audio != null`) — Fun Time 1-3 đủ 6 cặp, Fun Time 4 (Unit 13-14) chỉ 7 cặp (không phải 13
  như tính thô ban đầu). `MemoryPairItem` model, `funTimeByUnit` trong content_repository.dart,
  `memory_match_screen.dart` (lật cặp, KHÔNG xáo lại khi sai — khác quy ước thường của app).
  **Follow-up (2026-07-26, CR-021)**: "Easy mode: explicitly deferred for G09" bên dưới (Phase 1 gốc)
  nay đã bổ sung — xem trước toàn bộ thẻ 4 giây khi Dễ, chi tiết `BUGS_CR.md` CR-021.
- [x] **Phase 2 — G10 Săn chữ** (2026-07-23): sinh `g10_letter_hunt.json` — `target_letter` = copy
  trực tiếp `units.json.phonics`, `reward_*` = từ đầu tiên mỗi unit trong `g01_flashcard.json`,
  digraph Unit14 (`er`)/Unit15 (`sh`) giữ nguyên chuỗi 2 ký tự. `HuntLetterItem` model (config phẳng,
  không phải List — duy nhất trong số các game). `letter_hunt_screen.dart` (5 vòng lưới chữ, mẫu
  chọn-đáp-án chuẩn, sao tối đa 2). Thêm `'g10'` vào `kGameTypeOrder` + `gameDefsByType`.
- [x] **Phase 3 — G12 Boss Quiz + huy hiệu** (2026-07-23): script trộn 10 câu/checkpoint từ
  G02/G03/G05 đã có (dedupe G03 còn 1 lượt/từ, G05 sinh câu nhiễu bằng xáo token). `BossQuizQuestion`/
  `BossQuizOption` model, `boss_quiz_screen.dart` (bản sao `listen_pick_screen.dart`). DB: bảng
  `EarnedBadges` mới, `schemaVersion` 1→2, `MigrationStrategy` đầu tiên của app (`onUpgrade` chỉ tạo
  bảng mới, không đụng bảng cũ), sửa `ProfileRepository.delete()` xóa thêm `EarnedBadges`.
  `badge_repository.dart`, `badges_screen.dart` (xem lại huy hiệu, entry point icon 🏆 trên Home).
  Trao huy hiệu qua `UnitScreen._playGame` (đổi tham số từ `String gameType` sang `GameDef game`).
  `flutter analyze` sạch, build APK debug thành công. APK debug:
  `05_Build_APK/lop2_english_app-debug-2026-07-23-12.apk` — **chưa test trên điện thoại thật**, đặc
  biệt cần cài như bản cập nhật (không gỡ cài đặt lại) để xác nhận không mất hồ sơ/tiến độ cũ qua
  migration DB đầu tiên.

---

## Context

Sprint 2 shipped G01–G08 + F15 (settings/parent gate/difficulty) and is fully committed to git.
`CLAUDE.md` §8 has only a one-line placeholder for Sprint 3: "G09 memory, G10 săn chữ, G11 truyện,
G13 Boss Quiz + huy hiệu" — no detailed plan exists yet, unlike Sprint 2 which was researched and
approved before coding began. This plan does that research pass for Sprint 3, the same way it was
done for Sprint 2 (re-reading the 15-sheet dev doc + the curriculum-analysis workbook to find out
what's actually buildable now vs. genuinely blocked).

Two corrections confirmed with the user before this plan was written:
- **"G13" is a typo — the source docs' 12-game catalog calls Boss Quiz "G12"** (both workbooks agree,
  in 3 separate places). This plan uses G12 throughout; `CLAUDE.md`'s roadmap line should be corrected
  when this ships.
- **G11 (Truyện tương tác / Phil & Sue story) is deferred**, same status as G07: unlike G05/G06/G09/G10
  (where source content turned out to already exist, just unextracted), G11 has **no** dialogue/bubble
  text anywhere in either spreadsheet and **no** story-page illustrations in `04_image+audio/` — the
  audio tracks (22/45/68/91) exist but uncut. The real content likely lives in `01_Document/book.pdf`
  pages 20/37/54/71, which is too large to read in this environment. Sprint 3 = **G09 + G10 + G12 only**.

Research this session (reading both source Excel workbooks directly, plus the full current codebase —
models, content repository, progress repository, game_defs/unit_screen, DB layer, all 5 existing game
screens) found:
- **G09 (Memory match)** and **G10 (Săn chữ)** need zero new content — same "already there, just needs
  extracting" pattern as G05/G06. G10 even reuses `UnitInfo.phonics` directly as its target letter.
- **G12 (Boss Quiz)** needs zero new question content — it's a mix of already-shipped G02/G03/G05
  question data. Only **badges** are undesigned in the source docs ("App tự định nghĩa" — the app must
  invent names/criteria/art itself); this plan proposes a concrete default.
- G09/G12 aren't per-unit games like G01-G08 — they attach to a "checkpoint" unit (Fun Time after
  Units 2/6/10/14, Review+Boss Quiz after Units 4/8/12/16), which needs one new small mechanism, not a
  Home-screen redesign.
- This sprint's biggest engineering risk isn't a new package (Sprint 3 needs **zero new pub packages**,
  unlike Sprint 2's G08/F15 — avoids the whole BUG-004 class of problem) — it's the **first-ever Drift
  schema migration**, needed for the badges table, on a real device already holding the test child's
  real profile/progress data.

Intended outcome: ship G09, G10, G12 + badges fully working end-to-end, keep G11 explicitly pending
(update `CLAUDE.md`/`HANDOVER.md` the same way G07's pending status is already tracked).

## Phase 0 — Shared plumbing (no DB changes yet — keep the migration isolated to Phase 3)

**Fix the `game_defs.dart` / `progress_repository.dart` parallel-list footgun while both files are
already being touched.** Today `kUnitGames` (`game_defs.dart`) and `_gameTypes`
(`progress_repository.dart`) are two independently hand-maintained lists that must stay in the same
order, and nothing enforces that. Concretely:
- Rename `_gameTypes` → public `kGameTypeOrder` in `progress_repository.dart` (keep `_coreGameTypes`
  private).
- In `game_defs.dart`, keep the existing 8 `GameDef` literals but store them in an unordered
  `Map<String, GameDef> _gameDefsByType` keyed by `gameType`, and derive
  `final List<GameDef> kUnitGames = kGameTypeOrder.map((t) => _gameDefsByType[t]!).toList();` — render
  order and unlock order can then never diverge (a missing entry becomes a loud crash, not a silent
  always-unlocked game).
- Append `'g10'` to `kGameTypeOrder` (it's a normal per-unit game, like G01-G08). **Do not** add
  `'g09'`/`'g12'` to this list — they need a different unlock rule (below), and `isGameUnlocked`'s
  `indexOf(gameType) == -1 → returns true` behavior means anything accidentally left out is *silently
  always unlocked*, which is exactly why G07 was deliberately excluded and why G09/G12 must be too
  (with a comment explaining why, not just an omission).

**Add a per-game-type star cap** (needed because G10's catalog spec caps it at 2 stars, not 3 — see
Phase 2): in `progress_repository.dart`, add `const _maxStarsByGameType = {'g10': 2};` and change
`maxStarsPerUnit` to `kGameTypeOrder.fold(0, (s, g) => s + (_maxStarsByGameType[g] ?? 3))` instead of
the current `kGameTypeOrder.length * 3`.

**Checkpoint mechanism** (Fun Time / Boss Quiz attach to one specific unit, not every unit):
- New file `lib/features/unit/checkpoints.dart`: a small `Checkpoint {afterUnit, fromUnit, toUnit,
  badgeId}` class (badgeId nullable, only Boss Quiz checkpoints set it), two const lists
  `kFunTimeCheckpoints` (afterUnit 2/6/10/14) and `kBossQuizCheckpoints` (afterUnit 4/8/12/16), and
  `List<GameDef> extraGamesForUnit(int unitId)` returning `[]` normally or the matching checkpoint's
  `GameDef` (built via a closure over that `Checkpoint` so the label can mention its unit range).
- `GameDef` (`game_defs.dart`) gets **one** new optional field:
  `final bool Function(ProgressRepository, List<LessonProgress>, int)? isUnlockedOverride;` (null for
  all 9 per-unit entries; set to a new `isCheckpointUnlocked` for the 8 checkpoint constructors) and
  **one** more: `final String? badgeId;` (null except on the 4 Boss Quiz checkpoints).
- `progress_repository.dart`: add
  `bool isCheckpointUnlocked(progress, unitId) => _coreGameTypes.every((g) => starsFor(progress, unitId, g) >= 1);`
  — this checks the **attached unit's own** core games (not the previous unit's — reaching a unit only
  guarantees the *previous* unit is done, not that unit's own G01-G04, so Fun Time/Boss Quiz need their
  own gate here, otherwise a child could open e.g. Boss Quiz 1 on Unit 4 before ever touching Unit 4's
  own games).
- `unit_screen.dart`: add a second loop after the existing `for (final game in kUnitGames)` —
  `for (final game in extraGamesForUnit(unit.unitId))` — reusing `_gameRowFor` unchanged except its
  unlocked check becomes
  `game.isUnlockedOverride?.call(_progressRepo, progress, unit.unitId) ?? _progressRepo.isGameUnlocked(...)`.
  Fun Time and Boss Quiz `afterUnit` values never coincide (2/6/10/14 vs 4/8/12/16), so no unit ever
  needs to render both.

**Badge definitions as Dart constants, not DB/JSON** (same precedent as `GameDef`/`kUnitGames` —
app-authored structural data that never changes at runtime doesn't need a table): new
`lib/features/badges/badge_defs.dart` — `BadgeDef {badgeId, name, icon, afterUnit}` class + `const
kBadgeDefs` list of exactly 4. Proposed defaults (placeholder-quality, easy to rename later, same
"asset gap" spirit as the sfx-file gaps already tracked in `CLAUDE.md` §9 — flag as such, don't block
on it): "Ong Chăm Chỉ" (unit 4, `Icons.emoji_events_rounded`), "Ngôi Sao Nhỏ" (unit 8,
`Icons.workspace_premium_rounded`), "Nhà Vô Địch" (unit 12, `Icons.military_tech_rounded`), "Siêu Sao
Anh Ngữ" (unit 16, `Icons.auto_awesome_rounded`) — all tinted `AppColors.warning` (gold reads as
"achievement" universally; differentiate by icon/name, not a 4th new hue).

## Phase 1 — G09 "Fun Time" (memory match)

**Data.** Each Fun Time covers only its own immediately-preceding 2-unit pair (1→U1-2, 2→U5-6,
3→U9-10, 4→U13-14) — matches the source doc's repeated "hình + từ 2 unit trước" wording and the
project's "≤5 phút/phiên" goal (a cumulative review would balloon by Fun Time 4). **Generate pairs from
`g01_flashcard.json`'s per-unit `cards[]`** (already excludes the 7 audio-less extended words), not
raw `vocabulary.json` — this means pair count varies per Fun Time (don't hardcode 6; Fun Time 4 in
particular will have more than 6 since Units 13/14 include extra audio-ready words beyond the usual 3).

New `assets/data/games/g09_memory.json` (generate via script, mirroring the existing
`03_Assets/data_json/README_data.md` process): `instances[]` keyed by the **attachment** unit (2/6/10/14),
`config.pairs[]` = `{word_id, word, image, audio}` (same shape as `ScrambleItem`, but per this
codebase's convention of one model per game, add `MemoryPairItem` to `models.dart` + a
`Map<int, List<MemoryPairItem>> funTimeByUnit` field/loop in `content_repository.dart`, identical loop
shape to every existing one).

**Screen** `lib/features/games/memory_match/memory_match_screen.dart`. Closest structural analog is
`FlashcardScreen` (one self-contained board, not a page-through list of N questions), with
`listen_pick_screen.dart`'s feedback mechanics layered on top (`AnswerFeedbackOverlay`,
`AudioService.playSfx`, and the BUG-003 tap-guard discipline — block flips while feedback is showing).
**Explicit, deliberate deviation from the "chọn sai thì xáo trộn" convention: do NOT reshuffle card
positions after a wrong flip** — that would defeat the point of a memory game; only face-up/down state
changes, the board layout is fixed for the session.

Mechanics: for P pairs, build 2P cards (one image-kind + one word-kind per pair index), shuffle once at
start. Tap flips card 1 silently; tap on card 2 checks `pairIndex` equal **and** `kind` different (an
image card must pair with the *other* kind's card for the same word). Match → `correct.mp3` + that
pair's word audio (reinforces vocab, free win since the audio's already loaded), mark both matched.
Mismatch → `wrong.mp3`, flip both back after ~700-900ms (no reshuffle). `GridView.count(crossAxisCount:
4)` handles any pair count without special-casing. Header: moves counter + "Đã ghép X/P cặp". No
Back/Next (single-session shape, like Flashcard).

**Stars** (1-3, per catalog): track `attempts` (each completed pair-check, match or not); minimum
possible = `pairs` (flawless run). `stars = attempts <= pairs ? 3 : (attempts <= pairs*2 ? 2 : 1)`.

**Easy mode**: explicitly deferred for G09 — it fits neither existing easy-mode mechanic (no wrong
option to dim, no tile to prefill), and inventing a third mechanic is out of this sprint's scope. Track
as a known gap in `CLAUDE.md` §9, same as other tracked gaps.

**Wiring**: new `AppColors.successDark` (same "darken an existing role hue" technique as G08's
`infoDark`) + `Icons.grid_view_rounded`, default white foreground. Checkpoint `GameDef` built in
`checkpoints.dart` per §Phase 0, `gameType: 'g09'`, `isUnlockedOverride: isCheckpointUnlocked`.

## Phase 2 — G10 "Săn chữ" (letter hunt)

**Simplification (validated against the codebase's own precedent of deliberate simplicity — no
Riverpod/go_router, tap-instead-of-drag for G03): implement as 5 rounds of a static reshuffled grid
reusing the exact G02 answer-based pattern**, not literal falling/moving-letter physics — new
animation/collision code with zero precedent here and real performance risk on low-end phones, for a
mechanic ("reshuffled multiple-choice, 5 times") that teaches the same thing.

**Data.** `target_letter` = **direct copy of `units.json`'s existing `phonics` field** (verified: p, k,
s, r, q, x, j, v, y, z, i, a, n, **er**, **sh**, t for units 1-16 — already exactly what G10 needs, no
new authoring). Both source workbooks' risk sheets explicitly call out G10 by name for digraph handling
— `er`/`sh` are 2-character strings, matching how G03/G04 already treat digraphs as one unit.
`distractors`: ~5 random distinct single letters excluding the target (same category of generation as
G02/G03's existing distractor-picking). `reward_word_id`/`image`/`audio`: that unit's first entry in
`g01_flashcard.json`'s `cards[]` (reuses the already-filtered list, same trick as G09).

New model `HuntLetterItem` (`models.dart`). New `assets/data/games/g10_letter_hunt.json`, 16 instances.
**Deliberate loop-shape deviation, comment it clearly**: there's exactly one `HuntLetterItem` per unit
(the "5 rounds" is UI-side repetition of the same target+distractors, not 5 distinct data rows), so
`config` is a flat object, not a list — `content_repository.dart` gets
`final Map<int, HuntLetterItem> huntByUnit;` (singular, not `Map<int, List<...>>`) with a loop that
casts `m['config']` directly, no `.map().toList()`.

**Screen** `lib/features/games/letter_hunt/letter_hunt_screen.dart` — standard answer-based pattern,
no exception here (reshuffle-on-wrong applies normally, unlike G09). State: `_caught` (target 5),
`_tiles` (target + distractors, reshuffled per round). Header: "Tìm chữ: P" prompt (silent by default,
matching the CR-012/017 convention) + "Nghe gợi ý" button (plays the reward word's existing audio as an
approximate phonics-sound cue, e.g. `pasta.mp3` for target `p` — same "reuse a shared audio as a hint"
trick as G05/G06; comment that it's word-initial-sound, not an isolated phoneme). `GridView` ~6 tiles.
Correct → feedback + `_caught++`, reshuffle next round or finish at 5; wrong → feedback + reshuffle
(standard), BUG-003 tap-guard. No Back/Next (single session). On 5/5: `_showResult()` shows the reward
`WordImage` + word + auto-plays its audio once (a celebratory reveal, not a "hint auto-play" — G02
already auto-plays its own prompt on entry, so auto-play isn't categorically banned, just the *hint*
button specifically shouldn't fire without a tap).

**Stars — capped at 2** (per catalog, not the usual 3): `stars = misses == 0 ? 2 : 1` (this is exactly
why Phase 0 added the per-game-type star cap).

**Easy mode**: fits the answer-based pattern cleanly — eliminate 1 wrong distractor tile, same mechanic
as `ListenPickScreen`'s `_eliminatedDisplayPos`, recomputed each round.

**Wiring**: `AppColors.secondaryDark` + `Icons.search_rounded`. `gameType: 'g10'`, added directly to
the flat per-unit `_gameDefsByType` map (Phase 0) — it's a normal entry, not a checkpoint.

## Phase 3 — G12 "Boss Quiz" + badges (includes the DB migration — do this last, test carefully)

**Sampling: a one-off generation script producing static JSON, not runtime mixing** — every other game
in this codebase is "JSON already fully shaped, Dart just casts it"; keep that invariant rather than
introducing the first runtime content-transformation. This also lets the ~10 questions per checkpoint
be hand-reviewed before shipping, like G05/G06 were.

New unified models in `models.dart`: `BossQuizQuestion {sourceGame, unitId, promptText?, promptAudio?,
promptImage?, options: List<BossQuizOption>, answerIdx}` / `BossQuizOption {image?, text?}`. Generation
script maps:
- **G02** (`ListenQuestion`) → 1:1 repackage, `promptAudio` + image options, zero transformation.
- **G03** (`FillItem`) → `promptImage` + `promptText` (word with `hiddenIdx` blanked to "_"), options =
  shuffled `[answer, ...distractors]` as **text** (reuses existing distractor data).
- **G05** (`SentenceItem`) → `promptText = "Câu nào đúng?"`, correct = `sentence` as-is, 1-2 decoys =
  token-shuffled versions of the *same* sentence (guaranteed-wrong, no new authoring). Edge case: very
  short sentences may not yield enough distinct wrong reorderings — fall back to borrowing a decoy from
  another unit in the same 4-unit pool.

Sample ~10 questions per checkpoint, roughly round-robin across the 3 source games and spread across
the 4 covered units. New `Map<int, List<BossQuizQuestion>> bossQuizByUnit` in `content_repository.dart`,
keyed by attachment unit (4/8/12/16), same loop shape as every other game.

**Screen** `lib/features/games/boss_quiz/boss_quiz_screen.dart` — near-verbatim structural copy of
`ListenPickScreen` (`_index`/`_order`/`_correctIndices`/`_feedback`, reshuffle-on-wrong, BUG-003 guard,
Back/Next, easy-mode elimination reused directly) — only difference is `_optionTile`/prompt rendering
branches on which of `image`/`text`/`promptAudio`/`promptImage` is populated. `_showResult()` reuses the
existing 3-tier star formula unmodified (`correct >= total ? 3 : correct >= total*0.6 ? 2 : 1`).

**Badges — DB migration (first one ever in this project).** In `app_database.dart`: add
`@DataClassName('EarnedBadge') class EarnedBadges extends Table { IntColumn id...; IntColumn profileId
=> integer().references(Profiles, #id)(); TextColumn badgeId => text()(); DateTimeColumn earnedAt...; }`,
add it to `@DriftDatabase(tables: [...])`, bump `schemaVersion` to `2`, and — **required, not
optional, the instant the version bumps** — add
`@override MigrationStrategy get migration => MigrationStrategy(onUpgrade: (m, from, to) async { if (from < 2) await m.createTable(earnedBadges); });`
(the default `onCreate: (m) => m.createAll()` already covers fresh installs correctly since it creates
every currently-registered table; only upgrades of an *existing* on-device DB need the explicit delta).
Re-run `dart run build_runner build --delete-conflicting-outputs` after. **Also update
`ProfileRepository.delete()`**: it already deletes `LessonProgressTable` rows before `Profiles` in one
transaction (no FK cascade enabled) — `EarnedBadges` now also references `Profiles`, so `delete()` must
delete `EarnedBadges` rows in that same transaction too, or deleting a profile leaves orphaned badge
rows (reproducing the exact problem CR-014 already solved once).

New `lib/data/repositories/badge_repository.dart` (mirrors `ProgressRepository`'s style):
`watchForProfile(profileId)`, `Future<bool> award(profileId, badgeId)` (insert if absent, return
whether newly-inserted — needed so the UI only celebrates once; check-then-insert, same
race-tolerance already accepted elsewhere, not a new gap).

**Badge award wiring** — keep game screens "dumb" (only `UnitScreen` touches the DB today; don't break
that separation for the first checkpoint game). Change `UnitScreen._playGame`'s first param from
`String gameType` to `GameDef game` (one call site). After a successful `reportResult`, if
`game.badgeId != null && result >= 2`: call `BadgeRepository(widget.db).award(...)`; if newly-awarded,
show a second `AlertDialog` (after the normal result dialog is dismissed, not replacing it) with the
`BadgeDef`'s icon + name + a congratulatory line, same `RoundedRectangleBorder`/`AppSpacing.radiusLg`
styling as every other dialog. Keep this as a private method in `unit_screen.dart` (one call site,
not worth promoting to `common_widgets.dart` yet).

**New `lib/features/badges/badges_screen.dart`** (required, not optional — without it, a badge earned
once becomes invisible forever after its one-time dialog): simple grid over `kBadgeDefs` +
`BadgeRepository.watchForProfile`; earned = full color, not-yet-earned = dimmed + lock icon (reuse
`home_screen.dart`'s existing locked-tile treatment). Entry point: one more `IconButton` on
`HomeScreen`'s `AppBar`.

**Wiring**: `AppColors.errorDark` + `Icons.emoji_events_rounded` (trophy) for the Boss Quiz tile itself.
`gameType: 'g12'`, checkpoint-only, `isUnlockedOverride: isCheckpointUnlocked`, `badgeId` set per the 4
`kBossQuizCheckpoints` entries.

## Verification

Baseline, same as every prior phase: `flutter analyze` clean + `dart format .` after each phase (not
just at the end), `flutter build apk --debug`, update `CLAUDE.md` (§2/§4/§8/§9 — including marking G11
still-pending and correcting "G13"→"G12"), `BUGS_CR.md`/`HANDOVER.md`, and
`03_Assets/data_json/README_data.md` (3 new rows) as you go.

This sprint's specific risk priorities, in order:

1. **The DB migration is the highest-risk item** — it's the one thing that could actually lose the
   test child's real progress, which is exactly what this project's "sao chỉ tăng, không giảm" norm
   exists to protect. Before installing the Sprint 3 APK: back up the current on-device SQLite file
   first (`adb shell run-as com.lop2englishapp.lop2_english_app`, file is `lop2_english_app.sqlite` per
   `app_database.dart`), then install the new APK as an **update**, not uninstall/reinstall (which
   would wipe app storage and defeat the point of testing the upgrade path) — confirm existing
   profiles/stars still render, then confirm badges/checkpoints work without crashing.
2. **Checkpoint gating** — specifically test that Fun Time/Boss Quiz tiles stay locked on a unit whose
   *own* core games aren't done yet, even though the unit itself is already reachable (this is a new
   code path with no precedent — the exact gap `isCheckpointUnlocked` was added to close).
3. **G10 digraph rendering** on Units 14/15 (`er`/`sh` 2-char tile among 1-char distractors).
4. **Fun Time 4's larger board** (Units 13-14 pair count is more than the usual 6 — confirm
   `GridView.count(crossAxisCount: 4)` doesn't clip/overflow on the real test phone).

Given zero automated tests exist today and this sprint adds the first schema migration plus new
unlock/star math, consider (same as SPRINT2_PLAN.md already suggested and didn't get to) a couple of
plain Dart unit tests for `isCheckpointUnlocked`'s boundary and the per-game-type star cap — cheap
insurance in the area with the least existing safety net, not a hard gate on shipping.
