import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mlbank/components/buttom.dart';
import 'package:mlbank/components/client_item.dart';
import 'package:mlbank/controller/card_controller.dart';
import 'package:mlbank/controller/client_controller.dart';
import 'package:mlbank/models/client.dart';
import 'package:mlbank/utils/constants.dart';
import 'package:mlbank/utils/validations.dart';
import 'package:provider/provider.dart';

class ViewClients extends StatefulWidget {
  const ViewClients({super.key});

  @override
  State<ViewClients> createState() => _ViewClientsState();
}

class _ViewClientsState extends State<ViewClients> with Validations {
  @override
  Widget build(BuildContext context) {
    final providerClient =
        Provider.of<ClientController>(context, listen: false);
    final providerCard = Provider.of<CardController>(context);
    List<DocumentSnapshot> documents = [];
    TextEditingController searchController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Clientes',
          style: Theme.of(context).textTheme.headline4!.copyWith(
                color: Constants.darkBlue,
                fontWeight: FontWeight.bold,
              ),
        ),
        elevation: 0,
        toolbarHeight: MediaQuery.of(context).size.width / 6,
        iconTheme: const IconThemeData(color: Constants.darkBlue),
        actions: [
          Builder(
            builder: (context) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Constants.ligthGrey,
                ),
                child: IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip,
                ),
              ),
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              Text(
                'Estado:',
                style: Theme.of(context).textTheme.headline4,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                hint: providerClient.state != ""
                    ? Text(providerClient.state!)
                    : const Text('Estado'),
                onChanged: (String? stateSelected) {
                  providerClient.setState(stateSelected!);
                },
                items: Constants.listStates.map((String state) {
                  return DropdownMenuItem(
                    value: state,
                    child: Text(state),
                  );
                }).toList(),
              ),
              const SizedBox(height: 30),
              Text(
                'Quantidade de Cartões:',
                style: Theme.of(context).textTheme.headline4,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: searchController,
                keyboardType: TextInputType.number,
                onChanged: (value) =>
                    providerCard.setqtdCards(searchController.text.toString()),
              ),
              const SizedBox(height: 20),
              Observer(
                builder: (_) => Buttom(
                  texto: "Ordem alfabética",
                  color: providerClient.isSorted
                      ? Constants.darkBlue
                      : Constants.ligthGrey,
                  colorFont: providerClient.isSorted
                      ? Colors.white
                      : Constants.darkBlue,
                  submitForm: (_) {
                    providerClient.setSort(!providerClient.isSorted);
                  },
                ),
              ),
              const SizedBox(height: 30),
              Buttom(
                texto: "Aplicar",
                submitForm: (_) {
                  setState(() {});
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 30),
              Buttom(
                texto: "Limpar filtro",
                color: Constants.red,
                submitForm: (_) {
                  providerClient.setState('');
                  providerCard.setqtdCards('');
                  providerClient.setSort(false);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder(
        stream: providerClient.getClients(),
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
                      "Não existe nenhum cliente cadastrado!",
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
            List<Client> clients = [];
            for (var doc in snapshot.data!.docs) {
              final client =
                  Client.fromJson(doc.data() as Map<String, dynamic>);
              clients.add(client);
            }

            documents = snapshot.data!.docs;
            if (providerClient.state != null &&
                providerClient.state!.isNotEmpty) {
              clients = [];
              documents = documents
                  .where((element) => element['state'] == providerClient.state!)
                  .toList();

              for (var doc in documents) {
                final client =
                    Client.fromJson(doc.data() as Map<String, dynamic>);

                clients.add(client);
              }
            }

            if (providerCard.qtdCards != null &&
                providerCard.qtdCards!.isNotEmpty) {
              clients = [];
              documents = documents.where((clients) {
                return clients
                    .get('qtdCards')
                    .toString()
                    .contains(providerCard.qtdCards!);
              }).toList();

              for (var doc in documents) {
                final client =
                    Client.fromJson(doc.data() as Map<String, dynamic>);

                clients.add(client);
              }
            }

            if (providerClient.isSorted) {
              clients.sort((a, b) {
                return a.name!.toLowerCase().compareTo(b.name!.toLowerCase());
              });
            }

            return ListView.builder(
              itemCount: clients.length,
              padding: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ClientItem(clients[index]),
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
