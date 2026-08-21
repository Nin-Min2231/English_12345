# CLAUDE.md — lop2_english_app

Ngữ cảnh cho Claude Code khi làm việc trong repo này. Đọc kỹ trước khi sửa code.

**Trước khi sửa bug/thay đổi theo yêu cầu người dùng**: kiểm tra `BUGS_CR.md` (cùng thư mục) — nhật
ký Bug/CR đang mở, tránh xử lý sai/trùng/bỏ sót.

## 1. Dự án là gì

App Android (Flutter, offline-first) luyện tiếng Anh tiểu học theo giáo trình **Global Success**.
**Sprint 4 (2026-08-21) đã thêm hỗ trợ đa lớp** (1 app, màn "Chọn lớp" SCR-00, xem §2/§4) — Lớp 2
vẫn đầy đủ nhất (16 unit, 48 lesson, 56 từ vựng, 12 loại game tái sử dụng G01–G12); Lớp 1 mới có
Unit 1 (3 từ). Người dùng: trẻ 7–8 tuổi tự chơi; phụ huynh/giáo viên theo dõi. Triết lý: "học mà
chơi", phiên ≤5 phút, dựa vào hình/màu/âm thanh vì trẻ chưa đọc thạo.

Tài liệu gốc (nguồn sự thật, KHÔNG ở trong repo code mà ở thư mục cha):
- `../01_Tai_lieu/TaiLieu_Phat_Trien_App.xlsx` — 15 sheet: tính năng F01–F15, game G01–G12, tech stack, kiến trúc, DB, design system, lộ trình, rủi ro.
- `../../02_Phan_tich/TiengAnh2_GiaoTrinh_Game_AppData.xlsx` — phân tích giáo trình, từ vựng, audio, game theo lesson.
- `../../04_image+audio/` — 56 ảnh + 49 audio gốc + `manifest.csv/json`.

## 2. Trạng thái hiện tại (đã làm)

Cập nhật 2026-07-23 — **Sprint 2 (P1) gần xong** (kế hoạch đầy đủ: `SPRINT2_PLAN.md`).
G04/G05/G06 xong, test thật lần đầu → sửa BUG-002/BUG-003 + layout/mô hình tương tác/dữ liệu
(CR-005…CR-013, chi tiết `BUGS_CR.md`): G04/G05 mô hình "xếp rồi bấm Kiểm tra", G03 mỗi từ 3 lượt,
G06 đổi tên nút + bỏ auto-play, audio "Nghe" G05/G06 đã cắt phần giới thiệu đầu track. Sau đó làm
tiếp **F15 cài đặt+cổng phụ huynh+sửa/xóa hồ sơ (CR-014)**, **wiring độ khó vào G02-G06 (CR-015)**,
**G08 ghi âm (CR-016)** — Sprint 2 giờ chỉ còn thiếu **G07 karaoke, người dùng chủ động để pending
chưa cần làm**. Vòng đối ứng tiếp theo sau khi test bản build #10: **CR-017** (G05 đổi nút "Gợi ý"
+ bỏ auto-play, giống G06) và **CR-018** (G08: màu đậm hơn `AppColors.infoDark` + đổi hẳn từ tự
chấm sao sang `speech_to_text` tự nhận diện giọng nói/so khớp đáp án ra %/điểm/âm thanh cảnh báo,
đổi từ package `record` — xem `BUGS_CR.md` để biết lý do đánh đổi bỏ "Nghe lại giọng của bé"). Đã
build APK debug (`05_Build_APK/lop2_english_app-debug-2026-07-23-11.apk`),
**chưa test bản mới nhất trên điện thoại thật**.

**Sprint 3 (P2) đã code xong G09+G10+G12 (CR-019, kế hoạch đầy đủ: `SPRINT3_PLAN.md`)** — nghiên
cứu lại 2 file Excel gốc trước khi code (giống cách làm Sprint 2): **G09 Fun Time** (memory match,
sau Unit 2/6/10/14) + **G10 Săn chữ** (sau Unit mỗi bài, sao tối đa 2) đều không cần nội dung mới,
**G12 Boss Quiz + huy hiệu** (sau Unit 4/8/12/16, đổi tên từ "G13" — tài liệu gốc gọi là G12) trộn
câu hỏi có sẵn từ G02/G03/G05, huy hiệu là nội dung app tự nghĩ (tên/icon placeholder). Đây là
**migration DB đầu tiên của app** (bảng `EarnedBadges` mới, `schemaVersion` 1→2). **G11 truyện vẫn
để pending** như G07 — không có lời thoại/ảnh trang truyện ở đâu cả, nội dung thật (nếu có) nằm
trong `01_Document/book.pdf` chưa đọc được. Build APK debug
(`05_Build_APK/lop2_english_app-debug-2026-07-23-12.apk`), **chưa test trên điện thoại thật — đặc
biệt cần test cài như bản CẬP NHẬT (không gỡ cài lại) để xác nhận migration không mất hồ sơ/tiến độ
cũ**.

**CR-020 (2026-07-26)** — 3 màn hình chỉnh nội dung theo yêu cầu người dùng, chi tiết đầy đủ
`BUGS_CR.md`: **G03 Điền chữ** đổi mốc ẩn chữ theo độ dài từ (< 4 chữ cái ẩn 1 ô như cũ, ≥4 chữ cái
ẩn **2 ô cùng lúc**, vị trí ngẫu nhiên có thể không liền nhau) — sinh lại `g03_fill_letter.json` +
sửa `fill_letter_screen.dart` (cách hiển thị cũ giả định `hidden_idx` luôn liền dải, sai với 2 ô cách
nhau). **G08 Ghi âm**: nút "Ghi âm" nền đỏ nhạt khi đang nghe, `pauseFor` 2s→3s, thêm cờ `_isScoring`
chặn bấm ghi âm lượt mới trong lúc chờ kết quả nhận diện (độ trễ thật của engine, không phải app xử
lý chậm). **G10 Săn chữ — đổi hẳn cơ chế** (không còn "săn chữ cái phonics"): giờ là nghe 1 từ vựng →
chọn đúng từ đó trong 6 đáp án CHỮ (gộp từ vựng unit hiện tại + unit liền trước, Unit 1 dùng
You/He/She) — thay hẳn model `HuntLetterItem` bằng `WordHuntQuestion` (cùng shape `ListenQuestion`),
sinh lại `g10_letter_hunt.json` (giờ nhiều lượt/unit như G02, không còn 1 mục phẳng), viết lại
`letter_hunt_screen.dart` theo mẫu `listen_pick_screen.dart`. Build APK debug mới (xem mục "Lệnh
chuẩn" để build lại), **chưa test trên điện thoại thật**.

**CR-021 (2026-07-26)** — theo yêu cầu người dùng rà lại Sprint 3 xem còn chức năng nào chưa đối ứng:
phát hiện **G09 Fun Time chưa có độ khó Dễ** (CLAUDE.md §6 đã ghi nhận là ngoại lệ chưa xử lý từ
CR-019) — đã bổ sung cơ chế riêng (không khớp 2 mẫu độ khó chuẩn): xem trước toàn bộ thẻ lật ngửa 4
giây lúc mới vào màn hình rồi mới úp xuống chơi bình thường. Rà lại toàn bộ Sprint 3 không thấy chức
năng nào khác còn thiếu — **G11 truyện vẫn pending** (không đổi, vẫn chặn bởi thiếu nội dung nguồn
thật trong `01_Document/book.pdf`, không phải thứ có thể tự code xong được).

**CR-022 (2026-07-26)** — người dùng yêu cầu "đối ứng F11, F12, F13" + báo G08 chưa đối ứng triệt để.
**G08**: tìm ra bug thật (không phải thiếu code) — màu đỏ CR-020 không hề hiện vì nút đang bị
`disabled` đúng lúc đó, Flutter tự vẽ xám mặc định đè lên trừ khi truyền riêng
`disabledBackgroundColor` — đã thêm `disabledColor`/`disabledForegroundColor` vào `PrimaryButton`.
Thêm trần chờ kết quả 1.5s sau khi hết nghe (`_resultGraceWindow`) — hết hạn mà chưa có `finalResult`
thật thì chấm luôn bằng bản ghi nhận từng phần gần nhất, chặn hẳn việc chờ vô thời hạn. **F11 (G09+
G10)**: rà theo đúng tiêu chí xlsx sheet `03_Mô tả tính năng`, phát hiện CR-020 đã vô tình bỏ tiêu chí
"săn chữ có thưởng" khi đổi cơ chế G10 — khôi phục bằng cách hiện hình+audio câu hỏi đầu tiên của unit
làm "phần thưởng" trong dialog hoàn thành. **F13 (G12)**: rà lại, xác nhận đã đạt đủ tiêu chí, không
cần sửa. **F12 (G11 truyện)**: xác nhận qua xlsx đây chính là "Truyện tương tác" — vẫn hoàn toàn không
có nội dung nguồn (khác các gap khác, không phải thiếu code); đã hỏi lại người dùng, **chọn "Chờ nội
dung thật"** — không viết code/khung màn hình G11 cho tới khi người dùng tự cung cấp nội dung từ
`01_Document/book.pdf` (xem BUGS_CR.md CR-022).

**CR-023 (2026-07-26)** — 5 màn hình theo yêu cầu tiếp của người dùng. **G08**: bỏ hẳn tự dừng khi im
lặng (`pauseFor` = `listenFor` = 8s), thêm nút "Dừng ghi âm" thật (tái dùng nút Ghi âm, giờ bấm được
lúc đang nghe để gọi `_speech.stop()`). **G09 đổi tên "Fun Time" → "Lật thẻ"** (`checkpoints.dart` +
`memory_match_screen.dart`); lưới thẻ phóng to lấp đầy màn hình qua `LayoutBuilder` tính
`childAspectRatio`; mở khóa chặt hơn — `isFunTimeUnlocked` (mới, `progress_repository.dart`) đòi hỏi
MỌI game (`kGameTypeOrder`) của CẢ 2 unit trong phạm vi ôn tập, không chỉ 4 game lõi như
`isCheckpointUnlocked` (Boss Quiz không đổi); công thức sao nới rộng 1 bậc để dễ đạt 3 sao hơn. **G03
Điền chữ**: tách 2-ô-gộp (CR-020) thành điền RIÊNG từng chữ cái 1 lượt — viết lại toàn bộ
`fill_letter_screen.dart` (`_filledCount` thay `_filled` bool, `_order`/`_usedPositions` tách khỏi vị
trí hiển thị giống mẫu `listen_pick_screen.dart`), sinh lại `distractors` thành chữ đơn (126 mục).
**G10**: đổi `Wrap` → `GridView.count(crossAxisCount: 2)` + `FittedBox` để 2 đáp án luôn cùng dòng dù
từ dài. **G12**: bọc thêm `FittedBox` cho chữ (đã là lưới 2 cột sẵn, chỉ thiếu chống tràn). Chi tiết
đầy đủ: `BUGS_CR.md` CR-023.

**CR-024/025/026 (2026-08-21)** — 3 việc nhỏ trên G08 + đổi tên/icon app trước khi bắt đầu Sprint 4:
banner hướng dẫn thao tác + màn hình loading toàn màn hình khi chấm điểm (CR-024); sửa bug ghi âm lại
cùng 1 từ không tính điểm mới/không hiện loading — do `_scores[index]` cũ không bị xóa khi bấm ghi âm
lại (CR-025); đổi tên app thành **"Nin&Min's English"** + icon mới (nhân vật "Nin", package
`flutter_launcher_icons`, CR-026). Chi tiết đầy đủ: `BUGS_CR.md` CR-024/025/026.

**Sprint 4 (P3) — đa lớp (SCR-00 Chọn lớp) + Lớp 1 Unit 1, CR-027 (2026-08-21)** — app từ single-grade
tuyệt đối (chỉ Lớp 2) đổi sang hỗ trợ nhiều lớp trong CÙNG 1 app (không phải 1 app/lớp như hướng dẫn
tái sử dụng cũ ở sheet 10 BasicDesign). **Migration DB lần 2**: thêm cột `grade` (default 2, giữ
tương thích dữ liệu Lớp 2 cũ) vào `LessonProgressTable` + `EarnedBadges`, `schemaVersion` 2→3.
`ContentRepository`/`WordImage`/`AudioService.play` tham số hóa theo `grade` (hàm thuần, KHÔNG dùng
static/global state); asset Lớp 2 di chuyển sang `assets/{content,data}/lop2/...`, Lớp 1 mới có
`assets/{content,data}/lop1/...` (chỉ Unit 1 — ball/bike/book — nội dung thật, Unit 2-16 hiện trên bản
đồ nhưng khóa vì chưa có dữ liệu). Màn hình mới **SCR-00 "Chọn lớp"**
(`lib/features/grade/grade_select_screen.dart`, đứng giữa ProfileSelect và Home) — `ProfileSelectScreen`/
`SettingsScreen` bỏ field `repo` (chưa biết lớp nào lúc đó). G06 cố tình bỏ qua cho Lớp 1 Unit 1 (Excel
xác nhận pattern là hội thoại tên riêng, không có mẫu điền-từ). Trước khi code đã audit kỹ
`SPRINT4_PLAN.md` (viết bởi phiên Cowork khác) và vá 2 lỗ hổng kỹ thuật thật (asset() tĩnh sẽ vỡ build;
đọc file game thiếu sẽ crash lúc chạm "Lớp 1") — xem `BUGS_CR.md` CR-027 để biết chi tiết đầy đủ.

**CR-028 (2026-08-21, người dùng test ra ngay)** — G06 (không có dữ liệu cho Lớp 1) đã khóa cứng
**vĩnh viễn** G08 vì `isGameUnlocked` đòi hỏi game NGAY TRƯỚC trong `kGameTypeOrder` (dùng chung mọi
lớp) có sao, mà G06 không ai chơi được nên không ai bao giờ earn được sao đó. Sửa tổng quát (không
riêng G06/Lớp1): `isGameUnlocked` thêm `hasContent` callback để bỏ qua mọi game không có dữ liệu khi
tìm "game ngay trước" (lùi tiếp về game trước đó nữa); `unit_screen.dart` ẩn hẳn dòng game khi
`countFor == 0` thay vì hiện khóa vĩnh viễn. Lớp 2 không đổi hành vi (mọi game đều có dữ liệu mọi
unit). **Rủi ro cùng loại chưa sửa**: `isFunTimeUnlocked` (Lật thẻ) cũng đòi mọi game trong
`kGameTypeOrder` có sao — sẽ gặp lại vấn đề này khi Lớp 1 có dữ liệu G09 mà G06 vẫn chưa phát triển,
xem `BUGS_CR.md` CR-028 mục cuối. Build APK debug mới nhất:
`05_Build_APK/lop2_english_app-debug-2026-08-21-4-sprint4.apk`, code trên nhánh
**`sprint-4`** — **chưa test trên điện thoại thật**, đặc biệt quan trọng vì đây là migration DB lần 2
(xem checklist Verification trong `BUGS_CR.md` CR-027).

**Sprint 1 (P0) đã xong** trước đó, đã build thật và cài lên điện thoại test:
- Nạp JSON config từ `assets/data` (data-driven) — vẫn giữ, không đổi sang Drift cho content tĩnh.
- Luồng đầy đủ: **ProfileSelect** (F02, tạo/chọn hồ sơ trẻ) → **Home** (F01, bản đồ 16 unit có sao + khóa) → **Unit** (F03, 3 game mở tuần tự) → 3 game P0 (G01 Flashcard, G02 Nghe chọn hình, G03 Điền chữ) → trả sao về lưu **Drift** (F14).
- Quy tắc khóa/mở (xem `data/repositories/progress_repository.dart`): unit 1 luôn mở, unit N cần unit N-1 hoàn thành cả 3 game (≥1 sao); trong 1 unit, G02 cần G01 ≥1 sao, G03 cần G02 ≥1 sao. Flashcard không có đúng/sai → nút "Xong" trả cố định 3 sao.
- 56 ảnh + 49 audio đã đóng trong `assets/content/`.
- **Đã `flutter analyze` sạch (0 issue) và `flutter build apk --debug` thành công.** APK mới nhất: `../05_Build_APK/` (xem file có ngày mới nhất).
- Toolchain đã cài trên máy này (KHÔNG nằm trong PATH hệ thống — cần nạp mỗi session, xem mục 3.1):
  Flutter 3.44.7 tại `D:\flutter`, JDK 17 Temurin tại `D:\jdk17_extract\jdk-17.0.19+10`,
  Android SDK tại `%USERPROFILE%\AppData\Local\Android\Sdk` (đã có platform-tools,
  build-tools 34-36, platforms 34-36, NDK, license đã accept).

## 3. Lệnh chuẩn

`android/` đã được sinh (2026-07-23) — **KHÔNG chạy lại** `flutter create` (sẽ không hại gì vì nó
không đè `lib/`/`pubspec.yaml`, nhưng không cần thiết).

`android/gradle.properties` có dòng `kotlin.incremental=false` (thêm 2026-07-23, xem BUG-004
`BUGS_CR.md`) — máy này bị lỗi "Daemon compilation failed / Could not close incremental caches"
khi build sau khi thêm package `record`/`shared_preferences`; tắt incremental compilation của
Kotlin sửa được, chỉ đổi tốc độ build lại (không ảnh hưởng app). Đừng xóa dòng này trừ khi đã xác
nhận lỗi hết tái diễn.

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # khi sửa app_database.dart (bảng Drift)
flutter analyze                         # phải sạch trước khi commit
dart format .                           # trước khi commit
flutter run                             # chạy trên emulator/thiết bị
flutter build apk --debug               # test nhanh; --release cần signing config (chưa có)
```

### 3.1. Nạp toolchain cho session mới (PowerShell)

Flutter/JDK/Android SDK **không nằm trong PATH hệ thống** — mỗi session/terminal mới phải nạp lại.
Dot-source file `activate_env.ps1` ở gốc project này (dấu `. ` đầu dòng là bắt buộc, nếu không
PATH sẽ không áp dụng vào shell hiện tại):

```powershell
. .\activate_env.ps1
```

Hoặc set tay:
```powershell
$env:JAVA_HOME = "D:\jdk17_extract\jdk-17.0.19+10"
$env:ANDROID_SDK_ROOT = "$env:USERPROFILE\AppData\Local\Android\Sdk"
$env:ANDROID_HOME = $env:ANDROID_SDK_ROOT
$env:PATH = "D:\flutter\bin;$env:JAVA_HOME\bin;" + $env:PATH
```

## 4. Kiến trúc & cấu trúc thư mục (feature-first — sheet 06)

```
lib/
  main.dart, app.dart          # khởi động, mở AppDatabase + SettingsService, theme,
                                # home = ProfileSelectScreen (KHÔNG còn eager-load
                                # ContentRepository — Sprint 4, xem dưới)
  core/theme/app_theme.dart    # AppColors, AppSpacing (design tokens sheet 09)
  core/widgets/common_widgets.dart  # PrimaryButton, SecondaryButton, StarBar, WordImage
                                     # (Sprint 4: thêm field `grade` bắt buộc),
                                     # AppScaffold, AnswerFeedbackOverlay (đúng/sai)
  core/widgets/parent_gate.dart # F15 — showParentGate(), confirmDeleteProfile() (2026-07-23)
  data/models/models.dart      # UnitInfo (Sprint 4: thêm field `grade`, gán bởi loader —
                                # KHÔNG đọc từ units.json), FlashCard, ListenQuestion, FillItem,
                                # ScrambleItem, SentenceItem, MindmapOption, MindmapItem,
                                # MemoryPairItem (G09), WordHuntQuestion (G10, đổi từ
                                # HuntLetterItem — CR-020), BossQuizQuestion/Option (G12)
  data/content_repository.dart # Sprint 4: `load({required int grade})` + field `grade` trên
                                # instance; `asset({grade, relativePath})` là hàm THUẦN (không
                                # còn static const assetBase) — đọc `assets/data/lop$grade/...`;
                                # mọi đọc file game (`gNN_*.json`) qua `_readOptionalGame()`
                                # (file thiếu -> instances rỗng, KHÔNG ném lỗi — bắt buộc vì Lớp
                                # 1 Unit 1 chưa có g09/g12); nạp JSON -> map theo unit_id
                                # (huntByUnit là Map<int,List<WordHuntQuestion>> — CR-020)
  data/db/app_database.dart    # Drift: Profiles, LessonProgressTable, EarnedBadges — cả 2 bảng
                                # sau có thêm cột `grade` (Sprint 4, default 2, schemaVersion 3)
                                # (+ .g.dart sinh ra)
  data/repositories/
    profile_repository.dart    # watchProfiles(), create(), update(), delete() (F15, 2026-07-23;
                                # delete() xóa cả EarnedBadges từ Sprint 3)
    progress_repository.dart   # kGameTypeOrder (đổi tên công khai từ _gameTypes, Sprint 3),
                                # watchForProfile()/reportResult() nhận `grade` (Sprint 4, lọc
                                # TẠI QUERY) — mọi hàm thuần còn lại (isUnitUnlocked,
                                # isGameUnlocked, isCheckpointUnlocked, isFunTimeUnlocked,
                                # starsFor, totalStarsForUnit) KHÔNG cần `grade` vì hoạt động
                                # trên list `progress` đã được lọc sẵn theo lớp
    badge_repository.dart      # Sprint 3 — watchForProfile()/award() (Sprint 4: thêm `grade`,
                                # cùng lý do progress_repository.dart — badgeId dùng chung mọi lớp)
  services/audio_service.dart  # just_audio, singleton, kiểm tra SettingsService.soundOn;
                                # `play()` (Sprint 4: nhận `grade`) — `playSfx()` KHÔNG đổi
                                # (dùng riêng assets/sfx/, không liên quan lớp)
  services/settings_service.dart  # F15 — âm thanh on/off, độ khó easy/hard (2026-07-23)
  features/
    grade/grade_select_screen.dart  # Sprint 4 — SCR-00 "Chọn lớp", đứng giữa ProfileSelect và
                                     # Home; GradeOption/kGradeOptions (mô phỏng pattern GameDef)
    profile/profile_select_screen.dart   # F02 — chọn/tạo hồ sơ; chạm giữ để sửa/xóa (F15).
                                          # Sprint 4: bỏ field `repo` (chưa có lớp lúc này),
                                          # `_openProfile` đi tới GradeSelectScreen, không phải Home
    settings/settings_screen.dart  # F15 — cài đặt + xóa hồ sơ. Sprint 4: bỏ field `repo` (cùng
                                    # lý do trên)
    badges/badge_defs.dart, badges_screen.dart  # Sprint 3 — F13/G12, xem huy hiệu đã/chưa đạt.
                                                 # Sprint 4: BadgesScreen thêm field `grade` bắt buộc
    home/  flashcard/
    unit/unit_screen.dart, game_defs.dart  # F03; kUnitGames = danh sách game/unit (mọi unit)
    unit/checkpoints.dart  # Sprint 3 — Lật thẻ/Boss Quiz chỉ gắn 1 unit cụ thể, không phải
                            # kUnitGames; extraGamesForUnit()
    games/listen_pick/  games/fill_letter/  games/scramble/
    games/sentence_build/  games/mindmap/  # G05, G06 (Sprint 2 Phase 2, 2026-07-23)
    games/record/record_screen.dart  # G08 ghi âm + nhận diện giọng nói tự chấm điểm (CR-018)
    games/memory_match/memory_match_screen.dart  # Sprint 3 — G09 "Lật thẻ" (đổi tên từ Fun Time, CR-023)
    games/letter_hunt/letter_hunt_screen.dart    # Sprint 3 — G10 Săn chữ
    games/boss_quiz/boss_quiz_screen.dart        # Sprint 3 — G12, bản sao listen_pick_screen.dart
assets/
  # Sprint 4 — đa lớp: mỗi lớp 1 thư mục con `lopN/` (N=1-5) dưới CẢ `content/` lẫn `data/`.
  data/lop2/{units,vocabulary}.json + data/lop2/games/g0{1,2,3,4,5,6,9}_*.json,
  g10_letter_hunt.json, g12_boss_quiz.json         # Lớp 2 — đủ 16 unit (di chuyển từ
                                                    # assets/data/ gốc, nội dung không đổi)
  data/lop1/units.json (đủ 16 unit) + data/lop1/games/g0{1,2,3,4,5,10}_*.json
                                                    # Lớp 1 — CHỈ Unit 1 (ball/bike/book), G06 cố
                                                    # tình bỏ qua (không có mẫu điền-từ cho Unit 1)
  content/lop2/UnitNN/{image,audio}/...   # mirror của 04_image+audio/02_Lop-2; audio/ có thêm
                                     # sentence_pattern.mp3 (Track "Mẫu câu" mỗi unit, dùng chung
                                     # cho G05/G06 — không phải audio riêng từng câu)
  content/lop1/Unit01/{image,audio}/...   # mirror của 04_image+audio/01_Lop-1/Unit01 — KHÔNG có
                                     # sentence_pattern.mp3 (G05 Lớp 1 Unit1 audio: null)
  sfx/correct.mp3, wrong.mp3          # âm hiệu ứng đúng/sai (đã có 2026-07-23) — dùng chung mọi
                                     # lớp, không nằm trong lopN/
```

DB tiến độ/hồ sơ (SQLite qua Drift) nằm trong app documents dir của máy/điện thoại, **không** trong
`assets/` — mỗi hồ sơ trẻ là 1 dòng độc lập, xóa app = mất tiến độ. F15 (CR-014) đã thêm nút xóa
**từng hồ sơ** (qua cổng phụ huynh) nhưng **vẫn chưa có export/backup** trước khi xóa — rủi ro đã
được chấp nhận có chủ ý (xem `SPRINT2_PLAN.md` phần Context), không phải bỏ sót.

Đường dẫn asset trong JSON là **tương đối** (vd `Unit01/image/pasta.png`); prefix bundle (Sprint 4)
= `assets/content/lop$grade/` (hàm `ContentRepository.asset({grade, relativePath})` — không còn
static const `assetBase`, phải truyền `grade` rõ ràng mỗi lần gọi).

**Quan trọng — đồng bộ ảnh/audio (xem CR-001 trong `BUGS_CR.md`)**: `assets/content/lopN/` là bản
**copy thủ công** của `../04_image+audio/0N_Lop-N/`, KHÔNG tự động đồng bộ. Sửa/thay ảnh hoặc audio
gốc xong **PHẢI copy lại đè vào `assets/content/lopN/UnitNN/...` tương ứng rồi build lại** — nếu
không, app vẫn chạy bản cũ dù nguồn đã đổi.

## 5. Định dạng JSON config (quan trọng khi thêm game)

- `g01_flashcard.json`: `instances[].config.cards[]` = `{word_id, word, ipa, meaning_vi, image, audio}`.
- `g02_listen_pick.json`: `instances[].config.questions[]` = `{word_id, prompt_audio, options[{word_id,image}], answer_idx}`.
- `g03_fill_letter.json`: `instances[].config.items[]` = `{word_id, word, image, audio, hidden_idx[], answer, distractors[]}` (digraph `sh`/`er` tính 1 "ô" nhưng vẫn chiếm 2 index liền nhau trong `hidden_idx`). **Mỗi từ có 3 lượt liên tiếp** (2026-07-23, CR-010). **Số ô ẩn theo độ dài từ** (2026-07-26, CR-020): từ <4 chữ cái ẩn 1 ô/lượt (như cũ); từ ≥4 chữ cái ẩn **2 ô cùng lúc/lượt**, vị trí 2 ô chọn ngẫu nhiên trong các ô của từ nên **`hidden_idx` có thể KHÔNG liền nhau** (vd `[2,4]`) — `answer`/`distractors` khi đó dài 2-3 ký tự tùy có dính ô digraph hay không; `distractors` sinh riêng theo từng lượt (không còn dùng chung cho cả 3 lượt như từ <4 chữ cái, vì độ dài có thể khác nhau giữa các lượt) và LUÔN là chữ đơn (2026-07-26, CR-023 — trước đó CR-020 từng dùng chuỗi cùng độ dài với `answer` cho 1 lượt chạm gộp, nay `fill_letter_screen.dart` cho điền RIÊNG từng ký tự 1 lượt chạm nên khay chữ phải là chữ đơn: `answer.split('') + distractors`). `fill_letter_screen.dart` ghép hiển thị theo từng ký tự (`_wordSpans`), không giả định `hidden_idx` liền dải; `_filledCount` theo dõi đã điền đúng bao nhiêu ô (trái sang phải).
- `g04_scramble.json`: `instances[].config.items[]` = `{word_id, word, image, audio}` — xáo chữ cái của `word` (digraph gộp 1 ô, giống G03).
- `g05_sentence.json`: `instances[].config.items[]` = `{sentence, tokens[], audio}` — `tokens[]` là word-split (dấu câu dính vào từ trước, không tách riêng); `audio` là `Unit NN/audio/sentence_pattern.mp3` **dùng chung cho cả unit** (Track "Mẫu câu" nguyên track, không cắt riêng từng câu — xem mục 9).
- `g06_mindmap.json`: `instances[].config.items[]` = `{word_id, pattern, options[{word_id,word,image,audio}], answer_idx, audio}` — `pattern` là câu ví dụ đã khuyết đúng từ đang test (`___`), tính theo từng câu (không phải 1 pattern tĩnh cho cả unit vì có unit đổi cả động từ theo chủ ngữ, vd Unit 5). `options` khi từ đó đã có audio thì tái dùng nguyên từ câu hỏi tương ứng trong `g02_listen_pick.json` (cùng hình + cùng thứ tự xáo trộn); khi từ không có audio (`twelve`, `nineteen`, `sixteen`) thì tự dựng từ các từ còn lại cùng unit, `audio: null` cho lựa chọn đó (không chặn hiển thị hình, chỉ tắt nút loa). `audio` ở cấp item (thêm 2026-07-23, CR-004) là audio "Mẫu câu" dùng chung cả unit, giống `g05_sentence.json`.
- `g09_memory.json` (Sprint 3, CR-019): `instances[].config.pairs[]` = `{word_id, word, image, audio}` — `unit_id` của instance là unit **gắn checkpoint** (2/6/10/14), không phải unit chứa từ vựng; `pairs[]` gộp từ 2 unit trong phạm vi Fun Time đó (vd Fun Time sau Unit 2 = từ Unit 1+2). Sinh từ `g01_flashcard.json` nhưng **phải tự lọc `audio != null`** — khác giả định ban đầu, G01 (không như G02/G03) KHÔNG tự loại bỏ 7 từ mở rộng chưa có audio.
- `g10_letter_hunt.json` (đổi hẳn cơ chế 2026-07-26, CR-020 — không còn "săn chữ cái phonics" của
  Sprint 3/CR-019): `instances[].config.questions[]` = `{word_id, word, image, prompt_audio,
  options[], answer_idx}`, cùng shape `g02_listen_pick.json` nhưng `options` là **CHỮ** (`List<String>`,
  từ vựng) thay vì hình. 1 câu hỏi/từ CÓ AUDIO trong unit (số câu hỏi/unit = 3-4 tùy unit, không còn
  cố định "5 lượt" như bản cũ). `options` = từ đúng + 5 từ nhiễu rút ngẫu nhiên từ (mọi từ của unit
  hiện tại + mọi từ của unit liền trước, kể cả từ mở rộng không audio — chỉ cần CHỮ, không cần phát
  âm được); Unit 1 dùng `["You","He","She"]` thay cho "unit trước" (không có unit 0). `image`
  (CR-022) chỉ dùng cho màn "phần thưởng" cuối bài (lấy từ câu hỏi đầu tiên) — khôi phục tiêu chí F11
  "săn chữ có thưởng" mà CR-020 vô tình bỏ. Model cũ `HuntLetterItem` (config phẳng, chỉ 1 mục/unit,
  `target_letter`) đã bỏ hẳn.
- `g12_boss_quiz.json` (Sprint 3, CR-019): `instances[].config.questions[]` = `{source_game, unit_id, prompt_text?, prompt_audio?, prompt_image?, options[{image?,text?}], answer_idx}` — `unit_id` của instance là unit gắn Boss Quiz (4/8/12/16); mỗi câu hỏi có `unit_id` riêng (unit gốc câu hỏi đó, để tham khảo). Trộn từ dữ liệu **đã có sẵn** của G02 (giữ nguyên)/G03 (dedupe 1 lượt/từ, đổi thành trắc nghiệm chữ)/G05 (đổi thành trắc nghiệm, câu nhiễu = xáo token của chính câu đúng). Không nạp mới content — sinh 1 lần bằng script, review tay trước khi dùng.

Sinh lại config: xem `../03_Assets/data_json/README_data.md`. Script sinh G01-G04 đọc từ `04_image+audio/manifest.csv`; G05/G06 đọc trực tiếp từ `02_Phan_tich/…xlsx` sheet `02_Giáo trình chi tiết` cột F + tái dùng `g02_listen_pick.json`/`vocabulary.json` (không có manifest riêng, xem lịch sử `SPRINT2_PLAN.md` Phase 2 nếu cần sinh lại); G09/G10/G12 (Sprint 3) đọc trực tiếp từ `units.json`/`g01_flashcard.json`/`g02_listen_pick.json`/`g03_fill_letter.json`/`g05_sentence.json` đã có sẵn trong app, không cần tài liệu Excel gốc nữa (xem `SPRINT3_PLAN.md` từng phase). Sau khi sinh, **copy** vào `assets/data/` và `assets/data/games/`.

## 6. Quy ước code (sheet 08) — TUÂN THỦ

- `dart format` + `flutter analyze` sạch trước mỗi commit; lint mục tiêu: `very_good_analysis` (hiện tạm dùng `flutter_lints`).
- File `snake_case`, class `PascalCase`, biến/hàm `camelCase`, boolean bắt đầu `is/has/can`.
- **Không hardcode**: màu → `AppColors`; chuỗi UI → l10n (chưa dựng, xem mục 8); nội dung → JSON/DB.
- Comment nghiệp vụ bằng **tiếng Việt**; `TODO(tên): ...`.
- Tách widget khi >150 dòng. Git: nhánh `feature/*`, Conventional Commits (`feat:`, `fix:`), qua PR.
- **Luôn dùng `AppScaffold` (common_widgets.dart), KHÔNG dùng `Scaffold` trần** — `AppScaffold` bọc
  sẵn `SafeArea` để tránh bị thanh điều hướng hệ thống che nội dung/nút ở đáy màn hình (xem BUG-001
  trong `BUGS_CR.md` — đã xảy ra thật trên máy test, sửa ở cả 6 màn hình hiện có). Màn hình mới
  (Sprint 2+: G04–G13, cài đặt, cổng phụ huynh) tạo ra sau này cũng phải dùng `AppScaffold`.
- **Game có chọn đáp án đúng/sai, chấm ngay khi chọn** (mẫu G02/G03/G06, xem CR-002
  `BUGS_CR.md`): dùng `AnswerFeedbackOverlay` (message + hiệu ứng đúng/sai) + `AudioService.playSfx()`
  thay vì tự viết lại; nút "Quay lại"/"Tiếp theo" (`SecondaryButton` + `PrimaryButton`) thay cho
  auto-advance theo giờ; chọn sai thì xáo trộn lại lựa chọn; tính sao bằng tập hợp index đã đúng
  (không đếm dồn, để xem lại không bị tính 2 lần). **Bắt buộc chặn thao tác chạm trong lúc hiệu ứng
  sai còn hiện** (`if (... || _feedback == AnswerFeedback.wrong) return;` đầu hàm xử lý chạm) — xem
  BUG-003 `BUGS_CR.md`: thiếu chốt này để lọt cửa sổ ~700ms có thể chạm chồng lượt trước khi xáo
  trộn xong. Áp dụng cho G10 săn chữ, G12 Boss Quiz (cả 2 đã code xong, Sprint 3) — **G09 memory là
  ngoại lệ có chủ ý**: dùng mẫu chấm-ngay cho hiệu ứng đúng/sai nhưng **KHÔNG xáo trộn khi sai** (xáo
  vị trí thẻ sẽ phá hỏng bản chất trò chơi trí nhớ), xem `memory_match_screen.dart`.
- **Game "lắp ráp rồi kiểm tra" (không chấm ngay khi chọn)** — mẫu G04/G05 (G04 đổi từ mẫu chấm-ngay
  sang mẫu này ngày 2026-07-23 theo CR-011, cùng lúc với G05 ở CR-008; xem `BUGS_CR.md`): chạm để
  đặt vào ô trống kế tiếp, chạm ô đã đặt để bỏ ra chọn lại (không chấm đúng/sai lúc này); nút
  "Kiểm tra" chấm toàn bộ 1 lần (đúng thì `AnswerFeedbackOverlay.correct` + mở "Tiếp theo", sai thì
  `.wrong` **nhưng giữ nguyên cách xếp**, không tự xóa/xáo — để trẻ tự sửa); nút "Làm lại" (bên trái
  "Kiểm tra") reset về trạng thái ban đầu + xáo lại khay chọn. Không dùng cơ chế "xáo trộn khi chọn
  sai" của mẫu chấm-ngay ở trên. (G10 săn chữ KHÔNG dùng mẫu này — dùng đúng mẫu chấm-ngay chuẩn ở
  trên, gần như bản sao `listen_pick_screen.dart` từ khi đổi cơ chế sang nghe & chọn từ vựng, xem
  `letter_hunt_screen.dart` + CR-020 `BUGS_CR.md`.)
- **Nút nền sáng màu (vd `AppColors.warning` vàng, `AppColors.error` đỏ nhạt) phải dùng chữ tối**:
  `PrimaryButton` có tham số `foregroundColor` (mặc định `Colors.white`, hợp nền primary/secondary/
  info/success hiện có) — truyền `AppColors.textPrimary` khi nền sáng màu để đủ tương phản cho trẻ
  đọc (xem CR-009 `BUGS_CR.md`, đã áp dụng cho G05/G06 kể cả nút trên màn Unit qua
  `GameDef.foregroundColor`).
- **Độ khó (F15, `SettingsService.instance.isEasy`, xem CR-015 `BUGS_CR.md`)**: game chọn-đáp-án
  (G02/G03/G06/G10/G12) làm mờ + vô hiệu 1 lựa chọn SAI khi Dễ; game lắp-ráp (G04/G05) tự điền sẵn
  ô/token đầu tiên khi Dễ (kể cả sau khi bấm "Làm lại"). Khó = hành vi gốc, không gợi ý thêm. **G09
  memory không khớp 2 mẫu trên** (không có "lựa chọn sai" để làm mờ, không có "ô/token" để điền sẵn)
  nên dùng cơ chế thứ 3 riêng (CR-021): Dễ = xem trước toàn bộ thẻ lật ngửa 4 giây lúc mới vào màn
  hình rồi mới úp xuống cho chơi bình thường (`_previewing` trong `memory_match_screen.dart`). Game
  mới sau này nên theo đúng 1 trong các mẫu chuẩn đã có thay vì nghĩ ra cơ chế gợi ý riêng, trừ khi
  thật sự không khớp như G09.
- **Hết màu vai trò cho game mới**: 6 màu bảng sheet 09 (primary/secondary/success/warning/error/
  info) đã dùng hết cho G01-G06; game sau dùng lại 1 trong 6 màu nhưng tông đậm hơn (kỹ thuật
  `AppColors.xxxDark`, bắt đầu từ `infoDark` cho G08 — CR-018) thay vì hardcode hex mới, phân biệt
  bằng icon/nhãn/sắc độ: G09 `successDark`, G10 `secondaryDark`, G12 `errorDark` (Sprint 3).
- **Game "checkpoint" gắn 1 unit cụ thể (không phải mọi unit)** — Sprint 3, G09 "Lật thẻ" (sau Unit
  2/6/10/14, đổi tên từ "Fun Time" ở CR-023) và G12 Boss Quiz (sau Unit 4/8/12/16): khai báo trong
  `checkpoints.dart`
  (`Checkpoint`/`kFunTimeCheckpoints`/`kBossQuizCheckpoints`/`extraGamesForUnit()`), KHÔNG thêm vào
  `kGameTypeOrder` (`progress_repository.dart`) vì game trong danh sách đó coi là xuất hiện ở MỌI
  unit. Dùng `GameDef.isUnlockedOverride` thay vì `isGameUnlocked` mặc định — Boss Quiz gọi
  `ProgressRepository.isCheckpointUnlocked` (cần CHÍNH unit gắn checkpoint xong 4 game lõi, không
  phải unit trước); Lật thẻ gọi `isFunTimeUnlocked` (CR-023, chặt hơn — cần CẢ 2 unit trong phạm vi
  ôn tập xong MỌI game, không chỉ 4 game lõi). `UnitScreen` render qua vòng lặp riêng
  `extraGamesForUnit(unit.unitId)`, không sửa
  `kUnitGames`.
- **`kUnitGames` (`game_defs.dart`) và `kGameTypeOrder` (`progress_repository.dart`)**: từ Sprint 3,
  `kUnitGames` **suy ra** từ `kGameTypeOrder` (map `gameDefsByType`), không còn là 2 danh sách độc
  lập phải tự tay giữ khớp nhau — thêm game mới vào `kGameTypeOrder` mà quên thêm `GameDef` tương
  ứng vào `gameDefsByType` (hoặc ngược lại) sẽ **crash ngay lúc khởi động** (cố ý, để lộ lỗi sớm
  thay vì âm thầm sai như trước).

## 7. Khác biệt CÓ CHỦ Ý so với kiến trúc đích (cần nâng cấp khi vào code chính thức)

| Đích (tài liệu) | Hiện tại | Ghi chú |
|-----------------|----------|---------|
| Drift/SQLite (sheet 07) | ✅ **Đã dùng** cho Profiles + LessonProgress (2026-07-23) | Content tĩnh (unit/vocab/game config) vẫn đọc JSON — không cần chuyển, không phải dữ liệu người dùng sinh ra |
| Riverpod | StatefulWidget + repo qua constructor + StreamBuilder trên Drift | **Có chủ ý CHƯA chuyển** — Drift Stream đã đủ reactive cho scope hiện tại, tránh đổi kiến trúc 2 việc cùng lúc |
| go_router | Navigator lồng (push/pushReplacement) | Chuyển sang go_router khi cần deep-link/tách route rõ |
| Kéo-thả G03 | Chạm-để-điền | Nâng cấp Draggable/DragTarget |
| Baloo 2 / Nunito | Font hệ thống | Thêm google_fonts hoặc bundle .ttf |

## 8. Việc tiếp theo (ưu tiên theo lộ trình — sheet 11)

**Sprint 1 (P0) — XONG (2026-07-23):** F02 Hồ sơ trẻ, F14 Tiến độ & sao (Drift), F03 luồng 3
game tuần tự + khóa/mở unit, F01 hiển thị sao/khóa trên bản đồ. Đã build APK debug test được.

**Sprint 2 (P1) — gần xong, chỉ còn G07 pending** (kế hoạch chi tiết: `SPRINT2_PLAN.md`):
- ✅ **G04 xếp chữ — XONG** (2026-07-23): data từ `vocabulary.json`, màn hình
  `scramble_screen.dart`, digraph gộp 1 ô như G03. Đổi sang mô hình "lắp ráp rồi Kiểm tra" ở vòng
  sau (CR-011).
- ✅ **G05 lắp ráp câu + G06 hoàn thành câu — XONG** (2026-07-23): dữ liệu câu trích xuất trực tiếp
  từ `02_Phan_tich/…xlsx` sheet 2 cột F (49 câu G05, 33 mục G06, 16 unit) — xem `SPRINT2_PLAN.md`
  Phase 2. Audio "Nghe" đã cắt phần giới thiệu đầu track (CR-013).
- ✅ **F15 cài đặt + cổng phụ huynh + sửa/xóa hồ sơ — XONG** (2026-07-23, CR-014): âm thanh
  on/off, độ khó Dễ/Khó (wiring vào G02-G06 ở CR-015), cổng phụ huynh (phép tính), sửa/xóa hồ sơ
  (chạm giữ trên màn Hồ sơ hoặc từ màn Cài đặt).
- ✅ **G08 ghi âm — XONG** (2026-07-23, CR-016; cập nhật CR-018): nghe mẫu → nói theo (tự dừng khi
  im lặng ~2s) → **hệ thống tự nhận diện giọng nói, so khớp đáp án ra %/điểm/âm thanh cảnh báo**
  (không còn nghe lại giọng bé/tự chấm sao thủ công, xem lý do đánh đổi trong `BUGS_CR.md` CR-018),
  dùng package `speech_to_text` + `permission_handler`, không cần nội dung mới (dùng lại
  `vocabulary.json`).
- ⏸️ **G07 karaoke — PENDING, người dùng chủ động yêu cầu chưa cần làm** (2026-07-23). Lời bài
  hát/chant đã có (cùng file phân tích giáo trình), nhưng timing từng dòng CHƯA có (cần người
  nghe & đánh dấu) — khi nào cần làm lại, đọc phần "Phase 5" trong `SPRINT2_PLAN.md`.
- **Quy tắc mở unit**: chỉ cần G01-G04 (không phải toàn bộ) đạt ≥1 sao mới mở unit tiếp theo —
  G05/G06/G08/G10 vẫn cho sao nhưng không chặn tiến độ (xem `progress_repository.dart`).

**Sprint 3 (P2) — đã code G09+G10+G12, chỉ còn G11 pending** (kế hoạch chi tiết: `SPRINT3_PLAN.md`,
CR-019 `BUGS_CR.md`). **Sửa số game**: tài liệu gốc gọi Boss Quiz là **G12** (catalog chỉ có G01-G12)
— "G13" ở các ghi chú trước đây là gõ nhầm.
- ✅ **G09 Fun Time (memory match) — XONG** (2026-07-23): không cần nội dung mới, `g09_memory.json`
  sinh từ `g01_flashcard.json` (unit trong phạm vi Fun Time, đã lọc bỏ từ không có audio). Gắn sau
  Unit 2/6/10/14 qua cơ chế checkpoint (mục 6), không phải game của riêng 1 unit. **Độ khó Dễ đã bổ
  sung sau (2026-07-26, CR-021)** — xem tường trước 4 giây, mục 6.
- ✅ **G10 Săn chữ — XONG** (2026-07-23, code ban đầu); **đổi hẳn cơ chế 2026-07-26 (CR-020)**: không
  còn "săn chữ cái phonics" — giờ nghe 1 từ vựng rồi chọn đúng từ đó trong 6 đáp án chữ (gộp từ vựng
  unit hiện tại + unit liền trước). Mẫu chấm-ngay chuẩn (gần như bản sao G02) — xem mục 5/6 và
  CR-020 `BUGS_CR.md`.
- ✅ **G12 Boss Quiz + huy hiệu — XONG** (2026-07-23): câu hỏi trộn từ G02/G03/G05 đã có sẵn, không
  cần nội dung mới. Huy hiệu là nội dung app tự nghĩ (tài liệu gốc ghi "App tự định nghĩa") — 4 huy
  hiệu, tên/icon hiện là placeholder (xem `badge_defs.dart`), đổi được bất cứ lúc nào không cần sửa
  logic. Đây là **migration DB đầu tiên của app** (bảng `EarnedBadges`, `schemaVersion` 1→2).
- ⏸️ **G11 Truyện tương tác (Phil & Sue) — PENDING, giống G07**: không có lời thoại/ảnh trang truyện
  ở bất kỳ đâu trong 2 file Excel hay `04_image+audio/` (khác G05/G06/G09/G10, không phải "có sẵn
  chỉ cần trích xuất"). Audio 4 track Review tồn tại nhưng nguyên track, chưa cắt. Nội dung thật
  (nếu có) nhiều khả năng nằm trong `01_Document/book.pdf` trang 20/37/54/71 — file quá lớn để đọc
  trong môi trường hiện tại, cần người mở tay.

**Sprint 4 (P3) — đa lớp, đã code Phase 0-2 (chỉ Lớp 1 Unit 1), CR-027** (kế hoạch gốc:
`SPRINT4_PLAN.md`, chi tiết đã code: `BUGS_CR.md` CR-027):
- ✅ **Multi-grade plumbing (Phase 0) — XONG**: migration DB lần 2 (cột `grade`), `ContentRepository`/
  `WordImage`/`AudioService` tham số hóa theo lớp, asset Lớp 2 di chuyển sang `lop2/`.
- ✅ **Màn "Chọn lớp" SCR-00 (Phase 1) — XONG**: `grade_select_screen.dart`, nút "Đổi lớp" trên Home.
- ✅ **Lớp 1 Unit 1 (Phase 2) — XONG**: G01-G05/G08/G10 chơi được đầy đủ, G06 cố tình bỏ qua.
- ⏸️ **Lớp 1 Unit 2-16 — CHƯA LÀM** (để sprint sau, lặp lại đúng Phase 2 của `SPRINT4_PLAN.md` cho
  từng unit — dữ liệu ảnh/audio 16 unit đã có sẵn trong `04_image+audio/01_Lop-1/`, chỉ cần sinh JSON
  game + copy asset, không cần sửa lại Phase 0/1).
- ⏸️ **Lớp 3/4/5 — chưa có giáo trình/dữ liệu nguồn**, kiến trúc đã tổng quát hóa sẵn (`grade: int`
  không hardcode phạm vi, `kGradeOptions` chỉ cần thêm 1 dòng khi có dữ liệu).
- **Chưa test trên điện thoại thật** — xem checklist Verification đầy đủ trong `BUGS_CR.md` CR-027,
  đặc biệt: cài đè lên bản có hồ sơ Lớp 2 thật để xác nhận migration lần 2 không mất dữ liệu.

**Nợ kỹ thuật nhỏ chưa xử lý:** chưa có test tự động (`test/` đang trống — SPRINT2_PLAN.md có đề
xuất thêm vài test cho `progress_repository.dart`/xóa hồ sơ nhưng chưa làm); `flutter build apk
--release` chưa có signing config riêng (build --release vẫn dùng debug keystore mặc định, KHÔNG
dùng để phát hành Play Store); chưa có backup/export tiến độ trước khi cho xóa hồ sơ (chấp nhận rủi
ro theo quyết định ghi trong `SPRINT2_PLAN.md` Context).

## 9. Khoảng trống dữ liệu (cần con người xử lý — sheet 12/13)

- **7 từ mở rộng chưa có audio**: `twelve, sixteen, seventeen, eighteen, nineteen, twenty, near`.
  Đang loại khỏi G02/G03; có audio thì sinh lại config. **Cập nhật (2026-07-23, phiên Cowork — đã
  đối chiếu 92 file trong `01_Document/AUDIO/` với transcript SGK ở `02_Phan_tich/…xlsx` sheet
  `04_Audio (DB)`)**:
  - `seventeen`, `eighteen`, `twenty` — **không xuất hiện ở bất kỳ track nào trong 92 track**
    (kể cả 4 track Review chỉ có mô tả chung, chưa transcript chi tiết nên chưa loại trừ 100%).
    Nhiều khả năng phải **thu âm mới**, không có nguồn để "cắt".
  - `twelve` (Track 75), `sixteen` (Track 77), `nineteen` (Track 77/79/80), `near` (Track 87/89/90)
    — có xuất hiện, nhưng **nằm lồng trong câu hát/chant** (không phải bản đọc từ đơn lẻ như 49
    audio hiện có) → cắt được nhưng chất lượng/phong cách sẽ không đồng nhất với bộ audio từ vựng
    sạch hiện tại, cần nghe và cắt tay cẩn thận.
- Transcript track "Listen and tick/circle": sheet `04_Audio (DB)` mới có **mô tả dạng** ("2 câu,
  mỗi câu 2 lựa chọn hình"), chưa có câu thoại thật — vẫn cần nghe và gõ lại.
- Timing lyrics (chant/song): lời bài hát/chant **đã có sẵn** (transcript SGK, sheet `04_Audio
  (DB)` cột F / sheet `02_Giáo trình chi tiết` cột F) — chỉ thiếu **mốc thời gian** từng dòng, cần
  người nghe & đánh dấu (không có công cụ căn chỉnh tự động trong môi trường hiện tại).
- ~~Dữ liệu câu mẫu (`sentences`) cho G05/G06~~ — **đã sinh xong config game thật** (2026-07-23,
  xem `SPRINT2_PLAN.md` Phase 2): `g05_sentence.json` (49 câu) + `g06_mindmap.json` (33 mục), đọc
  trực tiếp từ `02_Phan_tich/…xlsx` sheet `02_Giáo trình chi tiết` cột F (không chỉ dựa vào bản
  draft `03_Assets/data_json/sentences.json` của phiên Cowork — đối chiếu lại từ nguồn). Khoảng
  trống Unit 16 (F-column gốc chỉ có 1/3 cặp câu ví dụ) đã xử lý xong: 2 cặp còn lại
  ("table"/"tent", "teapot"/"table") lấy từ lời bài hát Track 90 — cùng nguồn SGK, không phải nội
  dung tự bịa. `sentence_audio_path`/audio riêng từng câu **vẫn chưa có** (như draft đã ghi) —
  G05/G06 dùng chung 1 audio "Mẫu câu" mỗi unit thay vì cắt riêng từng câu, tại
  `assets/content/UnitNN/audio/sentence_pattern.mp3`. **Cập nhật (2026-07-23, CR-013)**: đã cắt bỏ
  đoạn giới thiệu "Unit N/Page/Lesson 3/Activity 6/Listen and repeat" đầu track (dùng
  faster-whisper xác định điểm cắt theo nội dung thật, không đoán mốc thời gian — xem BUGS_CR.md
  CR-013 để biết cách làm nếu cần lặp lại cho unit khác). **Lưu ý còn tồn tại**: nội dung audio
  "Mẫu câu" gốc SGK không phải lúc nào cũng khớp đủ với toàn bộ câu ví dụ trong
  `g05_sentence.json` — Unit 1/3/11 chỉ có 1/3 câu, Unit 4/14 có 2/3-2/4 câu, Unit 16 chỉ khớp
  cặp gốc (không có 2 cặp bổ sung từ bài hát); chấp nhận được vì là audio "Nghe chung unit", không
  phải audio đúng-từng-câu, nhưng **Unit 11 cần nghe lại tay để xác nhận** (transcript tự động
  nhận không rõ, khả năng là "They're driving cars").
- **4 file audio lỗi tên `.mp3 TA2.mp3` (Track 3–6)** — **đã xử lý xong** (người dùng đổi tên
  2026-07-23, đã xác nhận trong `01_Document/AUDIO/` sạch tên). **Track 1 vẫn thiếu** — không có
  trong 93 file, không có gì làm được nếu không có nguồn gốc.
- Bản quyền asset SGK: chỉ dùng nội bộ; muốn phát hành phải tự sản xuất lại hoặc xin phép.
- ~~2 file âm thanh hiệu ứng đúng/sai~~ — **đã có** (2026-07-23): `assets/sfx/correct.mp3` +
  `wrong.mp3` (nhận từ `05_App/03_Assets/sfx/`, xem CR-002 `BUGS_CR.md` — file `wrong.mp3` được suy
  đoán từ file `answer.mp3` người dùng gửi, CHƯA xác nhận đúng ý).
- **3 file âm thanh cảnh báo điểm G08 (CR-018, 2026-07-23) — CHƯA CÓ**: code đã trỏ sẵn
  `assets/sfx/score_low.mp3` (<=50 điểm), `score_mid.mp3` (51-80), `score_high.mp3` (81-100) —
  `AudioService.playSfx()` tự bỏ qua an toàn nếu thiếu file (không crash, giống cách xử lý
  `correct.mp3`/`wrong.mp3` ở trên) nên app vẫn chạy được, chỉ im lặng phần này cho tới khi có file.

## 10. Edge case đã biết (giữ khi refactor)

- Unit 13 có 4 từ (khác 3) → luôn xử lý số lượng động, không hardcode 3 lựa chọn.
- `is/are` theo số nhiều: `vocabulary.is_plural` (yo-yos, yams, grapes, shirts, shoes, shorts).
- Phonics digraph `er`, `sh` là chuỗi 2 ký tự, không phải 1 char.
- Flashcard (G01) không có khái niệm đúng/sai → nút "Xong" trả **cố định 3 sao** khi hoàn thành
  (quyết định đơn giản hóa 2026-07-23, xem `flashcard_screen.dart`). Nếu sau này thêm chấm điểm
  cho flashcard (vd. lật đủ tất cả thẻ mới cho Xong), cần sửa lại logic này.
- Sao **chỉ tăng, không giảm**: chơi lại 1 game với kết quả kém hơn không hạ sao đã đạt
  (`progress_repository.dart: reportResult`).
- Đổi hồ sơ (nút avatar trên AppBar Home) dùng `pushReplacement` về `ProfileSelectScreen`, không
  push chồng — tránh giữ lại state/route của hồ sơ cũ trong back stack.
- **`g01_flashcard.json` KHÔNG tự loại 7 từ mở rộng chưa có audio** (phát hiện khi sinh dữ liệu G09,
  Sprint 3) — khác G02/G03/G05/G06 vốn đều đã lọc sẵn. Bất kỳ script nào sau này đọc `cards[]` từ
  file này để lấy danh sách "từ có audio" của 1 unit phải tự lọc `audio != null`, không giả định
  file đã lọc sẵn.
- Phonics digraph `er`/`sh` (chuỗi 2 ký tự, không phải 1 char) áp dụng cho cả `hidden_idx` (G03) và
  xáo chữ (G04) — cùng 1 quy tắc dùng lại. (G10 không còn liên quan từ CR-020 — đổi hẳn sang nghe &
  chọn từ vựng, không còn khái niệm chữ cái/digraph riêng lẻ.)
