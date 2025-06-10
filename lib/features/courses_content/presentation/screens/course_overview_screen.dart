import 'package:flutter/material.dart';
import 'package:tatbeeqi/features/courses_content/presentation/widgets/course_overview_body.dart';
import 'package:tatbeeqi/features/courses_content/presentation/widgets/custom_course_content_app_bar_widget.dart';

class CourseOverviewScreen extends StatefulWidget {
  const CourseOverviewScreen({super.key});
  static String routePath = '/courseOverviewView';

  @override
  State<CourseOverviewScreen> createState() => _CourseOverviewScreenState();
}

class _CourseOverviewScreenState extends State<CourseOverviewScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        // Handle tab change here
        print('Tab changed to ${_tabController.index}');
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(tabController: _tabController),
      body: TabBarView(
        controller: _tabController, // Same controller used in CustomAppBar
        children: [
          CourseOverviewBody(tabController: _tabController),
          const GradesPage(),
          const ForumsPage(),
          const NotesPage(),
          const ReferencesPage(),
          const AboutCoursePage(),
        ],
      ),
    );
  }
}

// Grades Page Sample
class GradesPage extends StatelessWidget {
  const GradesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Grades'),
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Assignment ${index + 1}'),
            subtitle: Text('Submitted on: 2023-05-$index'),
            trailing: Chip(
              label: Text('${85 + index}%'),
              backgroundColor: Colors.green[100],
            ),
          );
        },
      ),
    );
  }
}

// Forums Page Sample
class ForumsPage extends StatelessWidget {
  const ForumsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Forums'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search discussions...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text('Discussion Topic ${index + 1}'),
                    subtitle:
                        Text('${15 + index} replies - Last updated 2 days ago'),
                    leading: const CircleAvatar(
                      child: Icon(Icons.forum),
                    ),
                    onTap: () {},
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}

// Notes Page Sample
class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: List.generate(6, (index) {
          return Card(
              child: InkWell(
            onTap: () {},
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.note,
                      size: 40,
                      color: Colors.blue[300],
                    ),
                    const SizedBox(height: 10),
                    Text('Lecture ${index + 1} Notes'),
                  ]),
            ),
          ));
        }),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}

// References Page Sample
class ReferencesPage extends StatelessWidget {
  const ReferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course References'),
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.link),
            title: Text('Official Documentation'),
            subtitle: Text('https://docs.example.com'),
            trailing: Icon(Icons.open_in_new),
          ),
          ListTile(
            leading: Icon(Icons.book),
            title: Text('Recommended Textbook PDF'),
            subtitle: Text('Chapter 1-5'),
          ),
          ListTile(
            leading: Icon(Icons.video_library),
            title: Text('Supplementary Videos'),
            subtitle: Text('10 videos available'),
          ),
        ],
      ),
    );
  }
}

// About Course Page Sample
class AboutCoursePage extends StatelessWidget {
  const AboutCoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About This Course'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Introduction to Flutter Development',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Course Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              'This course covers the fundamentals of Flutter development, including widgets, state management, and UI design principles.',
            ),
            const SizedBox(height: 16),
            const Text(
              'Instructor:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const ListTile(
              leading: CircleAvatar(
                backgroundImage:
                    NetworkImage('https://example.com/instructor.jpg'),
              ),
              title: Text('Dr. Jane Smith'),
              subtitle: Text('Professor of Computer Science'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Course Details:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DataTable(
              columns: const [
                DataColumn(label: Text('Attribute')),
                DataColumn(label: Text('Value')),
              ],
              rows: const [
                DataRow(cells: [
                  DataCell(Text('Credits')),
                  DataCell(Text('3')),
                ]),
                DataRow(cells: [
                  DataCell(Text('Duration')),
                  DataCell(Text('12 weeks')),
                ]),
                DataRow(cells: [
                  DataCell(Text('Start Date')),
                  DataCell(Text('September 1, 2023')),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
