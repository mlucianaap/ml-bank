import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mlbank/components/buttom.dart';
import 'package:mlbank/components/logo.dart';
import 'package:mlbank/controller/card_controller.dart';
import 'package:mlbank/controller/client_controller.dart';
import 'package:mlbank/models/card.dart';
import 'package:mlbank/utils/app_routes.dart';
import 'package:mlbank/utils/constants.dart';
import 'package:mlbank/utils/validations.dart';
import 'package:provider/provider.dart';

import '../services/firestore_service.dart';

class AddCard extends StatefulWidget {
  const AddCard({super.key});

  @override
  State<AddCard> createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> with Validations {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _numberCardController = TextEditingController();
  final _cvcController = TextEditingController();
  bool isLoading = false;

  void _showMsg(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
      ),
    );
  }

  Future<void> _requestCard(BuildContext context,
      ClientController providerClient, CardController providerCard) async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      String data = providerCard.setValidity(providerCard.validityCard!);

      MyCard card = MyCard(
        idClient: providerClient.client!.id,
        nameClient: _nameController.text,
        typeCard: providerCard.typeCard,
        numberCard: _numberCardController.text,
        cvc: _cvcController.text,
        identification: providerCard.identificationCard!,
        dataValidity: data,
        create: true,
      );

      var number = await FirestoreService()
          .loadCard('numberCard', _numberCardController.text.trim());
      var cvc =
          await FirestoreService().loadCard('cvc', _cvcController.text.trim());

      if (number.docs.isNotEmpty &&
          number.docs[0].data()['identification'] ==
              providerCard.identificationCard!) {
        _showMsg('O número do cartão já está cadastrado.', Colors.red);
        return;
      }

      if (cvc.docs.isNotEmpty &&
          cvc.docs[0].data()['identification'] ==
              providerCard.identificationCard!) {
        _showMsg('O CVC já está cadastrado.', Colors.red);
        return;
      }

      providerCard.create(card).then((value) {
        _showMsg('Cartão solicitado com sucesso!', Colors.green);
        providerCard.setqtdCardCreate();
        Navigator.of(context).pushReplacementNamed(
          AppRoutes.previewCard,
          arguments: card,
        );
      });
    } finally {
      setState(() {
        isLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var providerClient = Provider.of<ClientController>(context, listen: false);
    var providerCard = Provider.of<CardController>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Logo(),
                Text(
                  'Criar Cartão',
                  style: Theme.of(context).textTheme.headline1,
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nome Completo',
                        ),
                        validator: (name) => combine([
                          () => isNotEmpty(name, "O nome é obrigatório"),
                          () => isNameCompleteValid(name),
                        ]),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _numberCardController,
                        decoration: const InputDecoration(
                          labelText: 'Número do Cartão',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          Constants.maskCard
                        ],
                        validator: (number) => combine([
                          () => isNotEmpty(
                              number, "O número do cartão é obrigatório"),
                          () => isNumberCardValid(number),
                        ]),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _cvcController,
                        decoration: const InputDecoration(
                          labelText: 'CVC',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          Constants.maskCvc
                        ],
                        validator: (cvc) => combine([
                          () => isNotEmpty(cvc, "O CVC é obrigatório"),
                          () => isCVCValid(cvc),
                        ]),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        hint: const Text('Tipo de Cartão'),
                        onChanged: (String? typeCardSelected) {
                          providerCard.setTypeCard(typeCardSelected!);
                        },
                        items: Constants.listTypeCards.map((String card) {
                          return DropdownMenuItem(
                            value: card,
                            child: Text(card),
                          );
                        }).toList(),
                        validator: (typeCard) => isDropdownNotEmpty(
                            typeCard, 'Tipo de cartão é obrigatório'),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        hint: const Text('Identificação do cartão'),
                        onChanged: (String? identification) {
                          providerCard.setIdentificationCard(identification!);
                        },
                        items: Constants.listIdentificationCards
                            .map((String identification) {
                          return DropdownMenuItem(
                            value: identification,
                            child: Text(identification),
                          );
                        }).toList(),
                        validator: (identification) => isDropdownNotEmpty(
                            identification,
                            'Identificação do cartão é obrigatória'),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        hint: const Text('Validade'),
                        onChanged: (String? validity) {
                          providerCard.setValidityCard(validity!);
                        },
                        items: Constants.listValidityCards
                            .map((String validityCard) {
                          return DropdownMenuItem(
                            value: validityCard,
                            child: Text(validityCard),
                          );
                        }).toList(),
                        validator: (validated) => isDropdownNotEmpty(
                            validated, 'Validade é obrigatória'),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      isLoading
                          ? const CircularProgressIndicator()
                          : Buttom(
                              texto: 'Solicitar Cartão',
                              submitForm: (p0) => _requestCard(
                                  context, providerClient, providerCard),
                            ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
