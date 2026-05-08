import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO(phase-2.5): hive.initFlutter() + 注册 adapter（推荐流索引 / 通知草稿等非敏感缓存）。
  runApp(
    const ProviderScope(child: SugarArkApp()),
  );
}
