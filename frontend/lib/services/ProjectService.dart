import 'package:doit/model/Project.dart';
import 'package:doit/model/Tag.dart';

abstract class ProjectService {
  Future<Project> addProject(Project newProject);
  Future<bool> deleteProject(String id);
  Future<Project> updateProject(Project newProject);
  Future<List<Project>> findAll();
  Future<Project> findById(String id);
  Future<List<Project>> findByName(String name);
  Future<List<Project>> findByTag(List<String> tags);
  
}
