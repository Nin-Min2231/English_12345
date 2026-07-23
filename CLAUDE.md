# CLAUDE.md — lop2_english_app

Ngữ cảnh cho Claude Code khi làm việc trong repo này. Đọc kỹ trước khi sửa code.

**Trước khi sửa bug/thay đổi theo yêu cầu người dùng**: kiểm tra `BUGS_CR.md` (cùng thư mục) — nhật
ký Bug/CR đang mở, tránh xử lý sai/trùng/bỏ sót.

## 1. Dự án là gì

App Android (Flutter, offline-first) luyện tiếng Anh tiểu học theo giáo trình **Global Success**. Giai đoạn 1 = **Lớp 2**: 16 unit, 48 lesson, 56 từ vựng, 12 loại game tái sử dụng (G01–G12). Người dùng: trẻ 7–8 tuổi tự chơi; phụ huynh/giáo viên theo dõi. Triết lý: "học mà chơi", phiên ≤5 phút, dựa vào hình/màu/âm thanh vì trẻ chưa đọc thạo.

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
                                # home = ProfileSelectScreen
  core/theme/app_theme.dart    # AppColors, AppSpacing (design tokens sheet 09)
  core/widgets/common_widgets.dart  # PrimaryButton, SecondaryButton, StarBar, WordImage,
                                     # AppScaffold, AnswerFeedbackOverlay (đúng/sai)
  core/widgets/parent_gate.dart # F15 — showParentGate(), confirmDeleteProfile() (2026-07-23)
  data/models/models.dart      # UnitInfo, FlashCard, ListenQuestion, FillItem, ScrambleItem,
                                # SentenceItem, MindmapOption, MindmapItem (content JSON)
  data/content_repository.dart # nạp JSON -> map theo unit_id
  data/db/app_database.dart    # Drift: bảng Profiles, LessonProgressTable (+ .g.dart sinh ra)
  data/repositories/
    profile_repository.dart    # watchProfiles(), create(), update(), delete() (F15, 2026-07-23)
    progress_repository.dart   # watchForProfile(), reportResult(), isUnitUnlocked, isGameUnlocked
  services/audio_service.dart  # just_audio, singleton, kiểm tra SettingsService.soundOn
  services/settings_service.dart  # F15 — âm thanh on/off, độ khó easy/hard (2026-07-23)
  features/
    profile/profile_select_screen.dart   # F02 — chọn/tạo hồ sơ; chạm giữ để sửa/xóa (F15)
    settings/settings_screen.dart  # F15 — cài đặt + xóa hồ sơ (2026-07-23)
    home/  flashcard/
    unit/unit_screen.dart, game_defs.dart  # F03; kUnitGames = danh sách game/unit
    games/listen_pick/  games/fill_letter/  games/scramble/
    games/sentence_build/  games/mindmap/  # G05, G06 (Sprint 2 Phase 2, 2026-07-23)
    games/record/record_screen.dart  # G08 ghi âm + nhận diện giọng nói tự chấm điểm (CR-018)
assets/
  data/{units,vocabulary}.json + data/games/g0{1,2,3,4,5,6}_*.json
  content/UnitNN/{image,audio}/...   # mirror của 04_image+audio; audio/ có thêm
                                     # sentence_pattern.mp3 (Track "Mẫu câu" mỗi unit, dùng chung
                                     # cho G05/G06 — không phải audio riêng từng câu)
  sfx/correct.mp3, wrong.mp3          # âm hiệu ứng đúng/sai (đã có 2026-07-23)
```

DB tiến độ/hồ sơ (SQLite qua Drift) nằm trong app documents dir của máy/điện thoại, **không** trong
`assets/` — mỗi hồ sơ trẻ là 1 dòng độc lập, xóa app = mất tiến độ. F15 (CR-014) đã thêm nút xóa
**từng hồ sơ** (qua cổng phụ huynh) nhưng **vẫn chưa có export/backup** trước khi xóa — rủi ro đã
được chấp nhận có chủ ý (xem `SPRINT2_PLAN.md` phần Context), không phải bỏ sót.

Đường dẫn asset trong JSON là **tương đối** (vd `Unit01/image/pasta.png`); prefix bundle = `assets/content/` (hằng `ContentRepository.assetBase`).

**Quan trọng — đồng bộ ảnh/audio (xem CR-001 trong `BUGS_CR.md`)**: `assets/content/` là bản
**copy thủ công** của `../04_image+audio/`, KHÔNG tự động đồng bộ. Sửa/thay ảnh hoặc audio gốc ở
`04_image+audio/` xong **PHẢI copy lại đè vào `assets/content/UnitNN/...` tương ứng rồi build lại**
— nếu không, app vẫn chạy bản cũ dù nguồn đã đổi.

## 5. Định dạng JSON config (quan trọng khi thêm game)

- `g01_flashcard.json`: `instances[].config.cards[]` = `{word_id, word, ipa, meaning_vi, image, audio}`.
- `g02_listen_pick.json`: `instances[].config.questions[]` = `{word_id, prompt_audio, options[{word_id,image}], answer_idx}`.
- `g03_fill_letter.json`: `instances[].config.items[]` = `{word_id, word, image, audio, hidden_idx[], answer, distractors[]}` (digraph `sh`/`er` = 2 index liền nhau, answer 2 ký tự). **Mỗi từ có 3 lượt liên tiếp** (2026-07-23, CR-010) — 3 `items` cùng `word_id`/`word` nhưng `hidden_idx`/`answer` khác nhau (3 vị trí "ô" khác nhau, digraph tính 1 ô; từ ≤2 ô như "ox" chỉ có 2 lượt); `distractors` giữ nguyên như nhau cho cả 3 lượt của cùng 1 từ.
- `g04_scramble.json`: `instances[].config.items[]` = `{word_id, word, image, audio}` — xáo chữ cái của `word` (digraph gộp 1 ô, giống G03).
- `g05_sentence.json`: `instances[].config.items[]` = `{sentence, tokens[], audio}` — `tokens[]` là word-split (dấu câu dính vào từ trước, không tách riêng); `audio` là `Unit NN/audio/sentence_pattern.mp3` **dùng chung cho cả unit** (Track "Mẫu câu" nguyên track, không cắt riêng từng câu — xem mục 9).
- `g06_mindmap.json`: `instances[].config.items[]` = `{word_id, pattern, options[{word_id,word,image,audio}], answer_idx, audio}` — `pattern` là câu ví dụ đã khuyết đúng từ đang test (`___`), tính theo từng câu (không phải 1 pattern tĩnh cho cả unit vì có unit đổi cả động từ theo chủ ngữ, vd Unit 5). `options` khi từ đó đã có audio thì tái dùng nguyên từ câu hỏi tương ứng trong `g02_listen_pick.json` (cùng hình + cùng thứ tự xáo trộn); khi từ không có audio (`twelve`, `nineteen`, `sixteen`) thì tự dựng từ các từ còn lại cùng unit, `audio: null` cho lựa chọn đó (không chặn hiển thị hình, chỉ tắt nút loa). `audio` ở cấp item (thêm 2026-07-23, CR-004) là audio "Mẫu câu" dùng chung cả unit, giống `g05_sentence.json`.

Sinh lại config: xem `../03_Assets/data_json/README_data.md`. Script sinh G01-G04 đọc từ `04_image+audio/manifest.csv`; G05/G06 đọc trực tiếp từ `02_Phan_tich/…xlsx` sheet `02_Giáo trình chi tiết` cột F + tái dùng `g02_listen_pick.json`/`vocabulary.json` (không có manifest riêng, xem lịch sử `SPRINT2_PLAN.md` Phase 2 nếu cần sinh lại). Sau khi sinh, **copy** vào `assets/data/` và `assets/data/games/`.

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
  trộn xong. Áp dụng cho G09 memory, G13 Boss Quiz khi tới lượt.
- **Game "lắp ráp rồi kiểm tra" (không chấm ngay khi chọn)** — mẫu G04/G05 (G04 đổi từ mẫu chấm-ngay
  sang mẫu này ngày 2026-07-23 theo CR-011, cùng lúc với G05 ở CR-008; xem `BUGS_CR.md`): chạm để
  đặt vào ô trống kế tiếp, chạm ô đã đặt để bỏ ra chọn lại (không chấm đúng/sai lúc này); nút
  "Kiểm tra" chấm toàn bộ 1 lần (đúng thì `AnswerFeedbackOverlay.correct` + mở "Tiếp theo", sai thì
  `.wrong` **nhưng giữ nguyên cách xếp**, không tự xóa/xáo — để trẻ tự sửa); nút "Làm lại" (bên trái
  "Kiểm tra") reset về trạng thái ban đầu + xáo lại khay chọn. Không dùng cơ chế "xáo trộn khi chọn
  sai" của mẫu chấm-ngay ở trên. Áp dụng cho G10 săn chữ nếu hợp mô hình lắp-ráp khi tới lượt.
- **Nút nền sáng màu (vd `AppColors.warning` vàng, `AppColors.error` đỏ nhạt) phải dùng chữ tối**:
  `PrimaryButton` có tham số `foregroundColor` (mặc định `Colors.white`, hợp nền primary/secondary/
  info/success hiện có) — truyền `AppColors.textPrimary` khi nền sáng màu để đủ tương phản cho trẻ
  đọc (xem CR-009 `BUGS_CR.md`, đã áp dụng cho G05/G06 kể cả nút trên màn Unit qua
  `GameDef.foregroundColor`).
- **Độ khó (F15, `SettingsService.instance.isEasy`, xem CR-015 `BUGS_CR.md`)**: game chọn-đáp-án
  (G02/G03/G06) làm mờ + vô hiệu 1 lựa chọn SAI khi Dễ; game lắp-ráp (G04/G05) tự điền sẵn ô/token
  đầu tiên khi Dễ (kể cả sau khi bấm "Làm lại"). Khó = hành vi gốc, không gợi ý thêm. Game mới sau
  này (G09+) nên theo đúng 1 trong 2 mẫu này thay vì nghĩ ra cơ chế gợi ý riêng.
- **Hết màu vai trò cho game mới**: 6 màu bảng sheet 09 (primary/secondary/success/warning/error/
  info) đã dùng hết cho G01-G06; G08 dùng lại `info` nhưng tông đậm hơn — `AppColors.infoDark`
  (CR-018, vì chữ trắng trên `info` gốc khó đọc) — game G09+ sẽ phải lặp lại 1 trong 6 màu này,
  phân biệt bằng icon/nhãn/sắc độ chứ không hardcode hex mới.

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
  G05/G06/G08 vẫn cho sao nhưng không chặn tiến độ (xem `progress_repository.dart`).

**Sprint 3 (P2):** G09 memory, G10 săn chữ, G11 truyện, G13 Boss Quiz + huy hiệu.

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
