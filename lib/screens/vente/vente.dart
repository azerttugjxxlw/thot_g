import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../api_connection/api_connection.dart';
import '../../constants.dart';
import 'article_liste_formulaire.dart';
import 'vente_list.dart';

TextEditingController nom = TextEditingController();
TextEditingController prix_de_maintenance  = TextEditingController();
TextEditingController num = TextEditingController();
TextEditingController description = TextEditingController();
TextEditingController marque= TextEditingController();
int? etat=1;
DateTime now =new DateTime.now();
var formattedDate =new DateFormat('yyyy-MM-dd').format(now);

TextEditingController recherche = TextEditingController();

class Vente extends StatefulWidget {
  const Vente({Key? key}) : super(key: key);

  @override
  State<Vente> createState() => _VenteState();
}

class _VenteState extends State<Vente> {
  late bool error, sending, success;
  late String msg;
  bool _showForm = false;
  void _toggleFormVisibility() {
    setState(() {
      _showForm = !_showForm;
    });
  }
  bool showUpperContainer = false;
  @override
  void reload(){
    setState(() {
        currentPage = Vente();
    });
  }
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
          children:<Widget> [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height *0.09,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black45, offset: Offset(1, 1), blurRadius: 1)
                ],
                color: kdashdcolor
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Vente",
                      style:dashdTextaStyle,
                    ),
                  ),
                  Row(
                    children: [

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.add_box_rounded),
                          onPressed:(){ setState(() {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: SingleChildScrollView(
                                    child: formulaire(),
                                  ),
                                );
                              },
                            );
                          });},//_toggleFormVisibility,
                          style: ElevatedButton.styleFrom(
                            primary: const Color.fromRGBO(241, 234, 227, 1),
                            backgroundColor: const Color.fromRGBO(11, 6, 65, 1),
                          ),
                          label: Text("Nouvelle"),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),const SizedBox(height: 5,),
            Container(
              child:Column(
                children: [
                  Imprespsion(reload,_toggleFormVisibility),
                 // tableHeader()
                ],
              )
            ),


            //  const DateScreen(),

            SizedBox(width: double.infinity,height: 2,child: Container(color: Colors.black,),),
            Container(
              height: MediaQuery.of(context).size.height *0.7,
                child: MaintenanceList(),// _showForm? MaintenanceList():formulaire(),
            ),
          ],
        ),

    );
  }
  ///////////////////////////////////////////////////


  @override
  void initState() {
    error = false;
    sending = false;
    success = false;
    msg = "";

    super.initState();
  }
////////////////////////////////////////////////////




}
Widget Imprespsion(reload,VoidCallback onPressed)
{
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      IconButton(onPressed: onPressed, icon: Icon(Icons.add)),
      IconButton(onPressed: (){}, icon: Icon(Icons.edit)),
      IconButton(onPressed: (){},icon: Icon(Icons.print),),
      IconButton(onPressed: (){},icon: Icon(Icons.document_scanner_sharp),),

    ],
  );
}

