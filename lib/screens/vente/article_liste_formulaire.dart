
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


import '../../api_connection/api_connection.dart';
import '../../constants.dart';


//client



DateTime now = DateTime.now();
var formattedDate = DateFormat('yyyy-MM-dd').format(now);
double tva= 0.18;
double prix=0.0;
double prixt = 0.0;
var date_facture;

TextEditingController remise_facture = TextEditingController();
//panier
double qt_article = 0;
int CE_article=0;
double upprix=0.0;
String nomarticle='';

class formulaire extends StatefulWidget {
  const formulaire({Key? key}) : super(key: key);

  @override
  State<formulaire> createState() => _formulaireState();
}

class _formulaireState extends State<formulaire> {

  late bool error, sending, success;
  late String msg;
   var productList = [];

  List<Product> _cartItems = [];


  void _fetchProducts() async {
    final response = await http.get(Uri.parse(API.listarticleapi));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _cartItems = data.map((item) => Product(item['id_article'], item['Nom_article'].toString() , item['prix_up'].toDouble(), item['qteStock'].toDouble(), 0.0)).toList();
      });
    }
  }

  void _updateQuantity(int index, double newQuantity) {
    setState(() {
      _cartItems[index].quantity = newQuantity;
    });
  }

  double _calculateTotal() {

    double total = 0;
    for (var item in _cartItems) {
      total += item.prix_up * item.quantity ;
    }
    return total;
  }

  @override
  void initState() {
    _fetchProducts();
    super.initState();

  }
  @override
  void reload(){
    setState(() {
      currentPage = const formulaire();
    });
  }

  Future<void> sendData() async {
    final url = Uri.parse(API.addvent);
    for (var item in _cartItems) {
   //   int index = _cartItems.indexOf(item);


      if(item.quantity > 0){
        //  productList.add(item);
        nomarticle= item.Nom_article;
        qt_article= item.quantity;
        CE_article = item.id_article;
        upprix =item.prix_up;
        productList.add({'nom': CE_article, 'quantite': qt_article, 'nomarticle': nomarticle,'upprix':upprix});
      } }
    final response = await http.post(
      url,
      body: json.encode({

        //facture

        'date_facture':date_facture.toString(),
        'prix':prixt.toString(),
        'tva':tva.toString(),
        'remise_facture':remise_facture.text.toString(),
        'panier':productList}),
      headers: {'Content-Type': 'application/json'},
    );


    if (response.statusCode == 200) {
      //print('Données envoyées avec succès');

    } else {
     // print('Erreur lors de l\'envoi des données');

    }
  }

  // void addProduct() {}

  Widget build(BuildContext context) {
    prix=_calculateTotal();
   // prixt=( prix+(prix * 0.18));
    prixt=prix;
    date_facture=formattedDate;
    return Container(
        alignment: Alignment.center,
        width: 800,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.550,
          height: MediaQuery.of(context).size.height * 0.65,
          padding: const EdgeInsets.fromLTRB(55, 0, 5, 5), //content padding inside button

          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),

          child:Row(
            children:<Widget> [
              Expanded(

                child: ListView.builder(
                  itemCount: _cartItems.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('${_cartItems[index].Nom_article}   QteStock: ${_cartItems[index].qteStock}',style: dashdTextaStyle),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Price: ${_cartItems[index].prix_up.toStringAsFixed(2)}cfa',style: dashdTextaStyle),
                          TextField(
                            decoration: const InputDecoration(labelText: 'Quantity'),style: dashdTextaStyle,
                            keyboardType: TextInputType.number,
                            onChanged: (newValue) {
                              _updateQuantity(index, double.parse(newValue));

                            },
                          ),
                        ],
                      ),

                    );
                  },
                ),
              ),

              Expanded(
                  child: Column(
                    children:<Widget> [

                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                        width: MediaQuery.of(context).size.width * 0.21,
                        height:MediaQuery.of(context).size.width * 0.23,
                        decoration:  BoxDecoration(

                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            )
                        ),
                        child:Container(
                            child: Column(
                              children:<Widget> [
                                Container(
                                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                  width: MediaQuery.of(context).size.width * 0.23,
                                  height: 50,
                                  child: TextFormField(
                                    controller: remise_facture,style: dashdTextaStyle,
                                    validator: (value){
                                      if(value!.isEmpty){
                                        return "Champ vide";
                                      }
                                    },
                                    keyboardType: TextInputType.number,
                                    maxLines: 1,
                                    minLines: 1,
                                    decoration: new InputDecoration(
                                      hintText: "Remise : ",hintStyle: dashdTextaStyle,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                  width: MediaQuery.of(context).size.width * 0.23,
                                  height: 50,
                                  child:  Text("TVA :18%",style: dashdTextaStyle),
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                  width: MediaQuery.of(context).size.width * 0.23,
                                  height: 50,
                                  child: Text("Prix Hors Taxe : ${prix.toStringAsFixed(2)} cfa",style: dashdTextaStyle),
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                  width: MediaQuery.of(context).size.width * 0.23,
                                  height: 50,

                                  child: Text( 'Total: ${prixt.toStringAsFixed(2)} cfa',style: dashdTextaStyle),
                                ),
                              ],
                            )
                        ),
                      ),
                      const SizedBox(height: 35,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [

                          ElevatedButton(
    style: ElevatedButton.styleFrom(
    primary: kTiroirColor, //background color of button
    side: const BorderSide(width:3, color:Colors.brown), //border width and color
    elevation: 3, //elevation of button
    shape: RoundedRectangleBorder( //to set border radius to button
    borderRadius: BorderRadius.circular(30)
    ),
    padding: const EdgeInsets.all(20) //content padding inside button
    ),

    onPressed: () {
                              setState(() {
                                //addProduct();
                                sending = true;

                                sendData();
                                productList.clear();
                                remise_facture.clear();
                                prix=0;
                                date_facture=formattedDate;
                                Navigator.of(context).pop();
                              });
                            },
                            child: const Text(
                              "Enregistre",
                              style: const TextStyle(color: Colors.white),
                            ),

                          ),
                          const SizedBox(height: 15,),
                        ],
                      )
                    ],
                  )
              ),




            ],

          ),
        ),
      );
  }


}
//
class Product {
  final int id_article;
  final String Nom_article;
  final double prix_up;
  final double qteStock;
  double quantity;


  Product(this.id_article, this.Nom_article, this.prix_up, this.qteStock, this.quantity);


}