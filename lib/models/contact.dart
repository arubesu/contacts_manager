final idColumn = "id";
final nameColumn = "name";
final emailColumn = "email";
final phoneColumn = "phone";
final imgColumn = "img";

class Contact {
  int id;
  String name;
  String email;
  String phone;
  String img;

  Contact({this.id, this.name, this.email, this.phone, this.img});

  Contact.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
  }

  Map toMap() {
    return {
      idColumn: id,
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img,
    };
  }

  @override
  String toString() {
    return "Contact(id: $id, name: $name, email: $email, phone: $phone, img: $img";
  }
}
