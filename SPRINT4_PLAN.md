# Sprint 4 (Đa lớp / Multi-grade) implementation plan — lop2_english_app

Bàn giao cho Claude Code. Mở đúng thư mục project trước khi bắt đầu:

```powershell
cd "D:\01_NguyenNC\10_Claude\06_global_success\05_App\04_lop2_english_app"
. .\activate_env.ps1
claude
```

(`HANDOVER.md` ghi đường cd cũ là `D:\01_NguyenNC\10_Claude\05_Lop2 GLOBAL\05_App\...` — thư mục
gốc đã đổi tên thành `06_global_success` sau đó, dùng đường dẫn ở trên, không dùng đường trong
`HANDOVER.md`.)

**Git**: theo `HANDOVER.md`, repo đang ở nhánh `sprint-3` (đã push, có đủ Sprint 1+2+3). Chạy `git
branch` xác nhận lại trước khi làm gì. Tạo nhánh mới `sprint-4` từ `sprint-3` cho toàn bộ việc trong
file này — **không code trực tiếp trên `sprint-3`**.

Đọc `CLAUDE.md` trong thư mục này trước (ngữ cảnh đầy đủ nhất: kiến trúc, quy ước code, định dạng
JSON, khoảng trống dữ liệu) và `BUGS_CR.md` (bug/CR đang mở). File này bổ sung thêm phần **Lớp 1 +
đa lớp** mà 2 file đó chưa có.

## Context

**Yêu cầu của người dùng (2026-08-20), 2 việc**:
1. Triển khai code cho **Lớp 1 Unit 1** làm bản thử — người dùng tự kiểm tra trên điện thoại trước,
   sau đó mới làm tiếp Unit 2-16 (đúng cách đã làm Lớp 2: từng sprint nhỏ, test thật trước khi mở
   rộng).
2. Thêm **1 màn hình chính (main)** để phân nhánh vào từng lớp: **Lớp 1** (đang phát triển), **Lớp
   2** (đã có, chạy đầy đủ), **Lớp 3/4/5** (hiện disabled, để dành phát triển sau).

**Dữ liệu Lớp 1 đã có sẵn** (một phiên Cowork riêng vừa chuẩn bị xong hôm nay, KHÔNG phải Claude
Code, KHÔNG đụng vào code trong `05_App/`) — cùng schema/cấu trúc với dữ liệu Lớp 2 đã dùng để sinh
`assets/data/*.json` trước đây, nên tái dùng được đúng script/quy trình cũ (xem `10_Huong_dan_tai_su_dung`
trong `01_BasicDesign/BasicDesign_LopEnglishApp_v2.xlsx`, bước 1-2):
- `../../02_Phan_tich/01_Lop-1/TiengAnh1_GiaoTrinh_Game_AppData.xlsx` — 8 sheet **y hệt tên/cột**
  file Lớp 2 (`02_Phan_tich/02_Lop-2/TiengAnh2_GiaoTrinh_Game_AppData.xlsx`, có thể mở song song để
  đối chiếu): `02_Giáo trình chi tiết` cột F có mẫu câu + chant/song từng lesson (nguồn cho G05/G06,
  xem cảnh báo Phase 2), `03_Từ vựng (DB)`, `04_Audio (DB)`, `08_Rà soát & Rủi ro` (đọc trước khi
  code — có mục dành riêng cho Unit 3 "can", audio chưa nghe kiểm chứng bằng tai người, v.v.)
- `../../04_image+audio/01_Lop-1/manifest.csv` + `manifest.json` — schema **y hệt** manifest Lớp 2
  (`word_id, word, ipa, meaning_vi, unit, unit_theme, phonics, type, image, audio, image_ready,
  audio_ready, note`) — 70 từ, 16 unit. Cột `type` (`core`/`extended`) là **mới so với Lớp 2**: từ
  đếm số (Unit 9, 16) là `extended`, không phải từ chính SGK — lọc theo cột này khi sinh G01, đừng
  lẫn với 60 từ `core`.
- `../../04_image+audio/01_Lop-1/Unit01/{image,audio}/` — **Unit 1 đã đủ 3/3 ảnh + 3/3 audio** (ball,
  bike, book — không có từ `extended` nào ở Unit 1, không thiếu audio từ nào) → sạch nhất trong 16
  unit, hợp lý để làm bản thử đầu tiên. Unit 2-16 có 9/70 từ mở rộng (số đếm) chưa có audio — không
  liên quan tới scope sprint này nhưng sẽ gặp lại khi làm tiếp Unit 9/16.

**Phát hiện quan trọng khi đọc lại code hiện tại trước khi viết plan này** (cùng kỷ luật "đọc code
thật trước khi lên kế hoạch" như Sprint 2/3): app hôm nay là **single-grade tuyệt đối**, không có
khái niệm "lớp" ở bất kỳ đâu —
- Package Flutter tên `lop2_english_app`, `MaterialApp.title` hardcode "Tiếng Anh Lớp 2 — Global
  Success" (`app.dart`).
- `UnitInfo.unitId` (`models.dart`) là `int` trần 1-16, không có field lớp.
- `LessonProgressTable`/`EarnedBadges` (Drift) khóa theo `(profileId, unitId, gameType)` — **không
  có cột lớp** → nếu thêm thẳng Lớp 1 Unit 1-16 vào, tiến độ Lớp 1 Unit 1 và Lớp 2 Unit 1 sẽ **ghi
  đè lẫn nhau** trong cùng 1 dòng dữ liệu (cùng `unitId=1`).
- `assets/content/UnitNN/...` là thư mục phẳng — chỉ chứa 16 unit của Lớp 2, đặt thẳng Lớp 1 vào sẽ
  đè file (Unit 1 Lớp 2 là pasta/popcorn/pizza, Unit 1 Lớp 1 là ball/bike/book, cùng tên thư mục
  `Unit01`).
- `ContentRepository.load()` đọc thẳng 1 bộ đường dẫn cố định (`assets/data/units.json`,
  `assets/data/games/g0X_*.json`) — không tham số hóa theo lớp.

**Về `01_BasicDesign/BasicDesign_LopEnglishApp_v2.xlsx` sheet `10_Huong_dan_tai_su_dung`**: sheet này
đã có sẵn hướng dẫn tái dùng engine cho Lớp 1/3/4/5, nhưng theo mô hình **"mỗi lớp 1 app riêng"**
(copy nguyên engine, đổi dữ liệu, build APK riêng — không đổi lẫn nhau). Yêu cầu lần này của người
dùng ("1 màn hình main phân nhánh") là **1 app duy nhất chứa nhiều lớp** — khác hướng tài liệu cũ,
hợp lý hơn cho sản phẩm thật (1 lần cài, 1 bộ hồ sơ trẻ dùng chung cho mọi lớp, không phải cài lại
app khi trẻ lên lớp), nhưng có nghĩa Phase 0 dưới đây phải làm thêm phần "plumbing" mà sheet 10 chưa
tính tới (cột lớp trong DB, namespace lại asset theo lớp). Cứ làm theo yêu cầu mới này, không theo
sheet 10.

**Phạm vi sprint này — chỉ những gì dưới đây, không hơn**:
- ✅ Cơ chế đa lớp (Phase 0) — nền tảng bắt buộc, Lớp 2 phải chạy y hệt như trước, **không mất dữ
  liệu/sao/hồ sơ hiện có trên máy thật**.
- ✅ Màn hình chính chọn lớp (Phase 1).
- ✅ Lớp 1 — chỉ Unit 1 chơi được đầy đủ (Phase 2), Unit 2-16 hiện trên bản đồ nhưng khóa (tự nhiên
  nhờ quy tắc mở khóa có sẵn, xem Phase 2 cuối).
- ❌ Lớp 1 Unit 2-16 nội dung thật — để sprint sau, lặp lại đúng Phase 2 của sprint này.
- ❌ Lớp 3/4/5 nội dung — chưa có giáo trình/dữ liệu, chỉ hiện placeholder disabled ở màn chọn lớp
  (cơ chế bật lên sau này xem `GradeOption`/`kGradeOptions` ở Phase 1 và mục "Lớp 3/4/5 sau này — plan
  này đã tính tới chưa?" ngay dưới đây).
- ❌ G07 (karaoke)/G11 (truyện) cho Lớp 1 — vẫn pending giống hệt Lớp 2 (cùng lý do: chưa có
  timing lyrics / lời thoại+ảnh trang truyện, phiên Cowork chuẩn bị dữ liệu hôm nay cũng không tạo
  ra được 2 thứ này, xem `08_Rà soát & Rủi ro` file Excel Lớp 1).
- ❌ G09 (Lật thẻ)/G12 (Boss Quiz) cho Lớp 1 — 2 game này chỉ xuất hiện ở checkpoint sau Unit 2/6/
  10/14 và 4/8/12/16 (`checkpoints.dart`), Unit 1 không chạm tới checkpoint nào nên không cần đụng gì
  ở sprint này; sẽ tự nhiên cần khi làm tới Lớp 1 Unit 4. Riêng cột `grade` cho `EarnedBadges` (bảng
  huy hiệu) vẫn thêm **ngay ở Phase 0 sprint này**, dù chưa dùng tới — lý do xem bullet
  `app_database.dart` trong Phase 0, mục rủi ro đụng huy hiệu giữa các lớp.

**Lớp 3/4/5 sau này — plan này đã tính tới chưa?** Đã rà lại toàn bộ Phase 0-2 dưới đây theo đúng câu
hỏi này (2026-08-20, trước khi bàn giao cho Claude Code). Các phần sau **đã tổng quát hóa sẵn cho cả
5 lớp**, không cần sửa lại khi Lớp 3/4/5 có dữ liệu thật:
- Cột `grade` trên `LessonProgressTable` **và `EarnedBadges`** (xem bullet mới trong Phase 0) là
  `int` tự do 1-5, không có điều kiện hardcode giới hạn 2 lớp ở đâu cả.
- `ContentRepository.assetBase`/đường dẫn JSON tham số hóa theo `'lop$grade'` — Lớp 3 chỉ cần thêm
  thư mục `assets/content/lop3/`, `assets/data/lop3/` + khai báo `pubspec.yaml`, không sửa
  `content_repository.dart`.
- Toàn bộ `progress_repository.dart` nhận `grade` như 1 tham số lọc xuyên suốt, không có danh sách
  lớp nào hardcode bên trong.
- Màn chọn lớp (Phase 1) là danh sách cấu hình `kGradeOptions` (mô phỏng đúng pattern
  `gameDefsByType`/`kUnitGames` đã có ở `game_defs.dart`) — bật Lớp 3 trên giao diện chỉ là đổi
  `enabled: false → true` + sửa `subtitle`, không phải sửa logic/layout màn hình.

Phần **vẫn phải làm tay** cho mỗi lớp mới (Lớp 3/4/5 không tự nhiên "có" chỉ vì kiến trúc đã sẵn sàng
— đây là lặp lại Phase 2 + đúng 1 dòng cấu hình Phase 1, không phải làm lại Phase 0/1):
1. Chuẩn bị Excel phân tích + manifest ảnh/audio cho lớp đó (như phiên Cowork riêng đã làm cho Lớp 1
   hôm nay) — chưa có nguồn nào cho Lớp 3/4/5 tại thời điểm viết plan này.
2. Sinh `assets/data/lop3/units.json` + `games/g0X_*.json` (lặp lại Phase 2).
3. Thêm khai báo asset mới vào `pubspec.yaml` (đúng lưu ý ở Phase 0: chỉ khai thư mục đã có file
   thật, không khai trước 16 unit rỗng).
4. Thêm đúng 1 dòng `GradeOption(grade: 3, label: 'Lớp 3', subtitle: ..., enabled: true)` vào
   `kGradeOptions` (Phase 1).

Nói cách khác: phần khó (DB/repository/asset path đa lớp) đã xong ngay từ sprint này; mở thêm 1 lớp
mới sau này thuần là công việc **dữ liệu + khai báo**, không phải sửa lại kiến trúc hay logic màn
hình đã viết ở Sprint 4.

## Phase 0 — Multi-grade plumbing (làm trước, Lớp 2 không được đổi hành vi)

Đây là phần rủi ro cao nhất (đụng DB thật của Lớp 2 đang chạy) — làm cẩn thận, tách riêng khỏi Phase
1/2, test `flutter analyze` + chạy thử Lớp 2 sau khi xong Phase này trước khi sang Phase 1.

- **`models.dart`**: `UnitInfo` thêm field `grade` (`int`) — phạm vi thiết kế **1-5** (toàn cấp tiểu
  học), dù sprint này chỉ có dữ liệu thật cho 1 và 2. Không viết điều kiện kiểu
  `assert(grade == 1 || grade == 2)` hay switch liệt kê cứng 2 giá trị ở bất kỳ đâu trong code — để
  Lớp 3/4/5 không phải sửa lại field này khi có dữ liệu thật, chỉ cần thêm giá trị mới.
- **`ContentRepository`**: `load()` nhận thêm tham số `required int grade`. Đổi `assetBase` từ
  `static const String` sang field theo instance, giá trị `'assets/content/lop$grade/'`
  (`'assets/content/lop1/'` hoặc `'assets/content/lop2/'`) — nhờ vậy **không cần sửa** field
  `image`/`audio` bên trong bất kỳ file JSON nào đã có của Lớp 2 (chúng vẫn là đường dẫn tương đối
  kiểu `Unit01/image/pasta.png`, chỉ đổi tiền tố `assetBase` phía trước). Tương tự, đường đọc JSON
  nội dung tĩnh đổi từ `'assets/data/units.json'` → `'assets/data/lop$grade/units.json'`, và
  `'assets/data/games/g0X_...json'` → `'assets/data/lop$grade/games/g0X_...json'`.
- **Di chuyển file asset Lớp 2 hiện có** (đúng nội dung, chỉ đổi vị trí — dùng git mv để giữ lịch sử):
  - `assets/content/UnitNN/` → `assets/content/lop2/UnitNN/` (cả 16 unit).
  - `assets/data/units.json`, `assets/data/games/g0*.json` → `assets/data/lop2/units.json`,
    `assets/data/lop2/games/g0*.json`.
- **`pubspec.yaml`**: sửa toàn bộ khai báo `assets:` cho khớp đường mới (`assets/content/lop2/UnitNN/
  {image,audio}/` × 16, `assets/data/lop2/`, `assets/data/lop2/games/`) **+ thêm** `assets/data/lop1/`,
  `assets/data/lop1/games/`, `assets/content/lop1/Unit01/image/`, `assets/content/lop1/Unit01/audio/`.
  **Lưu ý bắt buộc**: Flutter báo lỗi build nếu khai 1 thư mục asset không tồn tại/rỗng — **chỉ khai
  `Unit01` cho `lop1`** ở sprint này (chưa có file thật cho Unit02-16), thêm dần dòng khai báo khi
  làm tới unit nào ở các sprint sau, đừng khai sẵn 16 thư mục rỗng.
- **`app_database.dart`**: thêm cột `grade` vào **cả `LessonProgressTable` lẫn `EarnedBadges`**
  (`IntColumn get grade => integer().withDefault(const Constant(2))()` ở cả 2 bảng — mặc định **2**,
  vì 100% dữ liệu đang có trên máy thật hôm nay là Lớp 2, không được để dòng cũ bị hiểu nhầm thành Lớp
  1 sau migrate). Bump `schemaVersion` 2 → 3. Thêm nhánh migration
  `if (from < 3) { await m.addColumn(lessonProgressTable, lessonProgressTable.grade); await
  m.addColumn(earnedBadges, earnedBadges.grade); }` vào `MigrationStrategy.onUpgrade` đang có (giữ
  nguyên nhánh `from < 2` cũ của Sprint 3, chỉ thêm nhánh mới) — **đây là lần thứ 2 migrate DB thật,
  làm đúng như đã làm với `EarnedBadges` ở Sprint 3, kể cả phần test "cài đè bản cũ, không gỡ cài lại"
  ở mục Verification**. Chạy lại `dart run build_runner build --delete-conflicting-outputs` sau khi
  sửa bảng.
- **Vì sao đụng cả `EarnedBadges` dù sprint này chưa code Boss Quiz cho Lớp 1**: `kBossQuizCheckpoints`
  (`checkpoints.dart`) dùng `badgeId` cố định kiểu `'badge_u4'`, không phân biệt lớp. Nếu không thêm
  cột `grade` vào `EarnedBadges` **ngay trong migration này**, huy hiệu "Unit 4" của Lớp 1 và Lớp 2 sẽ
  đụng nhau (cùng `badgeId`, không có gì phân biệt) ngay khi Lớp 1 tới Unit 4 (vài sprint nữa) — và
  sửa lúc đó sẽ cần migrate DB thật **lần 3** chỉ để vá việc này, tốn kém hơn nhiều so với thêm cột
  ngay bây giờ cùng lúc với cột của `LessonProgressTable`, dù chưa dùng tới. Việc còn lại, để dành cho
  sprint nào code Boss Quiz Lớp 1: sửa mọi query/insert huy hiệu trong `ProgressRepository` (tìm theo
  `badgeId`) để lọc/ghi thêm theo `grade`, giống hệt cách làm với tiến độ unit ở bullet
  `progress_repository.dart` ngay dưới đây — không cần đổi chuỗi `badgeId` (vẫn `'badge_u4'` v.v.), vì
  cột `grade` mới đã đủ để phân biệt 2 lớp.
- **`progress_repository.dart`**: đây là chỗ chạm nhiều nhất — mọi method hiện đang nhận `unitId`
  cần nhận thêm `grade` và lọc/ghi đúng cột mới: `isUnitUnlocked`, `isGameUnlocked`, `reportResult`,
  `watchForProfile` (nếu stream đang trả về TOÀN BỘ tiến độ của 1 hồ sơ bất kể lớp, cần lọc theo
  `grade` ngay trong query hoặc lọc lại ở nơi gọi — chọn 1 cách, đừng làm nửa vời ở cả 2 nơi),
  `starsFor`, `totalStarsForUnit`, `isCheckpointUnlocked`, `isFunTimeUnlocked`. Rà kỹ — thiếu 1 chỗ
  sẽ khiến Lớp 1 và Lớp 2 lại tính chung sao/khóa dù đã có cột `grade` trong DB.
- **Luồng gọi xuống**: `HomeScreen`, `UnitScreen`, `GameDef.countFor`/`buildScreen` cần biết đang ở
  lớp nào. Đề xuất: mỗi lớp có 1 `ContentRepository` riêng, **nạp lazy** (chỉ gọi
  `ContentRepository.load(grade: 1)` khi người dùng thật sự chạm vào ô "Lớp 1" ở màn chọn lớp, không
  nạp cả 2 lớp ngay từ `main.dart` — Lớp 3-5 chưa có gì để nạp, và Lớp 1 sprint này chỉ có Unit 1 nên
  không cần tốn thời gian khởi động app đọc dữ liệu 2 lớp cùng lúc).
- **`app.dart`/`main.dart`**: bỏ `home: ProfileSelectScreen(...)` gọi thẳng — luồng mới xem Phase 1.

## Phase 1 — SCR-00 · Màn hình chính: Chọn lớp

Mã màn hình mới theo đúng quy ước `01_BasicDesign/...xlsx` sheet `11_Dinh_nghia_ten_man_hinh`
(SCR-01a … SCR-15 đã dùng hết) — màn này đứng **trước** SCR-01, đặt mã **SCR-00**, tên gợi ý *Grade
Select*, file mới `lib/features/grade/grade_select_screen.dart`.

**Vị trí trong luồng**: `main.dart` → `ProfileSelectScreen` (SCR-01a/b, **không đổi gì**) →
**`GradeSelectScreen` (SCR-00, mới)** → `HomeScreen` (SCR-02, nhận thêm `grade`) → ... Chọn hồ sơ
đứng trước chọn lớp vì hồ sơ là danh tính đứa trẻ, độc lập với lớp — 1 trẻ có thể học cả Lớp 1 lẫn
Lớp 2 bằng cùng 1 hồ sơ (đúng lý do cần thêm cột `grade` ở Phase 0 thay vì tách hồ sơ riêng theo lớp).

**Giao diện**: lưới 5 ô (kiểu `_UnitCard` đã có trong `home_screen.dart`, tái dùng đúng pattern
`Opacity(opacity: locked ? 0.55 : 1)` + `Icon(Icons.lock_rounded)` cho ô khóa thay vì tự nghĩ style
mới), nhưng **không viết tay 5 khối `_GradeCard` lặp lại** — theo đúng pattern `GameDef`/
`gameDefsByType` đã có ở `game_defs.dart` (khai báo qua danh sách cấu hình, UI chỉ `map()` qua danh
sách), thêm 1 class cấu hình mới (đặt trong `grade_select_screen.dart` hoặc file riêng, tùy Claude
Code quyết định theo chỗ đặt các cấu hình tương tự trong repo):

```dart
class GradeOption {
  final int grade;
  final String label;      // "Lớp 1"
  final String subtitle;   // "Đang phát triển — Unit 1" / "Sắp ra mắt"
  final bool enabled;      // false => onTap: null, mờ vĩnh viễn

  const GradeOption({
    required this.grade,
    required this.label,
    required this.subtitle,
    required this.enabled,
  });
}

const kGradeOptions = [
  GradeOption(grade: 1, label: 'Lớp 1', subtitle: 'Đang phát triển — Unit 1', enabled: true),
  GradeOption(grade: 2, label: 'Lớp 2', subtitle: 'Đầy đủ 16 Unit', enabled: true),
  GradeOption(grade: 3, label: 'Lớp 3', subtitle: 'Sắp ra mắt', enabled: false),
  GradeOption(grade: 4, label: 'Lớp 4', subtitle: 'Sắp ra mắt', enabled: false),
  GradeOption(grade: 5, label: 'Lớp 5', subtitle: 'Sắp ra mắt', enabled: false),
];
```

`GradeSelectScreen` chỉ `kGradeOptions.map((g) => _GradeCard(option: g, onTap: g.enabled ? () =>
Navigator.push(..., HomeScreen(grade: g.grade, ...)) : null))` — không rẽ nhánh `if (grade == 1) ...
else if (grade == 2) ...` bằng tay ở đâu cả. Ý nghĩa cho Lớp 3/4/5 sau này: khi có dữ liệu thật, bật
1 lớp mới trên giao diện là sửa đúng 1 dòng (`enabled: false → true`, cập nhật `subtitle`), không
phải sửa lại widget hay thêm nhánh điều kiện — xem thêm mục "Lớp 3/4/5 sau này" ở Context. (Lưu ý:
đây chỉ là điều kiện đủ về mặt UI — vẫn cần dữ liệu/asset thật của lớp đó tồn tại trước, xem checklist
4 bước trong mục vừa nêu.)

Nội dung từng ô, theo `kGradeOptions` ở trên:
- **Lớp 1** — `enabled: true`, chạm vào đi tới `HomeScreen(grade: 1, ...)`. Nhãn phụ "Đang phát triển
  — Unit 1" (trung thực với người dùng/phụ huynh về việc mới có 1 unit, không phải 16).
- **Lớp 2** — `enabled: true`, chạm vào đi tới `HomeScreen(grade: 2, ...)` — **hành vi y hệt hiện
  tại**, không đổi gì cả.
- **Lớp 3, Lớp 4, Lớp 5** — `enabled: false` → `onTap: null`, mờ (khóa vĩnh viễn cho tới khi có nội
  dung thật), nhãn "Sắp ra mắt".

**Quay lại đổi lớp từ Home**: thêm 1 `IconButton` mới trong `AppBar` của `HomeScreen`, cạnh nút đổi
hồ sơ đã có (icon gợi ý `Icons.swap_horiz_rounded` hoặc tương tự, tooltip "Đổi lớp học") →
`Navigator.of(context).pushReplacement(... GradeSelectScreen ...)` — dùng `pushReplacement` giống
hệt cách nút đổi hồ sơ đang làm (tránh chồng `Home` cũ trong back stack). Chiều ngược lại (từ
`GradeSelectScreen` chạm vào 1 lớp để vào `Home`) dùng `push` bình thường, để nút back tự nhiên quay
lại đúng màn chọn lớp.

**Tên hiển thị app**: `app.dart` đổi `MaterialApp.title` từ `'Tiếng Anh Lớp 2 — Global Success'`
thành tên trung lập hơn, ví dụ `'Tiếng Anh Tiểu học — Global Success'`. **Không đổi** package
Flutter (`lop2_english_app`), `applicationId` Android (`com.lop2englishapp.lop2_english_app`), hay
tên file SQLite (`lop2_english_app.sqlite`) — đây là định danh kỹ thuật, đổi sẽ khiến máy thật đang
cài bản cũ bị coi là app khác (mất sạch hồ sơ/tiến độ khi cập nhật thay vì giữ nguyên qua migration
Phase 0). Coi là "tên lịch sử" vô hại, chỉ cần tên hiển thị cho phụ huynh/trẻ là trung lập.

## Phase 2 — Sinh dữ liệu Lớp 1 Unit 1 + wiring

**`assets/data/lop1/units.json`**: sinh đủ **16 unit** (không chỉ Unit 1) — theme/phonics/wordCount
lấy từ `manifest.json` (đếm `type=core` mỗi unit) hoặc thẳng từ sheet `01_Tổng quan` file Excel Lớp
1, đã verify kỹ theo Book Map nên tin cậy được cho cả 16 unit dù chỉ Unit 1 có game chơi được. Nhờ
liệt kê đủ 16 unit ngay từ đầu, `HomeScreen(grade: 1)` sẽ tự hiện đủ lưới 16 ô — Unit 2-16 tự động
**khóa** nhờ đúng quy tắc `isUnitUnlocked` có sẵn (unit N cần unit N-1 xong), **không cần code gì
thêm** cho phần "hiện nhưng chưa chơi được". Đã kiểm tra: nếu 1 unit chưa có data (`flashByUnit[n]`
rỗng), `unit_screen.dart` tự vô hiệu nút (`count == 0 → onPressed: null`) thay vì crash — an toàn để
mở khóa dần Unit 2-16 ở các sprint sau mà không sợ vỡ Unit 1 hiện tại.

**`assets/data/lop1/games/g0{1,2,3,4,5,6,8,10}_*.json`** — chỉ 1 instance (`unit_id: 1`), 3 từ
ball/bike/book, tái dùng đúng script/logic đã sinh dữ liệu Lớp 2 (script cụ thể xem
`../03_Assets/data_json/README_data.md`, tức `05_App/03_Assets/data_json/README_data.md`, nhắc
trong `CLAUDE.md` §5) trỏ vào nguồn Lớp 1 mới:
- G01/G02/G03/G04/G08: đọc thẳng `manifest.csv` Lớp 1 (đã lọc `type=core`, `audio_ready=True`) —
  logic y hệt Lớp 2, không có gì khác biệt cần xử lý cho Unit 1 (không digraph, không số nhiều
  is/are, không từ mở rộng ở unit này).
- **G05 (Lắp ráp câu) — khác Lớp 2, đọc kỹ**: sheet `02_Giáo trình chi tiết` cột F của Excel **Lớp
  1** chứa `Mẫu câu: <câu>` + `Song:\n<lời bài hát nhiều dòng>` dạng văn bản thô — **không có sẵn các
  câu ví dụ tách rời từng dòng bullet (•)** như file Excel Lớp 2 (báo cáo Lớp 1 cố tình không tự bịa
  câu ví dụ khi không chắc, xem `08_Rà soát & Rủi ro`). Cần tự tách câu hoàn chỉnh từ khối text đó
  (cắt theo dấu `.`, loại các dòng luyện âm kiểu "B, b, ball." nếu không muốn dùng, giữ câu tự nhiên
  như "Hi, I'm Ba." / "Hi, Bill."). Unit 1 có pattern là hội thoại chào hỏi ("Hi, I'm Bill. Bye,
  Bill.") + song 2 dòng — đủ để lấy 2-4 câu cho G05.
- **G06 (Hoàn thành câu) — Unit 1 không có khuôn mẫu điền-từ tự nhiên, cần quyết định riêng**: G06
  cần 1 `pattern` chứa `"___"` ứng với TỪNG từ vựng (`MindmapItem`, xem `models.dart`) — các unit
  khác của Lớp 1 thường có mẫu câu kiểu thay-thế-được ("This is a ___." → dog/duck/desk/door đều
  hợp), nhưng **pattern riêng của Unit 1 là hội thoại tên riêng** ("Hi, I'm Bill.") — ball/bike/book
  không lắp vào đó được. Đề xuất: **bỏ qua G06 cho riêng Unit 1** (không sinh instance `unit_id: 1`
  trong `g06_mindmap.json`, `GameDef.countFor` trả 0 → nút tự vô hiệu, không crash, giống cách unit
  thiếu dữ liệu khác đã được xử lý an toàn) thay vì cố nặn 1 pattern không có thật trong SGK. Ghi rõ
  quyết định này vào `CLAUDE.md`/`BUGS_CR.md` khi xong để không ai tưởng nhầm là thiếu sót — Unit 5+
  của Lớp 1 hầu hết có mẫu câu thay-thế-được bình thường, đây là edge case riêng của Unit 1.
- G09/G12: không đụng — checkpoint chưa tới lượt Unit 1 (xem phần Phạm vi ở trên).

**`content_repository.dart`**: không cần thêm field/Map mới (đã có đủ `flashByUnit`,
`listenByUnit`, v.v. từ trước) — chỉ cần `load(grade: 1)` đọc đúng thư mục `assets/data/lop1/...`
theo Phase 0.

## Verification

Baseline như mọi sprint trước: `flutter analyze` sạch, `dart format .`, `flutter build apk --debug`.
Vì Phase 0 đụng schema DB thật lần thứ 2 (sau Sprint 3), thứ tự test **bắt buộc** trên điện thoại
thật đang có sẵn hồ sơ/tiến độ Lớp 2 cũ:

1. **Cài bản mới như bản CẬP NHẬT** (không gỡ cài lại) — xác nhận hồ sơ + sao + huy hiệu Lớp 2 cũ
   **còn nguyên** sau khi migrate `schemaVersion` 2→3 (rủi ro cao nhất, giống hệt lý do Sprint 3 đã
   cẩn thận với migration đầu tiên — lần này còn cẩn thận hơn vì đã có dữ liệu thật lâu hơn).
2. **Hồi quy Lớp 2**: toàn bộ luồng ProfileSelect → GradeSelect → Home → Unit → 12 game hiện có của
   Lớp 2 chạy y hệt trước khi có sprint này — không lệch 1 pixel/hành vi nào do việc thêm tham số
   `grade` xuyên suốt `progress_repository.dart`.
3. **Lớp 1 Unit 1 chơi được đầy đủ, đúng nội dung thật**: ball/bike/book — hình đúng, audio đúng
   (đối chiếu bằng tai, vì audio Lớp 1 mới cắt bằng thuật toán, **chưa ai nghe kiểm chứng**, xem
   `08_Rà soát & Rủi ro` mục "Cao"), G01/G02/G03/G04/G05/G08/G10 mở khóa tuần tự đúng quy tắc, G06
   vắng mặt có chủ ý ở Unit 1 (không phải lỗi).
4. **Bản đồ Lớp 1** hiện đủ 16 ô, Unit 2-16 khóa, không crash khi lỡ chạm vào ô đã khóa hoặc (giả sử
   test) khi Unit 1 đủ sao mở Unit 2 — Unit 2 phải hiện game nhưng nút vô hiệu (0 dữ liệu), không văng
   app.
5. **Chuyển lớp 2 chiều**: Home Lớp 2 → nút đổi lớp → GradeSelect → Lớp 1 → Home Lớp 1 → quay lại
   GradeSelect → Lớp 2 → đúng lại tiến độ Lớp 2 (không lẫn sao 2 lớp).
6. Lớp 3/4/5 trên GradeSelect: chạm không phản ứng, không crash.

Sau khi xong, cập nhật theo đúng thói quen dự án: `CLAUDE.md` (§2 trạng thái, §4 cấu trúc thư mục có
thêm `grade/grade_select_screen.dart`, §8 việc tiếp theo thêm "Lớp 1 Unit 2-16"), `HANDOVER.md`,
`BUGS_CR.md` (log dưới dạng CR mới), `README.md`, và `01_BasicDesign/BasicDesign_LopEnglishApp_v2.xlsx`
(sheet `03_Danh_sach_man_hinh`/`11_Dinh_nghia_ten_man_hinh` thêm dòng SCR-00, sheet
`02_Trang_thai_Sprint` thêm Sprint 4). Sprint sau lặp lại **chỉ Phase 2** của file này cho Unit 2,
rồi 3, ... 16 — Phase 0/1 chỉ làm đúng 1 lần ở sprint này cho **cơ chế** đa lớp (Lớp 1+2). Thêm Lớp
3/4/5 sau này **không cần làm lại Phase 0/1** — chỉ lặp lại Phase 2 (dữ liệu) cho lớp mới + thêm đúng
1 dòng vào `kGradeOptions` (Phase 1), xem mục "Lớp 3/4/5 sau này — plan này đã tính tới chưa?" ở đầu
file (Context).
