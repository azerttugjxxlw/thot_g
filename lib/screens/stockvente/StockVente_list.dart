import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../api_connection/api_connection.dart';
import '../../constants.dart';
int etatModifie=1;
int idselect=0;
class StockVenteList extends StatefulWidget {
  @override
  _StockVenteListState createState() => _StockVenteListState();
}
class _StockVenteListState extends State<StockVenteList> with TickerProviderStateMixin {
  late AnimationController _controller;
  LinkedScrollControllerGroup controllerGroup = LinkedScrollControllerGroup();

  ScrollController? headerScrollController;
  ScrollController? dataScrollController;

  late TextEditingController searchController;
  List<dynamic> filteredList = [];

  @override
  Future<List<dynamic>> getArticle() async {
    final response = await http.get(Uri.parse(API.listarticleapi));
    var list = json.decode(response.body);
    return list;
  }

  List<dynamic> filterReservations(String query, List<dynamic> reservations) {
    if (query.isEmpty) {
      return reservations;
    }

    return reservations.where((reservation) {
      return reservation['Nom_article'].toString().toLowerCase().contains(query.toLowerCase()) ||
          reservation['categorie'].toString().toLowerCase().contains(query.toLowerCase());
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
                style: columnTextStyle,
              ),
            ),
            DataColumn(
              label: Text(
                "Nom",
                style: columnTextStyle,
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
            ),
            DataColumn(
              label: Text(
                "Etat",
                style: columnTextStyle,
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
            ),
            DataColumn(
              label: Text(
                "Prix UP",
                style: columnTextStyle,
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
            ),
            DataColumn(
              label: Text(
                "QTE",
                style: columnTextStyle,
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
            ),
            DataColumn(
              label: Text(
                "Description",
                style: columnTextStyle,
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
            ),
            DataColumn(
              label: Text(
                "categorie ",
                style: columnTextStyle,
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
                      DataCell(Text(data[i]['id_article'].toString(), style: dashdTextaStyle)),
                      DataCell(Text(data[i]['Nom_article'].toString(), style: dashdTextaStyle)),
                      DataCell(Text(data[i]['etat_article'].toString(), style: dashdTextaStyle)),
                      DataCell(Text(data[i]['prix_up'].toString(), style: dashdTextaStyle)),
                      DataCell(Text(data[i]['qteStock'].toString(), style: dashdTextaStyle)),
                      DataCell(Text(data[i]['description'].toString(), style: dashdTextaStyle)),
                      DataCell(Text(data[i]['categorie'].toString(), style: dashdTextaStyle)),

                    ]
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
}
