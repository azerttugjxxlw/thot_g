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



class StkMaintenance extends StatefulWidget {
  const StkMaintenance({Key? key}) : super(key: key);

  @override
  State<StkMaintenance> createState() => _StkMaintenanceState();
}

class _StkMaintenanceState extends State<StkMaintenance> {

  late bool error, sending, success;
  late String msg;

  bool showUpperContainer = false;
  @override
  void reload(){
    setState(() {
        currentPage = StkMaintenance();
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

                ],
              ),
            ),const SizedBox(height: 5,),

            Container(

              child:Column(
                children: [

                  Imprespsion(reload),
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





////////////////////////////////////////////////////

}
Widget Imprespsion(reload)
{
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [

      IconButton(onPressed: (){}, icon: Icon(Icons.edit)),
      IconButton(onPressed: (){},icon: Icon(Icons.print),),
      IconButton(onPressed: (){},icon: Icon(Icons.document_scanner_sharp),),


    ],
  );
}

