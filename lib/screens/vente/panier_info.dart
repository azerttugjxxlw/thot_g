
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../api_connection/api_connection.dart';
import '../../constants.dart';



class Panier extends StatelessWidget {
  Panier({
    Key? key,
  }) : super(key: key);
  @override
  Future<List<dynamic>>getPanier() async{
    final response = await http.post(Uri.parse(API.listpanierapi),
      body: {"ID_articlesel":ID_articlesel.toString(),},);
    var list = json.decode(response.body);


    return list;
  }

  @override
  void initState() {
    // TODO: implement initState
    getPanier();

  }

  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint){
      return Center(
          child: loadReservations());
    });
  }
  @override
  reservationList(data,dataLength){
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: kdashdcolor,
          borderRadius: const BorderRadius.all(Radius.circular(10),),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Panier",
              //   style: Theme.of(context).textTheme.subtitle1,
            ),
            SingleChildScrollView(
              //scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: double.infinity,

                child: DataTable(
                  horizontalMargin: 0,
                  columnSpacing: defaultPadding,
                  columns: [
                    DataColumn(
                      label: Text("Nom article", style: dashdTextaStyle),
                    ),
                    DataColumn(
                      label: Text("QTE", style: dashdTextaStyle),
                    ),

                    DataColumn(
                      label: Text("prix UP", style: dashdTextaStyle),
                    ),
                    DataColumn(
                      label: Text("Prix T", style: dashdTextaStyle),
                    ),

                  ],
                  rows: List<DataRow>.generate(
                    dataLength,
                        (i) => articleDataRow(data[i]),
                  ),
                ),
              ),
            ),
          ],
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
          future: getPanier(),
          builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData) {
              int dataLength = snapshot.data!.length;
              return reservationList(snapshot.data, dataLength);
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



  DataRow articleDataRow(var articlInfo) {

    var sto;
    sto =double.parse(articlInfo['qteStock'].toString()) ;
    double stof=sto*0.00001;
    return new DataRow(
        cells: [
          // DataCell(Text(articlInfo['id_article'].toString())),
          DataCell(Text(articlInfo['Nom_article'].toString(), style: dashdTextaStyle)),
          DataCell(Text(articlInfo['qt_article'].toString(), style: dashdTextaStyle)),
          DataCell(Text(articlInfo['prix_up'].toString(), style: dashdTextaStyle)),
          DataCell(Text(articlInfo['qteStock'].toString(), style: dashdTextaStyle)),

        ]

    );


  }
}
