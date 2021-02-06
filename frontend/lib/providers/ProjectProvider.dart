import 'package:doit/model/Project.dart';
import 'package:doit/services/ProjectService.dart';
import 'package:flutter/foundation.dart';

class ProjectProvider with ChangeNotifier {
  ProjectService _service;
  List<Project> _listUserProject = [];
  List<Project> _listAllProject = [];

  ProjectProvider(ProjectService service) {
    _service = service;
  }

  List<Project> getListUserProject() {
    return _listUserProject;
  }

  Future updateListUserProject(String _id) async {
    _listUserProject.clear();
    for (Project project in _listAllProject) {
      if (project.getProjectProposer() == _id) _listUserProject.add(project);
    }
    notifyListeners();
  }

  List<Project> getListAllProject() {
    return _listAllProject;
  }

  Future updateListAllProject() async {
    _listAllProject.clear();
    _listAllProject.addAll(await _service.findAll());
  }

  Future updateListProject(List<String> id) async {
    for (String element in id)
      if (_listAllProject
          .where((project) => project.getId() == element)
          .isEmpty) _listAllProject.add(await _service.findById(element));
    notifyListeners();
  }

  Project findById(String id) {
    return _listAllProject.where((project) => project.getId() == id).first;
  }

  List<Project> findByIds(List<String> ids) {
    List<Project> found = [];
    for (String id in ids) {
      found
          .add(_listAllProject.where((project) => project.getId() == id).first);
    }
    return found;
  }

  Future addProject(Project newProject) async {
    Project project = await _service.addProject(newProject);
    _listAllProject.add(project);
    _listUserProject.add(project);
    notifyListeners();
    return true;
  }
}
