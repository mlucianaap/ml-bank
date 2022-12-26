import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mlbank/components/card_item_client.dart';
import 'package:mlbank/components/logo.dart';
import 'package:mlbank/controller/card_controller.dart';
import 'package:mlbank/controller/client_controller.dart';
import 'package:mlbank/models/card.dart';
import 'package:mlbank/utils/app_routes.dart';
import 'package:mlbank/utils/constants.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final client = Provider.of<ClientController>(context, listen: false);
    final cards = Provider.of<CardController>(context, listen: false);

    final firtName = client.client!.name!.split(' ')[0];

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Logo(),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.profile,
                        );
                      },
                      child: Observer(
                        builder: (ctx) => CircleAvatar(
                          radius: 25,
                          backgroundImage:
                              NetworkImage(client.client!.imageUrl!),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  'Olá, $firtName!',
                  style: Theme.of(context).textTheme.headline4,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    'Meus Cartões',
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height - 285,
                  child: StreamBuilder(
                    stream: cards.getMyCards(),
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      if (snapshot.hasData) {
                        List<MyCard> cards = [];

                        for (var doc in snapshot.data!.docs) {
                          final card = MyCard.fromJson(
                              doc.data() as Map<String, dynamic>);
                          cards.add(card);
                        }

                        return ListView.builder(
                          itemCount: cards.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                CardItemClient(cards[index]),
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
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constants.ligthGrey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          padding: const EdgeInsets.all(15),
                        ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            AppRoutes.registerCard,
                          );
                        },
                        child: Text(
                          "Cadastrar",
                          style:
                              Theme.of(context).textTheme.headline5!.copyWith(
                                    color: Constants.darkBlue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          padding: const EdgeInsets.all(15),
                        ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                        onPressed: () {
                          if (cards.qtdCardCreate > 5) {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                content: const Text(
                                    'Você atingiu o limite máximo de cartões criados.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            Navigator.of(context).pushNamed(
                              AppRoutes.addCard,
                            );
                          }
                        },
                        child: Text(
                          "Criar",
                          style:
                              Theme.of(context).textTheme.headline5!.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
