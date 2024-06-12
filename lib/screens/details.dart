// import 'package:flutter/material.dart';

// class Details extends StatefulWidget {
//   const Details({super.key});

//   @override
//   State<Details> createState() => _DetailsState();
// }

// class _DetailsState extends State<Details> {
//   String data = '';
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('New Task'),
//       ),
//       body: Padding(
//           padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
//           child: Column(children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Title(color: Colors.black, child: const Text('Title')),
//                 const TextField(
//                     decoration: InputDecoration(
//                         filled: true,
//                         fillColor: Color.fromARGB(255, 239, 234, 234),
//                         contentPadding: EdgeInsets.zero,
//                         border: InputBorder.none)),
//                 Text(data)
//               ],
//             ),
//             const SizedBox(
//               height: 30,
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Title(color: Colors.black, child: const Text('Date')),
//                 const TextField(
//                     decoration: InputDecoration(
//                         filled: true,
//                         fillColor: Color.fromARGB(255, 239, 234, 234),
//                         contentPadding: EdgeInsets.zero,
//                         border: InputBorder.none))
//               ],
//             ),
//             const SizedBox(
//               height: 30,
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Title(color: Colors.blueGrey, child: const Text('Description')),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 const Text(
//                   'Build a E_ commerce Website about hand made furniture',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 30),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Title(color: Colors.black, child: const Text('Add category')),
//                 const TextField(
//                     decoration: InputDecoration(
//                         filled: true,
//                         fillColor: Color.fromARGB(255, 239, 234, 234),
//                         contentPadding: EdgeInsets.zero,
//                         border: InputBorder.none))
//               ],
//             ),
//             const SizedBox(height: 80),
//             SizedBox(
//               height: 20,
//             ),
//             SizedBox(
//               width: 350,
//               child: ElevatedButton(
//                   onPressed: () {},
//                   style: ElevatedButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(5.0),
//                       ),
//                       backgroundColor: Color.fromARGB(255, 29, 39, 179),
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 50, vertical: 20),
//                       textStyle:
//                           TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
//                   child: Text(
//                     'Create a new task',
//                     style: TextStyle(color: Colors.white),
//                   )),
//             )
//           ])),
//     );
//   }
// }
