
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:thot_g/screens/dashboard/dashboard_screen.dart';
import 'package:thot_g/screens/maintenance/maintenance.dart';


const primaryColor = Color(0xFF2697FF);
const secondaryColor = Color(0xFF05011E);
const bgColor = Color(0xFF05011E);
const kTiroirColor = Color(0xFF05011E);
const kdashdcolor = Color(0xFFFFFFFF);
Widget currentPage = Maintenance();
const defaultPadding = 16.0;
int? ID_articlesel;
bool _isDialogOpen = false;

final columnTextStyle = GoogleFonts.josefinSans(textStyle: TextStyle(color: secondaryColor));
final dashdTextaStyle = TextStyle(color: Colors.black,fontSize: 16);
final dashdTextaStylewhifte = TextStyle(color: Colors.white,fontSize: 16);
final labelstyle =TextStyle(
  color: Colors.black, // Change the color to your preference
  fontSize: 16.0, // Change the font size to your preference
  fontWeight: FontWeight.bold, // Add any additional styling you need
);
