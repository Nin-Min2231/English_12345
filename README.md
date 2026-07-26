# lop2_english_app — Flutter app (Sprint 1+2+3 xong, G07/G11 pending)

App Android offline-first luyện tiếng Anh lớp 2 (Global Success): 16 unit, 56 từ vựng, 12 loại game
(G01–G12, thiếu G07 karaoke + G11 truyện vì chưa có nội dung nguồn — xem CLAUDE.md §8/§9).

Chọn/tạo hồ sơ trẻ → chọn unit trên bản đồ (sao + khóa mở dần) → các game mở tuần tự trong unit:
Flashcard (G01), Nghe chọn hình (G02), Điền chữ (G03), Xếp chữ (G04), Lắp ráp câu (G05), Hoàn thành
câu (G06), Ghi âm (G08), Săn chữ (G10) — cộng "Lật thẻ" (G09) và "Boss Quiz" (G12, kèm huy hiệu) xuất
hiện theo checkpoint (sau Unit 2/6/10/14 và 4/8/12/16). Cài đặt (âm thanh, độ khó) + cổng phụ huynh
(F15). Offline hoàn toàn — nạp JSON config trong `assets/data`, lưu tiến độ/hồ sơ/huy hiệu bằng
Drift/SQLite.

## Cách chạy

`android/` đã được sinh sẵn — không cần `flutter create` lại. Trong thư mục này:

```powershell
# 0) Nạp Flutter/JDK/Android SDK cho session (xem CLAUDE.md §3.1 nếu toolchain ở vị trí khác)
. .\activate_env.ps1

# 1) Tải package
flutter pub get

# 2) Chạy trên máy ảo/điện thoại đã cắm
flutter run

# 3) (tuỳ chọn) đóng gói APK — build --release vẫn dùng debug keystore, chưa dùng để phát hành
flutter build apk --debug
```

Mở app → tạo hồ sơ (tên + avatar) → chọn unit đã mở → chọn 1 game.

## Cấu trúc (feature-first, theo sheet 06)

```
lib/
  main.dart, app.dart          # khởi động, mở AppDatabase + SettingsService, home = ProfileSelectScreen
  core/theme/                  # màu, spacing (design tokens sheet 09)
  core/widgets/                # AppScaffold, PrimaryButton, SecondaryButton, StarBar, WordImage,
                                # AnswerFeedbackOverlay (hiệu ứng đúng/sai)
  core/widgets/parent_gate.dart # F15 — cổng phụ huynh (phép tính) trước khu vực nhạy cảm
  data/models/                 # model parse JSON (content tĩnh)
  data/content_repository.dart # nạp JSON từ assets
  data/db/app_database.dart    # Drift: Profiles, LessonProgressTable, EarnedBadges (schemaVersion 2)
  data/repositories/           # profile_, progress_ (khóa/mở, sao), badge_ (huy hiệu)
  services/audio_service.dart  # just_audio, an toàn khi thiếu file
  services/settings_service.dart # F15 — âm thanh on/off, độ khó Dễ/Khó
  features/
    profile/                   # F02 chọn/tạo hồ sơ trẻ (chạm giữ để sửa/xóa)
    home/                       # F01 bản đồ unit — sao + khóa
    settings/                  # F15 cài đặt + xóa hồ sơ
    badges/                    # F13/G12 xem lại huy hiệu đã/chưa đạt
    unit/                      # F03 danh sách game/unit; checkpoints.dart gắn Lật thẻ/Boss Quiz
    flashcard/                 # F06 / G01
    games/listen_pick/         # F07 / G02
    games/fill_letter/         # F08 / G03 — điền riêng từng chữ cái
    games/scramble/            # F08 / G04
    games/sentence_build/      # F10 / G05
    games/mindmap/             # F10 / G06
    games/record/              # F09 / G08 — ghi âm, nhận diện giọng nói tự chấm điểm
    games/memory_match/        # F11 / G09 "Lật thẻ" — checkpoint sau Unit 2/6/10/14
    games/letter_hunt/         # F11 / G10 — nghe & chọn đúng từ vựng
    games/boss_quiz/           # F13 / G12 — checkpoint sau Unit 4/8/12/16, kèm huy hiệu
assets/
  data/                        # units, vocabulary, games/*.json (content tĩnh, không đổi)
  content/                     # 56 ảnh + 49 audio (mirror 04_image+audio)
  sfx/                         # correct/wrong.mp3, score_low/mid/high.mp3 (G08)
```

## Khác biệt so với kiến trúc đích (còn lại — xem CLAUDE.md §7 cho lý do)

| Tài liệu (đích) | Hiện tại | Ghi chú |
|-----------------|----------|---------|
| Drift / SQLite | ✅ Đã dùng cho hồ sơ + tiến độ + huy hiệu | Content tĩnh vẫn đọc JSON, không cần đổi |
| Riverpod | StatefulWidget + repo qua constructor + StreamBuilder | Có chủ ý chưa chuyển |
| go_router | Navigator lồng | Đủ cho các lớp màn hiện tại |
| Kéo-thả (G03/G04) | Chạm-để-điền | Ổn định; nâng cấp drag sau |
| Font Baloo 2 / Nunito | Font hệ thống, đúng cỡ/độ đậm | Chưa bundle file .ttf |

## Lưu ý dữ liệu

7 từ mở rộng chưa có audio (`twelve, sixteen–twenty, near`) chỉ xuất hiện ở Flashcard (thẻ không
tiếng); có thể dùng làm nhiễu chữ (G10) nhưng không thể là target audio ở bất kỳ game nào. Sau khi
bổ sung audio, chạy lại script sinh JSON rồi copy vào `assets/` (xem `03_Assets/data_json/README_data.md`).

G07 (karaoke) và G11 (truyện tương tác) chưa code được — thiếu nội dung nguồn thật (timing lyrics /
lời thoại+ảnh trang truyện), không phải thiếu công sức code. Xem `CLAUDE.md` §8/§9 và `HANDOVER.md`
"Việc cần con người" để biết chính xác cần gì trước khi làm tiếp.

Nhật ký đầy đủ mọi thay đổi/bug/CR: `BUGS_CR.md` (cùng thư mục). Bàn giao phiên làm việc: `../HANDOVER.md`.
