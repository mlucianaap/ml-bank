import 'package:mlbank/utils/constants.dart';

class Client {
  String? id;
  String? cpf;
  String? name;
  String? email;
  String? phone;
  String? state;
  String? address;
  String? accountType;
  String? imageUrl;
  bool? isAdm;
  String? qtdCards;

  Client({
    this.id,
    this.cpf,
    this.name,
    this.email,
    this.phone,
    this.state,
    this.address,
    this.accountType,
    this.imageUrl = Constants.imageDefault,
    this.isAdm,
    this.qtdCards,
  });

  Client.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cpf = json['cpf'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    state = json['state'];
    address = json['address'];
    accountType = json['accountType'];
    imageUrl = json['imageUrl'];
    isAdm = json['isAdm'];
    qtdCards = json['qtdCards'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cpf'] = cpf;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['state'] = state;
    data['address'] = address;
    data['accountType'] = accountType;
    data['imageUrl'] = imageUrl;
    data['isAdm'] = isAdm;
    data['qtdCards'] = qtdCards;
    return data;
  }
}
