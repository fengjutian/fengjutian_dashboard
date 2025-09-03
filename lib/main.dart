import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'website_card.dart';
import 'dart:convert';

void main() {
  runApp(const Application());
}

// 定义网站数据模型
class WebsiteData {
  final String title;
  final String description;
  final String url;
  final IconData icon;

  WebsiteData({
    required this.title,
    required this.description,
    required this.url,
    required this.icon,
  });

  // 转换为JSON格式
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'url': url,
      'iconName': icon.fontPackage, // 在实际实现中可能需要更复杂的图标序列化
    };
  }

  // 从JSON创建对象
  factory WebsiteData.fromJson(Map<String, dynamic> json, IconData icon) {
    return WebsiteData(
      title: json['title'],
      description: json['description'],
      url: json['url'],
      icon: icon,
    );
  }
}

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  // 使用JSON格式存储网站数据
  List<WebsiteData> websites = [];

  @override
  void initState() {
    super.initState();
    // 初始化示例数据（JSON格式）
    final jsonWebsites = [
      {
        'title': 'Flutter 官方网站',
        'description': 'Flutter 是 Google 开发的 UI 工具包，可用于构建跨平台应用。',
        'url': 'https://flutter.dev',
        'icon': FIcons.layoutDashboard,
      },
      {
        'title': 'Dart 官方网站',
        'description': 'Dart 是 Flutter 使用的编程语言。',
        'url': 'https://dart.dev',
        'icon': FIcons.code,
      },
      {
        'title': 'Pub Dev',
        'description': 'Flutter 和 Dart 的包管理器。',
        'url': 'https://pub.dev',
        'icon': FIcons.box,
      },
      {
        'title': 'GitHub',
        'description': '全球最大的代码托管平台。',
        'url': 'https://github.com',
        'icon': FIcons.gitBranch,
      },
      {
        'title': 'Stack Overflow',
        'description': '程序员问答社区，解决编程难题。',
        'url': 'https://stackoverflow.com',
        'icon': FIcons.messageSquare,
      },
      {
        'title': 'YouTube',
        'description': '视频分享平台，包含大量教程和演示。',
        'url': 'https://youtube.com',
        'icon': FIcons.circleSlash,
      },
      {
        'title': 'Medium',
        'description': '技术文章和博客分享平台。',
        'url': 'https://medium.com',
        'icon': FIcons.bookOpen,
      },
      {
        'title': 'Twitter',
        'description': '社交媒体平台，关注技术动态。',
        'url': 'https://twitter.com',
        'icon': FIcons.twitter,
      },
    ];

    // 转换JSON数据为WebsiteData对象
    websites = jsonWebsites.map((item) {
      return WebsiteData(
        title: item['title'] as String,
        description: item['description'] as String,
        url: item['url'] as String,
        icon: item['icon'] as IconData,
      );
    }).toList();
  }

  // 添加新网站的方法
  void _addNewWebsite() {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('添加新网站'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: '网站名称'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: '网站描述'),
              ),
              TextField(
                controller: urlController,
                decoration: const InputDecoration(labelText: '网站URL'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  websites.add(WebsiteData(
                    title: titleController.text,
                    description: descriptionController.text,
                    url: urlController.text,
                    icon: FIcons.link, // 默认图标
                  ));
                });
                Navigator.pop(context);
              },
              child: const Text('添加'),
            ),
          ],
        );
      },
    );
  }

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
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addNewWebsite,
                  tooltip: '添加新网站',
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,  // 每行4个卡片
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 4/5,  // 调整宽高比
                ),
                itemCount: websites.length,
                itemBuilder: (context, index) {
                  // 从JSON数据创建WebsiteCard
                  final website = websites[index];
                  return WebsiteCard(
                    title: website.title,
                    description: website.description,
                    url: website.url,
                    icon: website.icon,
                  );
                },
              ),
            ),
          );
        }),
      ),
    );
  }
}

