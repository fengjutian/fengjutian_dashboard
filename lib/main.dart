import 'package:flutter/material.dart';
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
  final String category; // 分类字段

  WebsiteData({
    required this.title,
    required this.description,
    required this.url,
    required this.icon,
    required this.category,
  });

  // 转换为JSON格式
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'url': url,
      'iconName': icon.codePoint,
      'category': category,
    };
  }

  // 从JSON创建对象
  factory WebsiteData.fromJson(Map<String, dynamic> json, IconData icon) {
    return WebsiteData(
      title: json['title'] as String,
      description: json['description'] as String,
      url: json['url'] as String,
      icon: icon,
      category: json['category'] as String,
    );
  }
}

// 定义分类数据模型
class WebsiteCategory {
  String name; // 将final去掉，改为可变属性
  final List<WebsiteData> websites;

  WebsiteCategory({
    required this.name,
    required this.websites,
  });
}

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  // 使用JSON格式存储分类网站数据
  List<WebsiteCategory> categories = [];
  String? selectedCategory; // 当前选中的分类

  @override
  void initState() {
    super.initState();
    // 初始化示例数据（按分类组织的JSON格式）
    // 注意：将FIcons替换为Material Icons
    final jsonCategories = {
      '开发工具': [
        {
          'title': 'Flutter 官方网站',
          'description': 'Flutter 是 Google 开发的 UI 工具包，可用于构建跨平台应用。',
          'url': 'https://flutter.dev',
          'icon': Icons.dashboard,
        },
        {
          'title': 'Dart 官方网站',
          'description': 'Dart 是 Flutter 使用的编程语言。',
          'url': 'https://dart.dev',
          'icon': Icons.code,
        },
        {
          'title': 'Pub Dev',
          'description': 'Flutter 和 Dart 的包管理器。',
          'url': 'https://pub.dev',
          'icon': Icons.archive,  // 使用更常见的 archive 图标
        },
      ],
      '代码托管': [
        {
          'title': 'GitHub',
          'description': '全球最大的代码托管平台。',
          'url': 'https://github.com',
          'icon': Icons.folder_special,  // 使用更常见的 folder_special 图标
        },
      ],
      '学习资源': [
        {
          'title': 'Stack Overflow',
          'description': '程序员问答社区，解决编程难题。',
          'url': 'https://stackoverflow.com',
          'icon': Icons.message,
        },
        {
          'title': 'YouTube',
          'description': '视频分享平台，包含大量教程和演示。',
          'url': 'https://youtube.com',
          'icon': Icons.play_circle_outline,
        },
        {
          'title': 'Medium',
          'description': '技术文章和博客分享平台。',
          'url': 'https://medium.com',
          'icon': Icons.article,  // 使用更常见的 article 图标
        },
      ],
      '社交媒体': [
        {
          'title': 'Twitter',
          'description': '社交媒体平台，关注技术动态。',
          'url': 'https://twitter.com',
          'icon': Icons.verified_user,
        },
      ],
    };

    // 转换JSON数据为分类对象列表
    categories = jsonCategories.entries.map((entry) {
      return WebsiteCategory(
        name: entry.key,
        websites: entry.value.map((item) {
          return WebsiteData(
            title: item['title'] as String,
            description: item['description'] as String,
            url: item['url'] as String,
            icon: item['icon'] as IconData,
            category: entry.key,
          );
        }).toList(),
      );
    }).toList();

    // 默认选中第一个分类
    if (categories.isNotEmpty) {
      selectedCategory = categories[0].name;
    }
  }

  // 获取当前选中分类的所有网站
  List<WebsiteData> getCurrentCategoryWebsites() {
    if (selectedCategory == null) return [];
    final category = categories.firstWhere(
      (cat) => cat.name == selectedCategory,
      orElse: () => WebsiteCategory(name: '', websites: []),
    );
    return category.websites;
  }

  // 添加新网站的方法
  void _addNewWebsite() {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController urlController = TextEditingController();
    String newCategory = selectedCategory ?? (categories.isNotEmpty ? categories[0].name : '未分类');

    // 如果没有分类，创建一个默认分类
    if (categories.isEmpty) {
      categories.add(WebsiteCategory(name: '未分类', websites: []));
      newCategory = '未分类';
      selectedCategory = '未分类';
    }

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
              // 分类选择器
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: DropdownButtonFormField<String>(
                  value: newCategory,
                  decoration: const InputDecoration(labelText: '选择分类'),
                  items: categories.map((category) {
                    return DropdownMenuItem(
                      value: category.name,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      newCategory = value;
                    }
                  },
                ),
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
                  // 查找或创建分类
                  final categoryIndex = categories.indexWhere(
                    (cat) => cat.name == newCategory,
                  );
                  
                  // 创建新网站
                  final newWebsite = WebsiteData(
                    title: titleController.text,
                    description: descriptionController.text,
                    url: urlController.text,
                    icon: Icons.link, // 默认图标
                    category: newCategory,
                  );
                  
                  // 添加到对应分类
                  if (categoryIndex >= 0) {
                    categories[categoryIndex].websites.add(newWebsite);
                  } else {
                    // 如果分类不存在，创建新分类
                    categories.add(WebsiteCategory(
                      name: newCategory,
                      websites: [newWebsite],
                    ));
                  }
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

  // 添加新分类的方法
  void _addNewCategory() {
    TextEditingController categoryNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('添加新分类'),
          content: TextField(
            controller: categoryNameController,
            decoration: const InputDecoration(labelText: '分类名称'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                final categoryName = categoryNameController.text.trim();
                if (categoryName.isNotEmpty) {
                  setState(() {
                    // 检查分类是否已存在
                    if (!categories.any((cat) => cat.name == categoryName)) {
                      categories.add(WebsiteCategory(
                        name: categoryName,
                        websites: [],
                      ));
                      // 选中新创建的分类
                      selectedCategory = categoryName;
                    }
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('添加'),
            ),
          ],
        );
      },
    );
  }

  // 分类管理页面
  void _openCategoryManagement() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: 500,
            height: 400,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '分类管理',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return Card(
                        child: ListTile(
                          title: Text(category.name),
                          subtitle: Text('${category.websites.length} 个网站'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children:
                            [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  // 编辑分类
                                  TextEditingController editController = TextEditingController(text: category.name);
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('编辑分类'),
                                        content: TextField(
                                          controller: editController,
                                          decoration: const InputDecoration(labelText: '新分类名称'),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text('取消'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              final newName = editController.text.trim();
                                              if (newName.isNotEmpty && newName != category.name) {
                                                setState(() {
                                                  // 修复：直接更新分类名称
                                                  category.name = newName;
                                                  // 同时更新该分类下所有网站的分类信息
                                                  for (int i = 0; i < category.websites.length; i++) {
                                                    // 由于WebsiteData是不可变的，创建新对象替换
                                                    category.websites[i] = WebsiteData(
                                                      title: category.websites[i].title,
                                                      description: category.websites[i].description,
                                                      url: category.websites[i].url,
                                                      icon: category.websites[i].icon,
                                                      category: newName,
                                                    );
                                                  }
                                                  // 检查当前选中的分类是否是被编辑的分类
                                                  if (selectedCategory == category.name) {
                                                    selectedCategory = newName;
                                                  }
                                                });
                                              }
                                              Navigator.pop(context);
                                            },
                                            child: const Text('保存'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  // 删除分类
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('删除分类'),
                                        content: Text('确定要删除分类 "${category.name}" 吗？该分类下的所有网站也将被删除。'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text('取消'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                categories.removeAt(index);
                                                // 如果删除的是当前选中的分类，重新选择第一个分类
                                                if (selectedCategory == category.name) {
                                                  selectedCategory = categories.isNotEmpty ? categories[0].name : null;
                                                }
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: const Text('删除', style: TextStyle(color: Colors.red)),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _addNewCategory,
                  child: const Text('添加新分类'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 直接使用MaterialApp，移除Forui主题包装器
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('网站导航'),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _addNewWebsite,
              tooltip: '添加新网站',
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: _openCategoryManagement,
              tooltip: '分类管理',
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 分类选择器 - 将FButton替换为Material Button
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedCategory = category.name;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedCategory == category.name
                                ? Theme.of(context).primaryColor
                                : Colors.grey[200],
                            foregroundColor: selectedCategory == category.name
                                ? Colors.white
                                : Theme.of(context).primaryColor,
                          ),
                          child: Text(category.name),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              // 网站卡片网格
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,  // 每行4个卡片
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 4/5,  // 调整宽高比
                  ),
                  itemCount: getCurrentCategoryWebsites().length,
                  itemBuilder: (context, index) {
                    // 从当前分类获取网站数据
                    final website = getCurrentCategoryWebsites()[index];
                    return WebsiteCard(
                      title: website.title,
                      description: website.description,
                      url: website.url,
                      icon: website.icon,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

