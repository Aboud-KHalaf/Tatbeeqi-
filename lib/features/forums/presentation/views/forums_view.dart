import 'package:flutter/material.dart';
import 'package:tatbeeqi/features/forums/domain/entities/forum_discussion.dart';

class ForumsView extends StatelessWidget {
  const ForumsView({super.key});

  @override
  Widget build(BuildContext context) {
   

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Forums'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: 
            ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      final discussion = ForumDiscussion(
                        id: '1',
                        courseId: '1',
                        title: 'Discussion $index',
                        author: 'John Doe',
                        replies: 10,
                        lastUpdate: DateTime.now(),
                      );
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            child: Text(discussion.author[0]),
                          ),
                          title: Text(discussion.title),
                          subtitle: Text(
                            '${discussion.replies} replies - Last updated by ${discussion.author}',
                          ),
                          onTap: () {},
                        ),
                      );
                    },
                  ),     
          );              
  
  }}