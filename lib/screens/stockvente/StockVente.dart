import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../api_connection/api_connection.dart';
import '../../constants.dart';
import 'StockVente_list.dart';

TextEditingController designation = TextEditingController();
TextEditingController prix_up  = TextEditingController();
TextEditingController quantite = TextEditingController();
TextEditingController description = TextEditingController();
TextEditingController categorie= TextEditingController();
int? etat=1;
class StockVente extends StatefulWidget {
  const StockVente({Key? key}) : super(key: key);

  @override
  State<StockVente> createState() => _MaintenanceState();
}

class _MaintenanceState extends State<StockVente> {
  late bool error, sending, success;
  late String msg;
  void _toggleFormVisibility() {
    setState(() {
      form();
      showUpperContainer = true;

    });
  }
  bool showUpperContainer = false;
  @override
  void reload(){
    setState(() {
        currentPage = StockVente();
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
                      "Article",
                      style:dashdTextaStyle,
                    ),
                  ),
                  Row(
                    children: [

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.add_box_rounded),
                          onPressed: () {
                            setState(() {
                              form();
                              showUpperContainer = true;

                            });

                          },
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



            SizedBox(width: double.infinity,height: 2,child: Container(color: Colors.black,),),
            Container(
              height: MediaQuery.of(context).size.height *0.7,
                child:  StockVenteList(),
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

  void addData()  {
    var resp =  http.post(Uri.parse(API.addarticleapi),
        body: {
          "Nom_article":designation.text.toString(),
          "prix_up":prix_up.text.toString(),
          "qteStock":quantite.text.toString(),
          " description":description.text.toString(),
          "etat_article":etat.toString(),
          "categorie":categorie.text.toString(),
        }
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                          onPressed: () {
                            setState(() {
                              showUpperContainer = false;
                              Navigator.pop(context);
                            });
                          },
                          icon: const Icon(Icons.cancel_rounded,color: Color.fromRGBO(11, 6, 65, 1),)
                      ),
                    ],
                  ),

                  const SizedBox(height: 10,),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                          width: MediaQuery.of(context).size.width * 0.23,
                          height: 50,
                          child: TextFormField(
                            controller: designation,style: dashdTextaStyle,
                            validator: (value){
                              if(value!.isEmpty){
                                return "Champ vide";
                              }
                            },
                            keyboardType: TextInputType.name,
                            maxLines: 1,
                            minLines: 1,
                            decoration: new InputDecoration(
                              hintText: "Designation : ",hintStyle: dashdTextaStyle,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                          width: MediaQuery.of(context).size.width * 0.203,
                          height: 50,
                          child: TextFormField(
                            controller:categorie,style: dashdTextaStyle,
                            validator: (value){
                              if(value!.isEmpty){
                                return "Champ vide";
                              }
                            },
                            keyboardType: TextInputType.name,
                            maxLines: 1,
                            minLines: 1,
                            decoration: new InputDecoration(
                              hintText: "categorie : ",hintStyle: dashdTextaStyle,
                            ),
                          ),
                        ),

                      ]),
                  const SizedBox(height: 12,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        width: MediaQuery.of(context).size.width * 0.23,
                        height: 50,
                        child: TextFormField(
                          controller: prix_up,style: dashdTextaStyle,
                          validator: (value){
                            if(value!.isEmpty){
                              return "Champ vide";
                            }
                          },
                          keyboardType: TextInputType.name,
                          maxLines: 1,
                          minLines: 1,
                          decoration: new InputDecoration(
                            hintText: "Prix UP : ",hintStyle: dashdTextaStyle,
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
                        labels: ['Desa', 'Acti'],
                        radiusStyle: true,
                        onToggle: (index) {
                          print('switched to: $index');
                          etat = index;
                          print('etat ==  $etat');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12,),
                  Container(
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    width: MediaQuery.of(context).size.width * 0.23,
                    height: 50,
                    child: TextFormField(
                      controller: quantite,style: dashdTextaStyle,
                      validator: (value){
                        if(value!.isEmpty){
                          return "Champ vide";
                        }
                      },
                      keyboardType: TextInputType.name,
                      maxLines: 1,
                      minLines: 1,
                      decoration: new InputDecoration(
                        hintText: "Quantité : ",hintStyle: dashdTextaStyle,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Container(
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    width: MediaQuery.of(context).size.width * 0.23,
                    height: 50,
                    child: TextFormField(
                      controller: description,style: dashdTextaStyle,
                      validator: (value){
                        if(value!.isEmpty){
                          return "Champ vide";
                        }
                      },
                      keyboardType: TextInputType.name,
                      maxLines: 1,
                      minLines: 1,
                      decoration: new InputDecoration(
                        hintText: "Description : ",hintStyle: dashdTextaStyle,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: kTiroirColor, //background color of button
                            side: BorderSide(width:3, color:Colors.brown), //border width and color
                            elevation: 3, //elevation of button
                            shape: RoundedRectangleBorder( //to set border radius to button
                                borderRadius: BorderRadius.circular(30)
                            ),
                            padding: EdgeInsets.all(20) //content padding inside button
                        ),
                        onPressed: () {
                          setState(() {
                            sending = true;
                            addData();
                            showUpperContainer = false;
                            designation.clear();
                            prix_up.clear();
                            quantite.clear();
                            categorie.clear();
                            etat=1;
                            quantite.clear();
                            description.clear();
                          });
                        },
                        child: new Text(
                          "Enregistre",
                          style: TextStyle(color: Colors.white),
                        ),

                      ),
                      const SizedBox(height: 15,),
                    ],
                  )
                ],
              ),
            )

        ) );
      });
    }
    );
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

