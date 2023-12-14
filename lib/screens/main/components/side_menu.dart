import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';
import '../../maintenance/maintenance.dart';
import '../../vente/vente.dart';

class SideMenu extends StatefulWidget {
  @override
  _SideMenu createState() => _SideMenu();
}
enum Gender { Maintenance, Ventes, Stock, Parametres}
class _SideMenu extends State<SideMenu> {

  Gender selectedGender =Gender.Maintenance;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: kTiroirColor,
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),
          DrawerListTile(
            title: "Maintenance",
            svgSrc: "assets/icons/2639855_maintenance_icon.svg",
            press: () {
              setState(() {
                selectedGender = Gender.Maintenance;
                currentPage = Maintenance();
              });
            },
          ),
          DrawerListTile(
            title: "Vente",
            svgSrc: "assets/icons/menu_task.svg",
            press: () { setState(() {
              selectedGender = Gender.Ventes;
              currentPage = Vente();
            });},
          ),
          DrawerListTile(
            title: "Stock Vente",
            svgSrc: "assets/icons/menu_doc.svg",
            press: () {

            },
          ),

          DrawerListTile(
            title: "Paramètres",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () {},
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: ColorFilter.mode(Colors.white54, BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
