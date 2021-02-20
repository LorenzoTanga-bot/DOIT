import 'package:doit/model/Project.dart';
import 'package:doit/services/ProjectService.dart';
import 'package:flutter/foundation.dart';

class ProjectProvider with ChangeNotifier {
  ProjectService _service;

  List<Project> _listProjects= [];

  ProjectProvider(ProjectService service) {
    _service = service;
  }

  Future<ProjectsPage> pageListUser(int index) async {
    ProjectsPage page = await _service.getProjectsPage(index);
    _listProjects.addAll(page.getListProject());
    return page;
  }

  List<Project> getListProject() {
    return _listProjects;
  }

  Future updateListProject(List<String> ids) async {
    List<String> notFound = [];
    for (String id in ids) {
      if (_listProjects
          .where((element) => element.getId() == id)
          .isEmpty) notFound.add(id);
    }
    if (notFound.isNotEmpty)
      _listProjects.addAll(await _service.findByIds(notFound));
    notifyListeners();
  }

  Project findById(String id) {
    return _listProjects.firstWhere((element) => element.getId() == id);
  }

  List<Project> findByIds(List<String> ids) {
    List<Project> found = [];
    for (String id in ids) {
      found.add(findById(id));
    }
    return found;
  }
  Future<List<Project>> findByTags(List<String> tags) async {
    return await _service.findByTags(tags);
  }

  Future addProject(Project newProject) async {
    Project project = await _service.addProject(newProject);
    _listProjects.add(project);

    notifyListeners();
    return true;
  }

  List<Project> findByName(String name) {
    List<Project> found = [];
    for (Project project in _listProjects) {
      if (project.getName().contains(name)) {
        found.add(project);
      }
    }
    return found;
  }
}
