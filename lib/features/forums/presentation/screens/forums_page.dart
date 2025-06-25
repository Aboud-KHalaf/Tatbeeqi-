import 'package:flutter/material.dart';
import 'package:tatbeeqi/features/forums/data/datasources/mock_forums_datasource.dart';
import 'package:tatbeeqi/features/forums/data/repositories/forums_repository_impl.dart';
import 'package:tatbeeqi/features/forums/domain/entities/forum_discussion.dart';
import 'package:tatbeeqi/features/forums/domain/use_cases/fetch_forum_discussions_use_case.dart';

class ForumsPage extends StatelessWidget {
  const ForumsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dataSource = MockForumsDataSource();
    final repository = ForumsRepositoryImpl(dataSource);
    final fetchDiscussionsUseCase = FetchForumDiscussionsUseCase(repository);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Forums'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search discussions...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ForumDiscussion>>(
              future: fetchDiscussionsUseCase('1'), // Mock course ID
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No discussions found.'));
                } else {
                  final discussions = snapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: discussions.length,
                    itemBuilder: (context, index) {
                      final discussion = discussions[index];
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
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
