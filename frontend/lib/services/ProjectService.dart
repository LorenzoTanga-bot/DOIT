import 'package:doit/model/Project.dart';

abstract class ProjectService {
  Future<Project> addProject(Project newProject);
  Future<bool> deleteProject(String id);
  Future<List<Project>> findAll();
  Future<Project> findById(String id);
  Future<List<Project>> findByIds(List<String> ids);
  Future<List<Project>> findByName(String name);
  Future<List<Project>> findByTags(List<String> tags);
  Future<ProjectsPage> getProjectsPage(int index);
  Future<Project> updateProject(Project newProject);
}

class ProjectsPage {
  List<Project> _listProject = [];
  int _totalPages;
  int _totalElements;
  bool _isLast;
  bool _isFirst;
  int _size;
  int _numberOfElements;
  int _number;

  ProjectsPage(
      this._listProject,
      this._totalPages,
      this._totalElements,
      this._isLast,
      this._isFirst,
      this._size,
      this._numberOfElements,
      this._number);

  List<Project> getListProject() {
    return _listProject;
  }

  int getTotalPages() {
    return _totalPages;
  }

  int getTotalElements() {
    return _totalElements;
  }

  bool isLast() {
    return _isLast;
  }

  bool isFirst() {
    return _isFirst;
  }

  int getSize() {
    return _size;
  }

  int getNumberOfElements() {
    return _numberOfElements;
  }

  int getNumber() {
    return _number;
  }
}
