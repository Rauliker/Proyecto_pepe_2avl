import 'package:flutter/material.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String mesage;
  const DefaultAppBar({super.key, required this.mesage});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(mesage),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
