import 'package:flutter/material.dart';
import 'package:tatbeeqi/features/courses/domain/entities/course_entity.dart';
import 'package:tatbeeqi/features/references/domain/entities/reference.dart';

import 'package:url_launcher/url_launcher.dart';

class ReferencesView extends StatelessWidget {
  final Course course;
  const ReferencesView({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 5,
        itemBuilder: (context, index) {
          final reference = Reference(
              id: "1",
              courseId: "1",
              title: "Reference $index",
              url: "https://example.com/reference-$index",
              type: "documentation");
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
      ),
    );
  }
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
