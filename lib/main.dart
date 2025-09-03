import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'website_card.dart';

void main() {
  runApp(const Application());
}

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    // 使用 MaterialApp 并设置 Forui 主题
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: FTheme(
        data: FThemeData(
          // 直接使用 FThemes.zinc.light 的数据属性
          colors: FThemes.zinc.light.colors,
          style: FThemes.zinc.light.style,
          typography: FThemes.zinc.light.typography,
        ),
        child: Builder(builder: (context) {
          final colors = context.theme.colors;
          return Scaffold(
            appBar: AppBar(
              title: const Text('网站导航'),
              backgroundColor: colors.primary,
              foregroundColor: colors.primaryForeground,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 3/4,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  // 示例网站数据
                  final websites = [
                    WebsiteCard(
                      title: 'Flutter 官方网站',
                      description: 'Flutter 是 Google 开发的 UI 工具包，可用于构建跨平台应用。',
                      url: 'https://flutter.dev',
                      icon: FIcons.layoutDashboard,
                    ),
                    WebsiteCard(
                      title: 'Dart 官方网站',
                      description: 'Dart 是 Flutter 使用的编程语言。',
                      url: 'https://dart.dev',
                      icon: FIcons.code,
                    ),
                    WebsiteCard(
                      title: 'Pub Dev',
                      description: 'Flutter 和 Dart 的包管理器。',
                      url: 'https://pub.dev',
                      icon: FIcons.box,
                    ),
                    WebsiteCard(
                      title: 'GitHub',
                      description: '全球最大的代码托管平台。',
                      url: 'https://github.com',
                      icon: FIcons.gitBranch,
                    ),
                  ];
                  return websites[index];
                },
              ),
            ),
          );
        }),
      ),
    );
  }
}

