import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 主壳：4-tab 底部导航。
///
/// Tab 顺序遵循 CRM ADR-0016 §3 推荐 + App MISSION §3：
///   0 聊天          — 跟顾问 1v1 / mutual match 三人群入口
///   1 推荐          — 顾问推送给我的 baby 卡片流
///   2 档案          — 我的档案查看 + 编辑
///   3 通知          — 公告频道 + 系统消息
///
/// 注意：跟 MISSION §3 提的 5-tab (资料/推荐/交友/消息/我的) 略有差异，
/// V1 先按 4-tab 起步（"交友墙"暂不进底栏，Phase 2.5.9 再考虑加入或挪到推荐 tab）。
class MainTabShell extends StatelessWidget {
  const MainTabShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (int i) => navigationShell.goBranch(
          i,
          // 重复点击当前 tab 回到根（go_router 默认行为）。
          initialLocation: i == navigationShell.currentIndex,
        ),
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: '聊天',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: '推荐',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: '档案',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications),
            label: '通知',
          ),
        ],
      ),
    );
  }
}
