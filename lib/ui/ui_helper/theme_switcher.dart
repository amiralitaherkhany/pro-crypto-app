import 'package:crypto_app/providers/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        var switchIcon = Icon(themeProvider.isDarkMode
            ? CupertinoIcons.moon_fill
            : CupertinoIcons.sun_max_fill);
        return IconButton(
          onPressed: () {
            themeProvider.toggleTheme();
          },
          icon: switchIcon,
        );
      },
    );
  }
}
