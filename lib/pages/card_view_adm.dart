import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mlbank/components/cardComponent.dart';
import 'package:mlbank/controller/card_controller.dart';
import 'package:mlbank/models/card.dart';
import 'package:mlbank/services/firestore_service.dart';
import 'package:mlbank/utils/constants.dart';
import 'package:mlbank/utils/validations.dart';
import 'package:provider/provider.dart';

class CardViewAdm extends StatelessWidget with Validations {
  const CardViewAdm({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final justificationController = TextEditingController();
    final arg = ModalRoute.of(context)?.settings.arguments;
    final card = arg as MyCard;
    var providerCard = Provider.of<CardController>(context);

    providerCard.setStatus(card.status);

    Future<void> submitJustification() async {
      final isValid = formKey.currentState?.validate() ?? false;

      if (!isValid) return;

      providerCard.setStatus("Reprovado");
      providerCard.setJustification(justificationController.text);

      await FirestoreService()
          .failCard(justificationController.text, card.id!)
          .then((value) => Navigator.pop(context));
    }

    Future<void> approveCard() async {
      await FirestoreService()
          .approveCard(card.id!)
          .then((value) => Navigator.pop(context));

      providerCard.setStatus("Aprovado");
    }

    void confirm() {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          contentPadding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            'Atenção!',
            style: Theme.of(context).textTheme.headline4!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          content: const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text("Você deseja realmente aprovar o cartão?"),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.ligthGrey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        padding: const EdgeInsets.all(15),
                      ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Não",
                        style: Theme.of(context).textTheme.headline5!.copyWith(
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
                    width: MediaQuery.of(context).size.width / 3,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.darkBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        padding: const EdgeInsets.all(15),
                      ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                      onPressed: approveCard,
                      child: Text(
                        "Sim",
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    void justify(BuildContext context) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          contentPadding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            'Justificativa',
            style: Theme.of(context).textTheme.headline4!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          content: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                maxLines: 7,
                controller: justificationController,
                decoration: const InputDecoration(
                    hintText: 'Descreva o porque da reprovação do cartão.'),
                validator: (justification) =>
                    isNotEmpty(justification, "A Justificativa é obrigatória."),
              ),
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    padding: const EdgeInsets.all(15),
                  ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                  onPressed: submitJustification,
                  child: Text(
                    "Enviar",
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

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
                  providerCard.status!,
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
                if (providerCard.status == "Esperando Avaliação")
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Constants.green,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            padding: const EdgeInsets.all(15),
                          ).copyWith(
                              elevation: ButtonStyleButton.allOrNull(0.0)),
                          onPressed: confirm,
                          child: Text(
                            "Aprovado",
                            style:
                                Theme.of(context).textTheme.headline5!.copyWith(
                                      color: Colors.white,
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
                            backgroundColor: Constants.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            padding: const EdgeInsets.all(15),
                          ).copyWith(
                              elevation: ButtonStyleButton.allOrNull(0.0)),
                          onPressed: () {
                            justify(context);
                          },
                          child: Text(
                            "Reprovado",
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
