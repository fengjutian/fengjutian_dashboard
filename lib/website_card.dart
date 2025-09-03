import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:url_launcher/url_launcher.dart';

class WebsiteCard extends StatelessWidget {
  final String title;
  final String description;
  final String url;
  final IconData icon;

  const WebsiteCard({
    super.key,
    required this.title,
    required this.description,
    required this.url,
    required this.icon,
  });

  Future<void> _launchUrl() async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    // 使用 Builder 确保能正确获取主题
    return Builder(builder: (context) {
      final colors = context.theme.colors;
      final typography = context.theme.typography;

      return GestureDetector(
        onTap: _launchUrl,
        child: FCard.raw(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, color: colors.primary),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      title,
                      style: typography.sm.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colors.foreground,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: typography.xs.copyWith(color: colors.mutedForeground),
                ),
                const SizedBox(height: 12),
                FButton(
                  child: const Text('访问网站'),
                  onPress: _launchUrl,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}