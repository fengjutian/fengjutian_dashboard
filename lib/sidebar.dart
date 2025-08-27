import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

// class Application extends StatelessWidget {
//   const Application({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final colors = context.theme.colors;
//     // Wrap content in MaterialApp to provide Directionality and other essential contexts
//     return MaterialApp(
//       home: ColoredBox(
//         color: colors.primary,
//         child: Text(
//           'Hello World!',
//           style: TextStyle(color: colors.primaryForeground),
//         ),
//       ),
//     );
//   }
// }




Widget _sidebar(BuildContext context) => DecoratedBox(
  decoration: BoxDecoration(color: context.theme.colors.background),
  child: FSidebar(
    width: 300,
    header: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            // child: SvgPicture.network(
            //   theme.colors.brightness == Brightness.light
            //       ? 'https://forui.dev/light_logo.svg'
            //       : 'https://forui.dev/dark_logo.svg',
            //   height: 24,
            //   colorFilter: ColorFilter.mode(context.theme.colors.foreground, BlendMode.srcIn),
            // ),
          ),
          FDivider(style: context.theme.dividerStyles.horizontalStyle.copyWith(padding: EdgeInsets.zero)),
        ],
      ),
    ),
    footer: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FCard.raw(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            spacing: 10,
            children: [
              FAvatar.raw(child: Icon(FIcons.userRound, size: 18, color: context.theme.colors.mutedForeground)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    Text(
                      'Dash',
                      style: context.theme.typography.sm.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.theme.colors.foreground,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'dash@forui.dev',
                      style: context.theme.typography.xs.copyWith(color: context.theme.colors.mutedForeground),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    children: [
      FSidebarGroup(
        label: const Text('Overview'),
        children: [
          FSidebarItem(
            icon: const Icon(FIcons.school),
            label: const Text('Getting Started'),
            initiallyExpanded: true,
            onPress: () {},
            children: [
              FSidebarItem(label: const Text('Installation'), selected: true, onPress: () {}),
              FSidebarItem(label: const Text('Themes'), onPress: () {}),
              FSidebarItem(label: const Text('Typography'), onPress: () {}),
            ],
          ),
          FSidebarItem(icon: const Icon(FIcons.code), label: const Text('API Reference'), onPress: () {}),
          FSidebarItem(icon: const Icon(FIcons.box), label: const Text('Pub Dev'), onPress: () {}),
        ],
      ),
      FSidebarGroup(
        action: const Icon(FIcons.plus),
        onActionPress: () {},
        label: const Text('Widgets'),
        children: [
          FSidebarItem(icon: const Icon(FIcons.circleSlash), label: const Text('Divider'), onPress: () {}),
          FSidebarItem(icon: const Icon(FIcons.scaling), label: const Text('Resizable'), onPress: () {}),
          FSidebarItem(icon: const Icon(FIcons.layoutDashboard), label: const Text('Scaffold'), onPress: () {}),
        ],
      ),
    ],
  ),
);

@override
Widget build(BuildContext context) => Center(
  child: FButton(
    child: const Text('Open Sidebar'),
    onPress: () => showFSheet(context: context, side: FLayout.ltr, builder: _sidebar),
  ),
);