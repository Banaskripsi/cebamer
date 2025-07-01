// import 'package:flutter/material.dart';

// class TahapIndikator extends StatelessWidget {
//   final String status;
//   final String tahapNama;

//   const TahapIndikator({
//     super.key,
//     required this.status,
//     required this.tahapNama,
//   });

//   @override
//   Widget build(BuildContext context) {
//     IconData icon;
//     Color color;

//     switch (status) {
//       case "Selesai":
//         icon = Icons.check_circle;
//         color = Colors.green;
//         break;
//       case "Dilewati":
//         icon = Icons.hourglass_bottom;
//         color = Colors.orange;
//         break;
//       case "Belum Selesai":
//       default:
//         icon = Icons.close;
//         color = Colors.red;
//         break;
//     }

//     return Row(
//       children: [
//         Icon(icon, color: color, size: 20),
//         const SizedBox(width: 8),
//         Text(
//           tahapNama,
//           style: TextStyle(
//             color: color,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }
// }