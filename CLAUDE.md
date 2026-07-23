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

Cập nhật 2026-07-23 — **Sprint 1 (P0) đã xong**, đã build thật và cài lên điện thoại test:
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
  main.dart, app.dart          # khởi động, mở AppDatabase, theme, home = ProfileSelectScreen
  core/theme/app_theme.dart    # AppColors, AppSpacing (design tokens sheet 09)
  core/widgets/common_widgets.dart  # PrimaryButton, SecondaryButton, StarBar, WordImage,
                                     # AppScaffold, AnswerFeedbackOverlay (đúng/sai)
  data/models/models.dart      # UnitInfo, FlashCard, ListenQuestion, FillItem (content JSON)
  data/content_repository.dart # nạp JSON -> map theo unit_id
  data/db/app_database.dart    # Drift: bảng Profiles, LessonProgressTable (+ .g.dart sinh ra)
  data/repositories/
    profile_repository.dart    # watchProfiles(), create()
    progress_repository.dart   # watchForProfile(), reportResult(), isUnitUnlocked, isGameUnlocked
  services/audio_service.dart  # just_audio, singleton, an toàn khi thiếu file
  features/
    profile/profile_select_screen.dart   # F02 — chọn/tạo hồ sơ, màn hình đầu app
    home/  unit/  flashcard/
    games/listen_pick/  games/fill_letter/
assets/
  data/{units,vocabulary}.json + data/games/g0{1,2,3}_*.json
  content/UnitNN/{image,audio}/...   # mirror của 04_image+audio
  sfx/correct.mp3, wrong.mp3          # âm hiệu ứng đúng/sai (đã có 2026-07-23)
```

DB tiến độ/hồ sơ (SQLite qua Drift) nằm trong app documents dir của máy/điện thoại, **không** trong
`assets/` — mỗi hồ sơ trẻ là 1 dòng độc lập, xóa app = mất tiến độ (chưa có export/backup, sẽ cần
nếu làm F15 cài đặt).

Đường dẫn asset trong JSON là **tương đối** (vd `Unit01/image/pasta.png`); prefix bundle = `assets/content/` (hằng `ContentRepository.assetBase`).

**Quan trọng — đồng bộ ảnh/audio (xem CR-001 trong `BUGS_CR.md`)**: `assets/content/` là bản
**copy thủ công** của `../04_image+audio/`, KHÔNG tự động đồng bộ. Sửa/thay ảnh hoặc audio gốc ở
`04_image+audio/` xong **PHẢI copy lại đè vào `assets/content/UnitNN/...` tương ứng rồi build lại**
— nếu không, app vẫn chạy bản cũ dù nguồn đã đổi.

## 5. Định dạng JSON config (quan trọng khi thêm game)

- `g01_flashcard.json`: `instances[].config.cards[]` = `{word_id, word, ipa, meaning_vi, image, audio}`.
- `g02_listen_pick.json`: `instances[].config.questions[]` = `{word_id, prompt_audio, options[{word_id,image}], answer_idx}`.
- `g03_fill_letter.json`: `instances[].config.items[]` = `{word_id, word, image, audio, hidden_idx[], answer, distractors[]}` (digraph `sh`/`er` = 2 index liền nhau, answer 2 ký tự).

Sinh lại config: xem `../03_Assets/data_json/README_data.md`. Script sinh đọc từ `04_image+audio/manifest.csv`. Sau khi sinh, **copy** vào `assets/data/` và `assets/data/games/`.

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
- **Game có chọn đáp án đúng/sai** (theo mẫu G02/G03, xem CR-002 trong `BUGS_CR.md`): dùng
  `AnswerFeedbackOverlay` (message + hiệu ứng đúng/sai) + `AudioService.playSfx()` thay vì tự viết
  lại; nút "Quay lại"/"Tiếp theo" (`SecondaryButton` + `PrimaryButton`) thay cho auto-advance theo
  giờ; chọn sai thì xáo trộn lại lựa chọn; tính sao bằng tập hợp index đã đúng (không đếm dồn, để
  xem lại không bị tính 2 lần). Áp dụng cho G09 memory, G10 săn chữ, G13 Boss Quiz khi tới lượt.

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

**Sprint 2 (P1) — ưu tiên tiếp theo:** F05 nghe chant/song + G07 karaoke (cần timing lyrics —
CHƯA có), F08 xếp chữ G04, F09 ghi âm G08 (package `record`), F10 lắp câu/mindmap G05/G06 (cần
bảng `sentences` — CHƯA có), F15 cài đặt + cổng phụ huynh.

**Sprint 3 (P2):** G09 memory, G10 săn chữ, G11 truyện, G13 Boss Quiz + huy hiệu.

**Nợ kỹ thuật nhỏ chưa xử lý:** chưa có test tự động (`test/` đang trống); `flutter build apk
--release` chưa có signing config riêng (build --release vẫn dùng debug keystore mặc định, KHÔNG
dùng để phát hành Play Store); chưa có màn hình sửa/xóa hồ sơ trẻ (F02 mới có tạo + chọn).

## 9. Khoảng trống dữ liệu (cần con người xử lý — sheet 12/13)

- 7 từ mở rộng chưa có audio: `twelve, sixteen, seventeen, eighteen, nineteen, twenty, near`. Đang loại khỏi G02/G03; có audio thì sinh lại config.
- Chưa có: timing lyrics (chant/song), transcript track nghe-tick, dữ liệu câu mẫu (`sentences`) cho G05/G06.
- 4 file audio lỗi tên `.mp3 TA2.mp3` (Track 3–6) + Track 1 thiếu — xử lý trước khi đóng gói.
- Bản quyền asset SGK: chỉ dùng nội bộ; muốn phát hành phải tự sản xuất lại hoặc xin phép.
- ~~2 file âm thanh hiệu ứng đúng/sai~~ — **đã có** (2026-07-23): `assets/sfx/correct.mp3` +
  `wrong.mp3` (nhận từ `05_App/03_Assets/sfx/`, xem CR-002 `BUGS_CR.md` — file `wrong.mp3` được suy
  đoán từ file `answer.mp3` người dùng gửi, CHƯA xác nhận đúng ý).

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
