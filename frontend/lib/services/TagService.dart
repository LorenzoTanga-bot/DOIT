import 'package:doit/model/Tag.dart';

abstract class TagService {
  Future<Tag> addTag(Tag newTag);
  Future<List<Tag>> findAll();
  Future<Tag> findById(String id);
  Future<List<Tag>> findByIds(List<String> ids);
}
