/// Model dữ liệu — map trực tiếp với JSON trong assets/data.
/// Không hardcode nội dung: mọi thứ đọc từ JSON (data-driven, sheet 06).
library;

class UnitInfo {
  final int unitId;
  final String theme;
  final String phonics;
  final int wordCount;

  const UnitInfo({
    required this.unitId,
    required this.theme,
    required this.phonics,
    required this.wordCount,
  });

  factory UnitInfo.fromJson(Map<String, dynamic> j) => UnitInfo(
        unitId: j['unit_id'] as int,
        theme: j['theme'] as String,
        phonics: j['phonics'] as String,
        wordCount: j['word_count'] as int,
      );
}

/// G01 — một thẻ flashcard.
class FlashCard {
  final String wordId;
  final String word;
  final String ipa;
  final String meaningVi;
  final String image;
  final String? audio;

  const FlashCard({
    required this.wordId,
    required this.word,
    required this.ipa,
    required this.meaningVi,
    required this.image,
    this.audio,
  });

  factory FlashCard.fromJson(Map<String, dynamic> j) => FlashCard(
        wordId: j['word_id'] as String,
        word: j['word'] as String,
        ipa: j['ipa'] as String,
        meaningVi: j['meaning_vi'] as String,
        image: j['image'] as String,
        audio: j['audio'] as String?,
      );
}

/// G02 — một lựa chọn hình.
class PickOption {
  final String wordId;
  final String image;

  const PickOption({required this.wordId, required this.image});

  factory PickOption.fromJson(Map<String, dynamic> j) =>
      PickOption(wordId: j['word_id'] as String, image: j['image'] as String);
}

/// G02 — một câu hỏi nghe → chọn hình.
class ListenQuestion {
  final String wordId;
  final String promptAudio;
  final List<PickOption> options;
  final int answerIdx;

  const ListenQuestion({
    required this.wordId,
    required this.promptAudio,
    required this.options,
    required this.answerIdx,
  });

  factory ListenQuestion.fromJson(Map<String, dynamic> j) => ListenQuestion(
        wordId: j['word_id'] as String,
        promptAudio: j['prompt_audio'] as String,
        options: (j['options'] as List)
            .map((e) => PickOption.fromJson(e as Map<String, dynamic>))
            .toList(),
        answerIdx: j['answer_idx'] as int,
      );
}

/// G03 — một mục điền chữ (theo âm phonics của unit).
class FillItem {
  final String wordId;
  final String word;
  final String image;
  final String? audio;
  final List<int> hiddenIdx;
  final String answer;
  final List<String> distractors;

  const FillItem({
    required this.wordId,
    required this.word,
    required this.image,
    this.audio,
    required this.hiddenIdx,
    required this.answer,
    required this.distractors,
  });

  factory FillItem.fromJson(Map<String, dynamic> j) => FillItem(
        wordId: j['word_id'] as String,
        word: j['word'] as String,
        image: j['image'] as String,
        audio: j['audio'] as String?,
        hiddenIdx: (j['hidden_idx'] as List).map((e) => e as int).toList(),
        answer: j['answer'] as String,
        distractors:
            (j['distractors'] as List).map((e) => e as String).toList(),
      );
}

/// G04 — một từ để xếp lại từ các chữ cái xáo trộn.
class ScrambleItem {
  final String wordId;
  final String word;
  final String image;
  final String? audio;

  const ScrambleItem({
    required this.wordId,
    required this.word,
    required this.image,
    this.audio,
  });

  factory ScrambleItem.fromJson(Map<String, dynamic> j) => ScrambleItem(
        wordId: j['word_id'] as String,
        word: j['word'] as String,
        image: j['image'] as String,
        audio: j['audio'] as String?,
      );
}

/// G05 — một câu ví dụ để lắp ráp lại theo đúng thứ tự token.
class SentenceItem {
  final String sentence;
  final List<String> tokens;
  final String? audio;

  const SentenceItem({
    required this.sentence,
    required this.tokens,
    this.audio,
  });

  factory SentenceItem.fromJson(Map<String, dynamic> j) => SentenceItem(
        sentence: j['sentence'] as String,
        tokens: (j['tokens'] as List).map((e) => e as String).toList(),
        audio: j['audio'] as String?,
      );
}

/// G06 — một lựa chọn hình trong mindmap (giống [PickOption] nhưng có thêm
/// chữ + audio riêng để trẻ chạm nghe từng lựa chọn).
class MindmapOption {
  final String wordId;
  final String word;
  final String image;
  final String? audio;

  const MindmapOption({
    required this.wordId,
    required this.word,
    required this.image,
    this.audio,
  });

  factory MindmapOption.fromJson(Map<String, dynamic> j) => MindmapOption(
        wordId: j['word_id'] as String,
        word: j['word'] as String,
        image: j['image'] as String,
        audio: j['audio'] as String?,
      );
}

/// G06 — một câu mẫu khuyết 1 từ (`pattern` chứa "___"), chạm hình đúng để
/// điền từ hoàn thành câu. `audio` là audio "Mẫu câu" dùng chung cả unit
/// (giống [SentenceItem]) — chưa có audio cắt riêng từng câu.
class MindmapItem {
  final String wordId;
  final String pattern;
  final List<MindmapOption> options;
  final int answerIdx;
  final String? audio;

  const MindmapItem({
    required this.wordId,
    required this.pattern,
    required this.options,
    required this.answerIdx,
    this.audio,
  });

  factory MindmapItem.fromJson(Map<String, dynamic> j) => MindmapItem(
        wordId: j['word_id'] as String,
        pattern: j['pattern'] as String,
        options: (j['options'] as List)
            .map((e) => MindmapOption.fromJson(e as Map<String, dynamic>))
            .toList(),
        answerIdx: j['answer_idx'] as int,
        audio: j['audio'] as String?,
      );
}

/// G09 — một cặp hình-từ dùng cho Fun Time (memory match). Sinh 2 thẻ (1 thẻ
/// hình + 1 thẻ chữ) từ mỗi mục — xem memory_match_screen.dart.
class MemoryPairItem {
  final String wordId;
  final String word;
  final String image;
  final String? audio;

  const MemoryPairItem({
    required this.wordId,
    required this.word,
    required this.image,
    this.audio,
  });

  factory MemoryPairItem.fromJson(Map<String, dynamic> j) => MemoryPairItem(
        wordId: j['word_id'] as String,
        word: j['word'] as String,
        image: j['image'] as String,
        audio: j['audio'] as String?,
      );
}

/// G10 (đổi mới, CR-020) — 1 câu hỏi nghe & chọn đúng từ vựng vừa nghe. Đáp
/// án là CHỮ (từ vựng của bài), không phải hình như G02 — `options[]` gộp từ
/// vựng của unit hiện tại + unit liền trước (Unit 1 dùng 3 đại từ You/He/She
/// thay cho "unit trước", xem content_repository.dart/gen script). `word` chỉ
/// để tiện debug/xem lại dữ liệu, màn hình không hiển thị (lộ đáp án). `image`
/// (CR-022) dùng cho màn "phần thưởng" cuối bài (câu hỏi đầu tiên của unit) —
/// khôi phục tiêu chí "săn chữ có thưởng" (F11) sau khi đổi cơ chế CR-020.
class WordHuntQuestion {
  final String wordId;
  final String word;
  final String image;
  final String promptAudio;
  final List<String> options;
  final int answerIdx;

  const WordHuntQuestion({
    required this.wordId,
    required this.word,
    required this.image,
    required this.promptAudio,
    required this.options,
    required this.answerIdx,
  });

  factory WordHuntQuestion.fromJson(Map<String, dynamic> j) => WordHuntQuestion(
        wordId: j['word_id'] as String,
        word: j['word'] as String,
        image: j['image'] as String,
        promptAudio: j['prompt_audio'] as String,
        options: (j['options'] as List).map((e) => e as String).toList(),
        answerIdx: j['answer_idx'] as int,
      );
}

/// G12 — 1 lựa chọn trong Boss Quiz: hoặc hình (câu hỏi gốc G02) hoặc chữ
/// (câu hỏi gốc G03/G05) — màn hình tự chọn hiển thị theo trường nào có giá
/// trị, không cần biết nguồn gốc game.
class BossQuizOption {
  final String? image;
  final String? text;

  const BossQuizOption({this.image, this.text});

  factory BossQuizOption.fromJson(Map<String, dynamic> j) => BossQuizOption(
        image: j['image'] as String?,
        text: j['text'] as String?,
      );
}

/// G12 — 1 câu hỏi Boss Quiz, trộn từ dữ liệu đã có của G02 (nghe chọn
/// hình)/G03 (điền chữ)/G05 (lắp câu) — xem `sourceGame` chỉ để log/debug,
/// không ảnh hưởng cách hiển thị. Đúng 1 trong 3 cặp (`promptAudio` /
/// `promptText`+`promptImage` / `promptText` riêng) có giá trị tùy nguồn.
class BossQuizQuestion {
  final String sourceGame;
  final int unitId;
  final String? promptText;
  final String? promptAudio;
  final String? promptImage;
  final List<BossQuizOption> options;
  final int answerIdx;

  const BossQuizQuestion({
    required this.sourceGame,
    required this.unitId,
    this.promptText,
    this.promptAudio,
    this.promptImage,
    required this.options,
    required this.answerIdx,
  });

  factory BossQuizQuestion.fromJson(Map<String, dynamic> j) => BossQuizQuestion(
        sourceGame: j['source_game'] as String,
        unitId: j['unit_id'] as int,
        promptText: j['prompt_text'] as String?,
        promptAudio: j['prompt_audio'] as String?,
        promptImage: j['prompt_image'] as String?,
        options: (j['options'] as List)
            .map((e) => BossQuizOption.fromJson(e as Map<String, dynamic>))
            .toList(),
        answerIdx: j['answer_idx'] as int,
      );
}
