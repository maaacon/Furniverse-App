class UserModel {
  final String name;
  final String email;
  final dynamic shippingAddress;
  final dynamic token;
  final String contactNumber;
  final String avatar;

  UserModel(
      {required this.name,
      required this.email,
      required this.shippingAddress,
      required this.token,
      required this.contactNumber,
      required this.avatar});

  factory UserModel.fromMap(Map data) {
    return UserModel(
      name: data['name'] ?? "",
      email: data['email'] ?? "",
      shippingAddress: data['shippingAddress'] ?? {},
      contactNumber: data['contactNumber'] ?? "",
      token: data['token'] ?? "",
      avatar: data['avatar'] ?? "",
    );
  }

  String getStringAddress() {
    List<String> components = [];

    if (shippingAddress['street'] != "") {
      components.add(shippingAddress['street'] ?? '');
    }
    if (shippingAddress['baranggay'] != "") {
      components.add(shippingAddress['baranggay'] ?? '');
    }
    if (shippingAddress['city'] != "") {
      components.add(shippingAddress['city'] ?? '');
    }
    if (shippingAddress['province'] != "") {
      components.add(shippingAddress['province'] ?? '');
    }
    if (shippingAddress['zipCode'] != "") {
      components.add(shippingAddress['zipCode'] ?? '');
    }

    return components.join(', ');
  }

  String getInitials() => name.isNotEmpty
      ? name.trim().split(' ').map((l) => l[0]).take(2).join()
      : '';
}
