class User {
  final String id;
  final String name;
  final String username;
  final String email;
  final int age;
  final String sex;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.age,
    required this.sex,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      username: map['username'],
      email: map['email'],
      age: map['age'],
      sex: map['sex'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'age': age,
      'sex': sex,
    };
  }
}
