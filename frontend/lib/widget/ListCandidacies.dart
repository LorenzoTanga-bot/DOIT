import 'package:doit/model/Candidacy.dart';
import 'package:doit/providers/ViewProvider.dart';

import 'package:doit/widget/CardListCandidacy.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListCandidacies extends StatelessWidget {
  final List<Candidacy> candidacies;
  const ListCandidacies({Key key, @required this.candidacies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: candidacies.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              child: CardListCandidacy(candidacy: candidacies[index]),
              onTap: () {
                
              });
        });
  }
}
