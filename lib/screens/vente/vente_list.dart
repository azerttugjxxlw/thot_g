import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:thot_g/screens/vente/panier_info.dart';
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
  late AnimationController _controller;
  bool showUpperContainer = false;
  LinkedScrollControllerGroup controllerGroup = LinkedScrollControllerGroup();

  ScrollController? headerScrollController;
  ScrollController? dataScrollController;

  late TextEditingController searchController;
  List<dynamic> filteredList = [];

  @override
  Future<List<dynamic>> getArticle() async {
    final response = await http.get(Uri.parse(API.listvent));
    var list = json.decode(response.body);
    return list;
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
                "TVA",
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
                "Prix",
                style: dashdTextaStyle,
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
            ),
            DataColumn(
              label: Text(
                "Remise Facture",
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
                DataCell(Text(data[i]['id_facture'].toString(), style: dashdTextaStyle)
                    ,onTap: () {
                      ID_articlesel =data[i]['id_facture'];
                      form();
                      showUpperContainer = true;

                    }),
                DataCell(Text(data[i]['tva'].toString(), style: dashdTextaStyle)),
                DataCell(Text(data[i]['date_facture'].toString(), style: dashdTextaStyle)),
                DataCell(Text(data[i]['prix'].toString(), style: dashdTextaStyle)),
                DataCell(Text(data[i]['remise_facture'].toString(), style: dashdTextaStyle)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Stream<int> _timerStream = Stream.periodic(Duration(seconds: 3), (i) => i);

  StreamBuilder<int> loadReservations() {
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
  form(){
    return showDialog(
        context: context, builder: (BuildContext context){
      return StatefulBuilder(builder: (context, setState){
        return AlertDialog( content:Container(
            child: Container(
                width: MediaQuery.of(context).size.width * 0.450,
                height: MediaQuery.of(context).size.height * 0.55,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: SingleChildScrollView(
                  child: Panier(),
                )
            )

        ) );
      });
    }
    );
  }
}
