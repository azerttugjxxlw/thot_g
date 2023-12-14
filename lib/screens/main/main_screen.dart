
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thot_g/screens/maintenance/maintenance.dart';

import '../../constants.dart';
import '../../controllers/MenuAppController.dart';
import '../../responsive.dart';
import '../dashboard/dashboard_screen.dart';
import '../parametreanalyse/parametreanalyse.dart';
import '../stk_maintenance/maintenance.dart';
import '../stockvente/StockVente.dart';
import '../vente/vente.dart';
import 'components/side_menu.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreen createState() => _MainScreen();
}
enum Gender { Maintenance, Stock_Maintenance, Ventes, Stock, Agent, Parametres}
class _MainScreen extends State<MainScreen> {
  Gender selectedGender =Gender.Maintenance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // key: context.read<MenuAppController>().scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: Drawer(
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
                        title: "Stock Maintenance ",
                        svgSrc: "assets/icons/menu_tran.svg",
                        press: () {
                          setState(() {
                            selectedGender = Gender.Stock_Maintenance;
                            currentPage = StkMaintenance();
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
                          setState(() {
                            selectedGender = Gender.Ventes;
                            currentPage = StockVente();
                          });
                        },
                      ),
                      DrawerListTile(
                        title: "Agent",
                        svgSrc: "assets/icons/menu_profile.svg",
                        press: () {},
                      ),

                      DrawerListTile(
                        title: "Paramètres",
                        svgSrc: "assets/icons/menu_setting.svg",
                        press: () {                          setState(() {
                          selectedGender = Gender.Ventes;
                          currentPage =ParametreAnalyse();
                        });},
                      ),
                    ],
                  ),
                ),
              ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: currentPage,//DashboardScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
