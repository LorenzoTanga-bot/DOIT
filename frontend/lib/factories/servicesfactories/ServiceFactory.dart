import 'package:doit/services/ProjectService.dart';
import 'package:doit/services/TagService.dart';
import 'package:doit/services/UserService.dart';

abstract class ServiceFactory {
  ProjectService getProjectService();
  TagService getTagService();
  UserService getUserService();
}
