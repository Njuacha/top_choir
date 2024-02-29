import 'package:flutter/material.dart';

class SongPartsTabBar extends StatelessWidget {
  const SongPartsTabBar({
    super.key,
    required TabController tabController,
  }) : _tabController = tabController;

  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: AppBar(
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Suprano'),
            Tab(text: 'Alto'),
            Tab(text: 'Tenor'),
            Tab(text: 'Bass')
          ],
        ),
      ),
    );
  }
}