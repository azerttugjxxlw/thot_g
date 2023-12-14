import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../api_connection/api_connection.dart';
import '../../constants.dart';
import '../../models/totalcard.dart';
import 'maintenance_list.dart';

TextEditingController nom = TextEditingController();
TextEditingController prix_de_maintenance  = TextEditingController();
TextEditingController num = TextEditingController();
TextEditingController description = TextEditingController();
TextEditingController marque= TextEditingController();
int? etat=1;
DateTime now =new DateTime.now();
var formattedDate =new DateFormat('yyyy-MM-dd').format(now);

TextEditingController recherche = TextEditingController();

class Maintenance extends StatefulWidget {
  const Maintenance({Key? key}) : super(key: key);

  @override
  State<Maintenance> createState() => _MaintenanceState();
}

class _MaintenanceState extends State<Maintenance> {

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
        currentPage = Maintenance();
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
                      "Maintenance",
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
                child:  MaintenanceList(),
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
   var resp =  http.post(Uri.parse(API.addmaintenanceapi),
        body: {
          "nom":nom.text.toString(),
          "prix_de_maintenance":prix_de_maintenance.text.toString(),
          "num":num.text.toString(),
          "description":description.text.toString(),
          "etat":etat.toString(),
          "marque":marque.text.toString(),
          "formattedDate":formattedDate
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
                      color: kdashdcolor,
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
                                  controller: nom,style: dashdTextaStyle,
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return "Champ vide";
                                    }
                                  },
                                  keyboardType: TextInputType.name,
                                  maxLines: 1,
                                  minLines: 1,
                                  decoration: new InputDecoration(
                                    hintText: "Nom Client : ",hintStyle: dashdTextaStyle,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                width: MediaQuery.of(context).size.width * 0.203,
                                height: 50,
                                child: TextFormField(
                                  controller: num,style: dashdTextaStyle,
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return "Champ vide";
                                    }
                                  },
                                  keyboardType: TextInputType.name,
                                  maxLines: 1,
                                  minLines: 1,
                                  decoration: new InputDecoration(
                                    hintText: "Tel : ",hintStyle: dashdTextaStyle,
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
                                controller: prix_de_maintenance,style: dashdTextaStyle,
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
                            controller:marque ,style: dashdTextaStyle,
                            validator: (value){
                              if(value!.isEmpty){
                                return "Champ vide";
                              }
                            },
                            keyboardType: TextInputType.name,
                            maxLines: 1,
                            minLines: 1,
                            decoration: new InputDecoration(
                              hintText: "Marque : ",hintStyle: dashdTextaStyle,
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
                                  nom.clear();
                                  prix_de_maintenance.clear();
                                  num.clear();
                                  marque.clear();
                                  etat=1;
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

