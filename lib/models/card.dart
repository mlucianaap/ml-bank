class MyCard {
  final String? id;
  final String? idClient;
  final String nameClient;
  final String? numberCard;
  final String? cvc;
  final String dataValidity;
  final String identification;
  final String? typeCard;
  final String status;
  final bool create;
  final String? justification;

  MyCard({
    this.id,
    required this.idClient,
    required this.nameClient,
    required this.numberCard,
    required this.cvc,
    required this.dataValidity,
    required this.identification,
    this.typeCard,
    this.status = 'Esperando Avaliação',
    required this.create,
    this.justification,
  });

  factory MyCard.fromJson(Map<String, dynamic> json) {
    return MyCard(
      id: json['id'],
      idClient: json['idClient'],
      nameClient: json['nameClient'],
      numberCard: json['numberCard'],
      cvc: json['cvc'],
      dataValidity: json['dataValidity'],
      identification: json['identification'],
      typeCard: json['typeCard'],
      status: json['status'],
      create: json['create'],
      justification: json['justification'],
    );
  }

  toJson(String id) {
    return {
      'id': id,
      'idClient': idClient,
      'nameClient': nameClient,
      'numberCard': numberCard,
      'cvc': cvc,
      'dataValidity': dataValidity,
      'identification': identification,
      'typeCard': typeCard,
      'status': status,
      'create': create,
      'justification': justification,
    };
  }
}
