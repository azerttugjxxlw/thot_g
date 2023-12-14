import 'package:flutter/material.dart';

class TotalCard extends StatelessWidget {
  TotalCard({required this.colour, required this.cardChild, required this.title});

  final Color colour;
  final Widget cardChild;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: [
          Center(
            child: Text(title),
          ),
          Container(
            height: 50,
            width: 200,
            child: cardChild,
            margin: EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              border:Border.all(
                  color: Colors.black,
                  width: 2.0,
                  style: BorderStyle.solid
              ) ,
              color: colour,
              borderRadius: BorderRadius.circular(10.0),

            ),
          ),
        ],
      )
    );
  }
}