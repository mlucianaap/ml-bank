// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:mlbank/controller/card_controller.dart';
import 'package:mlbank/models/card.dart';
import 'package:mlbank/utils/constants.dart';
import 'package:provider/provider.dart';

class CardComponent extends StatelessWidget {
  final MyCard card;
  const CardComponent(this.card, {super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<CardController>(context, listen: false);
    provider.getFlag(card.identification);
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: (MediaQuery.of(context).size.width - 40) * 0.60,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Theme.of(context).primaryColor,
                  Constants.darkBlue,
                ],
              ),
              borderRadius: BorderRadius.circular(10)),
        ),
        Positioned(
          left: 20,
          top: 30,
          child: SizedBox(
            width: 55,
            child: Image.asset(
              'assets/images/chip.png',
            ),
          ),
        ),
        Positioned(
          right: 20,
          top: 30,
          child: SizedBox(
            width: 50,
            child: Image.asset(
              provider.urlImage!,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        Positioned(
          left: 20,
          bottom: 30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    card.numberCard!.substring(0, 4),
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(color: Colors.white),
                  ),
                  const SizedBox(width: 30),
                  Text(
                    '****',
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(color: Colors.white),
                  ),
                  const SizedBox(width: 30),
                  Text(
                    '****',
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(color: Colors.white),
                  ),
                  const SizedBox(width: 30),
                  Text(
                    card.numberCard!.substring(15, 19),
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                card.nameClient.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
        Positioned(
          right: 20,
          bottom: 30,
          child: Text(
            card.dataValidity,
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
