import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tatbeeqi/features/courses/domain/entities/course_entity.dart';
import 'package:tatbeeqi/features/courses_details.dart/data/datasources/mock_course_details_datasource.dart';
import 'package:tatbeeqi/features/courses_details.dart/data/course_details_repository_impl.dart';
import 'package:tatbeeqi/features/courses_details.dart/domain/entities/course_details.dart';
import 'package:tatbeeqi/features/courses_details.dart/domain/use_cases/fetch_course_details_use_case.dart';

class AboutCoursePage extends StatelessWidget {
  final Course course;
  const AboutCoursePage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final dataSource = MockCourseDetailsDataSource();
    final repository = CourseDetailsRepositoryImpl(dataSource);
    final fetchDetailsUseCase = FetchCourseDetailsUseCase(repository);

    // إضافة Directionality لدعم التخطيط من اليمين لليسار
    return Scaffold(
      body: FutureBuilder<CourseDetails>(
        future: fetchDetailsUseCase('1'), // Mock course ID
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // تعريب رسالة الخطأ
            return Center(child: Text('حدث خطأ: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            // تعريب رسالة عدم وجود بيانات
            return const Center(
                child: Text('لم يتم العثور على تفاصيل للدورة.'));
          } else {
            final details = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    details.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo', // اقتراح: استخدام خط عربي
                        ),
                  ),
                  const SizedBox(height: 16),
                  // تعريب عنوان القسم
                  _buildSectionTitle(context, 'وصف الدورة:'),
                  Text(
                    details.description,
                    style: const TextStyle(fontFamily: 'Cairo', fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  // تعريب عنوان القسم
                  _buildSectionTitle(context, 'المحاضر:'),
                  ListTile(
                    // في وضع RTL، سيظهر leading على اليمين تلقائياً
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(details.instructorImageUrl),
                    ),
                    title: Text(details.instructorName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                    subtitle: Text(details.instructorTitle,
                        style: const TextStyle(fontFamily: 'Cairo')),
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 24),
                  // تعريب عنوان القسم
                  _buildSectionTitle(context, 'تفاصيل الدورة:'),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DataTable(
                      columns: const [
                        // تعريب عناوين الأعمدة
                        DataColumn(
                            label: Text('البيان',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('القيمة',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: [
                        DataRow(cells: [
                          // تعريب أسماء الحقول
                          const DataCell(Text('الساعات المعتمدة')),
                          DataCell(Text(details.credits.toString())),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text('المدة')),
                          DataCell(Text(details.duration)),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text('تاريخ البدء')),
                          DataCell(Text(
                            // استخدام اللغة العربية لتنسيق التاريخ
                            DateFormat.yMMMd('ar').format(details.startDate),
                          )),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo', // اقتراح: استخدام خط عربي
            ),
      ),
    );
  }
}
