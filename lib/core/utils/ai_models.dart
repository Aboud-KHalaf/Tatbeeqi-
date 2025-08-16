class AiModelInfo {
  final String id;
  final String name;
  final String description;
  final String category;
  final String usageType;
  final String icon;
  final String color;

  AiModelInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.usageType,
    required this.icon,
    required this.color,
  });
}

final List<AiModelInfo> aiModelsAr = [
  AiModelInfo(
    id: "gemini-pro",
    name: "Gemini Pro",
    description:
        "نموذج شامل يساعدك في الشرح، تلخيص النصوص، والإجابة على أسئلتك التعليمية بدقة عالية.",
    category: "التعليم العام",
    usageType: "محادثة + أسئلة وأجوبة",
    icon: "💡",
    color: "cyan",
  ),
  AiModelInfo(
    id: "gemini-flash",
    name: "Gemini Flash",
    description:
        "إجابات سريعة وخفيفة، مثالي للأسئلة القصيرة والمهام السريعة أثناء المذاكرة.",
    category: "مساعدة سريعة",
    usageType: "إجابات فورية",
    icon: "⚡",
    color: "yellow",
  ),
  AiModelInfo(
    id: "gemini-vision",
    name: "Gemini Vision",
    description:
        "يمكنك رفع صورة أو صفحة من كتاب، وسيقوم بشرحها أو استخراج المعلومات منها بسهولة.",
    category: "تحليل الصور",
    usageType: "سؤال بالصور + نصوص",
    icon: "🖼️",
    color: "purple",
  ),
  AiModelInfo(
    id: "gemini-pdf",
    name: "Gemini PDF",
    description:
        "حمّل ملف PDF وسيساعدك في البحث داخله، طرح الأسئلة، والحصول على شرح مبسط للمحتوى.",
    category: "التعلم من الملفات",
    usageType: "دراسة من ملفات PDF",
    icon: "📘",
    color: "blue",
  ),
];
final List<AiModelInfo> aiModelsEn = [
  AiModelInfo(
    id: "gemini-pro",
    name: "Gemini Pro",
    description:
        "A powerful all-around model that helps you explain, summarize, and answer your study questions with high accuracy.",
    category: "General Learning",
    usageType: "Conversation + Q&A",
    icon: "💡",
    color: "cyan",
  ),
  AiModelInfo(
    id: "gemini-flash",
    name: "Gemini Flash",
    description:
        "Fast and lightweight responses, perfect for quick questions and short study tasks.",
    category: "Quick Help",
    usageType: "Instant Answers",
    icon: "⚡",
    color: "yellow",
  ),
  AiModelInfo(
    id: "gemini-vision",
    name: "Gemini Vision",
    description:
        "Upload an image or book page, and it will explain it or extract useful information for you.",
    category: "Image Analysis",
    usageType: "Ask with images + text",
    icon: "🖼️",
    color: "purple",
  ),
  AiModelInfo(
    id: "gemini-pdf",
    name: "Gemini PDF",
    description:
        "Upload your PDF files to search, ask questions, and get simplified explanations of the content.",
    category: "File Learning",
    usageType: "Study from PDFs",
    icon: "📘",
    color: "blue",
  ),
];
