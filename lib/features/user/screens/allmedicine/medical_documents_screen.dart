import 'package:flutter/material.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../widgets/document_card.dart';
import '../../widgets/empty_state_widget.dart';
// import '../widgets/prescription_card.dart'; // যদি আলাদা কার্ড ব্যবহার করতে চাও

// নতুন ডিটেইল স্ক্রিন (যেখানে ডকুমেন্টের পুরো বিস্তারিত দেখাবে)
class DocumentDetailScreen extends StatelessWidget {
  final Map<String, dynamic> document;

  const DocumentDetailScreen({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    final color = document['color'] as Color;

    return Scaffold(
      appBar: AppBar(
        title: Text(document['title']),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // বড় প্রিভিউ কার্ড
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: color.withOpacity(0.4), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.description_rounded, color: color, size: 36),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          document['type'],
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    document['title'],
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 18, color: Colors.grey[700]),
                      const SizedBox(width: 8),
                      Text(document['date'], style: const TextStyle(fontSize: 15)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.file_present, size: 18, color: Colors.grey[700]),
                      const SizedBox(width: 8),
                      Text("ফাইল টাইপ: ${document['fileType']}"),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // অ্যাকশন বাটনসমূহ
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.download_rounded),
                  label: const Text('ডাউনলোড'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ডাউনলোড শুরু হয়েছে...')),
                    );
                  },
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.share_rounded),
                  label: const Text('শেয়ার'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: color,
                    side: BorderSide(color: color),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('শেয়ার ফিচার শীঘ্রই আসছে')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// মূল স্ক্রিন
class MedicalDocumentsScreen extends StatelessWidget {
  const MedicalDocumentsScreen({super.key});

  // ডামি ডাটা
  final List<Map<String, dynamic>> _dummyDocuments = const [
    {
      'title': 'Blood Test Report',
      'date': '১৫ জানুয়ারি ২০২৬',
      'type': 'Lab Report',
      'fileType': 'PDF',
      'color': Colors.blue,
    },
    {
      'title': 'Chest X-Ray',
      'date': '০৮ জানুয়ারি ২০২৬',
      'type': 'Imaging',
      'fileType': 'JPG',
      'color': Colors.redAccent,
    },
    {
      'title': 'Doctor Prescription - ঠান্ডা-জ্বর',
      'date': '০৫ জানুয়ারি ২০২৬',
      'type': 'Prescription',
      'fileType': 'PNG',
      'color': Colors.green,
    },
    {
      'title': 'ECG Report',
      'date': '২৮ ডিসেম্বর ২০২৫',
      'type': 'Cardiology',
      'fileType': 'PDF',
      'color': Colors.purple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final hasDocuments = _dummyDocuments.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('মেডিকেল ডকুমেন্ট'),
        centerTitle: true,
        elevation: 0,
      ),

      body: Column(
        children: [
          // সার্চ + ফিল্টার
          Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'ডকুমেন্ট খুঁজুন...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: colorScheme.surfaceVariant.withOpacity(0.4),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton.filledTonal(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          Expanded(
            child: hasDocuments
                ? ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingMedium,
                    ),
                    itemCount: _dummyDocuments.length,
                    itemBuilder: (context, index) {
                      final doc = _dummyDocuments[index];
                      return DocumentCard(
                        title: doc['title'],
                        date: doc['date'],
                        type: doc['type'],
                        fileType: doc['fileType'],
                        color: doc['color'],
                        onTap: () {
                          // এখানে ডিটেইল স্ক্রিনে নেয়া হচ্ছে
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DocumentDetailScreen(document: doc),
                            ),
                          );
                        },
                      );
                    },
                  )
                : const EmptyStateWidget(
                    icon: Icons.folder_open_outlined,
                    title: 'কোনো ডকুমেন্ট নেই',
                    subtitle: 'নতুন ডকুমেন্ট আপলোড করুন',
                  ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add_document',
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('নতুন ডকুমেন্ট আপলোড করার সুবিধা শীঘ্রই আসছে')),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('নতুন ডকুমেন্ট'),
      ),
    );
  }
}