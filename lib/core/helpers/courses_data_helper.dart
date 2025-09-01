import 'package:flutter/material.dart';

/// Represents the visual style for a course, including an icon and a color.
class CourseStyle {
  final IconData icon;
  final Color color;

  CourseStyle(this.icon, this.color);
}

/// A utility class to provide consistent icons and colors for different courses.
class CourseIconHelper {
  // A colorful palette to assign to courses.
  static final List<Color> _palette = [
    Colors.blue.shade700,
    Colors.green.shade700,
    Colors.red.shade700,
    Colors.orange.shade700,
    Colors.purple.shade700,
    Colors.teal.shade700,
    Colors.brown.shade700,
    Colors.indigo.shade700,
    Colors.cyan.shade700,
    Colors.pink.shade700,
    Colors.lime.shade800,
    Colors.deepOrange.shade700,
  ];

  // A map containing the specific style for each course ID.
  static final Map<int, CourseStyle> _styles = {
    // Block 1: General & Basic Sciences
    1: CourseStyle(Icons.calculate, _palette[1 % 12]), // الرياضيات الأساسية
    2: CourseStyle(Icons.science, _palette[2 % 12]), // الفيزياء الأساسية
    3: CourseStyle(Icons.settings, _palette[3 % 12]), // الميكانيك التطبيقي
    4: CourseStyle(Icons.architecture, _palette[4 % 12]), // الرسم الهندسي
    5: CourseStyle(Icons.menu_book, _palette[5 % 12]), // اللغة العربية
    6: CourseStyle(Icons.language, _palette[6 % 12]), // اللغة الأجنبية عامة (1)
    7: CourseStyle(Icons.computer, _palette[7 % 12]), // معلوماتية
    8: CourseStyle(Icons.functions, _palette[8 % 12]), // الرياضيات التطبيقية
    9: CourseStyle(
        Icons.local_fire_department, _palette[9 % 12]), // الترموديناميك
    10: CourseStyle(Icons.design_services, _palette[10 % 12]), // الرسم الصناعي
    11: CourseStyle(
        Icons.flag, _palette[11 % 12]), // الثقافة القومية الاشتراكية
    12: CourseStyle(Icons.build, _palette[0 % 12]), // ورش ميكانيكية (12%12=0)
    13: CourseStyle(
        Icons.language, _palette[1 % 12]), // اللغة الأجنبية عامة (2)
    14: CourseStyle(Icons.translate, _palette[2 % 12]), // لغة أجنبية اختصاصية

    // Block 2: HVAC & Energy Systems
    15: CourseStyle(Icons.device_thermostat, _palette[3 % 12]), // انتقال حرارة
    16: CourseStyle(Icons.bolt, _palette[4 % 12]), // أسس الكهرباء
    17: CourseStyle(
        Icons.ac_unit, _palette[5 % 12]), // مبادئ التدفئة والتكييف والتبريد
    18: CourseStyle(Icons.straighten, _palette[6 % 12]), // أجهزة القياس
    19: CourseStyle(
        Icons.desktop_windows, _palette[7 % 12]), // الرسم باستخدام الحاسب
    20: CourseStyle(Icons.home_work, _palette[8 % 12]), // التدفئة المركزية
    21: CourseStyle(Icons.water_drop, _palette[9 % 12]), // ميكانيك الموائع
    22: CourseStyle(Icons.ac_unit, _palette[10 % 12]), // اسس التبريد
    23: CourseStyle(Icons.electrical_services,
        _palette[11 % 12]), // كهرباء صناعية(قيادةوتحكم)
    24: CourseStyle(Icons.hvac, _palette[0 % 12]), // التكييف المركزي
    25: CourseStyle(Icons.layers, _palette[1 % 12]), // العزل الحراري
    26: CourseStyle(Icons.shield, _palette[2 % 12]), // أجهزة الحماية والتحكم
    27: CourseStyle(Icons.cloud_queue, _palette[3 % 12]), // مولدات البخار
    28: CourseStyle(Icons.whatshot, _palette[4 % 12]), // تجهيزات التدفئة
    29: CourseStyle(Icons.factory, _palette[5 % 12]), // التبريد الصناعي
    30: CourseStyle(Icons.solar_power,
        _palette[6 % 12]), // الطاقات المتجددة في التدفئة والتكييف
    31: CourseStyle(Icons.health_and_safety,
        _palette[7 % 12]), // الامن الصناعي والسلامة المهنية
    32: CourseStyle(
        Icons.assignment, _palette[8 % 12]), // مشروع تطبيقي(ملازمة ورش)
    33: CourseStyle(
        Icons.lightbulb, _palette[9 % 12]), // مبادئ إدارة الطاقة في المباني
    34: CourseStyle(Icons.air, _palette[10 % 12]), // تجهيزات التكييف
    35: CourseStyle(Icons.kitchen, _palette[11 % 12]), // تجهيزات التبريد
    36: CourseStyle(Icons.eco,
        _palette[0 % 12]), // المعايير البيئية لأنظمة التكييف والتبريد والتدفئة
    37: CourseStyle(
        Icons.recycling, _palette[1 % 12]), // التبريد بالنظم البديلة
    38: CourseStyle(Icons.school, _palette[2 % 12]), // مشروع تخرج 1
    39: CourseStyle(Icons.air, _palette[3 % 12]), // نظم تكييف الهواء والتهوية
    40: CourseStyle(Icons.build_circle,
        _palette[4 % 12]), // صيانة وتشغيل تجهيزات التدفئة المركزية
    41: CourseStyle(
        Icons.engineering, _palette[5 % 12]), // صيانة وتشغيل تجهيزات التكييف
    42: CourseStyle(Icons.list_alt,
        _palette[6 % 12]), // أمثلة أنظمة التدفئة والتكييف والتبريد
    43: CourseStyle(
        Icons.manage_accounts, _palette[7 % 12]), // إدارة المشاريع الصناعية
    44: CourseStyle(Icons.school, _palette[8 % 12]), // مشروع تخرج 2
    45: CourseStyle(Icons.verified, _palette[9 % 12]), // أنظمة ومعايير الجودة
    46: CourseStyle(
        Icons.handyman, _palette[10 % 12]), // صيانة وتشغيل تجهيزات التبريد
    47: CourseStyle(Icons.rule_folder,
        _palette[11 % 12]), // خطط تنفيذ أنظمة التدفئة والتكييف والبريد

    // Block 3: Computer Science & IT
    48: CourseStyle(Icons.language, _palette[0 % 12]), // اللغة الأجنبية (1)
    49: CourseStyle(Icons.menu_book, _palette[1 % 12]), // اللغة العربية
    50: CourseStyle(Icons.calculate, _palette[2 % 12]), // الرياضيات (1)
    51: CourseStyle(Icons.chat, _palette[3 % 12]), // مهارات التواصل
    52: CourseStyle(Icons.memory, _palette[4 % 12]), // دارات الكترونية ومنطقية
    53: CourseStyle(
        Icons.laptop_chromebook, _palette[5 % 12]), // أساسيات الحاسوب
    54: CourseStyle(Icons.code, _palette[6 % 12]), // البرمجة (1)
    55: CourseStyle(Icons.language, _palette[7 % 12]), // اللغة الأجنبية (2)
    56: CourseStyle(Icons.flag, _palette[8 % 12]), // ثقافة قومية اشتراكية
    57: CourseStyle(Icons.calculate, _palette[9 % 12]), // الرياضيات (2)
    58: CourseStyle(Icons.developer_board,
        _palette[10 % 12]), // تنظيم الحاسوب والبرمجة بلغة التجميع
    59: CourseStyle(Icons.build, _palette[11 % 12]), // صيانة الحاسوب (1)
    60: CourseStyle(Icons.code_off, _palette[0 % 12]), // البرمجة (2)
    61: CourseStyle(
        Icons.translate, _palette[1 % 12]), // اللغة الأجنبية التخصصية (1)
    62: CourseStyle(Icons.router, _palette[2 % 12]), // أسس هندسة الاتصالات
    63: CourseStyle(
        Icons.assessment, _palette[3 % 12]), // نظم المعلومات الإدارية
    64: CourseStyle(Icons.storage, _palette[4 % 12]), // قواعد المعطيات (1)
    65: CourseStyle(Icons.star, _palette[5 % 12]), // برمجة متقدمة
    66: CourseStyle(Icons.build, _palette[6 % 12]), // صيانة الحاسوب
    67: CourseStyle(
        Icons.translate, _palette[7 % 12]), // اللغة الأجنبية التخصصية (2)
    68: CourseStyle(Icons.lan, _palette[8 % 12]), // مبادئ الشبكات الحاسوبية
    69: CourseStyle(
        Icons.data_object, _palette[9 % 12]), // الخوارزميات وبنى المعطيات
    70: CourseStyle(Icons.dns, _palette[10 % 12]), // قواعد المعطيات (2)
    71: CourseStyle(Icons.web, _palette[11 % 12]), // برمجيات الويب (1)
    72: CourseStyle(Icons.dvr, _palette[0 % 12]), // نظم التشغيل
    73: CourseStyle(
        Icons.analytics, _palette[1 % 12]), // تحليل و تصميم نظم المعلومات
    74: CourseStyle(Icons.cell_tower, _palette[2 % 12]), // اتصالات حديثة
    75: CourseStyle(Icons.print, _palette[3 % 12]), // الوحدات المحيطية وصيانتها
    76: CourseStyle(Icons.dataset, _palette[4 % 12]), // قواعد المعطيات (3)
    77: CourseStyle(Icons.psychology, _palette[5 % 12]), // مبادئ الذكاء الصنعي
    78: CourseStyle(
        Icons.settings_ethernet, _palette[6 % 12]), // نظم تشغيل شبكية (1)
    79: CourseStyle(
        Icons.integration_instructions, _palette[7 % 12]), // هندسة البرمجيات
    80: CourseStyle(Icons.schema, _palette[8 % 12]), // تصميم الشبكات
    81: CourseStyle(
        Icons.settings_applications, _palette[9 % 12]), // إدارة الشبكات (1)
    82: CourseStyle(
        Icons.perm_media, _palette[10 % 12]), // الوسائط المتعددة وبرمجتها
    83: CourseStyle(Icons.web_asset, _palette[11 % 12]), // برمجيات الويب (2)
    84: CourseStyle(
        Icons.settings_ethernet, _palette[0 % 12]), // نظم تشغيل شبكية (2)
    85: CourseStyle(
        Icons.architecture, _palette[1 % 12]), // هندسة برمجيات متقدمة
    86: CourseStyle(Icons.data_usage, _palette[2 % 12]), // بيانات الحاسوب
    87: CourseStyle(Icons.memory, _palette[3 % 12]), // المعالجات والمتحكمات
    88: CourseStyle(
        Icons.settings_applications, _palette[4 % 12]), // إدارة الشبكات (2)
    89: CourseStyle(Icons.lock, _palette[5 % 12]), // امن المعلومات
    91: CourseStyle(
        Icons.bar_chart, _palette[7 % 12]), // تحليل البيانات و نظم دعم القرار
    93: CourseStyle(
        Icons.sync_alt, _palette[9 % 12]), // مبادئ الاتومات والمترجمات
    94: CourseStyle(Icons.smartphone, _palette[10 % 12]), // البرمجيات النقالة
    95: CourseStyle(Icons.security, _palette[11 % 12]), // امن الشبكات

    // Block 4: Projects & Management
    90: CourseStyle(Icons.school, _palette[6 % 12]), // مشروع تخرج (1)
    92: CourseStyle(
        Icons.account_tree, _palette[8 % 12]), // إدارة مشاريع تظم المعلومات
    96: CourseStyle(Icons.school, _palette[0 % 12]), // مشروع تخرج (2)
  };

  /// Retrieves the style for a given course ID.
  ///
  /// Returns a [CourseStyle] object containing the icon and color.
  /// If the ID is not found, a default style is returned.
  static CourseStyle getStyle(int courseId, BuildContext context) {
    return _styles[courseId] ??
        CourseStyle(
            Icons.school,
            Theme.of(context)
                .colorScheme
                .onSecondaryContainer); // Default style
  }
}
