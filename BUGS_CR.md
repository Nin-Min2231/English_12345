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
| CR-020 | CR | G03 (1-2 ô theo độ dài từ), G08 (nút đỏ khi nghe + 3s + chờ chấm điểm), G10 (đổi hẳn sang nghe & chọn từ vựng) | Cao | Đã sửa (chưa xác nhận) | 2026-07-26 |
| CR-021 | CR | Rà soát Sprint 3: bổ sung độ khó Dễ (xem trước 4s) còn thiếu cho G09 Fun Time | Thấp | Đã sửa (chưa xác nhận) | 2026-07-26 |
| CR-022 | Bug+CR | G08: sửa màu đỏ CR-020 không hiện thật (bug disabled-color), chặn trần chờ kết quả; G10: khôi phục "săn chữ có thưởng" (F11) | Cao | Đã sửa (chưa xác nhận) | 2026-07-26 |
| CR-023 | CR | G08 (nút Dừng thủ công, bỏ tự tắt 3s), G09 (đổi tên Lật thẻ, lưới to, khóa chặt hơn, sao dễ hơn), G03 (tách đáp án từng chữ cái), G10 (2 đáp án/dòng), G12 (chống tràn chữ) | Cao | Đã sửa (chưa xác nhận) | 2026-07-26 |

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

---

## CR-020 — G03 (1-2 ô theo độ dài từ), G08 (nút đỏ + 3s + chờ chấm điểm), G10 (đổi hẳn cơ chế)

- **Yêu cầu (theo người dùng, 2026-07-26)**: 3 màn hình độc lập, gộp 1 CR vì cùng 1 đợt yêu cầu.

**1. G03 Điền chữ**: "Mỗi lần điền nếu từ vựng dưới 4 chữ cái điền 1 từ. Nếu từ vựng trên 4 chữ cái
điền 2 từ 1 lúc. Chữ cái bị thiếu có thể lộn xộn các vị trí trong từ."
- **Cách hiểu**: từ <4 chữ cái giữ nguyên quy tắc cũ (CR-010, 1 ô/lượt); từ ≥4 chữ cái (đã chọn mốc
  "≥4" thay vì chỉ ">4" để không bỏ sót đúng từ 4 chữ cái — báo lại nếu ý người dùng là mốc khác) đổi
  sang ẩn **2 ô cùng lúc trong 1 lượt**, vị trí 2 ô chọn ngẫu nhiên trong số các ô của từ (digraph
  `er`/`sh` vẫn tính 1 ô như quy ước cũ) — **có thể liền nhau hoặc cách nhau** ("lộn xộn"), không còn
  đảm bảo lấy tuần tự trái-sang-phải như CR-010. Vẫn giữ **3 lượt/từ**: lượt 1 = ô phonics của unit +
  1 ô khác ngẫu nhiên; lượt 2-3 = 2 tổ hợp khác nhau rút từ các ô KHÔNG phải ô phonics (giữ tinh thần
  "lượt sau thử chữ khác" của CR-010, không lặp lại đúng ô phonics 3 lần).
- **Cách xử lý**: viết script sinh lại `g03_fill_letter.json` — 7 từ <4 chữ cái (sea, box, fox, ox,
  jam, van, zoo) copy nguyên y hệt bản cũ (quy tắc không đổi); 42 từ ≥4 chữ cái sinh lại theo quy tắc
  2-ô-ngẫu-nhiên trên, `distractors` sinh riêng theo từng lượt (khác quy ước cũ "dùng chung distractors
  cho cả 3 lượt" — không giữ được nữa vì độ dài đáp án có thể khác nhau giữa các lượt của từ có
  digraph, vd "brother" lượt 1 = "rer" 3 ký tự, lượt 2/3 = 2 ký tự). Đã kiểm tra tự động: 146/146 mục
  `hidden_idx` khớp đúng ký tự thật, không mục nào đáp án trùng nhiễu, độ dài nhiễu luôn khớp đáp án.
  **Sửa `fill_letter_screen.dart`**: cách hiển thị cũ (`prefix + slot + suffix`) giả định `hidden_idx`
  luôn là 1 dải liền nhau — SAI khi 2 ô cách nhau (vd ẩn vị trí 0 và 3 của "table" sẽ làm mất chữ "ab"
  ở giữa). Đổi sang `_wordSpans()` ghép từng ký tự riêng theo đúng vị trí, không giả định liền dải.
- **Trạng thái**: Đã sửa (chưa xác nhận).

**2. G08 Ghi âm**:
1. "Button ở trạng thái 'đang nghe' Background button màu đỏ nhẹ."
2. "Chuyển thời gian tự động tắt lên 3s nếu không nhận được âm thanh."
3. "Cải thiện performance khi trả lại kết quả... thêm loading: Đang chấm điểm, để tránh click button
   'ghi âm' khi chưa có kết quả."
- **Cách xử lý**:
  1. Nút "Ghi âm" đổi nền sang `AppColors.error` (đỏ nhạt, đã dùng cho hiệu ứng sai — CR-009 gọi đây
     là "đỏ nhạt") khi `_isListening`, kèm `foregroundColor: AppColors.textPrimary` (chữ tối) theo
     đúng quy ước tương phản CR-009 vì nền sáng màu; trở lại `infoDark`/chữ trắng khi không nghe.
  2. `pauseFor` trong `SpeechListenOptions` đổi từ `Duration(seconds: 2)` → `Duration(seconds: 3)`.
  3. **Khảo sát nguyên nhân**: `speech_to_text` báo trạng thái `done`/`notListening` (tắt
     `_isListening`) **độc lập** với lúc kết quả cuối (`onResult(finalResult: true)`) thực sự về —
     độ trễ giữa 2 mốc này (do xử lý nhận diện, có thể qua mạng) chính là khoảng "xử lý lâu" người
     dùng thấy, và trước đây nút "Ghi âm" bật lại ngay khi `_isListening=false` dù chưa có điểm, cho
     phép bấm ghi âm lượt mới đè lên lượt đang chờ kết quả. Thêm cờ `_isScoring` (true từ lúc status
     done/notListening cho tới lúc `_finishAttempt` tính xong điểm; reset ở `onError`/chuyển từ để
     không kẹt mãi) — khóa nút + hiện text "Đang chấm điểm..." trong lúc này.
- **Trạng thái**: Đã sửa (chưa xác nhận) — đây là latency thật của engine nhận diện giọng nói
  (không phải bug xử lý chậm phía app), giải pháp là chặn UI + báo trạng thái rõ ràng chứ không rút
  ngắn được thời gian chờ thật; cần bạn test xem độ trễ thực tế trên máy có chấp nhận được không.

**3. G10 Săn chữ — đổi hẳn cơ chế** (không còn "săn chữ cái theo phonics" nữa):
- "Từ để nghe là từ vựng trong bài đó." / "Khi vào màn hình là nghe luôn." / đổi text "Tìm chữ: x"
  thành "Lựa chọn đáp án đúng với từ đã nghe" / "Đáp án chọn... là từ vựng của bài đó" / "Số lượng
  đáp án... là 6 đáp án. Trong đó có đáp án là những từ đang học của unit + những từ đã học trước đó"
  (Unit 1 dùng You/He/She thay "unit trước").
- **Xác nhận số liệu trước khi code**: đếm lại từ `vocabulary.json` — mọi unit đều có ĐỦ ≥6 từ trong
  "unit hiện tại + unit liền trước" (kể cả 7 từ mở rộng không audio, dùng được làm nhiễu chữ vì đáp
  án ở đây chỉ là CHỮ không cần audio riêng) để luôn đủ 5 nhiễu + 1 đúng, **không có unit nào thiếu
  đáp án** (mốc chật nhất: Unit 1 đúng 6 từ kể cả 3 đại từ, Unit 16 dư ra 6 từ nhiễu khả dụng).
- **Cách xử lý — đây là đổi cơ chế hoàn toàn, không phải sửa nhỏ trên máy cũ**:
  - Bỏ hẳn model `HuntLetterItem` (config phẳng 1 mục/unit, chữ cái đơn lẻ) — thay bằng
    `WordHuntQuestion` (`models.dart`): `{word_id, word, prompt_audio, options[], answer_idx}`, giống
    hệt shape `ListenQuestion` (G02) nhưng `options` là CHỮ (`List<String>`) thay vì hình. Đổi
    `huntByUnit` từ `Map<int,HuntLetterItem>` sang `Map<int,List<WordHuntQuestion>>` (cùng shape
    List như mọi game khác, không còn ngoại lệ "config phẳng").
  - Sinh lại toàn bộ `g10_letter_hunt.json` bằng script: mỗi từ CÓ AUDIO trong unit = 1 "lượt"
    (round) — không còn cố định "5 lượt" UI-side như bản cũ, số lượt = số từ có audio của unit đó (3
    hoặc 4 tùy unit, giống G02). Với mỗi lượt: `options` = từ đúng + 5 từ nhiễu rút ngẫu nhiên từ
    (toàn bộ từ unit hiện tại + toàn bộ từ unit liền trước, kể cả từ mở rộng không audio); Unit 1
    dùng `['You','He','She']` thay cho "unit trước" (không có unit 0). Đã kiểm tra tự động: 49/49
    lượt có đúng 6 đáp án không trùng nhau, `answer_idx` trỏ đúng từ đã nghe.
  - Viết lại toàn bộ `letter_hunt_screen.dart` theo đúng mẫu `listen_pick_screen.dart` (G02): tự
    phát audio khi vào màn hình (`initState` + `addPostFrameCallback`, giống G02, khác quy ước "im
    lặng mặc định" của G05/G06 vì G10 vốn đã tự phát từ bản cũ), nút "Nghe lại", text tĩnh "Lựa chọn
    đáp án đúng với từ đã nghe" (không còn hiện chữ mục tiêu — sẽ lộ đáp án), lưới `Wrap` các ô CHỮ
    (không phải hình) — chấm ngay + xáo trộn khi sai + chốt chặn BUG-003, độ khó Dễ loại 1 nhiễu,
    y hệt mẫu chuẩn của app. **Bỏ hẳn cơ chế "bắt 5 lượt rồi mở hình thưởng"** của bản cũ — không còn
    hợp lý khi mọi từ trong unit đã lần lượt là "mục tiêu" của 1 lượt (không còn khái niệm phần
    thưởng RIÊNG ngoài các từ đã test). Giữ nguyên **sao tối đa 2** (theo catalog gốc, không đổi) —
    công thức đổi từ "misses==0?2:1" sang chuẩn 2 mức theo tỉ lệ đúng/tổng giống G02/G03 (thu gọn về
    thang 2 sao).
  - `game_defs.dart`: `countFor`/`countSuffix`/`buildScreen` của `g10` đổi theo shape List mới
    (trước đây đếm `containsKey` vì chỉ có 1 mục/unit).
  - **Giữ nguyên không đổi**: tên game "Săn chữ", icon `search_rounded`, màu `secondaryDark`, vị trí
    trong `kGameTypeOrder`/`kUnitGames`, mốc sao tối đa 2 — chỉ đổi cơ chế bên trong theo đúng yêu cầu.
- **Trạng thái**: Đã sửa (chưa xác nhận) — cần test: âm phát đúng ngay khi vào màn hình, 6 đáp án đọc
  rõ không bị tràn khi có từ dài (vd "grandmother", "volleyball"), Unit 1 hiển thị đúng You/He/She.

---

## CR-021 — Rà soát Sprint 3: bổ sung độ khó Dễ còn thiếu cho G09 Fun Time

- **Yêu cầu (theo người dùng, 2026-07-26)**: "Kiểm tra sprint 3 còn chức năng nào chưa đối ứng thì
  đối ứng hoàn tất luôn."
- **Rà soát**: đọc lại `CLAUDE.md`/`SPRINT3_PLAN.md`/`BUGS_CR.md`, grep `TODO` trong `lib/` (không có
  mục nào), kiểm tra từng game Sprint 3 (G09/G10/G12) đối chiếu 2 mẫu độ khó chuẩn của app. Kết quả:
  - **G09 Fun Time — thiếu độ khó Dễ**: `memory_match_screen.dart` không có bất kỳ chỗ nào đọc
    `SettingsService.instance.isEasy` (xác nhận bằng grep) — đúng như CLAUDE.md §6 đã ghi nhận từ
    CR-019 là "ngoại lệ chưa xử lý, để trống có chủ ý".
  - **G10 Săn chữ, G12 Boss Quiz — đã có độ khó Dễ đầy đủ** (kể cả sau khi G10 đổi cơ chế ở CR-020,
    đã giữ nguyên cơ chế loại 1 đáp án nhiễu khi viết lại `letter_hunt_screen.dart`).
  - **Huy hiệu (badge_defs.dart) — chức năng đầy đủ**, chỉ tên/icon là placeholder nội dung (đã ghi
    nhận từ CR-019, không phải chức năng thiếu).
  - **G11 truyện tương tác — vẫn pending, KHÔNG đối ứng được**: khác các mục trên (thiếu code/cơ
    chế), G11 thiếu NỘI DUNG NGUỒN thật (lời thoại + ảnh trang truyện) — không nằm trong bất kỳ file
    Excel/`04_image+audio/` nào, chỉ có khả năng nằm trong `01_Document/book.pdf` (117MB, không đọc
    được trong môi trường Claude Code). Không phải việc có thể "code cho xong" — cần người mở file đó
    và cung cấp nội dung trước (xem CLAUDE.md §8/§9 mục "Việc cần con người" trong `HANDOVER.md`).
  - (Ngoài phạm vi Sprint 3 nhưng liên quan: **G07 karaoke** cũng đang pending cùng lý do — thiếu
    timing lyrics, không phải thiếu code.)
- **Cách xử lý (G09)**: G09 không khớp 2 mẫu độ khó chuẩn (không có "lựa chọn sai" để làm mờ như
  G02/G03/G06/G10/G12, không có "ô/token" để điền sẵn như G04/G05) nên thêm cơ chế thứ 3 phù hợp hơn
  với bản chất trò nhớ vị trí: cờ `_previewing` (true khi Dễ, trong 4 giây đầu lúc `_prepare()`) — mọi
  thẻ hiện lật ngửa (`faceUp` luôn `true`), chạm không có tác dụng (`_tap` return sớm), header đổi
  thành "Ghi nhớ vị trí các cặp nhé!"; hết 4 giây tự úp xuống, vào chơi bình thường. Khó = không đổi
  (không xem trước). Không đổi công thức tính sao (Dễ vẫn có thể dễ đạt 3 sao hơn nhờ đã xem trước —
  nhất quán với cách các game khác không hạ sao khi dùng gợi ý Dễ).
- **Trạng thái**: Đã sửa (chưa xác nhận). `flutter analyze` sạch, build APK debug thành công (xem
  đường dẫn APK mới nhất trong `HANDOVER.md`) — cần test: 4 giây xem trước đủ để không gây khó chịu
  (không quá ngắn/dài), thẻ úp xuống đúng lúc và chơi bình thường sau đó.

---

## CR-022 — G08: sửa bug màu đỏ CR-020 không hiện + chặn trần chờ kết quả; G10: khôi phục "có thưởng"

- **Yêu cầu (theo người dùng, 2026-07-26)**: yêu cầu "đối ứng các chức năng F11, F12, F13" + báo lại
  G08 "chưa đối ứng triệt để": (1) nền đỏ nhạt lúc đang nghe chưa thấy hiện, (2) nhắc lại mốc 3s
  ("4s thì lâu quá" — xem khảo sát bên dưới), (3) "Trả lại kết quả rất lâu" — nhấn mạnh lại yêu cầu
  cải thiện performance.

**G08 — mục (1), bug thật, không phải chưa code**: đọc lại `record_screen.dart`, phát hiện
`PrimaryButton` "Ghi âm" set `color: AppColors.error` khi `_isListening` NHƯNG `onPressed` cũng
**null (disabled) đúng lúc đó** (`(_isListening || _isScoring) ? null : _startListening`). Flutter's
`ElevatedButton` khi bị disabled **tự vẽ màu xám mặc định, PHỚT LỜ `backgroundColor`/`foregroundColor`
đã set**, trừ khi truyền riêng `disabledBackgroundColor`/`disabledForegroundColor` — CR-020 không hề
truyền 2 tham số này nên màu đỏ không bao giờ thực sự hiện ra trên máy, đúng như người dùng báo. **Cách
xử lý**: thêm 2 tham số `disabledColor`/`disabledForegroundColor` vào `PrimaryButton`
(`common_widgets.dart`, mặc định `null` — giữ nguyên hành vi xám mặc định cho MỌI nút khác trong app,
không đổi diện mạo chỗ nào khác); `record_screen.dart` truyền `disabledColor: AppColors.error` +
`disabledForegroundColor: AppColors.textPrimary` khi `_isListening`.

**G08 — mục (2), `pauseFor` đã đúng 3s từ CR-020, không đổi**: khả năng "(4s thì lâu quá)" là do tổng
thời gian CẢM NHẬN (3s im lặng + thời gian engine xử lý xong sau đó) dài hơn con số 3s cấu hình —
đúng là vấn đề của mục (3) bên dưới, không phải `pauseFor` sai.

**G08 — mục (3), cải thiện thật sự (không chỉ che bằng loading)**: khảo sát sâu hơn — CR-020 chỉ thêm
loading "Đang chấm điểm..." nhưng vẫn CHỜ VÔ THỜI HẠN `onResult(finalResult: true)` thật sự về, độ trễ
này là của engine nhận diện (có thể qua mạng), không có trần. **Cách xử lý**: thêm hằng số
`_resultGraceWindow = Duration(milliseconds: 1500)` — ngay khi status `done`/`notListening` báo hết
nghe, hẹn giờ 1.5s; nếu sau đó vẫn chưa có `finalResult` thật, **chấm luôn bằng bản ghi nhận từng
phần (partial) gần nhất** (`_recognized`, đã được cập nhật liên tục suốt lúc nói nhờ
`partialResults: true` có sẵn) thay vì tiếp tục chờ. Có chốt `roundIndex` để không chấm nhầm từ nếu
trẻ đã chuyển từ khác trong lúc chờ. Kết quả: trần thời gian chờ tối đa sau khi im lặng ≈ 3s (pauseFor)
+ 1.5s (grace) = 4.5s, thay vì "chờ đến khi nào engine trả lời xong" như trước — bị động theo mạng/
máy có thể lâu hơn nhiều.

**Đối ứng F11 (Memory match & Săn chữ, G09+G10) — rà lại đúng tiêu chí trong
`01_Tai_lieu/TaiLieu_Phat_Trien_App.xlsx` sheet `03_Mô tả tính năng`**: "Cặp đúng biến mất; đếm lượt/
điểm; **săn chữ có thưởng**". Phát hiện: CR-020 khi đổi cơ chế G10 đã **bỏ hẳn** cơ chế thưởng cũ
("Bỏ hẳn cơ chế 'bắt 5 lượt rồi mở hình thưởng'... không còn hợp lý") — đúng về mặt UX cho mẫu mới,
nhưng vô tình bỏ luôn 1 tiêu chí hoàn thành đã ghi trong tài liệu gốc. **Cách xử lý**: khôi phục bằng
cách thêm field `image` vào `WordHuntQuestion` (`models.dart`, sinh lại `g10_letter_hunt.json`) và
hiện hình + phát lại audio của **câu hỏi đầu tiên trong unit** (giữ đúng quy ước "thưởng = từ đầu
unit" của bản cũ) như 1 mục "Phần thưởng cho bạn! 🎁" ngay trong dialog hoàn thành (không tách dialog
riêng như bản cũ, gộp chung cho gọn) — `_showResult()` trong `letter_hunt_screen.dart`.
G09 (đã kiểm tra "cặp đúng biến mất" — đúng ra là "không còn thao tác được nữa + tô màu khác", không
literally biến mất khỏi lưới, cách hiểu hợp lý và phổ biến cho game memory, không sửa) và "đếm lượt"
(đã có `_attempts`) đạt yêu cầu, không cần sửa thêm.

**Đối ứng F13 (Boss Quiz & Huy hiệu, G12) — rà lại tiêu chí**: "Trộn nhiều dạng; tính điểm; trao & lưu
huy hiệu". Xác nhận đã đạt đủ 3 ý — không cần sửa gì thêm.

**Đối ứng F12 (Truyện tương tác, G11)** — xem CR-019/CR-021: xác nhận qua đọc lại xlsx, F12 chính là
G11 (dữ liệu cần: `{pages[{img, bubbles[{text, audio}]}]}`). Đây KHÔNG phải trường hợp thiếu code như
G09 — **hoàn toàn không có nội dung nguồn**: không 1 ảnh trang truyện, không 1 dòng lời thoại nào
trong 2 file Excel hay `04_image+audio/`; chỉ có 4 track audio Review (22/45/68/91) nguyên vẹn CHƯA
cắt theo bóng thoại. Không tự bịa nội dung truyện được vì đây là nội dung chương trình học thật (khác
huy hiệu G12 — nơi tài liệu gốc cho phép "App tự định nghĩa"). Đã hỏi lại người dùng hướng xử lý (dựng
khung màn hình/cơ chế trước không nội dung thật, hay chờ có nội dung mới bắt đầu) — **người dùng chọn
"Chờ nội dung thật"** (2026-07-26): KHÔNG viết code G11 lúc này (kể cả khung/cơ chế placeholder),
chờ đến khi người dùng tự mở `01_Document/book.pdf` và cung cấp lời thoại + ảnh 4 trang Review
(20/37/54/71) thì mới bắt đầu code G11. Phiên sau: đừng tự ý dựng khung G11 nếu chưa có nội dung thật
kèm theo yêu cầu.
- **Trạng thái**: Đã sửa (chưa xác nhận) — G08/G10 cần test: màu đỏ đã hiện đúng, độ trễ trả kết quả
  có cải thiện rõ rệt so với trước, phần thưởng G10 hiện đúng hình/audio/tên từ.

---

## CR-023 — G08 (nút Dừng), G09 (đổi tên/lưới to/khóa chặt/sao dễ), G03 (tách từng chữ), G10/G12 (layout)

- **Yêu cầu (theo người dùng, 2026-07-26)**: 5 mục trên các màn hình G08/G09/G03/G10, cộng "Code luôn
  G10 và G12" (hiểu là: cứ triển khai luôn, không cần hỏi lại; đồng thời rà thêm G12 xem có cùng vấn
  đề layout với G10 không).

**1. G08 Ghi âm — "Thêm button dừng ghi âm. (Bỏ chức năng không nghe 3s tự tắt)"**:
- Bỏ hẳn cơ chế tự dừng khi im lặng: `pauseFor` đổi từ 3s → bằng `listenFor` (8s), để im lặng giữa
  chừng không còn tự kích hoạt dừng — `listenFor` giữ nguyên 8s làm trần an toàn nếu trẻ quên bấm nút.
- Thêm nút "Dừng ghi âm" thật: tái dùng CHÍNH nút "Ghi âm" (đổi label/icon thành "Dừng ghi âm"/
  `stop_circle_rounded`, nền đỏ nhạt giữ nguyên từ CR-020/022) — khi đang nghe, nút giờ **bấm được**
  (gọi `_stopListening()` → `_speech.stop()`) thay vì bị khóa như trước; nhờ vậy màu đỏ hiện đúng qua
  màu nền bình thường của nút (không cần `disabledColor` nữa cho nhánh này — chỉ trạng thái "Đang
  chấm điểm..." mới thực sự khóa nút, dùng màu xám mặc định là đủ). Logic chờ kết quả/`_isScoring`/
  trần 1.5s của CR-022 giữ nguyên không đổi — vẫn áp dụng dù dừng bằng tay hay bằng an toàn 8s.

**2. G09 Fun Time → "Lật thẻ"**:
- Đổi `baseLabel` trong `checkpoints.dart` + AppBar title trong `memory_match_screen.dart` từ
  "Fun Time" sang "Lật thẻ".
- **Lưới thẻ to gần lấp đầy màn hình**: `GridView.count` mặc định tính ô vuông theo bề rộng, để
  trống nhiều khoảng trắng phía dưới nếu số hàng ít hơn chiều cao khả dụng. Đổi sang `LayoutBuilder`
  đo đúng kích thước khung chứa thật, tính `childAspectRatio` để ô kéo giãn lấp cả 2 chiều. Icon "?"
  và chữ trên thẻ cũng phóng to theo (28→40, 14→20 + bọc `FittedBox` cho từ dài).
- **"Chỉ được chơi sau khi hoàn tất các bài học trước đó"**: rà lại code thấy `isCheckpointUnlocked`
  (dùng chung với Boss Quiz) chỉ đòi hỏi 4 game lõi (G01-G04) của CHÍNH unit gắn checkpoint — về mặt
  toán học đã đảm bảo unit trước đó cũng xong 4 game lõi (vì unit sau chỉ mở khi unit trước xong 4
  game lõi), nhưng KHÔNG đòi hỏi các game khác (G05/G06/G08/G10) của 2 unit trong phạm vi ôn tập.
  Hiểu "hoàn tất các bài học" theo nghĩa rộng hơn (mọi game, không chỉ 4 game lõi) — thêm
  `isFunTimeUnlocked(progress, fromUnit, toUnit)` riêng (`progress_repository.dart`) đòi hỏi MỌI
  game trong `kGameTypeOrder` đạt ≥1 sao ở CẢ 2 unit (`cp.fromUnit`/`cp.toUnit`) — **không đụng
  `isCheckpointUnlocked`/Boss Quiz**, chỉ áp dụng riêng cho Lật thẻ.
- **Sao dễ hơn**: công thức cũ `attempts<=pairs` mới được 3 sao gần như đòi hỏi chơi hoàn hảo tuyệt
  đối (không sai 1 lượt nào) — nới lên 1 bậc: `attempts<=pairs*2` → 3 sao, `<=pairs*3` → 2 sao,
  còn lại 1 sao.

**3. G03 Điền chữ — "Tách đáp án ra mỗi đáp án 1 chữ cái"**:
- Bản CR-020 (từ ≥4 chữ cái ẩn 2 ô cùng lúc) cho chạm 1 ô GỘP (2 ký tự) để điền cả 2 ô 1 lượt — nay
  đổi lại: mỗi ô trống điền RIÊNG bằng 1 lượt chạm 1 chữ cái, giống cách G03 vốn hoạt động khi chỉ có
  1 ô. Khay chữ giờ là 1 pool CHỮ ĐƠN dùng chung cho cả 1-2 ô của lượt (đáp án tách từng ký tự +
  distractor, tổng distractor sinh lại thành chữ đơn thay vì chuỗi cùng độ dài — xem script
  `gen_g03_v2`, 126 mục cập nhật). Chạm đúng chữ mục tiêu của ô trống ĐẦU TIÊN (trái sang phải) mới
  tính, xong ô đó chuyển mục tiêu sang ô kế; sai thì xáo trộn lại các ô CÒN LẠI (không xáo ô đã điền
  đúng). Viết lại toàn bộ `fill_letter_screen.dart`: `_filledCount` (số ô đã điền đúng, thay `_filled`
  bool cũ) + `_order`/`_usedPositions` (index thật, tách khỏi vị trí hiển thị — giống mẫu
  `listen_pick_screen.dart` — để xáo trộn không làm lệch chữ nào đã dùng/bị loại độ khó Dễ).
- **Chú ý xử lý trùng chữ**: nếu 2 ô trống cùng lượt có CÙNG 1 chữ cái đúng (vd "eleven" ẩn 2 vị trí
  đều là "e"), pool vẫn chứa đủ 2 bản sao chữ đó (không dedupe) để chạm đủ 2 lần.

**4. G10 Săn chữ — "Nhỏ đáp án lại để 2 đáp án cùng nằm trên 1 dòng"**:
- Đổi từ `Wrap` (mỗi từ dài chiếm hẳn 1 dòng do rộng gần hết màn hình) sang `GridView.count
  (crossAxisCount: 2)` cố định — luôn đúng 2 đáp án/dòng bất kể độ dài từ, giống mẫu G04 (CR-006)/G12.
  Chữ trong ô bọc `FittedBox(fit: scaleDown)` để tự co lại vừa ô thay vì tràn (vd "grandmother"），
  không cần quy tắc riêng cho từ ngắn/dài.

**5. G12 Boss Quiz — rà thêm theo yêu cầu "code luôn G10 và G12"**:
- Lưới đáp án G12 vốn ĐÃ là `GridView.builder(crossAxisCount: 2)` (không có vấn đề cấu trúc như G10's
  `Wrap`), nhưng phần chữ (`option.text`, dùng cho câu hỏi nguồn G03/G05) là `Text` trần không chống
  tràn — câu nguồn G05 (lắp câu) có thể khá dài trên ô vuông cố định. Bọc thêm `FittedBox(fit:
  scaleDown)` cho nhất quán với cách xử lý G10, phòng tràn/cắt chữ.
- **Trạng thái**: Đã sửa (chưa xác nhận). `flutter analyze` sạch, build APK debug thành công — cần
  test: G08 bấm "Dừng" đúng lúc dừng mic, G09 tên/lưới/khóa/sao đúng như mô tả (đặc biệt: thử vào Lật
  thẻ khi mới xong 4 game lõi nhưng CHƯA làm G05/G06/G08/G10 — phải vẫn khóa), G03 tách 2 ô riêng biệt
  đúng thứ tự trái-phải, G10/G12 hiển thị chữ không tràn/không vỡ dòng.
