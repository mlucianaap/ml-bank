import 'package:flutter/material.dart';
import 'package:mlbank/controller/card_controller.dart';
import 'package:mlbank/models/card.dart';
import 'package:mlbank/utils/app_routes.dart';
import 'package:mlbank/utils/constants.dart';
import 'package:provider/provider.dart';

class CardItemClient extends StatelessWidget {
  final MyCard card;

  const CardItemClient(
    this.card, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<CardController>(context);

    final matchedText = '..${card.numberCard!.substring(15, 19)}';

    provider.getFlag(card.identification);

    return ListTile(
      contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
      leading: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Constants.ligthGrey,
        ),
        child: SizedBox(
          width: 30,
          child: Image.asset(
            provider.urlImage!,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
      title: Text(
        card.identification,
        style: Theme.of(context)
            .textTheme
            .headline4!
            .copyWith(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        matchedText,
        style: Theme.of(context)
            .textTheme
            .headline4!
            .copyWith(color: Constants.midleGrey),
      ),
      trailing: SizedBox(
        width: 100,
        child: Text(
          textAlign: TextAlign.center,
          card.status,
          style: TextStyle(color: provider.getColor(card.status)),
        ),
      ),
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRoutes.cardViewClient,
          arguments: card,
        );
      },
    );
  }
}
