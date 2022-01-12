import 'package:survey_kit/src/answer_format/answer_format.dart';

class NumberAnswerFormat implements AnswerFormat {
  final double? defaultValue;
  final double? max;
  final double? min;
  final num? step;
  final String hint;

  NumberAnswerFormat({
    this.defaultValue,
    this.max,
    this.min,
    required this.step,
    this.hint = '',
  });
}
