# lop2_english_app — Flutter app (Sprint 1 xong)

Chọn/tạo hồ sơ trẻ → chọn unit trên bản đồ (sao + khóa mở dần) → 3 game P0 mở tuần tự trong unit:
Flashcard (G01), Nghe chọn hình (G02), Điền chữ (G03). Offline hoàn toàn, nạp JSON config trong
`assets/data` + lưu tiến độ/hồ sơ bằng Drift/SQLite.

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

Mở app → tạo hồ sơ (tên + avatar) → chọn unit đã mở → chọn 1 trong 3 game.

## Cấu trúc (feature-first, theo sheet 06)

```
lib/
  main.dart, app.dart          # khởi động, mở AppDatabase, home = ProfileSelectScreen
  core/theme/                  # màu, spacing (design tokens sheet 09)
  core/widgets/                # AppScaffold, PrimaryButton, SecondaryButton, StarBar, WordImage,
                                # AnswerFeedbackOverlay (hiệu ứng đúng/sai)
  data/models/                 # model parse JSON (content tĩnh)
  data/content_repository.dart # nạp JSON từ assets
  data/db/app_database.dart    # Drift: Profiles, LessonProgress
  data/repositories/           # profile_repository, progress_repository (khóa/mở, sao)
  services/audio_service.dart  # just_audio, an toàn khi thiếu file
  features/
    profile/                   # F02 chọn/tạo hồ sơ trẻ
    home/                      # F01 bản đồ unit — sao + khóa
    unit/                      # F03 3 game mở tuần tự trong unit
    flashcard/                 # F06 / G01
    games/listen_pick/         # F07 / G02
    games/fill_letter/         # F08 / G03
assets/
  data/                        # units, vocabulary, games/*.json (content tĩnh, không đổi)
  content/                     # 56 ảnh + 49 audio (mirror 04_image+audio)
  sfx/                         # correct.mp3, wrong.mp3 — âm hiệu ứng đúng/sai (G02, G03)
```

## Khác biệt so với kiến trúc đích (còn lại — xem CLAUDE.md §7 cho lý do)

| Tài liệu (đích) | Hiện tại | Ghi chú |
|-----------------|----------|---------|
| Drift / SQLite | ✅ Đã dùng cho hồ sơ + tiến độ | Content tĩnh vẫn đọc JSON, không cần đổi |
| Riverpod | StatefulWidget + repo qua constructor + StreamBuilder | Có chủ ý chưa chuyển |
| go_router | Navigator lồng | Đủ cho các lớp màn hiện tại |
| Kéo-thả (G03) | Chạm-để-điền | Ổn định; nâng cấp drag sau |
| Font Baloo 2 / Nunito | Font hệ thống, đúng cỡ/độ đậm | Chưa bundle file .ttf |

## Lưu ý dữ liệu

7 từ mở rộng chưa có audio (`twelve, sixteen–twenty, near`) chỉ xuất hiện ở Flashcard (thẻ không tiếng) và làm ảnh nhiễu ở G02; không có trong câu hỏi G02/G03. Sau khi bổ sung audio, chạy lại script sinh JSON rồi copy vào `assets/`.
