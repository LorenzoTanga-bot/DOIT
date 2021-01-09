import 'package:doit/model/Tag.dart';

abstract class TagService {
  Future<Tag> addTag(Tag newTag);
  Future<List<Tag>> getAllTag();
}
