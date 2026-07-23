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
| CR-003 | CR | Chuẩn bị dữ liệu `sentences.json` (mẫu câu) cho G05/G06 từ tài liệu phân tích giáo trình | Trung bình | Đã sửa (chưa xác nhận) — **đã sinh config game thật + build APK** | 2026-07-23 |
| BUG-002 | Bug | G04 & G05: từ/câu thứ 2 trở đi không chọn được đáp án (chạm không phản ứng) | Cao | Đã sửa (chưa xác nhận) | 2026-07-23 |
| BUG-003 | Bug | Chọn sai → xáo trộn → chọn đáp án đúng vẫn báo sai | Cao | Đã sửa (chưa xác nhận) | 2026-07-23 |
| CR-004 | CR | G06: thêm audio nghe câu mẫu (hiện không có audio nào cho câu đang test) | Trung bình | Đã sửa (chưa xác nhận) | 2026-07-23 |
| CR-005 | CR | Nút "Nghe gợi ý"/"Nghe câu mẫu" nên ở đầu màn hình như "Nghe chọn hình" (G02), không phải gần Back/Next | Thấp | Đã sửa (chưa xác nhận) | 2026-07-23 |
| CR-006 | CR | G04 Xếp chữ: layout chữ cái xáo trộn — 2 đáp án nằm trên 1 dòng | Thấp | Đã sửa (chưa xác nhận) | 2026-07-23 |
| CR-007 | CR | G05 Lắp ráp câu: layout token xáo trộn 2 đáp án/dòng + các từ đã chọn nối liền thành 1 câu | Thấp | Đã sửa (chưa xác nhận) | 2026-07-23 |
| CR-008 | CR | G05: đổi mô hình tương tác — bỏ chấm đúng/sai tự động, cho xóa chọn lại, thêm nút "Kiểm tra" + "Làm lại" | Cao | Đã sửa (chưa xác nhận) | 2026-07-23 |
| CR-009 | CR | Chữ trắng trên nền vàng (G05)/đỏ nhạt (G06) khó đọc — đổi sang chữ tối cho đủ tương phản | Trung bình | Đã sửa (chưa xác nhận) | 2026-07-23 |
| CR-010 | CR | G03 Điền chữ: mỗi từ thêm 3 lượt chọn, mỗi lượt 1 vị trí chữ cái khác nhau | Trung bình | Đã sửa (chưa xác nhận) | 2026-07-23 |
| CR-011 | CR | G04: đổi mô hình tương tác giống G05 (bỏ chấm đúng/sai tự động, thêm "Kiểm tra" + "Làm lại") | Cao | Đã sửa (chưa xác nhận) | 2026-07-23 |
| CR-012 | CR | G06: đổi tên nút "Nghe câu" → "Gợi ý", bỏ tự động phát âm thanh khi vào màn hình | Thấp | Đã sửa (chưa xác nhận) | 2026-07-23 |
| CR-013 | CR | Audio nghe cho G05/G06: cắt bỏ đoạn giới thiệu đầu track, chỉ giữ phần câu mẫu thật | Trung bình | Đã sửa (chưa xác nhận) | 2026-07-23 |
| CR-014 | CR | F15 — Cài đặt (âm thanh, độ khó), cổng phụ huynh, sửa/xóa hồ sơ (Sprint 2 Phase 3) | Cao | Đã sửa (chưa xác nhận) | 2026-07-23 |
| CR-015 | CR | Wiring độ khó (Dễ/Khó) vào G02/G03/G04/G05/G06 | Trung bình | Đã sửa (chưa xác nhận) | 2026-07-23 |
| CR-016 | CR | G08 Ghi âm — nghe mẫu, ghi âm, nghe lại, tự chấm sao (Sprint 2 Phase 4) | Cao | Đã sửa (chưa xác nhận) | 2026-07-23 |
| BUG-004 | Bug | Build APK lỗi "Daemon compilation failed" (Kotlin incremental cache) sau khi thêm package `record`/`shared_preferences` | Cao | Đã sửa | 2026-07-23 |
| CR-017 | CR | G05: đổi nút "Nghe câu mẫu"→"Gợi ý" + bỏ tự động phát âm thanh (giống CR-012 của G06) | Thấp | Đã sửa (chưa xác nhận) | 2026-07-23 |
| CR-018 | CR | G08: màu xanh đậm hơn + bỏ tự chấm sao, thay bằng nhận diện giọng nói tự động so khớp đáp án ra %/điểm/âm thanh cảnh báo | Cao | Đã sửa (chưa xác nhận) | 2026-07-23 |
| CR-019 | CR | Sprint 3: thêm G09 Fun Time, G10 Săn chữ, G12 Boss Quiz + huy hiệu (G11 truyện vẫn pending) | Cao | Đã sửa (chưa xác nhận) | 2026-07-23 |

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

---

## CR-003 — Chuẩn bị dữ liệu `sentences.json` (mẫu câu) cho G05/G06

- **Bối cảnh**: `CLAUDE.md` §9 ghi nhận G05 (Lắp ráp câu) và G06 (Mindmap hoàn thành câu) cần bảng
  `sentences` — CHƯA có. Người dùng yêu cầu: chuẩn bị dữ liệu trước, sẽ báo fix sau (ghi log ở đây
  để không mất ngữ cảnh).
- **Nguồn**: `../../02_Phan_tich/TiengAnh2_GiaoTrinh_Game_AppData.xlsx`, sheet `02_Giáo trình chi
  tiết`, cột F (mỗi lesson 3 của 16 unit có sẵn: 1 pattern câu mẫu + 2-4 câu ví dụ cụ thể, theo đúng
  SGK) — dữ liệu này đã có sẵn, không cần nghe audio để tạo.
- **Đã làm (2026-07-23)**: Sinh `03_Assets/data_json/sentences.json` — 16 unit, mỗi unit gồm
  `pattern` + danh sách câu ví dụ (`text`, `tokens[]` để dùng cho G05 kéo-xếp), tự động khớp câu với
  từ vựng của unit đó (`matched_word_id/image/word_audio`) khi câu chứa đúng 1 từ vựng — dùng được
  ngay cho G06 (chạm hình điền từ). Đã cập nhật `README_data.md` mô tả file mới.
- **3 khoảng trống cần xác nhận trước khi generate config game thật** (đã ghi trong
  `sentences.json["known_gaps"]`):
  1. `sentence_audio_path` đang `null` toàn bộ — track gốc (Track "Mẫu câu" mỗi Lesson 3) đọc gộp
     2-3 câu liền một hơi, chưa cắt audio riêng từng câu. Nếu muốn mỗi câu có audio riêng khi trẻ
     chạm nghe, cần cắt audio (không tự làm được, xem mục 9 `CLAUDE.md`).
  2. Một số câu hỏi/trả lời chung (vd "Yes, she is.", "What can you see?") không gắn với 1 từ vựng
     cụ thể nào → `matched_word_id: null`. Dùng được cho G05, nhưng muốn dùng cho G06 (cần hình đại
     diện) thì phải chọn thủ công hình/audio phù hợp.
  3. Unit 16 nguồn Excel chỉ liệt kê 2 câu ví dụ ("blanket"/"tent") dù lời bài hát Track 90 có 3 cặp
     (thêm "table"/"tent" và "teapot"/"table") — thiếu 1 cặp so với các unit khác (thường có 2-4).
- **Trạng thái**: Đã sửa (chưa xác nhận) — chờ người dùng xem `sentences.json` và báo lại điều chỉnh
  (đúng/sai nội dung câu, có cần bổ sung Unit 16, ưu tiên cắt audio riêng từng câu hay không...).
  Chưa generate `games/g05_*.json` / `g06_*.json` từ file này — đợi xác nhận xong mới sinh config
  game thật (xem `README_data.md`).
- **Cập nhật (2026-07-23, phiên Claude Code, SPRINT2_PLAN.md Phase 2)**: Đã sinh config game thật
  `g05_sentence.json` (49 câu) + `g06_mindmap.json` (33 mục) — đọc lại trực tiếp từ
  `02_Phan_tich/…xlsx` sheet `02_Giáo trình chi tiết` cột F (đối chiếu từ nguồn, không chỉ dùng bản
  draft `sentences.json` ở trên) thay vì chờ người dùng xác nhận thêm, vì đây là nội dung SGK có sẵn
  (không phải nội dung tự bịa) và Sprint 2 Phase 2 đã có kế hoạch chi tiết đã duyệt. Đã xử lý xong
  khoảng trống #3 (Unit 16 thiếu 1 cặp câu ví dụ): bổ sung 2 cặp còn lại từ lời bài hát Track 90
  (cùng nguồn SGK). Khoảng trống #1 (audio riêng từng câu) **vẫn giữ nguyên chưa xử lý** — G05 dùng
  audio "Mẫu câu" nguyên track dùng chung cho cả unit (quyết định đã ghi trong `SPRINT2_PLAN.md`
  Phase 2), không phải cắt riêng. Khoảng trống #2 (câu không gắn từ vựng cụ thể) xử lý bằng cách bỏ
  qua các câu đó khi sinh G06 (chỉ dùng cho G05). Đã build APK debug thành công
  (`05_Build_APK/lop2_english_app-debug-2026-07-23-6.apk`), `flutter analyze` sạch — **cần test
  trên điện thoại thật** để chuyển "Đã xác nhận".
- **Ghi chú liên quan (2026-07-23)**: phiên Claude Code song song (xem `SPRINT2_PLAN.md` Phase 2)
  độc lập tìm ra đúng cùng nguồn dữ liệu này và đã quyết định chi tiết hơn cách sinh config thật:
  `g05_sentence.json` dùng chung audio nguyên `Track N.mp3` (từ `01_Document/AUDIO/`) làm cue nghe
  mỗi unit (giải quyết gap "audio null" ở trên), `g06_mindmap.json` lấy `options[]` trực tiếp từ
  `vocabulary.json` (không cần match từ trong câu như `sentences.json` đang làm). `sentences.json`
  ở đây dùng để đối chiếu nhanh (đặc biệt là gap Unit 16 + danh sách câu không gắn từ vựng cụ thể);
  file config game thật nên sinh theo `SPRINT2_PLAN.md` Phase 2, không phải trực tiếp từ
  `sentences.json`.

---

## BUG-002 — G04 & G05: không chọn được đáp án từ mục thứ 2 trở đi

- **Màn hình ảnh hưởng**: Xếp chữ (G04) `scramble_screen.dart`, Lắp ráp câu (G05)
  `sentence_build_screen.dart`.
- **Mô tả (theo người dùng)**: Từ điện thoại thật — sau khi hoàn thành từ/câu đầu tiên và bấm
  "Tiếp theo", các ô chữ/token ở từ/câu thứ 2 trở đi chạm vào không có phản ứng gì.
- **Nguyên nhân (xác nhận qua đọc code, so sánh với `fill_letter_screen.dart` G03 vốn không bị lỗi
  này)**: `_goTo(newIndex)` chỉ có nhánh `if (_correctIndices.contains(newIndex)) { ...; _filled =
  true; }` mà **không có `else` đưa `_filled` về `false`**. G03/G02 làm đúng bằng cách gán lại
  **không điều kiện** mỗi lần chuyển mục: `_filled = _correctIndices.contains(newIndex);` (luôn ra
  đúng `true`/`false` tùy trường hợp). Vì G04/G05 chỉ gán `true` trong nhánh `if`, sau khi hoàn
  thành mục 1 (`_filled=true`), chuyển sang mục 2 (chưa từng hoàn thành, `_correctIndices` không
  chứa) thì nhánh `if` không chạy → `_filled` **giữ nguyên `true` từ mục trước** → hàm `_pick` có
  `if (_filled || ...) return;` nên mọi lượt chạm bị chặn ngay từ đầu, im lặng không phản hồi gì.
  Bug này vốn đã có sẵn trong `scramble_screen.dart` (G04, code từ Sprint 2 Phase 1, **chưa từng
  test điện thoại thật trước đợt này**) — `sentence_build_screen.dart` (G05) copy nguyên mẫu G04
  nên bị lỗi giống hệt.
- **Trạng thái**: Đã sửa (chưa xác nhận).
- **Cách xử lý (2026-07-23)**: Đổi `_goTo` ở cả 2 file sang gán lại không điều kiện
  `_filled = _correctIndices.contains(newIndex);` (khớp đúng mẫu G02/G03), giữ nguyên phần khôi
  phục `_placed`/`_nextSlot` khi quay lại mục đã hoàn thành.
- **Phòng ngừa tái diễn**: khi tạo game mới theo mẫu G04 (multi-slot, tap-in-order), dùng gán lại
  không điều kiện cho biến "đã hoàn thành mục" trong `_goTo`, không dùng `if` một chiều.
- **Build**: `flutter analyze` sạch, build APK debug:
  `05_Build_APK/lop2_english_app-debug-2026-07-23-7.apk`.

---

## BUG-003 — Chọn sai → xáo trộn → chọn đáp án đúng vẫn báo sai

- **Màn hình ảnh hưởng**: mọi game có cơ chế "chọn sai thì xáo trộn lại" (G02, G03, G04, G05, G06).
- **Mô tả (theo người dùng)**: Sau khi chọn sai, hệ thống xáo trộn lại vị trí lựa chọn (đúng thiết
  kế CR-002). Nhưng sau đó chọn đáp án đúng (ở vị trí mới) vẫn báo sai.
- **Khảo sát**: Trong khoảng 700ms giữa lúc chọn sai và lúc xáo trộn thực sự chạy (hẹn giờ bằng
  `Future.delayed`), hàm `_pick` **không có chốt chặn nào** ngoài "đã trả lời đúng chưa" — nghĩa là
  trẻ có thể chạm tiếp trong lúc hiệu ứng "sai" (😢) còn đang hiện, trước khi vị trí thật sự được
  xáo. Nếu chạm nhiều lần liên tiếp trong cửa sổ này (dễ xảy ra với trẻ nhỏ thao tác nhanh/hấp
  tấp), các lượt chạm chồng lên nhau có thể tạo cảm giác "chọn đúng vẫn báo sai" dù từng lượt tính
  riêng lẻ vẫn đúng logic — vì đáp án chỉ thực sự đổi vị trí SAU khi hiệu ứng sai biến mất, chạm
  trước thời điểm đó vẫn đang nhắm vào layout CŨ dù mắt nhìn tưởng đã xáo. Xử lý triệt để bằng cách
  khóa hẳn thao tác chạm trong lúc hiệu ứng sai đang hiện (tới khi xáo trộn xong), không chỉ dựa
  vào thời gian ước lượng bằng mắt.
- **Trạng thái**: Đã sửa (chưa xác nhận).
- **Cách xử lý (2026-07-23)**: Thêm điều kiện `_feedback == AnswerFeedback.wrong` vào chốt chặn đầu
  hàm `_pick` ở cả 5 màn hình (`listen_pick_screen.dart`, `fill_letter_screen.dart`,
  `scramble_screen.dart`, `sentence_build_screen.dart`, `mindmap_screen.dart`) — trong lúc hiệu ứng
  sai còn hiện (~700ms), mọi lượt chạm bị bỏ qua hoàn toàn cho tới khi xáo trộn xong và hiệu ứng
  tắt, đảm bảo trẻ luôn chạm đúng layout đã xáo, không còn cửa sổ chồng lượt chạm.
- **Phòng ngừa tái diễn**: quy ước "chọn sai thì xáo trộn" (CR-002, `CLAUDE.md` §6) từ nay bắt buộc
  đi kèm chốt chặn `_feedback == AnswerFeedback.wrong` trong guard đầu `_pick`/hàm xử lý chạm.
- **Build**: `flutter analyze` sạch, build APK debug:
  `05_Build_APK/lop2_english_app-debug-2026-07-23-7.apk`.

---

## CR-004 — G06: thêm audio nghe câu mẫu

- **Yêu cầu (theo người dùng)**: G06 hiện không có audio nào để trẻ nghe câu đang test là gì —
  cần thêm.
- **Xử lý (2026-07-23)**: Thêm field `audio` vào `MindmapItem` (giá trị = `UnitNN/audio/
  sentence_pattern.mp3`, cùng audio "Mẫu câu" dùng chung cho G05 — chưa có audio cắt riêng từng
  câu, xem CLAUDE.md §9), sinh lại `g06_mindmap.json`. Thêm nút "Nghe câu" trong
  `mindmap_screen.dart` gọi `AudioService.instance.play(_it.audio)`.
- **Trạng thái**: Đã sửa (chưa xác nhận). Vị trí/kiểu nút sẽ chỉnh lại cùng đợt duyệt layout
  CR-005 (đẩy lên đầu màn hình).
- **Build**: `flutter analyze` sạch, build APK debug:
  `05_Build_APK/lop2_english_app-debug-2026-07-23-7.apk`.

---

## CR-005 — Nút "Nghe gợi ý" nên ở đầu màn hình như G02

- **Yêu cầu (theo người dùng)**: Nút nghe gợi ý (âm thanh) nên đặt ở đầu màn hình, giống cách bố
  trí ở "Nghe chọn hình" (G02) — hiện đang đặt gần cụm nút "Quay lại"/"Tiếp theo" ở đáy màn hình.
- **Phạm vi ảnh hưởng**: Điền chữ (G03), Xếp chữ (G04), Lắp ráp câu (G05) hiện đều đặt nút này ở
  đáy; Mindmap (G06) vừa thêm nút mới ở CR-004 nên đặt theo đúng vị trí mới luôn.
- **Trạng thái**: Đã sửa (chưa xác nhận) — người dùng đã duyệt hình xem trước, xác nhận áp dụng cả
  G03 (không chỉ G04/G05 đã nêu tên).
- **Cách xử lý (2026-07-23)**: Di chuyển `PrimaryButton` "Nghe gợi ý"/"Nghe câu mẫu" lên ngay dưới
  bộ đếm "Từ/Câu X/Y", trước phần nội dung chính — khớp đúng vị trí G02 — ở cả
  `fill_letter_screen.dart`, `scramble_screen.dart`, `sentence_build_screen.dart`. G06 đã đặt đúng
  vị trí này ngay từ lúc code CR-004.
- **Build**: `flutter analyze` sạch, build APK debug:
  `05_Build_APK/lop2_english_app-debug-2026-07-23-8.apk`.

---

## CR-006 — G04 Xếp chữ: layout 2 đáp án nằm trên 1 dòng

- **Yêu cầu (theo người dùng)**: Chỉnh layout chữ cái xáo trộn — 2 đáp án nằm trên 1 dòng.
- **Cách hiểu đã xác nhận qua hình xem trước**: xếp cố định 2 ô/dòng dạng lưới (thay vì tự động
  xuống dòng theo `Wrap`, có thể tạo dòng cuối lẻ 1 ô nhìn lệch).
- **Trạng thái**: Đã sửa (chưa xác nhận).
- **Cách xử lý (2026-07-23)**: Đổi khay chữ cái xáo trộn từ `Wrap` sang
  `GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: NeverScrollableScrollPhysics())`
  trong `scramble_screen.dart` — luôn đúng 2 ô/dòng bất kể từ dài/ngắn.
- **Build**: `flutter analyze` sạch, build APK debug:
  `05_Build_APK/lop2_english_app-debug-2026-07-23-8.apk`.

---

## CR-007 — G05 Lắp ráp câu: layout 2 đáp án/dòng + đáp án đã chọn nối thành câu

- **Yêu cầu (theo người dùng)**: (1) Chỉnh layout token xáo trộn — 2 đáp án nằm trên 1 dòng (giống
  CR-006 nhưng cho G05). (2) Các từ đã chọn đúng (khu vực hiển thị câu đang ghép) nên nối liền
  thành 1 câu tự nhiên thay vì từng ô chữ tách biệt như hiện tại (đang dùng cùng kiểu box với G04,
  hợp cho từng chữ cái nhưng không hợp cho cả từ/câu).
- **Trạng thái**: Đã sửa (chưa xác nhận) — người dùng đã duyệt hình xem trước.
- **Cách xử lý (2026-07-23)**: Khay từ xáo trộn đổi sang `GridView.count(crossAxisCount: 2)`. Khu
  vực câu đang ghép đổi từ `Wrap` các `Container` viền riêng sang `Wrap` các `Text` nối liền nhau
  (không viền/nền) — từ đã đặt hiện chữ có gạch chân, ô trống hiện "___" màu xám nhạt, đọc liền
  mạch như câu văn thật, tự xuống dòng khi dài (vd Unit 16 7 token). Làm cùng lúc với CR-008 vì
  cùng 1 file, đổi luôn cách xây khu vực này để hỗ trợ chạm-để-xóa (xem CR-008).
- **Build**: `flutter analyze` sạch, build APK debug:
  `05_Build_APK/lop2_english_app-debug-2026-07-23-8.apk`.

---

## CR-008 — G05: đổi mô hình tương tác (bỏ chấm đúng/sai tự động, thêm Kiểm tra/Làm lại)

- **Yêu cầu (theo người dùng)**:
  1. Không chấm đúng/sai ngay khi chọn từng token (khác hẳn G02/G03/G04/G06 vẫn giữ nguyên).
  2. Sau khi chọn (đặt token vào câu) có thể xóa để chọn lại.
  3. Thêm nút "Kiểm tra" — bấm mới chấm đúng/sai cho cả câu: đúng thì phát sự kiện đúng, sai thì
     báo sự kiện sai.
  4. Thêm nút "Làm lại" bên trái nút "Kiểm tra" — bấm thì reset màn hình về mặc định (chưa đặt
     token nào).
- **Cách xử lý (2026-07-23)**: Viết lại `sentence_build_screen.dart`:
  - Chạm token còn trong khay -> đặt vào ô trống **đầu tiên** (không so đúng/sai gì cả lúc này).
  - Chạm token **đã đặt** trong câu -> bỏ ra lại khay chọn (`_tapSlot`), khớp đúng yêu cầu "xóa để
    chọn lại".
  - Nút "Kiểm tra" (chỉ bật khi đã đặt đủ hết ô trống): so toàn bộ thứ tự đã xếp với đáp án đúng —
    đúng thì `AnswerFeedbackOverlay` + sfx `correct.mp3` + đánh dấu câu đã xong (mở "Tiếp theo");
    sai thì `AnswerFeedbackOverlay` + sfx `wrong.mp3`, **giữ nguyên cách xếp hiện tại** (không tự
    xóa/xáo lại) để trẻ tự sửa bằng cách xóa từng từ hoặc bấm "Làm lại".
  - Nút "Làm lại" (tắt khi câu đã đúng): xóa hết về trạng thái ban đầu + xáo lại khay từ (gọi lại
    logic chuẩn bị câu, cùng cách `_prepare()` đã làm khi mới vào câu).
  - "Tiếp theo" giờ chỉ mở khi đã bấm "Kiểm tra" và đúng (thay vì tự động như trước); quay lại câu
    đã đúng sẽ tự hiển thị lại đúng cách xếp đã đúng (khớp theo giá trị, xử lý đúng cả token trùng
    lặp như "the" xuất hiện 2 lần trong 1 câu).
  - Vì không còn chấm đúng/sai theo từng lượt chọn, cơ chế "xáo trộn khi chọn sai" (CR-002/BUG-003)
    **không còn áp dụng cho G05** — thay bằng nút "Kiểm tra" tường minh. 4 màn hình còn lại (G02,
    G03, G04, G06) vẫn giữ nguyên cơ chế chấm ngay + xáo trộn khi sai.
- **Trạng thái**: Đã sửa (chưa xác nhận).
- **Build**: `flutter analyze` sạch, build APK debug:
  `05_Build_APK/lop2_english_app-debug-2026-07-23-8.apk`.

---

## CR-009 — Chữ trắng trên nền sáng màu (vàng/đỏ nhạt) khó đọc

- **Phát hiện khi rà lại màu sắc theo yêu cầu người dùng** ("xem màu sắc hài hòa phù hợp với trẻ")
  lúc đối ứng CR-005/006/007: `PrimaryButton` (`common_widgets.dart`) **hard-code chữ trắng**
  (`foregroundColor: Colors.white`) bất kể màu nền truyền vào. G05 dùng nền `AppColors.warning`
  (vàng) và G06 dùng `AppColors.error` (đỏ nhạt) cho AppBar + nút chính — chữ/icon trắng trên 2 nền
  sáng màu này tương phản kém, khó đọc với trẻ nhỏ hơn hẳn so với G01-G04 (nền xanh dương/cam/xanh
  biển/xanh lá đều đủ tối để chữ trắng rõ).
- **Cách xử lý (2026-07-23)**: Thêm tham số `foregroundColor` tùy chọn cho `PrimaryButton` (mặc
  định vẫn `Colors.white` — **không đổi giao diện G01-G04 đã xác nhận/đang dùng**), truyền
  `AppColors.textPrimary` (chữ tối) tường minh ở mọi nơi dùng màu `warning`/`error`: AppBar +
  nút trong `sentence_build_screen.dart`, `mindmap_screen.dart`, và thêm field `foregroundColor`
  tương ứng vào `GameDef` (`game_defs.dart`) để nút G05/G06 trên **màn Unit** (danh sách game) cũng
  được sửa đồng bộ, không chỉ bên trong từng game.
- **Trạng thái**: Đã sửa (chưa xác nhận).
- **Phòng ngừa tái diễn**: khi thêm màu nền mới cho game sau này (G07 karaoke, G08 ghi âm, G09+),
  kiểm tra độ tương phản chữ/nền trước khi hardcode trắng — nền sáng màu (vàng, cam nhạt, pastel)
  cần `foregroundColor: AppColors.textPrimary`.
- **Build**: `flutter analyze` sạch, build APK debug:
  `05_Build_APK/lop2_english_app-debug-2026-07-23-8.apk`.

---

## CR-010 — G03 Điền chữ: mỗi từ thêm 3 lượt chọn (3 vị trí chữ khác nhau)

- **Yêu cầu (theo người dùng)**: "Một từ vựng thêm 3 lần chọn. Mỗi lần là chọn 1 chữ cái khác nhau
  trong từ vựng đó." — trước đây mỗi từ chỉ có 1 lượt (luôn ẩn đúng âm phonics của unit).
- **Cách xử lý (2026-07-23)**: Viết script sinh lại `g03_fill_letter.json` (không cần sửa
  `fill_letter_screen.dart`/`FillItem` — màn hình vốn đã đọc `config.items[]` như 1 danh sách lượt
  độc lập, chỉ cần data có nhiều lượt hơn cho cùng 1 từ):
  - **Lượt 1 giữ nguyên y hệt bản gốc** (âm phonics của unit, đúng như đã sinh trước đây).
  - **Lượt 2, 3**: chọn 2 vị trí chữ cái **khác** vị trí phonics đã dùng ở lượt 1 (tính theo "đơn
    vị ô" giống cách G03/G04 tách digraph — nếu unit dùng digraph `sh`/`er`, digraph vẫn tính là 1
    ô, các ô còn lại là từng chữ đơn), lấy theo thứ tự trái sang phải, tối đa 2 ô. Từ chỉ có ≤2 ô
    khả dụng (chỉ gặp "ox" — 2 chữ) thì chỉ sinh được 2 lượt thay vì 3.
  - `distractors` của lượt mới: tái dùng nguyên bộ nhiễu của lượt 1 (không cần thuật toán chọn nhiễu
    mới), có kiểm tra an toàn tráo chữ khác nếu trùng đúng đáp án lượt mới (không xảy ra trong thực
    tế sau khi chạy, đã kiểm tra toàn bộ 146 mục không có xung đột).
  - 49 từ (gốc) → **146 lượt** (49×3 trừ 1 do "ox" chỉ đủ 2 lượt).
  - Đã kiểm tra máy: mọi `hidden_idx` khớp đúng ký tự thật trong từ, không lượt nào có đáp án trùng
    1 trong các đáp án nhiễu.
- **Trạng thái**: Đã sửa (chưa xác nhận).
- **Build**: `flutter analyze` sạch, build APK debug:
  `05_Build_APK/lop2_english_app-debug-2026-07-23-9.apk`.

---

## CR-011 — G04: đổi mô hình tương tác giống G05 (Kiểm tra/Làm lại)

- **Yêu cầu (theo người dùng)**: "(Tương tự màn hình G05)" — áp dụng nguyên văn yêu cầu của CR-008
  cho G04: không chấm đúng/sai khi chọn, cho xóa chữ đã đặt để chọn lại, thêm nút "Kiểm tra" +
  "Làm lại" (bên trái "Kiểm tra").
- **Cách xử lý (2026-07-23)**: Viết lại `scramble_screen.dart` theo đúng cấu trúc đã dùng cho
  `sentence_build_screen.dart` (CR-008) — khay chữ cái xáo trộn (`_tapPoolTile`) đặt vào ô trống kế
  tiếp, ô đã đặt (`_tapSlot`) chạm để bỏ ra; nút "Kiểm tra" so cả từ 1 lần, đúng thì phát lại audio
  từ + hiệu ứng đúng + mở "Tiếp theo", sai thì hiệu ứng sai nhưng giữ nguyên cách xếp; nút "Làm lại"
  reset + xáo lại khay. Giữ nguyên phần ảnh minh họa (`WordImage`) và xử lý digraph (`_tilesFor`)
  — khác G05 ở chỗ khu vực hiển thị vẫn dùng ô chữ viền vuông (không đổi sang "nối liền" như câu
  văn, vì đây là 1 từ đơn, không phải câu) nhưng mỗi ô đã đặt giờ **chạm được để xóa**.
- **Trạng thái**: Đã sửa (chưa xác nhận).
- **Build**: `flutter analyze` sạch, build APK debug:
  `05_Build_APK/lop2_english_app-debug-2026-07-23-9.apk`.

---

## CR-012 — G06: đổi tên nút + bỏ tự động phát âm thanh

- **Yêu cầu (theo người dùng)**: (1) Đổi text nút "Nghe câu" thành "Gợi ý". (2) Vào màn hình mặc
  định không tự phát âm thanh — chỉ phát khi người dùng chạm nút "Gợi ý".
- **Cách xử lý (2026-07-23)**: Đổi label nút trong `mindmap_screen.dart`; xóa lời gọi tự động phát
  (`WidgetsBinding.instance.addPostFrameCallback(... _playPattern)`) trong `initState()` **và**
  trong `_goTo()` (chuyển câu bằng Back/Next trước đây cũng tự phát — bỏ luôn cho nhất quán, khớp
  đúng tinh thần "mặc định im lặng, chỉ phát khi bấm Gợi ý" ở mọi câu, không chỉ câu đầu).
- **Trạng thái**: Đã sửa (chưa xác nhận).
- **Build**: `flutter analyze` sạch, build APK debug:
  `05_Build_APK/lop2_english_app-debug-2026-07-23-9.apk`.

---

## CR-013 — Audio nghe G05/G06: cắt bỏ đoạn giới thiệu đầu track

- **Yêu cầu (theo người dùng)**: File audio "Nghe" cho G05/G06 hiện là nguyên track gốc — cắt bỏ
  đoạn đầu, chỉ giữ phần có nội dung câu dùng trên màn hình (ví dụ Track 5 chỉ cần giữ câu liên
  quan tới unit 1).
- **Khảo sát bằng speech-to-text (2026-07-23)**: Không thể "nghe" trực tiếp để xác định điểm cắt,
  nên dùng `faster-whisper` (cài qua pip, model `small.en`, chạy local/offline) để lấy transcript +
  mốc thời gian thật của cả 16 track. Phát hiện **cả 16 track dùng chung 1 cấu trúc**: mở đầu luôn
  là "Unit N. [Chủ đề]. Page NN. Lesson 3. Activity 6. Listen and repeat." (~11–15 giây đầu), sau đó
  mới là câu mẫu thật. Đã dựng script tự tìm điểm cắt (dựa vào nội dung transcript khớp với các từ
  khóa "Unit/Page/Lesson/Activity/Listen and repeat", không phải đoán mốc thời gian cố định), cắt
  bằng PyAV (không cần cài ffmpeg riêng), xuất lại đúng bitrate 128kbps khớp các file audio từ vựng
  đã có, cắt luôn khoảng lặng cuối file cho gọn. **Tự kiểm chứng bằng cách transcribe lại bản đã
  cắt** — cả 16/16 file đều bắt đầu sạch bằng câu mẫu thật, không còn sót phần giới thiệu, không bị
  cắt hụt.
- **Phát hiện quan trọng — nội dung audio KHÔNG khớp 100% với text đã sinh cho G05 ở một số unit**:
  audio "Mẫu câu" mỗi unit là bản ghi gốc từ SGK, độc lập với danh sách câu ví dụ (cột F) đã dùng để
  sinh `g05_sentence.json` — 2 nguồn không phải lúc nào cũng khớp nhau 100%:
  - Unit 1: audio chỉ đọc **1/3 câu** ("The popcorn is yummy!" — không có pasta/pizza).
  - Unit 3: chỉ **1/3 câu** ("Let's look at the sea!").
  - Unit 4: **2/4 câu** (câu hỏi + "rainbow", không có river/road).
  - Unit 11: **1/3 câu**, transcript ("Bear Driving Cars") có vẻ nhận sai chữ — nội dung thật nhiều
    khả năng là "They're driving cars", nhưng **độ tin cậy nhận dạng thấp hơn các unit khác**.
    **Trạng thái: Pending — người dùng sẽ tự nghe lại và xác nhận sau (2026-07-23), chưa xử lý
    thêm cho tới khi có phản hồi.**
  - Unit 14: **2/3 câu** (brother + "He's nineteen", không có "She's sixteen").
  - Unit 16: chỉ khớp cặp "blanket"/"tent" gốc (2/5 câu — 3 câu còn lại là bổ sung từ lời bài hát
    Track 90 lúc sinh dữ liệu G05, xem CR-003, không có trong track "Mẫu câu" này).
  - Các unit còn lại (2, 5, 6, 7, 8, 9, 10, 12, 13, 15) khớp tốt hoặc đủ toàn bộ câu.
  Vì đây là audio "Nghe" dùng chung cho cả unit (không phải audio riêng từng câu — xem CLAUDE.md
  §9), việc không khớp 100% vẫn chấp nhận được (trẻ vẫn nghe đúng chủ đề/mẫu câu của unit), nhưng
  **cần bạn nghe thử để xác nhận có chấp nhận được không**, đặc biệt Unit 11.
- **Áp dụng**: `sentence_pattern.mp3` trong cả `04_image+audio/UnitNN/audio/` và
  `assets/content/UnitNN/audio/`, dùng chung cho G05 (đã có từ Phase 2) và G06 (CR-004).
- **Trạng thái**: Đã sửa (chưa xác nhận) — cần nghe thử, đặc biệt Unit 11.
- **Build**: `flutter analyze` sạch, build APK debug:
  `05_Build_APK/lop2_english_app-debug-2026-07-23-9.apk`.

---

## CR-014 — F15: Cài đặt (âm thanh, độ khó), cổng phụ huynh, sửa/xóa hồ sơ

- **Yêu cầu**: Hoàn tất Sprint 2 Phase 3 (`SPRINT2_PLAN.md`) — cài đặt âm thanh/độ khó, cổng phụ
  huynh (phép tính) trước khi vào khu vực nhạy cảm, sửa/xóa hồ sơ trẻ.
- **Cách xử lý (2026-07-23)**:
  - `lib/services/settings_service.dart` (mới) — singleton đọc/ghi `SharedPreferences`
    (package mới, xem `pubspec.yaml`), cache trong bộ nhớ lúc `init()` (gọi trong `main.dart`
    trước `runApp`) để đọc đồng bộ ở mọi nơi khác. 2 cài đặt: `soundOn` (bool), `difficulty`
    (`Difficulty.easy`/`.hard`).
  - `AudioService.play()`/`playSfx()` kiểm tra `SettingsService.instance.soundOn` trước khi phát
    — tắt âm thanh là tắt **toàn bộ** (từ vựng + hiệu ứng đúng/sai), không tách riêng "nhạc" vì
    app hiện **chưa có nhạc nền** nào để tắt riêng (chỉ có audio từ vựng/câu + 2 sfx) — cố tình
    không thêm toggle "nhạc" chết (không điều khiển được gì) theo kế hoạch gốc.
  - `lib/core/widgets/parent_gate.dart` (mới) — `showParentGate()`: dialog phép tính cộng/trừ
    1-2 chữ số ngẫu nhiên, sai thì đổi phép tính mới thử lại, không khóa/không giới hạn lượt (1
    gia đình dùng chung máy). Cùng file: `confirmDeleteProfile()` — dialog xác nhận xóa dùng
    chung cho màn Cài đặt và màn Hồ sơ.
  - `lib/data/repositories/profile_repository.dart`: thêm `update()` (sửa tên/avatar) và
    `delete()` — `delete()` là 1 `db.transaction` xóa `LessonProgressTable` rồi `Profiles` theo
    đúng thứ tự, vì DB **chưa bật FK cascade** (xem `app_database.dart`: `schemaVersion=1`,
    không có `beforeOpen`/`PRAGMA foreign_keys`) — không tự làm sẽ để lại dòng tiến độ mồ côi.
  - `lib/features/settings/settings_screen.dart` (mới) — toggle âm thanh, chọn độ khó (2 nút bo
    tròn Dễ/Khó), nút "Xóa hồ sơ" (gate bằng `showParentGate` → `confirmDeleteProfile` →
    `delete()` → điều hướng về `ProfileSelectScreen`, xóa hết back stack). Entry point: icon
    ⚙️ mới trên AppBar `home_screen.dart` (cạnh icon đổi hồ sơ).
  - `lib/features/profile/profile_select_screen.dart`: thêm chạm-giữ (`onLongPress`) trên mỗi
    `_ProfileTile` → `showParentGate` → bottom sheet chọn "Sửa"/"Xóa". Sửa mở dialog tên + chọn
    lại avatar (tái dùng danh sách avatar có sẵn). Đã thêm dòng gợi ý nhỏ dưới lưới hồ sơ để phụ
    huynh biết tính năng này tồn tại (chạm giữ không tự nhiên phát hiện được). Luồng
    `profiles.isEmpty` → bắt buộc màn tạo hồ sơ đã tự đúng sẵn (StreamBuilder phản ứng theo dữ
    liệu), không cần sửa thêm.
- **Trạng thái**: Đã sửa (chưa xác nhận).
- **Build**: `flutter analyze` sạch, build APK debug:
  `05_Build_APK/lop2_english_app-debug-2026-07-23-10.apk`.

---

## CR-015 — Wiring độ khó (Dễ/Khó) vào G02/G03/G04/G05/G06

- **Bối cảnh**: `SPRINT2_PLAN.md` Phase 3 yêu cầu độ khó phải thật sự tác động tới các game hiện
  có ("wire difficulty into G02/G03 hint visibility và G04-G06"), không chỉ là 1 màn cài đặt
  không làm gì.
- **Thiết kế đã chọn (thống nhất, đơn giản, không cần thêm luồng dữ liệu mới)**: Dễ = bớt 1 trở
  ngại; Khó = giữ nguyên hành vi gốc:
  - **G02, G06** (chọn hình): Dễ làm mờ + vô hiệu hóa 1 lựa chọn SAI ngẫu nhiên
    (`_eliminatedDisplayPos`, tính lại mỗi khi thứ tự xáo trộn đổi — kể cả sau khi chọn sai — để
    không bao giờ vô tình loại nhầm đáp án đúng khi vị trí đổi chỗ).
  - **G03** (điền chữ): Dễ làm mờ + vô hiệu hóa 1 đáp án nhiễu (`_eliminatedLetter`, chọn theo
    giá trị chữ nên không cần tính lại khi xáo trộn — khác G02/G06 vì G03 vốn đã chọn theo giá
    trị, không theo vị trí).
  - **G04, G05** (lắp ráp): Dễ tự điền sẵn ô/token đầu tiên (`_prefillFirstTile`/
    `_prefillFirstToken`) mỗi khi chuẩn bị 1 từ/câu mới **và** sau khi bấm "Làm lại" (không chỉ
    lúc vào màn hình lần đầu).
  - Cân nhắc đã bỏ: hiển thị chữ dưới ảnh (G02/G06) — cần thêm 1 luồng dữ liệu word_id→word text
    mới (G02/G06 hiện chỉ có ảnh, không có chữ) trong khi PickOption/MindmapOption con đường
    ngắn nhất (suy chữ từ tên file ảnh) không đúng 100% (vd "yo-yos" → file `yo_yos.png`, gạch nối
    thành gạch dưới) — chọn phương án "bớt 1 lựa chọn nhiễu" thay thế, nhất quán với G03 và không
    rủi ro sai lệch dữ liệu.
- **Trạng thái**: Đã sửa (chưa xác nhận).
- **Build**: `flutter analyze` sạch, build APK debug:
  `05_Build_APK/lop2_english_app-debug-2026-07-23-10.apk`.

---

## CR-016 — G08 Ghi âm (Sprint 2 Phase 4)

- **Yêu cầu**: Hoàn tất Phase 4 `SPRINT2_PLAN.md` — nghe từ mẫu → ghi âm bắt chước → nghe lại →
  tự chấm sao (không chấm điểm tự động).
- **Cách xử lý (2026-07-23)**:
  - Thêm package `record` (7.1.1) + `permission_handler` (12.0.3) vào `pubspec.yaml`; thêm quyền
    `RECORD_AUDIO` vào `AndroidManifest.xml`.
  - `TappableStarBar` (mới, `common_widgets.dart`) — biến thể chạm được của `StarBar`, dùng để
    trẻ tự chọn 1-3 sao.
  - `lib/features/games/record/record_screen.dart` (mới) — dùng lại dữ liệu `flashByUnit` (không
    cần content mới): "Nghe mẫu" (audio từ vựng có sẵn) → "Ghi âm" (nút chuyển đổi ghi/dừng, ghi
    đè cùng 1 file `g08_recording.m4a` trong `getTemporaryDirectory()` mỗi lần, không cần lưu
    lại) → "Nghe lại giọng của bé" (phát bằng `AudioPlayer` cục bộ trong màn hình, khác
    `AudioService` vì đây là đường dẫn file thật, không phải asset bundle) → `TappableStarBar` tự
    chấm, bắt buộc chấm mới bật "Tiếp theo" (khớp quy ước "phải hoàn thành mới qua tiếp" toàn app).
  - Quyền mic: `_recorder.hasPermission()` (tự xin quyền lần đầu qua chính package `record`); nếu
    từ chối thì tra `Permission.microphone.status` (package `permission_handler`) để phân biệt
    `denied` (còn xin lại được, hiện thông báo bấm "Ghi âm" lần nữa) và `permanentlyDenied` (phải
    `openAppSettings()`).
  - Sao tổng của cả game = trung bình các lượt tự chấm (làm tròn, giới hạn 1-3) — vẫn qua
    `reportResult`/`progress_repository.dart` như mọi game khác nên quy tắc "sao chỉ tăng không
    giảm" ở mức DB vẫn được giữ nguyên dù điểm trong 1 phiên chơi có thể lên xuống tự do (trẻ tự
    đánh giá lại, không có lý do phải đơn điệu tăng trong 1 lượt chơi).
  - `GameDef` cho `g08` trong `game_defs.dart` dùng lại màu `AppColors.info` (đã dùng cho G03) vì
    hết cả 6 màu vai trò trong bảng màu sheet 09 — phân biệt bằng icon/nhãn, sẽ lặp lại tình
    huống này với G09+ sau này.
  - `_gameTypes` trong `progress_repository.dart` **đã có sẵn** `g08` từ vòng "shared plumbing"
    đầu Sprint 2 — không cần sửa unlock chain.
- **Trạng thái**: Đã sửa (chưa xác nhận).
- **Build**: `flutter analyze` sạch, build APK debug:
  `05_Build_APK/lop2_english_app-debug-2026-07-23-10.apk`.

---

## BUG-004 — Build APK lỗi "Daemon compilation failed" sau khi thêm package mới

- **Mô tả**: Sau khi thêm `record`/`shared_preferences`/`permission_handler` (CR-014/CR-016),
  `flutter build apk --debug` lỗi `e: Daemon compilation failed` /
  `Could not close incremental caches ... record_android\...\caches-jvm\jvm\kotlin` (và tương tự
  cho `shared_preferences_android`). Lỗi lặp lại y hệt sau khi dừng Gradle daemon
  (`gradlew --stop`) và `flutter clean` + `flutter pub get` — không phải cache tạm bị kẹt một
  lần, mà là lỗi hệ thống của Kotlin incremental compiler (Build Tools API) khi biên dịch module
  Kotlin của 2 package này trên máy Windows này.
- **Cách xử lý (2026-07-23)**: Thêm `kotlin.incremental=false` vào
  `android/gradle.properties` — tắt hẳn tính năng biên dịch tăng dần của Kotlin (chỉ ảnh hưởng
  tốc độ build lại — build sẽ luôn full-recompile thay vì chỉ phần đổi — không ảnh hưởng hành vi
  app). Build lại thành công ngay lần đầu sau khi thêm dòng này.
- **Trạng thái**: Đã sửa.
- **Phòng ngừa tái diễn**: nếu sau này nâng cấp Kotlin/Gradle/AGP và build lại nhanh (không cần
  dòng này nữa), có thể thử xóa `kotlin.incremental=false` để lấy lại tốc độ build tăng dần —
  nhưng chỉ nên thử khi không vội, vì lỗi này khó tái hiện có chủ đích để xác nhận đã hết.

---

## CR-017 — G05: đổi nút "Gợi ý" + bỏ tự động phát âm thanh

- **Yêu cầu (theo người dùng)**: "Làm giống màn hình G06 Hoàn thành câu" — (1) đổi text nút "Nghe
  câu" thành "Gợi ý", (2) vào màn hình mặc định không phát âm thanh, chỉ phát khi bấm nút "Gợi ý".
- **Bối cảnh**: G06 đã có đúng hành vi này từ CR-012 (đổi tên nút + bỏ auto-play) — CR-017 áp dụng
  y hệt cho G05 (`sentence_build_screen.dart`), vốn trước đó vẫn giữ nút "Nghe câu mẫu" + tự phát
  audio khi vào màn hình/chuyển câu (sót lại từ trước CR-012, vì CR-012 khi đó chỉ ghi rõ áp dụng
  cho G06).
- **Cách xử lý (2026-07-23)**: Đổi label nút trong `sentence_build_screen.dart` thành "Gợi ý"; xóa
  lời gọi tự động phát (`WidgetsBinding.instance.addPostFrameCallback(...)` trong `initState()`) và
  xóa lời gọi `_playHint()` cuối hàm `_goTo()` (chuyển câu bằng Back/Next). Giữ nguyên màu nút
  (`AppColors.warning` + `foregroundColor: AppColors.textPrimary`, đã đúng từ CR-009) — chỉ đổi
  hành vi phát âm thanh, không đổi giao diện màu.
- **Trạng thái**: Đã sửa (chưa xác nhận).
- **Build**: `flutter analyze` sạch. Gộp chung APK với CR-018 bên dưới.

---

## CR-018 — G08: màu đậm hơn + nhận diện giọng nói tự động chấm điểm (bỏ tự chấm sao)

- **Yêu cầu (theo người dùng)**:
  1. Đổi tông xanh nhạt hiện tại (chữ trắng khó đọc) sang xanh đậm hơn.
  2. Ghi âm tự nhận diện, nếu dừng nói lâu thì tự lấy kết quả luôn — không cần người dùng bấm nút
     "Dùng" thủ công.
  3. Hiển thị kết quả nhận diện được ra chữ (text).
  4. Bỏ hẳn phần bé tự chấm sao — thay bằng hệ thống tự so sánh bản ghi với đáp án ra % chính xác,
     quy đổi điểm (100% = 100 điểm), 3 mốc âm thanh cảnh báo khác nhau: <=50 điểm / 51-80 / 81-100.
  5. Giữ nguyên phần còn lại (nghe mẫu, luồng Quay lại/Tiếp theo...).
- **Màu sắc (2026-07-23)**: Thêm hằng số `AppColors.infoDark` (`0xFF0277BD`, `app_theme.dart`) —
  **không đổi `AppColors.info` gốc** vì G03 (`fill_letter_screen.dart`) đang dùng chung màu đó, chỉ
  đổi `record_screen.dart` (AppBar + 3 nút) và tile G08 trên màn Unit (`game_defs.dart`) sang
  `infoDark`.
- **Quyết định kiến trúc nhận diện giọng nói — đã trao đổi trực tiếp với người dùng trước khi code**
  (xem thêm trong lịch sử phiên chat, không lặp lại toàn bộ ở đây): yêu cầu vừa tự nhận diện lúc
  đang ghi (cho phần "tự dừng khi im lặng") vừa giữ file ghi âm thô để phát lại tạo ra mâu thuẫn kỹ
  thuật thật — gói `speech_to_text` (ổn định, phổ biến, dùng API `SpeechRecognizer` có sẵn của
  Android) không lộ file âm thanh thô ra ngoài nên **không thể vừa nhận diện vừa giữ được "Nghe lại
  giọng của bé"**; gói thay thế (`stt_record`) làm được cả 2 nhưng mới ra mắt 2 tháng (bản 0.0.8),
  cần thêm quyền thông báo + chạy như foreground service (đổi UX, hiện thông báo hệ thống lúc ghi
  âm), rủi ro lỗi build cao hơn hẳn cho máy này (từng bị BUG-004 chỉ vì 2 package ghi âm/quyền phổ
  biến hơn). **Người dùng đã chọn `speech_to_text`, chấp nhận bỏ "Nghe lại giọng của bé"** để đổi
  lấy gói ổn định, rủi ro build thấp. Lưu ý đã báo trước và người dùng xác nhận hiểu: nhận diện
  giọng nói của Android **không đảm bảo 100% chạy được khi không có mạng** — tùy điện thoại có sẵn
  gói nhận diện offline hay không, máy không có sẽ tự động cần Internet để gửi âm thanh lên máy chủ
  Google xử lý (đã thêm quyền `INTERNET` vào `AndroidManifest.xml`).
- **Cách xử lý (2026-07-23)**:
  - `pubspec.yaml`: bỏ `record` (không còn dùng ở đâu khác trong code), thêm `speech_to_text:
    ^7.4.0`. Giữ nguyên `permission_handler` (vẫn dùng để phân biệt quyền mic bị từ chối tạm thời
    hay vĩnh viễn, và mở Cài đặt máy — xem `record_screen.dart`).
  - `AndroidManifest.xml`: thêm quyền `INTERNET`, `BLUETOOTH`/`BLUETOOTH_ADMIN` (maxSdk 30),
    `BLUETOOTH_CONNECT` (yêu cầu của `speech_to_text` trên Android) + 1 mục `<queries>` cho
    `android.speech.RecognitionService` (bắt buộc từ Android 11+ để plugin tìm được dịch vụ nhận
    diện giọng nói đã cài trên máy — package visibility).
  - `record_screen.dart` viết lại phần lõi: bỏ `AudioRecorder`/`_playbackPlayer`/file tạm; thêm
    `SpeechToText` — `initialize()` lúc vào màn hình (xin quyền mic qua chính plugin, dùng
    `permission_handler` để phân biệt denied/permanentlyDenied nếu thất bại, giống cách cũ);
    `listen()` với `SpeechListenOptions(partialResults: true, listenFor: 8s, pauseFor: 2s, localeId:
    'en_US')` — **`pauseFor: 2s` chính là cơ chế "tự dừng khi im lặng"** yêu cầu #2 (plugin tự gọi
    `onResult` với `finalResult: true` sau 2 giây không nói tiếp, không cần code tự đo mức âm
    thanh); `onResult` cập nhật `_recognized` (yêu cầu #3, hiển thị trực tiếp trong `build()`).
  - **So khớp % + điểm (yêu cầu #4)**: hàm riêng `_scoreFor()` — khoảng cách Levenshtein giữa chữ
    nhận diện được và từ đáp án (so không phân biệt hoa/thường, bỏ khoảng trắng thừa), quy ra %
    giống nhau = `1 - (khoảng_cách / độ_dài_dài_hơn)`, làm tròn thành điểm 0-100 (100% = 100 điểm
    đúng như yêu cầu). Không dùng độ tin cậy (`confidence`) của bản thân plugin vì đó là độ tin cậy
    *nhận dạng giọng nói*, không phải độ giống *với đáp án* — 2 khái niệm khác nhau, yêu cầu người
    dùng là so với đáp án.
  - **3 mốc âm thanh cảnh báo (yêu cầu #4)**: hàm `_tierFor(score)` dùng chung 1 chỗ cho cả sfx lẫn
    quy đổi sao tổng kết — `<=50` → `score_low.mp3` (1 sao), `51-80` → `score_mid.mp3` (2 sao),
    `81-100` → `score_high.mp3` (3 sao). **3 file sfx này CHƯA CÓ** — tương tự khoảng trống
    `correct.mp3`/`wrong.mp3` ở CR-002: code đã trỏ sẵn đường dẫn `assets/sfx/score_low.mp3`,
    `score_mid.mp3`, `score_high.mp3`, `AudioService.playSfx()` tự bỏ qua an toàn nếu thiếu file
    (không crash) — cần bạn cung cấp 3 file này vào `assets/sfx/` khi có, không cần sửa code.
  - **Bỏ tự chấm sao (yêu cầu #4)**: xóa hẳn `TappableStarBar` khỏi màn hình G08 **và xóa khỏi
    `common_widgets.dart`** (không còn nơi nào dùng). `_showResult()` tính sao tổng kết bằng điểm
    trung bình các từ đã nói qua `_tierFor()` (cùng mốc <=50/51-80/81-100), vẫn qua `reportResult`
    như cũ nên quy tắc "sao chỉ tăng" ở DB không đổi.
  - **Giữ nguyên (yêu cầu #5)**: "Nghe mẫu", luồng Quay lại/Tiếp theo (nay bắt theo "đã nói thử
    chưa" thay vì "đã tự chấm sao chưa"), quy tắc phải hoàn thành mới qua tiếp.
  - **Build**: `flutter clean` (dọn cache cũ của `record` vừa gỡ) → `flutter pub get` →
    `flutter analyze` sạch → `flutter build apk --debug` thành công (có 1 cảnh báo không chặn build
    về Kotlin Gradle Plugin cũ của `speech_to_text`, không phải lỗi — bản ghi lại để biết nếu sau
    này Flutter chặn hẳn thì cần chờ plugin cập nhật). APK debug:
    `05_Build_APK/lop2_english_app-debug-2026-07-23-11.apk` — **chưa test trên điện thoại thật**,
    đặc biệt cần test: mic có thật sự tự dừng sau ~2s im lặng không, độ chính xác nhận diện tiếng
    Anh trẻ em đọc, và máy test có cần bật mạng để nhận diện chạy được không.
- **Trạng thái**: Đã sửa (chưa xác nhận) — cần test thật, xem ghi chú "Build" ở trên.

---

## CR-019 — Sprint 3: G09 Fun Time, G10 Săn chữ, G12 Boss Quiz + huy hiệu

- **Yêu cầu**: "triển khai tiếp Sprint 3" — chưa có kế hoạch chi tiết trước đó (CLAUDE.md chỉ có 1
  dòng tóm tắt), nên đã nghiên cứu lại 2 file Excel gốc trước khi code (giống cách Sprint 2 đã làm),
  lập kế hoạch qua plan mode, người dùng duyệt trước khi bắt đầu — xem `SPRINT3_PLAN.md` (đầy đủ chi
  tiết từng phase) để biết lý do/thiết kế; mục này chỉ tóm tắt kết quả.
- **2 điều chỉnh xác nhận với người dùng trước khi code**:
  1. **"G13" là gõ nhầm** — tài liệu gốc (2 file Excel, 3 chỗ khác nhau) gọi Boss Quiz là **G12**
     (catalog chỉ có đúng G01-G12). Đã đổi theo tài liệu gốc, không dùng "G13" nữa.
  2. **G11 Truyện tương tác (Phil & Sue) — để pending giống G07**: không có lời thoại/ảnh trang
     truyện ở bất kỳ đâu trong 2 file Excel hay `04_image+audio/` — nội dung thật (nếu có) nằm trong
     `01_Document/book.pdf` trang 20/37/54/71, file quá lớn để đọc trong môi trường này. Sprint 3 chỉ
     làm G09+G10+G12.
- **Cách xử lý (2026-07-23)** — chi tiết đầy đủ từng phase ở `SPRINT3_PLAN.md`, tóm tắt nhanh:
  - **Shared plumbing**: `progress_repository.dart`'s `_gameTypes` đổi tên công khai
    `kGameTypeOrder`; `game_defs.dart`'s `kUnitGames` đổi từ danh sách tay sang **suy ra** từ
    `kGameTypeOrder` (map `gameDefsByType`) — trước đây là 2 danh sách độc lập phải tự tay giữ đồng
    bộ, nay thiếu 1 mục sẽ crash rõ ràng lúc khởi động thay vì âm thầm sai (`isGameUnlocked` coi
    gameType không có trong danh sách là "luôn mở"). Thêm `isCheckpointUnlocked` (Fun
    Time/Boss Quiz cần chính unit gắn checkpoint xong 4 game lõi, không phải unit trước — khác
    `isUnitUnlocked`). `checkpoints.dart` (mới) — Fun Time gắn sau Unit 2/6/10/14, Boss Quiz sau Unit
    4/8/12/16, tái dùng nguyên cơ chế `GameDef`/`kUnitGames` (2 field mới: `isUnlockedOverride`,
    `badgeId`), không cần redesign màn Home. `badge_defs.dart` (mới) — 4 huy hiệu, tên/icon placeholder
    (tài liệu gốc ghi "App tự định nghĩa" — chưa có sẵn), dễ đổi sau.
  - **G09 Fun Time (memory match)**: sinh `g09_memory.json` từ `g01_flashcard.json` — **phát hiện khi
    sinh dữ liệu**: `g01_flashcard.json` KHÔNG tự loại 7 từ mở rộng chưa có audio (khác G02/G03) nên
    phải tự lọc `audio != null`, nếu không Fun Time 4 (Unit 13-14) sẽ có 13 cặp gồm cả từ không audio
    thay vì đúng 7 cặp có audio. `memory_match_screen.dart`: lật 2 thẻ (1 hình + 1 chữ) khớp cùng từ;
    **cố ý KHÔNG áp dụng quy ước "chọn sai thì xáo trộn"** (CR-002) — xáo lại vị trí sẽ phá hỏng bản
    chất trò chơi trí nhớ, chỉ đổi mặt úp/ngửa của thẻ. Không có độ khó Dễ (không khớp 2 mẫu độ khó
    hiện có, ghi nhận là khoảng trống đã biết).
  - **G10 Săn chữ**: sinh `g10_letter_hunt.json` — `target_letter` copy thẳng từ `units.json.phonics`
    (không cần tạo mới), `reward_*` lấy từ đầu tiên mỗi unit. **Đơn giản hóa có chủ ý**: làm theo mẫu
    chọn-đáp-án tĩnh (lưới xáo lại, giống G02) thay vì chữ rơi/di chuyển thật như mô tả gốc — tránh
    thêm animation/va chạm vật lý mới chưa có tiền lệ trong app, giữ đúng tinh thần "đơn giản hóa có
    chủ ý" đã áp dụng nhiều nơi (không Riverpod/go_router, chạm thay vì kéo-thả ở G03). Nút "Nghe gợi
    ý" phát audio từ thưởng (âm đầu gần đúng phonics, không phải âm tách biệt — chưa có audio phonics
    riêng). Digraph Unit 14 (`er`)/Unit 15 (`sh`) giữ nguyên chuỗi 2 ký tự trong ô, không tách. **Sao
    tối đa 2** (không phải 3, theo đúng catalog gốc) — thêm `_maxStarsByGameType` vào
    `progress_repository.dart` để `maxStarsPerUnit`/hiển thị "X/Y sao" không bị lệch.
  - **G12 Boss Quiz + huy hiệu**: script sinh `g12_boss_quiz.json` — trộn 10 câu/checkpoint từ dữ
    liệu **đã có sẵn** của G02 (nghe chọn hình, giữ nguyên)/G03 (điền chữ, chỉ lấy 1 lượt/từ dù data
    gốc có 3 lượt — tránh Boss Quiz lặp lại gần giống nhau, chuyển thành trắc nghiệm chữ thay vì điền
    tay)/G05 (lắp câu, chuyển thành trắc nghiệm — câu nhiễu sinh bằng xáo thứ tự token của chính câu
    đúng, đảm bảo sai ngữ pháp mà không cần bịa nội dung mới; câu quá ngắn không đủ cách xáo khác biệt
    thì mượn câu nhiễu từ 1 câu khác cùng nhóm 4 unit). `boss_quiz_screen.dart` gần như bản sao
    `listen_pick_screen.dart`, chỉ khác phần hiển thị "hỏi"/"lựa chọn" phải xem trường nào có giá trị
    (ảnh hay chữ) vì 3 nguồn câu hỏi khác định dạng.
  - **Huy hiệu — migration DB đầu tiên của app**: bảng `EarnedBadges` mới (`app_database.dart`),
    `schemaVersion` 1→2, thêm `MigrationStrategy` (`onCreate` vẫn `createAll()` cho cài mới,
    `onUpgrade` chỉ tạo thêm bảng `EarnedBadges` cho máy đã có DB cũ — **trước đây app chưa từng có
    `migration` override, chỉ dựa vào `onCreate` mặc định**, từ giờ bắt buộc phải có mỗi khi tăng
    version). `ProfileRepository.delete()` cập nhật xóa thêm `EarnedBadges` trong cùng transaction
    (giống lý do CR-014 đã xử lý cho `LessonProgressTable` — `EarnedBadges` cũng tham chiếu
    `Profiles` nhưng DB chưa bật FK cascade). `badge_repository.dart` (mới, cùng phong cách
    `ProgressRepository`). `badges_screen.dart` (mới) — xem lại huy hiệu đã/chưa đạt, entry point
    icon 🏆 trên AppBar Home — nếu không có màn này, huy hiệu chỉ hiện đúng 1 lần lúc vừa đạt rồi mất
    hẳn. Trao huy hiệu tại `UnitScreen._playGame` (đổi tham số đầu từ `String gameType` sang
    `GameDef game` để đọc được `badgeId`) — ngưỡng ≥2 sao (khớp mốc "khá tốt" dùng ở G08 CR-018),
    giữ màn hình game "không biết gì về DB" như quy ước cũ (chỉ `UnitScreen` chạm DB).
  - **3 file sinh mới** (không phải sửa tay): `assets/data/games/g09_memory.json`,
    `g10_letter_hunt.json`, `g12_boss_quiz.json` (đồng thời lưu bản sao ở
    `03_Assets/data_json/games/`, theo đúng quy ước README_data.md).
- **Build**: `flutter analyze` sạch sau từng phase, `dart run build_runner build` (bảng Drift mới),
  `flutter build apk --debug` thành công (1 cảnh báo Kotlin Gradle Plugin không chặn build, giống
  CR-018). APK debug: `05_Build_APK/lop2_english_app-debug-2026-07-23-12.apk`.
- **Trạng thái**: Đã sửa (chưa xác nhận) — **cần test thật đặc biệt cẩn thận vì có migration DB đầu
  tiên**: cài APK này như bản CẬP NHẬT đè lên bản cũ trên điện thoại đang có sẵn hồ sơ/tiến độ thật
  (không gỡ cài đặt lại trước khi cài, sẽ mất hết dữ liệu cũ và không kiểm tra được đường nâng cấp),
  xác nhận hồ sơ/sao cũ vẫn còn sau khi mở app bản mới. Ngoài ra cần test: Fun Time 4 (14 thẻ, nhiều
  hơn bình thường) không bị tràn/cắt hình trên máy thật, ô chữ digraph Unit 14/15 hiển thị ổn, tile
  Fun Time/Boss Quiz thực sự khóa khi unit gắn nó chưa xong 4 game lõi dù unit đã mở được.
