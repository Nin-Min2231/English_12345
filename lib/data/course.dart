/// Định danh "khoá học" — Sprint 5 (CR-037, luồng "Chủ đề").
///
/// App khoá mọi thứ theo `int grade` từ Sprint 4 (đường dẫn asset/data, cột DB
/// `grade` của tiến độ + huy hiệu, tham số của AudioService/WordImage). "Chủ đề"
/// đứng ĐỒNG CẤP với các lớp nên cách rẻ và an toàn nhất là cấp cho nó một giá
/// trị `grade` riêng thay vì thêm một chiều dữ liệu mới (sẽ phải migrate DB và
/// sửa mọi nơi đang cầm `grade`).
///
/// Chọn 9: còn chỗ cho Lớp 6-8 sau này; là số dương nên mọi phép `%` (vd
/// AppColors.unitColor) vẫn hợp lệ; và nếu lỡ QUÊN branch ở đâu đó thì UI hiện
/// "Lớp 9" — sai rõ ràng, phát hiện ngay khi test, thay vì âm thầm sai.
library;

const int kTopicCourseId = 9;

bool isTopicCourse(int grade) => grade == kTopicCourseId;

/// Tên thư mục con dưới `assets/content/` và `assets/data/` cho 1 khoá học.
String courseFolder(int grade) => isTopicCourse(grade) ? 'chude' : 'lop$grade';

/// Nhãn khoá học hiện trên AppBar ("Lớp 2" / "Chủ đề").
String courseLabel(int grade) => isTopicCourse(grade) ? 'Chủ đề' : 'Lớp $grade';
