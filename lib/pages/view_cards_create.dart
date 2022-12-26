import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mlbank/components/card_item_adm.dart';
import 'package:mlbank/controller/card_controller.dart';
import 'package:mlbank/models/card.dart';
import 'package:mlbank/utils/constants.dart';
import 'package:mlbank/utils/validations.dart';
import 'package:provider/provider.dart';

class ViewCardsClients extends StatefulWidget {
  const ViewCardsClients({super.key});

  @override
  State<ViewCardsClients> createState() => _ViewCardsClientsState();
}

class _ViewCardsClientsState extends State<ViewCardsClients> with Validations {
  @override
  Widget build(BuildContext context) {
    final cards = Provider.of<CardController>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Cartões Criados',
          style: Theme.of(context).textTheme.headline4!.copyWith(
                color: Constants.darkBlue,
                fontWeight: FontWeight.bold,
              ),
        ),
        elevation: 0,
        toolbarHeight: MediaQuery.of(context).size.width / 6,
        iconTheme: const IconThemeData(color: Constants.darkBlue),
      ),
      body: StreamBuilder(
        stream: cards.getCardsCreate(),
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
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        textAlign: TextAlign.center,
                        "Não existe nenhum cartão criado para ser avaliado!",
                        style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .copyWith(fontSize: 18),
                      ),
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
              final card = MyCard.fromJson(doc.data() as Map<String, dynamic>);
              cards.add(card);
            }

            return ListView.builder(
              itemCount: cards.length,
              padding: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
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
    );
  }
}
