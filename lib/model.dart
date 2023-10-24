final String table = 'my_table';

class ModelDatabase {
  static final id = "_id";
  static final name = "_name";
  static final age = "_age";

  static final List<String> values = [id, name, age];
}

class Model {
  final int? id;
  final int age;
  final String name;

  // Constructor
  const Model({
    this.id,
    required this.age,
    required this.name,
  });

  Model copy({
    int? id,
    int? age,
    String? name,
  }) =>
      Model(
        id: id ?? this.id, //Ternary if
        age: age ?? this.age,
        name: name ?? this.name,
      );

  static Model fromJson(Map<String, Object?> json) => Model(
        id: json[ModelDatabase.id] as int?,
        age: json[ModelDatabase.age] as int,
        name: json[ModelDatabase.name] as String,
      );

  Map<String, Object?> toJson() => {
        ModelDatabase.id: id,
        ModelDatabase.name: name,
        ModelDatabase.age: age,
      };
}
