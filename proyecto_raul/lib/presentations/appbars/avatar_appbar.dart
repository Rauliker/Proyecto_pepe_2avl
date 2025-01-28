import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_bloc.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_state.dart';

class AvatarAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AvatarAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final String baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';

    return AppBar(
      title: const Text('BidHub'),
      leading: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoaded) {
            return GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: CircleAvatar(
                backgroundImage: state.user.avatar.isNotEmpty
                    ? NetworkImage(
                        '$baseUrl${state.user.avatar}?timestamp=${DateTime.now().millisecondsSinceEpoch}')
                    : null,
                child: state.user.avatar.isEmpty
                    ? const Icon(Icons.person, size: 40)
                    : null,
              ),
            );
          } else {
            return const CircleAvatar(
              child: Icon(Icons.person),
            );
          }
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
