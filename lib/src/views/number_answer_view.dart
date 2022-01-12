import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:survey_kit/src/answer_format/number_answer_format.dart';
import 'package:survey_kit/src/controller/survey_controller.dart';
import 'package:survey_kit/src/views/decoration/input_decoration.dart';
import 'package:survey_kit/src/result/question/number_question_result.dart';
import 'package:survey_kit/src/steps/predefined_steps/question_step.dart';
import 'package:survey_kit/src/views/widget/step_view.dart';

class NumberAnswerView extends StatefulWidget {
  final QuestionStep questionStep;
  final NumberQuestionResult? result;

  const NumberAnswerView({
    required this.questionStep,
    required this.result,
  });

  @override
  _NumberAnswerViewState createState() => _NumberAnswerViewState();
}

class _NumberAnswerViewState extends State<NumberAnswerView> {
  late NumberAnswerFormat _integerAnswerFormat;
  late final TextEditingController _controller;
  late DateTime _startDate;

  bool _isValid = false;
  bool _isDouble = false;

  @override
  void initState() {
    super.initState();
    _integerAnswerFormat =
        widget.questionStep.answerFormat as NumberAnswerFormat;
    _controller = TextEditingController();
    _controller.text = widget.result?.result?.toString() ?? '';
    _checkValidation(_controller.text);
    _isDouble = _integerAnswerFormat.step is double;
    _startDate = DateTime.now();
  }

  @override
  void didUpdateWidget(covariant NumberAnswerView oldWidget) {
    if (oldWidget.questionStep.id.id != widget.questionStep.id.id) {
      _controller.text = widget.result?.result?.toString() ?? '';
      _checkValidation(_controller.text);
      _integerAnswerFormat =
          widget.questionStep.answerFormat as NumberAnswerFormat;
      _isDouble = _integerAnswerFormat.step is double;
      _startDate = DateTime.now();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _checkValidation(String text) {
    setState(() {
      _isValid = text.isNotEmpty &&
          (_isDouble
              ? double.tryParse(text) != null
              : int.tryParse(text) != null);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("DOUBLE: " + (_integerAnswerFormat.step is double).toString());
    print("INT: " + (_integerAnswerFormat.step is int).toString());
    return StepView(
      step: widget.questionStep,
      canCancel: widget.questionStep.canCancel,
      controller: SurveyController(
        context: context,
        resultFunction: () => NumberQuestionResult(
          id: widget.questionStep.id,
          startDate: _startDate,
          endDate: DateTime.now(),
          valueIdentifier: _controller.text,
          result: num.tryParse(_controller.text) ??
              _integerAnswerFormat.defaultValue ??
              null,
        ),
      ),
      isValid: widget.questionStep.isOptional || _isValid,
      title: Text(
        widget.questionStep.title,
        style: Theme.of(context).textTheme.headline5,
        textAlign: TextAlign.center,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: TextField(
            controller: _controller,
            onChanged: (String value) {
              _checkValidation(value);
            },
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              _isDouble
                  ? FilteringTextInputFormatter.allow(
                      RegExp(r'([0-9]+([.][0-9]*)?|[.][0-9]+)'))
                  : FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            textAlign: TextAlign.center,
            decoration: textFieldInputDecoration(
              hint: _integerAnswerFormat.hint,
            ),
          ),
        ),
      ),
    );
  }
}
