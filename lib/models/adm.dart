class Adm {
  String? id;
  String? cpf;
  String? email;
  String? name;
  String? state;
  String? address;
  bool? isAdm;

  Adm({
    this.id,
    this.cpf,
    this.email,
    this.name,
    this.state,
    this.address,
    this.isAdm,
  });

  Adm.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cpf = json['cpf'];
    email = json['email'];
    name = json['name'];
    state = json['state'];
    address = json['address'];
    isAdm = json['isAdm'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cpf'] = cpf;
    data['email'] = email;
    data['name'] = name;
    data['state'] = state;
    data['address'] = address;
    data['isAdm'] = isAdm;
    return data;
  }
}
