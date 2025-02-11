import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:survey_kit/src/answer_format/date_answer_format.dart';
import 'package:survey_kit/src/controller/survey_controller.dart';
import 'package:survey_kit/src/result/question/date_question_result.dart';
import 'package:survey_kit/src/steps/predefined_steps/question_step.dart';
import 'package:survey_kit/src/views/widget/step_view.dart';

class DateAnswerView extends StatefulWidget {
  final QuestionStep questionStep;
  final DateQuestionResult? result;

  const DateAnswerView({
    Key? key,
    required this.questionStep,
    required this.result,
  }) : super(key: key);

  @override
  _DateAnswerViewState createState() => _DateAnswerViewState();
}

class _DateAnswerViewState extends State<DateAnswerView> {
  final DateFormat _dateFormat = DateFormat('E, MMM d');
  final DateTime _startDate = DateTime.now();
  late final DateAnswerFormat _dateAnswerFormat;
  DateTime? _result;

  @override
  void initState() {
    super.initState();
    _dateAnswerFormat = widget.questionStep.answerFormat as DateAnswerFormat;
    _result = widget.result?.result ?? DateTime.now();
  }

  void _handleDateChanged(DateTime date) {
    setState(() => _result = date);
  }

  @override
  Widget build(BuildContext context) {
    return StepView(
      step: widget.questionStep,
      canCancel: widget.questionStep.canCancel,
      controller: SurveyController(
        context: context,
        resultFunction: () => DateQuestionResult(
          id: widget.questionStep.id,
          startDate: _startDate,
          endDate: DateTime.now(),
          valueIdentifier: _result?.toIso8601String() ?? 'none',
          result: _result,
        ),
      ),
      title: Text(
        widget.questionStep.title,
        style: Theme.of(context).textTheme.headline5,
        textAlign: TextAlign.center,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: Text(
              widget.questionStep.text,
              style: TextStyle(
                fontSize: 18.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Platform.isAndroid ? _androidDatePicker() : _iosDatePicker(context),
        ],
      ),
    );
  }

  Widget _androidDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Stack(
            children: [
              Container(
                color: Theme.of(context).primaryColor,
                width: double.infinity,
                height: 80.0,
              ),
              Positioned(
                left: 8.0,
                bottom: 8.0,
                child: Text(
                  _result != null ? _dateFormat.format(_result!) : '',
                  style: TextStyle(
                    fontSize: 28.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          height: 300.0,
          child: CalendarDatePicker(
            firstDate: _dateAnswerFormat.minDate ??
                DateTime.now().add(Duration(days: 365 * DateTime.now().year)),
            lastDate: _dateAnswerFormat.maxDate ??
                DateTime.now().add(Duration(days: 365 * 100)),
            initialDate: _result ??
                _dateAnswerFormat.defaultDate ??
                _dateAnswerFormat.maxDate ??
                DateTime.now(),
            currentDate: _result,
            onDateChanged: (DateTime value) => _handleDateChanged(value),
          ),
        ),
      ],
    );
  }

  Widget _iosDatePicker(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.width > 350 ? 400.0 : 210.0,
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.date,
        minimumDate: _dateAnswerFormat.minDate,
        //We have to add an hour to to met the assert maxDate > initDate
        maximumDate: _dateAnswerFormat.maxDate?.add(
          Duration(hours: 1),
        ),
        initialDateTime: _dateAnswerFormat.defaultDate,
        onDateTimeChanged: (DateTime value) {
          setState(() {
            _result = value;
          });
        },
      ),
    );
  }
}
