import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../api_connection/api_connection.dart';
import '../../constants.dart';

//client
TextEditingController nom_client = TextEditingController();
TextEditingController prenom_client = TextEditingController();
TextEditingController num = TextEditingController();

int? bon=1;
DateTime now = DateTime.now();
var formattedDate = DateFormat('yyyy-MM-dd').format(now);
double tva= 0.18;
double prix=0.0;
double prixt = 0.0;
var date_facture;
int? idetr_employe= 1 ;
//int? idetr_employe;
TextEditingController remise_facture = TextEditingController();
String nom = '';
String prenom='';
//panier
double qt_article = 0;
int CE_article=0;
double upprix=0.0;
String nomarticle='';
class FomulaireVente extends StatefulWidget {
  @override
  _FomulaireVenteState createState() => _FomulaireVenteState();
}
class _FomulaireVenteState extends State<FomulaireVente> with TickerProviderStateMixin {




  @override
  void initState() {
    super.initState();
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
            children:<Widget> [

              Container(
                padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                width: MediaQuery.of(context).size.width * 0.23,
                height: 50,
                child: TextFormField(
                  controller: nom_client,
                  onChanged: (valu){
                    setState(() {
                      nom = valu;
                    });
                  },
                  validator: (value){
                    if(value!.isEmpty){
                      return "Champ vide";
                    }
                  },
                  keyboardType: TextInputType.name,
                  maxLines: 1,
                  minLines: 1,
                  decoration: new InputDecoration(
                    hintText: "Nom du client : ",
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                width: MediaQuery.of(context).size.width * 0.23,
                height: 50,
                child: TextFormField(
                  controller: prenom_client,
                  onChanged: (valu){
                    setState(() {
                      prenom = valu;
                    });
                  },
                  validator: (value){
                    if(value!.isEmpty){
                      return "Champ vide";
                    }
                  },
                  keyboardType: TextInputType.name,
                  maxLines: 1,
                  minLines: 1,
                  decoration: new InputDecoration(
                    hintText: "prenom du client : ",
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                width: MediaQuery.of(context).size.width * 0.23,
                height: 50,
                child: TextFormField(
                  controller: num,
                  validator: (value){
                    if(value!.isEmpty){
                      return "Champ vide";
                    }
                  },
                  keyboardType: TextInputType.number,
                  maxLines: 1,
                  minLines: 1,
                  decoration: new InputDecoration(
                    hintText: "Tel du client : ",
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                width: MediaQuery.of(context).size.width * 0.23,
                height: 50,
                child: TextFormField(
                  controller: remise_facture,
                  validator: (value){
                    if(value!.isEmpty){
                      return "Champ vide";
                    }
                  },
                  keyboardType: TextInputType.number,
                  maxLines: 1,
                  minLines: 1,
                  decoration: new InputDecoration(
                    hintText: "Remise : ",
                  ),
                ),
              ),
              ToggleSwitch(
                minWidth: 50.0,
                cornerRadius: 5.0,
                activeBgColors: [
                  [Colors.red[800]!],
                  [Colors.green[800]!]

                ],
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.grey,
                inactiveFgColor: Colors.white,
                initialLabelIndex: 1,
                totalSwitches: 2,
                labels: ['Bon', 'Fac'],
                radiusStyle: true,
                onToggle: (index) {
                  print('switched to: $index');
                  bon = index;
                  print('bon ==  $bon');
                },
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                width: MediaQuery.of(context).size.width * 0.23,
                height: 50,
                child: const Text("TVA :18%"),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                width: MediaQuery.of(context).size.width * 0.23,
                height: 50,
                child: Text("Prix Hors Taxe : ${prix.toStringAsFixed(2)} cfa"),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                width: MediaQuery.of(context).size.width * 0.23,
                height: 50,

                child: Text( 'Total: ${prixt.toStringAsFixed(2)} cfa'),
              ),
            ],
          ),
        ),
      );
    });
  }

}
