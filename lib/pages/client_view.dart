import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mlbank/components/card_item_adm.dart';
import 'package:mlbank/controller/card_controller.dart';
import 'package:mlbank/models/card.dart';
import 'package:mlbank/models/client.dart';
import 'package:mlbank/utils/constants.dart';
import 'package:provider/provider.dart';

class ClientView extends StatelessWidget {
  const ClientView({super.key});

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)?.settings.arguments;
    final client = arg as Client;
    final cards = Provider.of<CardController>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: MediaQuery.of(context).size.width / 6,
        iconTheme: const IconThemeData(color: Constants.darkBlue),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(client.imageUrl!),
                      backgroundColor: Colors.transparent,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      client.name!,
                      style: Theme.of(context)
                          .textTheme
                          .headline4!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      client.email!,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Text(
                    'CPF: ',
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    client.cpf!,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Telefone: ',
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    client.phone!,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Estado: ',
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    client.state!,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Endereço: ',
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    client.address!,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Tipo de Conta: ',
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    client.accountType!,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Cartões: ',
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: MediaQuery.of(context).size.height - 200,
                child: StreamBuilder(
                  stream: cards.getMyCards(client.id),
                  builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: Constants.midleGrey,
                      ));
                    }
                    if (snapshot.data == null) {
                      return const SizedBox();
                    }
                    if (snapshot.data!.docs.isEmpty) {
                      return SizedBox(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                textAlign: TextAlign.center,
                                "Você não possui nenhum cartão!",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4!
                                    .copyWith(fontSize: 18),
                              ),
                              const SizedBox(height: 30),
                              Image.asset(
                                'assets/images/no_credit_cards.png',
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width * 0.4,
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (snapshot.hasData) {
                      List<MyCard> cards = [];

                      for (var doc in snapshot.data!.docs) {
                        final card =
                            MyCard.fromJson(doc.data() as Map<String, dynamic>);
                        cards.add(card);
                      }

                      return ListView.builder(
                        itemCount: cards.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              CardItemAdm(cards[index]),
                              const Divider(),
                            ],
                          );
                        },
                      );
                    }
                    return const SizedBox();
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
