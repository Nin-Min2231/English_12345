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
