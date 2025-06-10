import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required TabController tabController,
  }) : _tabController = tabController;

  final TabController _tabController;

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight + kTextTabBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context)
              .pop(); // or context.pop() if using go_router or similar
        },
        tooltip: 'رجوع',
      ),
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('برمجة متقدمة'),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.alarm),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {},
        ),
      ],
      bottom: TabBar(
        isScrollable: true,
        controller: _tabController,
        indicatorWeight: 3,
        tabAlignment: TabAlignment.start,
        tabs: const [
          Tab(text: 'الرئيسية'),
          Tab(text: 'الدرجات'),
          Tab(text: 'المنتديات'),
          Tab(text: 'الملاحظات'),
          Tab(text: 'المراجع'),
          Tab(text: 'عن المقرر'),
        ],
      ),
    );
  }
}
