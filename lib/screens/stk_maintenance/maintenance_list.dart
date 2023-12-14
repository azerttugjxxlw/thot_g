import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../api_connection/api_connection.dart';
import '../../constants.dart';
int etatModifie=1;
int idselect=0;
class MaintenanceList extends StatefulWidget {
  @override
  _MaintenanceListState createState() => _MaintenanceListState();
}
class _MaintenanceListState extends State<MaintenanceList> with TickerProviderStateMixin {
  String resultat = "...";
  String resultata = "...";
  String resultatl = "...";
  String resultatla = "...";
  late AnimationController _controller;
  LinkedScrollControllerGroup controllerGroup = LinkedScrollControllerGroup();

  ScrollController? headerScrollController;
  ScrollController? dataScrollController;

  late TextEditingController searchController;
  List<dynamic> filteredList = [];

  @override
  Future<List<dynamic>> getArticle() async {
    final response = await http.get(Uri.parse(API.listmaintenancestkapi));
    var list = json.decode(response.body);
    return list;
  }
  Future<void> fetchNombreEmployes() async {
    final response = await http.get(Uri.parse(API.responseM));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        resultat = data['etat_1_count'].toString();
        resultata = data['etat_0_count'].toString();
        resultatl = data['livrer_1_count'].toString();
        resultatla = data['livrer_0_count'].toString();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }
  List<dynamic> filterReservations(String query, List<dynamic> reservations) {
    if (query.isEmpty) {
      return reservations;
    }

    return reservations.where((reservation) {
      return reservation['nom'].toString().toLowerCase().contains(query.toLowerCase()) ||
          reservation['marque'].toString().toLowerCase().contains(query.toLowerCase())||
          reservation['num'].toString().toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    fetchNombreEmployes();
    searchController = TextEditingController();
    headerScrollController = controllerGroup.addAndGet();
    dataScrollController = controllerGroup.addAndGet();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Center(
        child: Container(
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: kdashdcolor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  Container(
                    width: 200,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      controller: searchController,
                      style: dashdTextaStyle,
                      decoration: InputDecoration(
                        hintText: 'Recherche...',
                        hintStyle: dashdTextaStyle,
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (query) {
                        setState(() {
                          // Mettez à jour la liste filtrée lorsque l'utilisateur tape dans le champ de recherche
                          filteredList = filterReservations(query, filteredList);
                        });
                      },
                    ),
                  ),
                  Container(
                    width: 100,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child:Row(
                      children: [
                        Icon(Icons.adb,color: Colors.green,),
                        Text(resultat,style: dashdTextaStyle)
                      ],
                    )
                  ),
                  Container(
                      width: 100,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child:Row(
                        children: [
                          Icon(Icons.adb,color: Colors.red,),
                          Text(resultata,style: dashdTextaStyle)
                        ],
                      )
                  ),
                  Container(
                      width: 100,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child:Row(
                        children: [
                          Icon(Icons.library_add_check,color: Colors.green,),
                          Text(resultatl,style: dashdTextaStyle)
                        ],
                      )
                  ),
                  Container(
                      width: 100,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child:Row(
                        children: [
                          Icon(Icons.library_add_check,color: Colors.red,),
                          Text(resultatla,style: dashdTextaStyle)
                        ],
                      )
                  ),
                ],
              ),
              SizedBox(height: 10),
              Expanded(child: loadReservations()),
            ],
          ),
        ),
      );
    });
  }
  void modifieretat()  {
    var resp =  http.post(Uri.parse(API.modiffier_maintenanceapi),
        body: {
      "id_maintenance":idselect.toString(),
          "etat":etatModifie.toString(),
        }
    ); print("ok sa marche");

  }
  void modifierlivrer()  {
    var resp =  http.post(Uri.parse(API.modiffier_maintenancelapi),
        body: {
          "id_maintenance":idselect.toString(),
          "livrer":etatModifie.toString(),
        }
    );

  }
  Widget reservationList(List<dynamic> data, int dataLength) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: MaterialStateColor.resolveWith((states) => kdashdcolor),
          dataRowHeight: 35,
          headingRowHeight: 35,
          columns: [
            DataColumn(
              label: Text(
                "ID",
                style: dashdTextaStyle,
              ),
            ),
            DataColumn(
              label: Text(
                "Etat",
                style: dashdTextaStyle,
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
            ),
            DataColumn(
              label: Text(
                "Livrer",
                style: dashdTextaStyle,
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
            ),
            DataColumn(
              label: Text(
                "Date",
                style: dashdTextaStyle,
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
            ),
            DataColumn(
              label: Text(
                "Nom",
                style: dashdTextaStyle,
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
            ),
            DataColumn(
              label: Text(
                "TEL",
                style: dashdTextaStyle,
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
            ),
            DataColumn(
              label: Text(
                "Marque",
                style: dashdTextaStyle,
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
            ),
            DataColumn(
              label: Text(
                "Prix",
                style: dashdTextaStyle,
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
            ),
            DataColumn(
              label: Text(
                "Description",
                style: dashdTextaStyle,
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
            ),
          ],
          rows: List<DataRow>.generate(
            filteredList.isEmpty ? dataLength : filteredList.length,
                (i) => DataRow(
              color: MaterialStateColor.resolveWith((states) {
                return kdashdcolor;
              }),
              cells: [
                DataCell(Text(data[i]['id_maintenance'].toString(), style: dashdTextaStyle)),
                DataCell(
                  IconButton(
                    icon: Icon(Icons.adb),
                    color: data[i]['etat'] == 1 ? Colors.green : Colors.red,
                    onPressed: () {
                      setState(() {
                        if (data[i]['etat'] == 1) {
                          etatModifie = 0;
                        } else if (data[i]['etat'] == 0) {
                          etatModifie = 1;
                        }
                        idselect = data[i]['id_maintenance'];
                        modifieretat();
                      });


                    },
                  ),
                ),
                DataCell(
                  IconButton(
                    icon: Icon(Icons.library_add_check),
                    color: data[i]['livrer'] == 1 ? Colors.green : Colors.red,
                    onPressed: () {
                      setState(() {
                        if (data[i]['livrer'] == 1) {
                          etatModifie = 0;
                        } else if (data[i]['livrer'] == 0) {
                          etatModifie = 1;
                        }
                        idselect = data[i]['id_maintenance'];
                        modifierlivrer();
                      });


                    },
                  ),
                ),
                DataCell(Text(data[i]['date'].toString(), style: dashdTextaStyle)),
                DataCell(Text(data[i]['nom'].toString(), style: dashdTextaStyle)),
                DataCell(Text(data[i]['num'].toString(), style: dashdTextaStyle)),
                DataCell(Text(data[i]['marque'].toString(), style: dashdTextaStyle)),
                DataCell(Text(data[i]['prix_de_maintenance'].toString(), style: dashdTextaStyle)),
                DataCell(Text(data[i]['description'].toString(), style: dashdTextaStyle)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Stream<int> _timerStream = Stream.periodic(Duration(seconds: 3), (i) => i);

  StreamBuilder<int> loadReservations() {
    fetchNombreEmployes();
    return StreamBuilder<int>(
      stream: _timerStream,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        return FutureBuilder<List<dynamic>>(
          future: getArticle(),
          builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData) {
              int dataLength = snapshot.data!.length;
              filteredList = filterReservations(searchController.text, snapshot.data!);
              return reservationList(filteredList, filteredList.length);
            } else if (snapshot.hasError) {
              return Text('Une erreur s\'est produite.');
            } else {
              return LinearProgressIndicator();
            }
          },
        );
      },
    );
  }
}
