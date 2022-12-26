import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mlbank/components/cardComponent.dart';
import 'package:mlbank/controller/card_controller.dart';
import 'package:mlbank/models/card.dart';
import 'package:mlbank/utils/app_routes.dart';
import 'package:mlbank/utils/constants.dart';
import 'package:mlbank/utils/validations.dart';
import 'package:provider/provider.dart';

class PreviewCard extends StatelessWidget with Validations {
  const PreviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)?.settings.arguments;
    final card = arg as MyCard;
    var provider = Provider.of<CardController>(context);

    provider.setStatus(card.status);

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
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.home,
            );
          },
          icon: const Icon(
            Icons.clear_rounded,
            size: 40,
            color: Constants.midleGrey,
          ),
        ),
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
                  provider.status!,
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
