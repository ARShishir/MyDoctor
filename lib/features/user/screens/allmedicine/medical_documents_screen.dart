import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_filex/open_filex.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../widgets/document_card.dart';
import '../../widgets/empty_state_widget.dart';

/// ===============================
/// DOCUMENT DETAIL SCREEN
/// ===============================
class DocumentDetailScreen extends StatelessWidget {
  final Map<String, dynamic> document;

  const DocumentDetailScreen({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    final Color color = document['color'];
    final String? filePath = document['filePath'];

    return Scaffold(
      appBar: AppBar(
        title: Text(document['title']),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: color.withOpacity(0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                document['title'],
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text("টাইপ: ${document['type']}"),
              Text("তারিখ: ${document['date']}"),
              Text("ফাইল টাইপ: ${document['fileType']}"),
              const Spacer(),

              /// OPEN FILE BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('ফাইল দেখুন / খুলুন'),
                  onPressed: () async {
                    if (filePath == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('এই ডকুমেন্টে কোনো ফাইল নেই'),
                        ),
                      );
                      return;
                    }

                    final file = File(filePath);
                    if (!file.existsSync()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('ফাইলটি পাওয়া যায়নি'),
                        ),
                      );
                      return;
                    }

                    final result = await OpenFilex.open(filePath);

                    if (result.type != ResultType.done) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('ফাইল খোলা যায়নি: ${result.message}'),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ===============================
/// ADD DOCUMENT DIALOG
/// ===============================
class AddDocumentDialog extends StatefulWidget {
  const AddDocumentDialog({super.key});

  @override
  State<AddDocumentDialog> createState() => _AddDocumentDialogState();
}

class _AddDocumentDialogState extends State<AddDocumentDialog> {
  final _titleController = TextEditingController();
  final _typeController = TextEditingController();
  final _dateController = TextEditingController();

  Color _selectedColor = Colors.blue;
  PlatformFile? _selectedFile;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('নতুন ডকুমেন্ট যোগ করুন'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'ডকুমেন্ট নাম'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _typeController,
              decoration: const InputDecoration(labelText: 'টাইপ'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(labelText: 'তারিখ'),
            ),
            const SizedBox(height: 16),

            OutlinedButton.icon(
              onPressed: _pickFile,
              icon: const Icon(Icons.upload_file),
              label: const Text('ফাইল নির্বাচন করুন'),
            ),

            if (_selectedFile != null) ...[
              const SizedBox(height: 8),
              Text(
                'Selected: ${_selectedFile!.name}',
                style: const TextStyle(fontSize: 13),
              ),
            ],

            const SizedBox(height: 16),

            DropdownButtonFormField<Color>(
              value: _selectedColor,
              decoration:
                  const InputDecoration(labelText: 'কালার নির্বাচন করুন'),
              items: const [
                DropdownMenuItem(value: Colors.blue, child: Text('Blue')),
                DropdownMenuItem(
                    value: Colors.redAccent, child: Text('Red')),
                DropdownMenuItem(value: Colors.green, child: Text('Green')),
                DropdownMenuItem(
                    value: Colors.purple, child: Text('Purple')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedColor = value!;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('বাতিল'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_titleController.text.isEmpty || _selectedFile == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('সব তথ্য পূরণ করুন')),
              );
              return;
            }

            Navigator.pop(context, {
              'title': _titleController.text,
              'type': _typeController.text,
              'date': _dateController.text,
              'fileType':
                  _selectedFile!.extension?.toUpperCase() ?? '',
              'filePath': _selectedFile!.path,
              'color': _selectedColor,
            });
          },
          child: const Text('সংরক্ষণ'),
        ),
      ],
    );
  }
}

/// ===============================
/// MAIN MEDICAL DOCUMENT SCREEN
/// ===============================
class MedicalDocumentsScreen extends StatefulWidget {
  const MedicalDocumentsScreen({super.key});

  @override
  State<MedicalDocumentsScreen> createState() =>
      _MedicalDocumentsScreenState();
}

class _MedicalDocumentsScreenState extends State<MedicalDocumentsScreen> {
  /// ⚠️ EMPTY INIT (only real uploaded files)
  final List<Map<String, dynamic>> _documents = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('মেডিকেল ডকুমেন্ট'),
        centerTitle: true,
      ),
      body: Column(
        children: [
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
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusLarge),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor:
                          colorScheme.surfaceVariant.withOpacity(0.4),
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
            child: _documents.isNotEmpty
                ? ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingMedium),
                    itemCount: _documents.length,
                    itemBuilder: (context, index) {
                      final doc = _documents[index];
                      return DocumentCard(
                        title: doc['title'],
                        date: doc['date'],
                        type: doc['type'],
                        fileType: doc['fileType'],
                        color: doc['color'],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  DocumentDetailScreen(document: doc),
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
        icon: const Icon(Icons.add),
        label: const Text('নতুন ডকুমেন্ট'),
        onPressed: () async {
          final result = await showDialog<Map<String, dynamic>>(
            context: context,
            builder: (_) => const AddDocumentDialog(),
          );

          if (result != null) {
            setState(() {
              _documents.add(result);
            });
          }
        },
      ),
    );
  }
}
