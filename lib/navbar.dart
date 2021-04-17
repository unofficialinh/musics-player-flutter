// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:music_player/color.dart';
//
// class NavigationBar extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 90,
//       alignment: Alignment.bottomCenter,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           NavbarItem(
//             icon: Icons.arrow_back_ios,
//           ),
//           Text(
//             'Playing Now',
//             style: TextStyle(
//                 fontSize: 20,
//                 color: darkPrimaryColor,
//                 fontWeight: FontWeight.bold),
//           ),
//           NavbarItem(
//             icon: Icons.list,
//           )
//         ],
//       ),
//     );
//   }
// }
//
// class NavbarItem extends StatelessWidget {
//   final IconData icon;
//
//   const NavbarItem({Key key, this.icon}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 40,
//       width: 40,
//       margin: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
//       decoration: BoxDecoration(
//           // boxShadow: [BoxShadow(color: darkPrimaryColor.withOpacity(0.5))],
//           color: primaryColor,
//           borderRadius: BorderRadiusDirectional.circular(10)),
//       child: Icon(
//         icon,
//         color: darkPrimaryColor,
//       ),
//     );
//   }
// }
