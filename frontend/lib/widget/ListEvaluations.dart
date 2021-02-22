import 'package:doit/model/Evaluation.dart';
import 'package:doit/widget/CardListEvaluation.dart';

import 'package:flutter/material.dart';

class ListEvaluations extends StatelessWidget {
  final List<Evaluation> evaluations;
  const ListEvaluations({Key key, @required this.evaluations})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: evaluations.length,
        itemBuilder: (context, index) {
          return CardListEvaulation(id: evaluations[index].getId());
        });
  }
}
