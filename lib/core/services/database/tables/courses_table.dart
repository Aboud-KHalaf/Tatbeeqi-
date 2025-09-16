import 'package:sqflite/sqflite.dart';
import 'package:tatbeeqi/core/utils/app_logger.dart';

// Table name
const String coursesTableName = 'courses';

// Column names
const String coursesColId = 'id';
const String coursesColCourseCode = 'course_code';
const String coursesColCourseName = 'course_name';
const String coursesColDepartmentId = 'department_id';
const String coursesColStudyYear = 'study_year';
const String coursesColSemester = 'semester';
const String coursesColGradeTotal = 'grade_total';
const String coursesColGradeTheoreticalExam = 'grade_theoretical_exam';
const String coursesColWeeklyHoursTheory = 'weekly_hours_theory';
const String coursesColWeeklyHoursPractical = 'weekly_hours_practical';
const String coursesColWeeklyHoursTotal = 'weekly_hours_total';
const String coursesColGradeStudentWork = 'grade_student_work';
const String coursesColProgressPercent = 'progress_percent';

class CoursesTable {
  static Future<void> create(Database db) async {
    AppLogger.info('Creating database table: $coursesTableName');
    await db.execute('''
       CREATE TABLE IF NOT EXISTS $coursesTableName (
        $coursesColId INTEGER PRIMARY KEY,
        $coursesColCourseCode TEXT NOT NULL,
        $coursesColCourseName TEXT NOT NULL,
        $coursesColDepartmentId INTEGER NOT NULL,
        $coursesColStudyYear INTEGER NOT NULL,
        $coursesColSemester INTEGER NOT NULL,
        $coursesColGradeTotal INTEGER,
        $coursesColGradeTheoreticalExam INTEGER,
        $coursesColWeeklyHoursTheory INTEGER,
        $coursesColWeeklyHoursPractical INTEGER,
        $coursesColWeeklyHoursTotal INTEGER,
        $coursesColGradeStudentWork INTEGER,
        $coursesColProgressPercent REAL
      )
    ''');
    AppLogger.info('Table $coursesTableName created successfully.');
  }
}
