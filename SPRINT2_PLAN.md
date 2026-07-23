# Sprint 2 (P1) implementation plan — lop2_english_app

Bản sao lưu lại trong project của kế hoạch đã được duyệt (plan mode) ngày 2026-07-23, để phiên
Claude Code mới đọc được (kế hoạch gốc nằm ở `C:\Users\NguyenNC\.claude\plans\` — chỉ máy này có,
không đưa vào git). Cập nhật tiến độ ở đây khi xong từng phase; nội dung kế hoạch bên dưới giữ
nguyên như lúc duyệt.

## Tiến độ

- [x] **Shared plumbing** (2026-07-23): `GameDef`/`kUnitGames` (`game_defs.dart`), unlock chain
  g01-g06+g08 (g07 đứng ngoài), `_coreGameTypes` g01-g04 quyết định mở unit, `maxStarsPerUnit`.
- [x] **Phase 1 — G04 xếp chữ** (2026-07-23): xong, build APK debug
  (`05_Build_APK/lop2_english_app-debug-2026-07-23-5.apk`), **CHƯA test trên điện thoại thật**.
- [x] **Phase 2 — G05 lắp câu + G06 mindmap** (2026-07-23): xong, build APK debug
  (`05_Build_APK/lop2_english_app-debug-2026-07-23-6.apk`), **CHƯA test trên điện thoại thật**.
  Đọc trực tiếp `02_Phan_tich/…xlsx` sheet `02_Giáo trình chi tiết` cột F (đối chiếu lại từ nguồn,
  không chỉ dùng bản draft `sentences.json` của phiên Cowork) → sinh `g05_sentence.json` (49 câu,
  16 unit) + `g06_mindmap.json` (33 mục, 16 unit). Nhân tiện sửa luôn khoảng trống Unit 16 (xem
  known_gaps #3 cũ trong `sentences.json`/CR-003): F-column gốc chỉ liệt kê 1/3 cặp câu hỏi-đáp,
  2 cặp còn lại ("table"/"tent", "teapot"/"table") lấy từ lời bài hát Track 90 (cùng nguồn SGK,
  transcript đã đối chiếu trong `01_Document/AUDIO/`) — Unit 16 giờ có đủ 5 câu ví dụ thay vì 2.
  G06 options tái dùng chính xác từ `g02_listen_pick.json` khi từ đó đã có sẵn câu hỏi G02 (đa số
  trường hợp); tự dựng options cho 3 từ không có audio xuất hiện trong câu mẫu (`twelve` unit 13,
  `nineteen`/`sixteen` unit 14) — audio option để `null`, không chặn hiển thị hình. Model mới
  `SentenceItem`/`MindmapOption`/`MindmapItem` trong `models.dart`; 2 field
  `Map<int, List<...>>` + loop nạp JSON mới trong `content_repository.dart`; màn hình mới
  `sentence_build_screen.dart` (G05, giống hệt cơ chế `scramble_screen.dart` nhưng ghép token/từ
  thay vì chữ cái, không có ảnh minh họa vì config không có trường `image`) và `mindmap_screen.dart`
  (G06, giống hệt cơ chế `listen_pick_screen.dart` nhưng phần "hỏi" là chữ pattern câu thay vì audio
  prompt). Thêm audio `sentence_pattern.mp3` (copy từ Track "Mẫu câu" mỗi unit trong
  `01_Document/AUDIO/`) vào cả `04_image+audio/UnitNN/audio/` (staging) và
  `assets/content/UnitNN/audio/` (bundle) làm audio gợi ý dùng chung cho G05. 2 `GameDef` mới
  trong `game_defs.dart` (màu `AppColors.warning` cho G05, `AppColors.error` cho G06 — dùng nốt 2
  màu còn lại trong bảng 6 màu sheet 09 mà G01-G04 chưa dùng tới, giữ đúng quy ước "màu qua
  AppColors, không hardcode hex mới"). `unit_screen.dart` không cần sửa (đã data-driven qua
  `kUnitGames` từ Sprint 2 shared plumbing). `flutter analyze` sạch, `dart format .` xong,
  `flutter build apk --debug` thành công.
- [x] **Test thật lần đầu (G04/G05/G06) + sửa bug + layout** (2026-07-23): người dùng test APK
  build #6 trên điện thoại, phát hiện BUG-002 (`_filled` không reset khi qua từ/câu thứ 2 trong
  `_goTo` — G04 + G05, sửa bằng gán lại không điều kiện giống G02/G03), BUG-003 (chạm lọt trong lúc
  hiệu ứng "sai" còn hiện trước khi xáo trộn xong — thêm chốt `_feedback == AnswerFeedback.wrong`
  vào guard `_pick` cả 5 màn hình có cơ chế reshuffle), CR-004 (thêm audio "Nghe câu" cho G06).
  Sau đó duyệt layout preview (Artifact) rồi đối ứng CR-005 (nút nghe lên đầu, áp dụng cả G03),
  CR-006 (G04 grid 2 cột), CR-007 (G05 grid 2 cột + câu nối liền), và **CR-008 — đổi hẳn mô hình
  tương tác G05**: bỏ chấm đúng/sai khi chọn, cho xóa token đã đặt để chọn lại, thêm nút "Kiểm tra"
  (chấm cả câu 1 lần) + "Làm lại" (reset), viết lại toàn bộ `sentence_build_screen.dart`. Rà màu
  theo yêu cầu "phù hợp với trẻ" phát hiện CR-009 (chữ trắng hard-code trong `PrimaryButton` khó
  đọc trên nền vàng/đỏ nhạt G05/G06 — thêm tham số `foregroundColor`, áp dụng cả nút trên màn Unit
  qua `GameDef.foregroundColor`, không đổi giao diện G01-G04 đã xác nhận). Chi tiết đầy đủ từng
  mục: `BUGS_CR.md` (BUG-002, BUG-003, CR-004…CR-009). Build APK debug:
  `05_Build_APK/lop2_english_app-debug-2026-07-23-8.apk` — **chưa test lại trên điện thoại thật**.
- [x] **Vòng đối ứng thứ 2 sau test thật** (2026-07-23): (1) **CR-010** — G03 mỗi từ thêm 2 lượt
  (tổng 3 lượt/từ, mỗi lượt ẩn 1 vị trí chữ khác nhau, digraph tính 1 ô) — thuần sinh lại
  `g03_fill_letter.json` (49→146 lượt), không cần sửa code màn hình vì đã đọc `items[]` như danh
  sách lượt độc lập sẵn. (2) **CR-011** — G04 đổi hẳn sang mô hình "lắp ráp rồi Kiểm tra" giống G05
  (CR-008), viết lại toàn bộ `scramble_screen.dart` theo cùng cấu trúc, giữ nguyên phần ảnh +
  digraph. (3) **CR-012** — G06 đổi tên nút "Nghe câu"→"Gợi ý", bỏ tự động phát audio (cả lúc vào
  màn hình lẫn lúc chuyển câu). (4) **CR-013** — cắt audio "Nghe" G05/G06: dùng `faster-whisper`
  (cài qua pip, chạy local, không cần internet sau khi tải model) để lấy transcript + mốc thời gian
  thật của cả 16 track "Mẫu câu", phát hiện cấu trúc chung "Unit/Page/Lesson 3/Activity 6/Listen
  and repeat" (~11-15s đầu) rồi mới tới câu mẫu; viết script tự tìm điểm cắt theo nội dung (không
  đoán mốc cố định), cắt bằng PyAV giữ nguyên bitrate 128kbps, **tự kiểm chứng bằng cách transcribe
  lại bản đã cắt** — 16/16 sạch, không sót phần giới thiệu. Phát hiện phụ: audio gốc SGK không khớp
  100% với toàn bộ câu ví dụ đã sinh cho G05 ở vài unit (1, 3, 4, 11, 14, 16) — chấp nhận được vì
  là audio "Nghe chung unit" chứ không phải đúng-từng-câu, nhưng Unit 11 cần nghe tay xác nhận
  (transcript tự động không rõ). Build APK debug:
  `05_Build_APK/lop2_english_app-debug-2026-07-23-9.apk` — **chưa test lại trên điện thoại thật**.
  Chi tiết đầy đủ: `BUGS_CR.md` CR-010 đến CR-013.
- [x] **Phase 3 — F15 cài đặt + cổng phụ huynh + sửa/xóa hồ sơ** (2026-07-23, CR-014): package
  `shared_preferences`; `SettingsService` (âm thanh on/off, độ khó easy/hard), khởi tạo trong
  `main.dart` trước `runApp`; `AudioService` kiểm tra `soundOn` trước khi phát (không tách riêng
  toggle "nhạc" vì app chưa có nhạc nền nào để tắt); `parent_gate.dart` (phép tính cộng/trừ +
  `confirmDeleteProfile`); `ProfileRepository.update()`/`delete()` (transaction xóa
  `LessonProgressTable` rồi `Profiles`, vì DB chưa bật FK cascade); `settings_screen.dart` (entry
  point: icon ⚙️ trên AppBar Home); chạm giữ trên `_ProfileTile` (màn Hồ sơ) mở bảng sửa/xóa. Đồng
  thời làm **CR-015 — wiring độ khó vào G02-G06**: chọn thiết kế thống nhất "Dễ = bớt 1 trở ngại"
  thay vì thêm chữ dưới ảnh (tránh cần thêm luồng dữ liệu word_id→text mới) — G02/G03/G06 làm mờ +
  vô hiệu 1 lựa chọn sai, G04/G05 tự điền sẵn ô/token đầu tiên.
- [x] **Phase 4 — G08 ghi âm** (2026-07-23, CR-016): package `record` + `permission_handler`,
  quyền `RECORD_AUDIO` trong AndroidManifest; `TappableStarBar` (mới, common_widgets.dart);
  `record_screen.dart` — nghe mẫu (dùng lại `flashByUnit`, không cần content mới) → ghi âm (ghi đè
  1 file tạm `g08_recording.m4a`) → nghe lại (AudioPlayer cục bộ, không qua AudioService vì là file
  thật không phải asset) → tự chấm sao; xử lý quyền mic denied/permanentlyDenied riêng biệt. Sao
  tổng = trung bình các lượt tự chấm, vẫn qua `reportResult` như mọi game khác (giữ quy tắc "sao
  chỉ tăng" ở mức DB). `_gameTypes` progress_repository.dart đã có sẵn `g08` từ shared plumbing,
  không cần sửa unlock chain.
  **Build sau cả Phase 3+4**: gặp lỗi build "Daemon compilation failed" (Kotlin incremental cache,
  xem BUG-004 `BUGS_CR.md`) sau khi thêm 3 package native mới — sửa bằng
  `kotlin.incremental=false` trong `android/gradle.properties`. APK debug:
  `05_Build_APK/lop2_english_app-debug-2026-07-23-10.apk` — **chưa test trên điện thoại thật**.
- [x] **Vòng đối ứng thứ 3 sau test thật (CR-017, CR-018)** (2026-07-23): (1) **CR-017** — G05 đổi
  nút "Nghe câu mẫu"→"Gợi ý" + bỏ tự động phát audio khi vào màn hình/chuyển câu, áp dụng đúng mẫu
  CR-012 đã làm cho G06. (2) **CR-018** — G08 đổi tông màu `info` sang đậm hơn (`AppColors.infoDark`,
  chữ trắng trên nền cũ khó đọc) + **thay đổi kiến trúc lớn**: bỏ hẳn ghi âm bằng package `record` +
  tự chấm sao thủ công, chuyển sang `speech_to_text` (nhận diện giọng nói qua `SpeechRecognizer` có
  sẵn của Android) tự động dừng ghi khi im lặng ~2s (`pauseFor`), hiển thị chữ nhận diện được, so
  khớp với đáp án bằng khoảng cách Levenshtein ra %/điểm 0-100, 3 mốc âm thanh cảnh báo
  (<=50/51-80/81-100 điểm, file sfx chưa có — xem CLAUDE.md §9). Đã trao đổi trực tiếp với người
  dùng về đánh đổi kiến trúc trước khi code (3 hướng: `speech_to_text` bỏ "Nghe lại giọng của bé" /
  `speech_to_text` + ghi file song song rủi ro xung đột mic / `stt_record` gói mới giữ đủ nhưng rủi
  ro build cao) — người dùng chọn `speech_to_text`, chấp nhận bỏ "Nghe lại". Thêm quyền `INTERNET` +
  Bluetooth + `<queries>` cho `RecognitionService` vào `AndroidManifest.xml`. Xóa `TappableStarBar`
  (không còn nơi dùng). `flutter clean` (dọn cache gói `record` vừa gỡ) → `flutter analyze` sạch →
  build APK debug thành công. Build APK debug:
  `05_Build_APK/lop2_english_app-debug-2026-07-23-11.apk` — **chưa test trên điện thoại thật**, đặc
  biệt cần xác nhận: tự dừng ghi đúng thời điểm, độ chính xác nhận diện giọng trẻ em, và máy test có
  cần bật mạng hay không. Chi tiết đầy đủ: `BUGS_CR.md` CR-017, CR-018.
- [ ] Phase 5 — G07 karaoke — **PENDING theo yêu cầu người dùng (2026-07-23), chưa cần làm ngay**.
  Best-effort, tùy unit nào có audio dùng được, khi nào cần làm đọc lại phần Phase 5 bên dưới.

---

## Context

Sprint 1 (P0) is shipped and confirmed working on-device: profile → unit map → 3 sequential
games (G01 Flashcard, G02 Listen&Pick, G03 Fill-Letter) → Drift-backed stars/progress. Since
then we've also patched a layout bug (SafeArea), refreshed the 56 word images, and added
answer-feedback effects + Back/Next + reshuffle to G02/G03 (see `BUGS_CR.md`).

The user asked to plan the next chunk of work: Sprint 2, which the project's own roadmap
(dev-doc sheet 11) scopes as **F05 (chant/song+karaoke), F08 (letter-scramble G04), F09
(recording G08), F10 (sentence games G05/G06), F15 (settings+parent gate) + finishing 16-unit
content**. Research this session (reading the full 15-sheet dev spec, the separate
curriculum-analysis xlsx, and the current codebase) found the real picture is better than
`CLAUDE.md`'s one-line summary suggested:

- **G04, G08, F15 have zero data blockers** — buildable now with existing vocabulary data.
- **G05/G06 are NOT actually blocked on missing content** — the sentence patterns + example
  sentences for all 16 units already exist, unused, in
  `02_Phan_tich/TiengAnh2_GiaoTrinh_Game_AppData.xlsx` (sheet `02_Giáo trình chi tiết`, column
  F), the same file `vocabulary.json` itself was derived from. They just need extracting into a
  JSON config, the same way `vocabulary.json`/`g01-g03` JSON already were.
- **G07 (karaoke) is the one still genuinely blocked** — the lyrics text also already exists in
  that same column, but nobody has listened to the chant/song audio tracks and marked per-line
  timestamps, and there's no forced-alignment tool available to do it automatically.

Decisions already confirmed with the user: only **G01–G04 gate advancing to the next unit**
(G05/G06/G08 award stars but don't block progress, keeping units closer to the app's own
"≤5 phút/phiên" goal); the delete-data action in F15 deletes **one profile only** (no separate
full-wipe feature); **no backup/export** is being added before that ships (accepted as a known
risk, already tracked in `CLAUDE.md`).

Intended outcome of this plan: ship G04, G05, G06, G08, and F15 fully working end-to-end this
sprint, and unblock G07 as far as possible (lyrics extracted, screen built against
whichever units actually have usable audio) without waiting on a manual timing pass.

## Shared plumbing (do this first — everything else depends on it)

**Refactor the per-unit game list to be data-driven**, instead of hand-writing 7 near-identical
blocks in `lib/features/unit/unit_screen.dart`. Add a `GameDef` (gameType, label, icon, color,
count, open-callback) list — `kUnitGames` — and have `UnitScreen` map over it, reusing the
existing generic `_gameRow`/`_playGame` unchanged. This is the same file that currently hardcodes
3 `_gameRow` calls; today's 3 become list entries, and G04/G05/G06/G08 are 4 more entries, not 4
more copy-pasted blocks.

**Fix the other hardcoded lever**: `lib/features/home/home_screen.dart`'s `_UnitCard` literally
prints `'$stars/9'`. Add `int get maxStarsPerUnit => _gameTypes.length * 3;` to
`ProgressRepository` (`lib/data/repositories/progress_repository.dart`) and use it there instead
of a second hand-maintained number.

**Extend the unlock chain** in `progress_repository.dart`:
```dart
const _gameTypes = ['g01', 'g02', 'g03', 'g04', 'g05', 'g06', 'g08']; // g07 never enters this list
```
Add `bool get isCoreComplete` style logic — per the user's decision, **`isUnitUnlocked` should
only require g01–g04** (not the full list) to have ≥1 star each, while `totalStarsForUnit`/
`maxStarsPerUnit` still sum/count all 7 for the star display. Concretely: keep a separate
`const _coreGameTypes = ['g01','g02','g03','g04']` used only inside `isUnitUnlocked`, leave
`isGameUnlocked`/`totalStarsForUnit` iterating the full `_gameTypes` so g05/g06/g08 still unlock
sequentially after g04 and still contribute stars.

G07 is **not** added to `_gameTypes` at all — it's rendered as a separate, visually distinct,
non-`StarBar` tile in `UnitScreen`, opened via a plain `Navigator.push` (not through `_playGame`,
which exists specifically to call `reportResult` on a popped `int` — G07 never pops one).

**Status: DONE** (2026-07-23) — see `game_defs.dart` (new file) and `progress_repository.dart`.

## Phase 1 — G04 "Xếp chữ" (letter/word scramble)

Data: reuse `vocabulary.json` directly (word + image + audio already present for all 56 words,
same 7 extended words already excluded from audio the way G02/G03 handle it). Generate
`05_App/03_Assets/data_json/games/g04_scramble.json` following the exact `instances[]` /
`config.items[]` convention `README_data.md` documents for g01-g03, item shape
`{word_id, word, image, audio}`. Digraphs (`sh`, `er`): treat as **one draggable tile**, matching
how G03 already treats them as a single 2-char answer unit (`CLAUDE.md` §10) — keeps the mental
model consistent across games.

Code: new `lib/data/models/models.dart` class `ScrambleItem` (mirrors `FillItem` minus
hidden_idx/distractors), new `Map<int, List<ScrambleItem>> scrambleByUnit` field +
loading loop in `content_repository.dart` (mechanical, same pattern as g01-g03). New screen
`lib/features/games/scramble/scramble_screen.dart`, modeled directly on
`fill_letter_screen.dart` (closest existing analog): `AppScaffold`, shuffle the letters of
`word` into draggable/tappable tiles, `AnswerFeedbackOverlay` + `AudioService.playSfx` on
correct/wrong, reshuffle tiles on wrong pick, Back/Next buttons gated the same way (`Next` only
enabled once the current word is solved), star math via `Set<int>` of solved indices (not a
raw counter) — same conventions already documented in `CLAUDE.md` §6 for "answer-based games."

**Status: DONE** (2026-07-23) — `scramble_screen.dart`, digraph-aware tile splitting via
`_tilesFor()`. Built & analyzed clean; **not yet device-tested**.

## Phase 2 — G05 "Lắp ráp câu" + G06 "Mindmap hoàn thành câu"

**Data generation (one-off, do this once):** read
`02_Phan_tich/TiengAnh2_GiaoTrinh_Game_AppData.xlsx`, sheet `02_Giáo trình chi tiết`, column F,
Lesson-3 rows (one per unit) — extract the `Mẫu câu: ...` pattern line and its 3–4 bulleted
example sentences. Hand-author:
- `g05_sentence.json`: per unit, one instance per example sentence, `config.items[]` shape
  `{sentence, tokens[], audio}` — `tokens[]` = word-split of the sentence (lock down up front:
  punctuation stays glued to the preceding word, not its own tile). **Audio**: per the plan
  review, null audio here would leave a pre-reader with no non-text signal at all (no image
  field exists in this config, unlike every other game) — reuse the existing whole-lesson
  `Track N.mp3` (from `01_Document/AUDIO/`, copied alongside the way `04_image+audio` already
  feeds `assets/content/`) as a shared "Nghe" cue per unit, imprecise but consistent with every
  other game having a listen affordance.
- `g06_mindmap.json`: per unit, `config` shape `{pattern, slot, options[{img,word,audio}]}` —
  `options[]` reuses that unit's existing `vocabulary.json` words (already have real
  `image`/`audio`), so G06 needs no new audio at all; this game is structurally a sentence-framed
  G02, ship it exactly like G02's option-tile mechanic.
- Handle `is_plural` sentences (Unit 12: yo-yos/grapes/shirts) the same way G03/vocabulary
  already do — make sure the generated `tokens[]`/`full_text` uses the exact is/are form, not a
  hardcoded default.

Code: new models `SentenceItem` (G05) and `MindmapItem` (G06) in `models.dart`, two new
`Map<int, List<...>>` fields + loops in `content_repository.dart`. Two new screens:
`lib/features/games/sentence_build/sentence_build_screen.dart` (G05 — drag/tap tokens into
order, check against `sentence`, reuse `AnswerFeedbackOverlay`/reshuffle-on-wrong/Back-Next
exactly like Phase 1) and `lib/features/games/mindmap/mindmap_screen.dart` (G06 — visually a
`ListenPickScreen` clone with a sentence-pattern header instead of a bare prompt).

## Phase 3 — F15 Settings + Parent gate + profile edit/delete

**Parent gate**: new `lib/core/widgets/parent_gate.dart` (new file — `common_widgets.dart` is
already ~270 lines, past the project's own ">150 lines, split" convention) exposing
`Future<bool> showParentGate(BuildContext)`: a dialog with a random 1–2 digit +/- arithmetic
problem, retry on wrong answer, no lockout/cooldown (single-family app, not needed).

**Settings storage**: add `shared_preferences` to `pubspec.yaml` (per the dev-spec's own
explicit choice, not Drift). Add a thin `lib/services/settings_service.dart` singleton
(mirrors `AudioService.instance`'s style — no new state-management layer) exposing typed
get/set for: volume/sound on-off, music on-off, difficulty (easy/hard). Wire volume/sound into
`AudioService`; wire difficulty into G02/G03 (hint visibility) and the new G04-G06 screens —
this is real surface area, not just a settings screen, budget for touching those existing files.

**Settings screen**: `lib/features/settings/settings_screen.dart`, `AppScaffold`, toggles for
the above, a "Xóa hồ sơ" action that calls `showParentGate` → on success →
`ProfileRepository.delete(profileId)`.

**Profile edit/delete** (closes out F02's original scope, per the dev spec — delete/edit were
always meant to be parent-gated): add `update()` and `delete()` to
`lib/data/repositories/profile_repository.dart`. `delete()` must be a manual `db.transaction`
that deletes that profile's `LessonProgressTable` rows then the `Profiles` row — confirmed by
reading `app_database.dart` that FK enforcement is **not** turned on (`schemaVersion` is
hardcoded 1, no `beforeOpen`/migration adding `onDelete: KeyAction.cascade` or
`PRAGMA foreign_keys`), so this is not optional cleanup, it's the only thing preventing orphaned
progress rows. Add a long-press (or edit icon) affordance on `_ProfileTile` in
`profile_select_screen.dart` (currently tap-only) leading to edit/delete, gated by
`showParentGate`. Re-check the existing `profiles.isEmpty` → forced create-form path still
behaves correctly once delete can bring the count back to zero.

## Phase 4 — G08 "Ghi âm" (recording/shadowing)

Add `record` + `permission_handler` to `pubspec.yaml`. Add
`<uses-permission android:name="android.permission.RECORD_AUDIO"/>` to
`android/app/src/main/AndroidManifest.xml` (currently has zero permission entries). Handle both
`permission_handler` denial states — `denied` (re-askable) vs `permanentlyDenied` (must route to
`openAppSettings()`).

Data: **zero new content** — reuse existing `vocabulary.json` word+audio as the "model" to
shadow (shadow single words, not full sentences, for this phase). No new JSON file needed;
reuse `flashByUnit`/the vocabulary loader already in `content_repository.dart`.

Code: new `lib/features/games/record/record_screen.dart` — play model word audio
(`AudioService.play`) → tap to record (`record` package) to a **fixed filename in
`getTemporaryDirectory()`**, overwritten every attempt (no cleanup logic needed, and per-spec
there's no retention requirement — also the more privacy-respectful default for a kids' app) →
play back the child's own recording → **self-rating**: child taps 1/2/3 stars themselves
(no automatic scoring — explicitly out of phase-1 scope per the dev spec). Build this
self-rating control as a small reusable widget (a tappable variant of the existing `StarBar`)
since it's a new completion pattern (alongside G01's "always 3" and G02/G03's "graded
correct/wrong") that later games may reuse.

## Phase 5 — G07 "Karaoke Chant/Song" (best-effort, scoped to available audio)

**Do this first, before generating anything**: check which `Track N.mp3` files under
`01_Document/AUDIO/` actually exist and play cleanly — `CLAUDE.md` §9 already tracks 4 misnamed
files (Track 3–6) and Track 1 missing. Scope G07's Sprint-2 build to only the units whose
chant+song tracks are present and playable; skip the rest for now rather than guessing.

For the covered units: extract lyrics (same column F cells used in Phase 2, the `Chant:`/`Song:`
blocks) into `lyrics[]` (one entry per line). Generate placeholder `timings[]` by dividing each
track's known duration evenly across its line count (weight by line character count if cheap to
add, not required) — clearly mark these as estimates in the generated JSON (e.g. a
`"timings_source": "estimated"` field) so a later manual pass is a JSON edit, not a code change.

Code: new model `KaraokeTrack`, loader addition, new screen
`lib/features/games/karaoke/karaoke_screen.dart` — audio player (`just_audio`, likely needs
position-stream access beyond what the fire-and-forget `AudioService` currently exposes, so this
screen may talk to `just_audio` more directly rather than through `AudioService`), highlight the
current line by comparing playback position to `timings[]`, seek/repeat-section controls per the
spec. Rendered as the separate, non-gated, non-`StarBar` tile described above.

## Verification (after each phase)

- `flutter analyze` clean + `dart format .` after every phase, not just at the end (matches
  existing project convention in `CLAUDE.md` §3).
- `flutter build apk --debug`, install on the real test device, actually play the new game
  end-to-end (not just static analysis) — this project has already been burned once by a
  device-only layout bug (BUG-001) that static checks didn't catch.
- Specifically test: reshuffle-on-wrong for G04/G05, the mic-permission flow for G08 on the
  real device (denied + permanently-denied paths), parent-gate math retry, and that deleting a
  profile removes its `LessonProgressTable` rows (no orphaned data) without affecting other
  profiles.
- Given zero automated tests exist today and this sprint adds a destructive delete transaction
  plus extends unlock/star math from 3 to 7 game types, add at least a couple of plain Dart unit
  tests for `progress_repository.dart` (unlock boundary conditions, "stars never decrease") and
  the new delete-cascade transaction — cheap insurance against a silent regression a parent would
  only notice as "my kid's progress disappeared."
- After each phase, update `CLAUDE.md` (`§2` current state, `§4` architecture tree, `§8` roadmap,
  `§9` data gaps) and `BUGS_CR.md`/`HANDOVER.md` the same way prior fixes this session were
  logged — keep the persistent memory files in sync as you go, not as an afterthought at the end.
