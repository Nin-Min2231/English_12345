# BUGS & CR — lop2_english_app

Nhật ký lỗi (Bug) và yêu cầu thay đổi (CR) phát hiện sau khi test/kiểm tra thật. **Đọc trước khi
sửa code/asset liên quan** để tránh xử lý sai, xử lý trùng, hoặc bỏ sót.

**Quy ước trạng thái**: `Mở` (chưa xử lý) → `Đang sửa` → `Đã sửa` → `Đã xác nhận` (người dùng test
lại và xác nhận xong). Claude Code **không tự đổi sang "Đã xác nhận"** — chỉ người dùng xác nhận.
Khi xử lý xong một mục: cập nhật Trạng thái + điền "Cách xử lý" bên dưới mục đó, **không xóa mục**
(giữ lại lịch sử).

## Danh sách

| ID | Loại | Mô tả ngắn | Ưu tiên | Trạng thái | Ngày ghi nhận |
|--------|------|------------|---------|------------|---------------|
| BUG-001 | Bug | Flashcard (G01) & Điền chữ (G03): nút bị che bởi thanh điều hướng điện thoại | Cao | Đã xác nhận | 2026-07-23 |
| CR-001 | CR | 56 ảnh trong app (`assets/content/`) chưa cập nhật theo bản đã chỉnh (bỏ text) trong `04_image+audio/` | Cao | Đã xác nhận | 2026-07-23 |
| CR-002 | CR | G02/G03: hiệu ứng phản hồi đúng/sai + âm thanh + Back/Next + xáo trộn khi sai | Trung bình | Đã sửa (chưa xác nhận) | 2026-07-23 |

---

## BUG-001 — Flashcard & Điền chữ: nút bị che bởi thanh điều hướng hệ thống

- **Màn hình ảnh hưởng**: Flashcard (G01), Điền chữ (G03).
- **File liên quan**: `lib/features/flashcard/flashcard_screen.dart`, `lib/features/games/fill_letter/fill_letter_screen.dart`.
- **Mô tả (theo người dùng)**: Trên điện thoại thật, layout vỡ — nút bấm bị che bởi các phím back/home
  (thanh điều hướng hệ thống).
- **Ảnh chụp minh họa**: tìm thấy 2 file trong `05_App/06_Test_QA/` — máy test dùng **thanh điều
  hướng 3 nút** (không phải gesture nav). Flashcard: nút "Nghe lại" bị thanh điều hướng che khuất một
  phần ở đáy màn hình. Điền chữ: nút "Nghe gợi ý" bị che tương tự.
- **Yêu cầu xử lý (theo người dùng)**: Giảm chiều cao màn hình lại.
- **Khảo sát nhanh (chưa sửa)**: Cả 2 file đều dùng `Scaffold` nhưng KHÔNG bọc `SafeArea` quanh
  `body`, cũng không có `resizeToAvoidBottomInset`/xử lý `MediaQuery.viewPadding` — khớp với hiện
  tượng trong ảnh (nội dung/nút vẽ tràn xuống đúng vùng thanh điều hướng hệ thống).
- **Trạng thái**: Đã xác nhận (2026-07-23, người dùng đã test trên điện thoại thật — OK)
- **Cách xử lý (2026-07-23)**: Tạo widget dùng chung `AppScaffold` (`lib/core/widgets/common_widgets.dart`)
  bọc sẵn `Scaffold` + `SafeArea(top: appBar == null)` quanh `body`. **Áp dụng cho cả 6 màn hình**
  (không chỉ 2 màn hình báo lỗi) vì tất cả đều dùng `Scaffold` trần, cùng lỗi tiềm ẩn: Flashcard
  (G01), Điền chữ (G03), Nghe chọn hình (G02), Home (F01), Unit (F03), ProfileSelect (F02). Riêng
  `unit_screen.dart`: bỏ luôn `Container(color:...)` bọc ngoài, chuyển màu unit sang
  `AppScaffold.backgroundColor` cho nhất quán với các màn khác (màu vẫn tràn viền, chỉ nội dung
  được inset). `flutter analyze` sạch, `dart format .` xong, build lại APK debug thành công
  (`05_Build_APK/lop2_english_app-debug-2026-07-23-2.apk`). Đã test trên điện thoại thật — OK.
- **Phòng ngừa tái diễn**: đã thêm quy ước bắt buộc dùng `AppScaffold` thay `Scaffold` vào
  `CLAUDE.md` §6 — màn hình mới tạo sau này tự động có `SafeArea`, không cần nhớ thủ công.

---

## CR-001 — Cập nhật ảnh mới (đã bỏ text) vào bản app đang dùng

- **Bối cảnh (theo người dùng)**: Đã chỉnh lại 56 ảnh trong `04_image+audio/UnitNN/image/*.png` (bỏ
  phần text phía dưới ảnh) và lưu đè lên file gốc (giữ nguyên tên file).
- **Đã kiểm tra (2026-07-23)**: So sánh byte-for-byte toàn bộ 56 ảnh giữa `04_image+audio/` (nguồn)
  và `assets/content/` (bản app đang bundle để build) → **100% (56/56) khác nhau**; bản trong
  `assets/content/` nhỏ hơn đáng kể (vd. `pasta.png` nguồn 47.6KB vs app 23.4KB) → **app hiện đang
  dùng bản ảnh cũ**, chưa có bản đã bỏ text.
- **Kết luận**: CÓ, cần cập nhật. Ảnh không tự đồng bộ — `assets/content/` là bản copy thủ công của
  `04_image+audio/` (xem `CLAUDE.md` §4 và `03_Assets/data_json/README_data.md`), sửa ở thư mục
  nguồn không tự phản ánh vào app; phải copy lại + build lại APK.
- **Yêu cầu xử lý**: Copy đè 56 ảnh từ `04_image+audio/UnitNN/image/` vào
  `assets/content/UnitNN/image/` tương ứng (16 unit), sau đó `flutter build apk --debug` lại để lấy
  bản test mới.
- **Trạng thái**: Đã xác nhận (2026-07-23, người dùng đã test trên điện thoại thật — OK)
- **Cách xử lý (2026-07-23)**: Copy đè 56 ảnh từ `04_image+audio/UnitNN/image/` vào
  `assets/content/UnitNN/image/` tương ứng; kiểm tra lại byte-for-byte → 56/56 khớp 100%. (Lưu ý:
  script copy ban đầu vô tình copy luôn `_overview_56tu.png` — ảnh tổng quan không thuộc nội dung
  từng từ — vào `assets/content/`; đã phát hiện và xóa lại vì `pubspec.yaml` có khai báo thư mục
  `assets/content/` trần nên sẽ bị đóng gói nhầm vào APK.) Build lại APK debug thành công
  (`05_Build_APK/lop2_english_app-debug-2026-07-23-2.apk`) — bản APK này gộp chung cả bản vá
  BUG-001. Đã test trên điện thoại thật — OK.
- **Phòng ngừa tái diễn**: đã thêm ghi chú bắt buộc vào `CLAUDE.md` §4 — sửa ảnh/audio gốc trong
  `04_image+audio/` PHẢI copy lại vào `assets/content/` rồi build lại, nội dung KHÔNG tự đồng bộ.

---

## CR-002 — G02/G03: hiệu ứng phản hồi đúng/sai + âm thanh + Back/Next + xáo trộn khi sai

- **Yêu cầu (theo người dùng)**:
  1. Thêm message + hiệu ứng (pháo hoa khi đúng, icon buồn khi sai) + âm thanh khi đúng/sai — sẽ
     dùng chung cho các màn hình tương tự sau này.
  2. Thêm button "Next" và "Back".
  3. Chọn sai thì xáo trộn lại lựa chọn.
- **Áp dụng cho**: Nghe chọn hình (G02) và Điền chữ (G03) — 2 màn hình duy nhất hiện có cơ chế chọn
  đáp án đúng/sai (Flashcard G01 không có khái niệm đúng/sai nên không áp dụng). Người dùng gọi màn
  G02 là "Nghe chọn chữ" — hiểu là "Nghe chọn hình" vì không có màn nào khác khớp mô tả; báo lại nếu
  ý là màn khác.
- **Đã làm (2026-07-23)**:
  - `AnswerFeedbackOverlay` + enum `AnswerFeedback` (mới trong `common_widgets.dart`) — message +
    hiệu ứng bật giữa màn hình: đúng = 🎉 "Chính xác!" + vài ngôi sao/lấp lánh bay ra kiểu pháo hoa
    (tự vẽ bằng widget Flutter có sẵn, không cần thêm package); sai = 😢 "Chưa đúng, thử lại nhé!".
    Dùng chung được cho game khác sau này (G09 memory, G10 săn chữ, ...) — chỉ cần gọi lại widget.
  - `AudioService.playSfx()` (mới) — player audio riêng để không cắt ngang audio từ vựng đang phát
    cùng lúc — gọi `assets/sfx/correct.mp3` / `assets/sfx/wrong.mp3` khi đúng/sai.
  - `SecondaryButton` (mới trong `common_widgets.dart`) cho nút "Quay lại" + `PrimaryButton` có sẵn
    cho "Tiếp theo", đặt ở đáy màn hình. "Quay lại" bấm được trừ câu/từ đầu tiên. "Tiếp theo" chỉ
    bật khi câu/từ hiện tại đã trả lời đúng (ép trả lời trước khi qua bài — báo lại nếu muốn cho
    qua tự do không cần trả lời đúng). **Bỏ auto-advance cũ** (trước tự chuyển câu sau 900ms khi
    đúng) vì giờ trẻ tự bấm "Tiếp theo", có thời gian xem hết hiệu ứng, không bị giục.
  - Chọn sai: xáo trộn lại vị trí lựa chọn (ảnh ở G02, chữ ở G03) ngay sau khi hiệu ứng sai tắt
    (~700ms) — tránh đoán mò theo vị trí đã nhớ.
  - Cách tính sao: đổi từ đếm dồn (`_correct++`) sang tập hợp index đã trả lời đúng
    (`_correctIndices`), để bấm "Quay lại" xem câu đã đúng không bị tính 2 lần — khớp nguyên tắc
    "sao chỉ tăng không giảm" đã áp dụng cho tiến độ (`CLAUDE.md` §10).
- **Âm thanh — đã nhận (2026-07-23)**: bạn đặt 2 file vào `05_App/03_Assets/sfx/`:
  `correct.mp3` (khớp tên) và `answer.mp3`. Vì chỉ cần đúng/sai và `correct.mp3` đã rõ, **tôi suy
  đoán `answer.mp3` là file cho trường hợp SAI** (đặt tên thành `wrong.mp3` khi copy vào app) — file
  gốc bạn đặt ở `03_Assets/sfx/` vẫn giữ nguyên tên, không đổi. **Cần bạn xác nhận đoán này đúng
  không** khi test (nghe thử lúc chọn sai xem có hợp không) — nếu ngược/không đúng ý, báo lại để đổi
  lại chỉ mất 1 phút (không cần đụng code, chỉ đổi tên file).
- **Trạng thái**: Đã sửa (chưa xác nhận) — cần bạn test đủ cả hình ảnh lẫn âm thanh trên điện thoại.
- **Cách xử lý**: Copy `03_Assets/sfx/{correct.mp3→correct.mp3, answer.mp3→wrong.mp3}` vào
  `04_lop2_english_app/assets/sfx/`. Build lại APK debug:
  `05_Build_APK/lop2_english_app-debug-2026-07-23-4.apk` (gộp tất cả bản vá từ đầu tới giờ).
