class Group {
  String id = '';
  String name;
  String picturePath;

  static String idField = 'id';
  static String nameField = 'name';
  static String picturePathField = 'picturePath';

  Group({this.id = '', required this.name, required this.picturePath});

  Group.fromJson(Map<String, Object?> json, String id) : this (id: id,
      name: json[nameField] == null? '': json[nameField] as String,
      picturePath: json[picturePathField] == null? '': json[picturePathField] as String);

  Map<String, Object> toJson() {
    return {
      nameField : name,
      picturePathField: picturePath
    };
  }

}