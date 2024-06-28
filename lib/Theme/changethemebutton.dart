import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_commute/providers/theme_provider.dart';

class ChangeThemeButton extends StatefulWidget {
  const ChangeThemeButton({super.key});

  @override
  State<ChangeThemeButton> createState() => _ChangeThemeButtonState();
}

class _ChangeThemeButtonState extends State<ChangeThemeButton> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDark = themeProvider.themeMode == ThemeMode.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: IconButton(
        icon: Icon(isDark ? Icons.nightlight_sharp : Icons.sunny),
        color: isDark ? Colors.yellow : Colors.amber,
        onPressed: () {
          final provider = Provider.of<ThemeProvider>(context, listen: false);
          provider.toggleTheme(!isDark);
        },
      ),
    );
  }
}
