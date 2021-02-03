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
    _listUserProject = await _service.findByProjectProposer(_id);
    notifyListeners();
  }

  List<Project> getListAllProject() {
    return _listAllProject;
  }

  Future updateListAllProject() async {
    _listAllProject.clear();
    _listAllProject = await _service.getAllProject();
    notifyListeners();
  }

  Project findById(String id) {
    return _listAllProject.where((project) => project.getId() == id).first;
  }

  Future addProject(Project newProject) async {
    Project project = await _service.addProject(newProject);
    _listAllProject.add(project);
    _listUserProject.add(project);
    notifyListeners();
    return true;
  }
}
