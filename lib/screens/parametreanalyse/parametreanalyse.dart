import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../api_connection/api_connection.dart';
import '../../constants.dart';
import '../../models/totalcard.dart';


class ParametreAnalyse extends StatefulWidget {
  const ParametreAnalyse({Key? key}) : super(key: key);

  @override
  State<ParametreAnalyse> createState() => _ParametreAnalyseState();
}

class _ParametreAnalyseState extends State<ParametreAnalyse> {
  String resultat='...';
  String resultatmois='...';
  String resultatv='...';
  String resultatvmois='...';
  late bool error, sending, success;
  late String msg;
  late TooltipBehavior _tooltipBehavior;
  List<SalesData> _chartData = [];
  List<SalesData> _chartDatam = [];
  Future<void> fetchNombre() async {

      final response = await http.get(Uri.parse(API.calcul));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          resultat = data['somme_prix'].toString();
          resultatmois = data['somme_prixm'].toString();

        });
      } else {
        throw Exception('Failed to load data');
      }

}
  Future<void> fetchvente() async {

    final response = await http.get(Uri.parse(API.calculv));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        resultatv = data['somme_prix'].toString();
        resultatvmois = data['somme_prixm'].toString();

      });
    } else {
      throw Exception('Failed to load data');
    }

  }
  Future<void> _getChartData() async {
    final response = await http.get(Uri.parse(API.graphe));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _chartData = data
            .map((item) => SalesData(item['mois'].toString(),
            double.parse(item['total_prix'].toString())))
            .toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }
  Future<void> _getChartDatam() async {
    final response = await http.get(Uri.parse(API.graphem));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _chartDatam = data
            .map((item) => SalesData(item['mois'].toString(),
            double.parse(item['total_prix'].toString())))
            .toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }
  bool showUpperContainer = false;
  @override
  void reload(){
    setState(() {
        currentPage = ParametreAnalyse();
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
                      "Analyse",
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
                child:   Container(
                  padding: EdgeInsets.all(defaultPadding),
                  decoration: BoxDecoration(
                    color: kTiroirColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child:Column(
                    children: [
                      Center(
                        child: Container(
                          child: SfCartesianChart(
                            primaryXAxis: CategoryAxis(),
                            title: ChartTitle(text: "Analyse Mensuelle "),
                            legend: Legend(isVisible: true),
                            tooltipBehavior: _tooltipBehavior,
                            series: <LineSeries<SalesData, String>>[
                              LineSeries<SalesData, String>(
                                  dataSource: _chartData,
                                  xValueMapper: (SalesData sales, _) => sales.month,
                                  yValueMapper: (SalesData sales, _) => sales.totalSales,
                                  dataLabelSettings: DataLabelSettings(isVisible: true)),
                              LineSeries<SalesData, String>(
                                  dataSource: _chartDatam,
                                  xValueMapper: (SalesData sales, _) => sales.month,
                                  yValueMapper: (SalesData sales, _) => sales.totalSales,
                                  dataLabelSettings: DataLabelSettings(isVisible: true))
                            ],
                          ),
                        ),
                      ),                      Row(
                        children: [
                          Expanded(
                              child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Maintenance ",
                                    style:dashdTextaStylewhifte,
                                  ),
                                  SizedBox(width: 16,height: 2,child: Container(color: Color.fromRGBO(192, 108, 132, 1),),),
                                ],
                              ),
                              Row(
                                children: [
                                  TotalCard(colour: kdashdcolor, cardChild: Center(
                                    child: Text(resultat,
                                      style:dashdTextaStyle,),
                                  ), title: 'Aujourd\'hui',),
                                  TotalCard(colour: kdashdcolor, cardChild: Center(
                                    child: Text(resultatmois,
                                      style:dashdTextaStyle,),
                                  ), title: 'Mois',)

                                ],
                              )
                            ],
                          )),
                          Expanded(child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Ventes ",
                                    style:dashdTextaStylewhifte,
                                  ),
                                  SizedBox(width: 16,height: 2,child: Container(color: Color.fromRGBO(75, 135, 185, 1),),),
                                ],
                              ),

                              Row(
                                children: [
                                  TotalCard(colour: kdashdcolor, cardChild: Center(
                                    child: Text(resultatv,
                                      style:dashdTextaStyle,),
                                  ), title: 'Aujourd\'hui',),
                                  TotalCard(colour: kdashdcolor, cardChild: Center(
                                    child: Text(resultatvmois,
                                      style:dashdTextaStyle,),
                                  ), title: 'Mois',)

                                ],
                              )
                            ],
                          )),
                          SizedBox(height: 8),

                        ],
                      )
                    ],
                  ),
                ),
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
    fetchNombre();
    fetchvente();
    _tooltipBehavior = TooltipBehavior(enable: true);
    _getChartData();
    _getChartDatam();
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
class SalesData {
  final String month;
  final double totalSales;

  SalesData(this.month, this.totalSales);
}