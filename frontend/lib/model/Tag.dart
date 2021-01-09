class Tag {
  String _id;
  String _value;

  Tag(String value) {
    _id = "00000000-0000-0000-0000-000000000000";
    this._value = value;
  }

  Tag.fromJson(String id, String value) {
    this._id = id;
    this._value = value;
  }

  String getId() {
    return _id;
  }

  String getValue() {
    return _value;
  }

  Map<String, String> toMap() {
    return {"id": _id, "value": _value};
  }
}
