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
      child: Switch.adaptive(
        thumbIcon: MaterialStatePropertyAll(
          isDark ? const Icon(Icons.nightlight_sharp) : const Icon(Icons.sunny),
        ),
        activeColor: Colors.amber,
        value: themeProvider.isDarkMode,
        onChanged: (value) {
          showDialog(
              context: context,
              builder: (context) {
                return const Center(child: CircularProgressIndicator());
              });
          final provider = Provider.of<ThemeProvider>(context, listen: false);
          provider.toggleTheme(value);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
