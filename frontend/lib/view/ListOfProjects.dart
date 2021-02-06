import 'package:doit/model/Project.dart';
import 'package:doit/providers/ProjectProvider.dart';
import 'package:doit/providers/ViewProvider.dart';
import 'package:doit/view/ProjectOverView.dart';
import 'package:doit/widget/CardList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListOfProjects extends StatelessWidget {
  final List<Project> projects;
  const ListOfProjects({Key key, @required this.projects}) : super(key: key);

  String determinateState(Project project) {
    return (DateTime.parse(project.getDateOfEnd()).compareTo(DateTime.now()) ==
            1)
        ? (project.getCandidacyMode() ? "Candidacy Mode" : "In corso")
        : "Completato";
  }

  @override
  Widget build(BuildContext context) {
    if (projects.isNotEmpty)
      return ListView.builder(
          shrinkWrap: true,
          itemCount: projects.length,
          itemBuilder: (context, index) {
            return GestureDetector(
                child: CardList(
                    name: projects[index].getName(),
                    sDescription: projects[index].getShortDescription() +
                        "\n" +
                        "State :" +
                        determinateState(projects[index])),
                onTap: () {
                  Provider.of<ViewProvider>(context, listen: false)
                      .pushWidget(ProjectOverView(id: projects[index].getId()));
                });
          });
  }
}
