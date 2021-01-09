import 'package:doit/factories/servicesfactories/ServiceFactory.dart';
import 'package:doit/services/ProjectService.dart';
import 'package:doit/services/TagService.dart';
import 'package:doit/services/UserService.dart';
import 'package:doit/services/backendservice/BackendProjectservice.dart';
import 'package:doit/services/backendservice/BackendTagService.dart';
import 'package:doit/services/backendservice/BackendUserService.dart';

class BackendServiceFactory implements ServiceFactory {
  String _ip;

  BackendServiceFactory(String ip) {
    _ip = ip;
  }
  @override
  ProjectService getProjectService() {
    return new BackEndProjectService(_ip);
  }

  @override
  TagService getTagService() {
    return new BackendTagService(_ip);
  }

  @override
  UserService getUserService() {
    return new BackendUserService(_ip);
  }
}
