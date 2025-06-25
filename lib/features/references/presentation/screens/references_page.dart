import 'package:flutter/material.dart';
import 'package:tatbeeqi/features/courses_content/data/datasources/mock_references_datasource.dart';
import 'package:tatbeeqi/features/references/data/repositories/references_repository_impl.dart';
import 'package:tatbeeqi/features/references/domain/entities/reference.dart';
import 'package:tatbeeqi/features/references/domain/use_cases/fetch_references_use_case.dart';

import 'package:url_launcher/url_launcher.dart';

class ReferencesPage extends StatelessWidget {
  const ReferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dataSource = MockReferencesDataSource();
    final repository = ReferencesRepositoryImpl(dataSource);
    final fetchReferencesUseCase = FetchReferencesUseCase(repository);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course References'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: FutureBuilder<List<Reference>>(
        future: fetchReferencesUseCase('1'), // Mock course ID
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No references found.'));
          } else {
            final references = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: references.length,
              itemBuilder: (context, index) {
                final reference = references[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Icon(_getIconForType(reference.type)),
                    title: Text(reference.title),
                    subtitle: Text(reference.url, overflow: TextOverflow.ellipsis),
                    trailing: const Icon(Icons.open_in_new),
                    onTap: () async {
                      final url = Uri.parse(reference.url);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'documentation':
        return Icons.book;
      case 'video':
        return Icons.video_library;
      default:
        return Icons.link;
    }
  }
}
