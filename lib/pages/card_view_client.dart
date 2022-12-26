import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mlbank/components/buttom.dart';
import 'package:mlbank/components/cardComponent.dart';
import 'package:mlbank/controller/card_controller.dart';
import 'package:mlbank/models/card.dart';
import 'package:mlbank/utils/app_routes.dart';
import 'package:mlbank/utils/constants.dart';
import 'package:mlbank/utils/validations.dart';
import 'package:provider/provider.dart';

class CardViewClient extends StatelessWidget with Validations {
  const CardViewClient({super.key});

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)?.settings.arguments;
    final card = arg as MyCard;
    var providerCard = Provider.of<CardController>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          card.identification,
          style: Theme.of(context).textTheme.headline4!.copyWith(
                color: Constants.darkBlue,
                fontWeight: FontWeight.bold,
              ),
        ),
        elevation: 0,
        toolbarHeight: MediaQuery.of(context).size.width / 6,
        iconTheme: const IconThemeData(color: Constants.darkBlue),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Observer(
            builder: (context) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CardComponent(card),
                const SizedBox(height: 30),
                Text(
                  'Nome: ',
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  card.nameClient,
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(height: 20),
                Text(
                  'Número: ',
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  card.numberCard!,
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(height: 20),
                Text(
                  'Validade: ',
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  card.dataValidity,
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(height: 20),
                Text(
                  'CVC: ',
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  card.cvc!,
                  style: Theme.of(context).textTheme.headline4,
                ),
                card.typeCard != null
                    ? const SizedBox(height: 20)
                    : const SizedBox(),
                card.typeCard != null
                    ? Text(
                        'Função: ',
                        style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .copyWith(fontWeight: FontWeight.bold),
                      )
                    : const SizedBox(),
                card.typeCard != null
                    ? Text(
                        card.typeCard!,
                        style: Theme.of(context).textTheme.headline4,
                      )
                    : const SizedBox(),
                const SizedBox(height: 20),
                Text(
                  'Bandeira: ',
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  card.identification,
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(height: 20),
                Text(
                  'Status: ',
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  card.status,
                  style: Theme.of(context).textTheme.headline4,
                ),
                if (providerCard.status == 'Reprovado')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        'Justificativa: ',
                        style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        card.justification ?? '',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ],
                  ),
                const SizedBox(height: 30),
                Buttom(
                  texto: 'Apagar Cartão',
                  submitForm: (_) {
                    showDialog<void>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Atenção!'),
                        content:
                            const Text('Deseja realmente apagar o cartão?'),
                        actions: [
                          TextButton(
                            child: const Text('Não'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          TextButton(
                            child: const Text('Sim'),
                            onPressed: () async {
                              try {
                                providerCard.delete(card.id!);
                                Navigator.of(context).pushReplacementNamed(
                                  AppRoutes.home,
                                );
                              } catch (error) {
                                await showDialog<void>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Ocorreu um erro!'),
                                    content: const Text(
                                        'Ocorreu um erro ao apagar o cartão.'),
                                    actions: [
                                      TextButton(
                                        child: const Text('Ok'),
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  color: Constants.red,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
