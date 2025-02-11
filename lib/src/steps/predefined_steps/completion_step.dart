import 'package:flutter/widgets.dart';
import 'package:survey_kit/src/result/question_result.dart';
import 'package:survey_kit/src/steps/step.dart';
import 'package:survey_kit/src/steps/identifier/step_identifier.dart';
import 'package:survey_kit/src/views/completion_view.dart';

class CompletionStep extends Step {
  final String title;
  final String text;
  final bool canCancel;

  CompletionStep({
    bool isOptional = false,
    this.canCancel = true,
    required StepIdentifier id,
    String buttonText = 'End Survey',
    required this.title,
    required this.text,
  }) : super(id: id, isOptional: isOptional, buttonText: buttonText);

  @override
  Widget createView({required QuestionResult? questionResult}) {
    return CompletionView(completionStep: this);
  }
}
