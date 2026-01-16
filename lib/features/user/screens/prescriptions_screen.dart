// import 'package:flutter/material.dart';
// import '../../../../core/constants/app_dimensions.dart';
// import '../widgets/document_card.dart'; // তোমার DocumentCard উইজেট
// import '../widgets/empty_state_widget.dart';

// class PrescriptionsScreen extends StatelessWidget {
//   const PrescriptionsScreen({super.key});

//   // শুধু প্রেসক্রিপশন টাইপের ডামি ডাটা
//   final List<Map<String, dynamic>> _prescriptionDocs = const [
//     {
//       'title': 'Doctor Prescription - ঠান্ডা, জ্বর ও কাশি',
//       'date': '০৫ জানুয়ারি ২০২৬',
//       'type': 'Prescription',
//       'doctor': 'Dr. Md. Rafiqul Islam',
//       'fileType': 'PNG',
//       'color': Colors.green,
//     },
//     {
//       'title': 'Prescription - High BP & Diabetes',
//       'date': '১২ ডিসেম্বর ২০২৫',
//       'type': 'Prescription',
//       'doctor': 'Dr. Fatima Begum',
//       'fileType': 'PDF',
//       'color': Colors.teal,
//     },
//     {
//       'title': 'Eye Checkup Prescription',
//       'date': '২৮ নভেম্বর ২০২৫',
//       'type': 'Prescription',
//       'doctor': 'Dr. Sabrina Akter',
//       'fileType': 'JPG',
//       'color': Colors.orangeAccent,
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;

//     final hasPrescriptions = _prescriptionDocs.isNotEmpty;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('প্রেসক্রিপশন'),
//         centerTitle: true,
//         elevation: 0,
//       ),

//       body: Column(
//         children: [
//           // সার্চ + ফিল্টার বার
//           Padding(
//             padding: const EdgeInsets.all(AppDimensions.paddingMedium),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     decoration: InputDecoration(
//                       hintText: 'প্রেসক্রিপশন খুঁজুন...',
//                       prefixIcon: const Icon(Icons.search),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
//                         borderSide: BorderSide.none,
//                       ),
//                       filled: true,
//                       fillColor: colorScheme.surfaceVariant.withOpacity(0.4),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 IconButton.filledTonal(
//                   icon: const Icon(Icons.filter_list),
//                   onPressed: () {
//                     // পরে ফিল্টার মেনু/বটমশিট যোগ করতে পারো
//                   },
//                 ),
//               ],
//             ),
//           ),

//           // প্রেসক্রিপশন লিস্ট
//           Expanded(
//             child: hasPrescriptions
//                 ? ListView.builder(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: AppDimensions.paddingMedium,
//                     ),
//                     itemCount: _prescriptionDocs.length,
//                     itemBuilder: (context, index) {
//                       final doc = _prescriptionDocs[index];
//                       return DocumentCard(
//                         title: doc['title'],
//                         date: doc['date'],
//                         type: doc['type'],
//                         // doctor: doc['doctor'], // অতিরিক্ত ডাক্তারের নাম
//                         fileType: doc['fileType'],
//                         color: doc['color'],
//                         onTap: () {
//                           // ডকুমেন্ট খোলার লজিক
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text('${doc['title']} খুলছে...')),
//                           );

//                           // পরে ডিটেইল স্ক্রিনে নিতে পারো:
//                           // Navigator.push(
//                           //   context,
//                           //   MaterialPageRoute(
//                           //     builder: (_) => DocumentDetailScreen(document: doc),
//                           //   ),
//                           // );
//                         },
//                       );
//                     },
//                   )
//                 : const EmptyStateWidget(
//                     icon: Icons.receipt_long_outlined,
//                     title: 'কোনো প্রেসক্রিপশন নেই',
//                     subtitle: 'নতুন প্রেসক্রিপশন আপলোড করুন',
//                   ),
//           ),
//         ],
//       ),

//       // নতুন প্রেসক্রিপশন যোগ করার বাটন
//       floatingActionButton: FloatingActionButton.extended(
//         heroTag: 'add_prescription',
//         onPressed: () {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('নতুন প্রেসক্রিপশন আপলোডের সুবিধা শীঘ্রই আসছে')),
//           );
//         },
//         icon: const Icon(Icons.add),
//         label: const Text('নতুন প্রেসক্রিপশন'),
//       ),
//     );
//   }
// }