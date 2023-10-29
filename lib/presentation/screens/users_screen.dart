import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:encuestas_app/presentation/providers/auth/users_provider.dart';
import "package:encuestas_app/presentation/widgets/widgets.dart";

class UsersScreen extends ConsumerWidget {
  static const name = 'usuarios';

  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersState = ref.watch(usersProvider);
    ref.watch(usersProvider.notifier).getUsers();
    return Scaffold(
      backgroundColor: const Color(0xFFf0f4fc),
      appBar: AppBar(
        backgroundColor: const Color(0xFFf0f4fc),
      ),
      body: usersState.isLoading ? const FullScreenLoader() : const UsersView(),
    );
  }
}

class UsersView extends ConsumerWidget {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(usersProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const Row(
            children: [
              Text(
                'Usuarios ',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF303030)),
              ),
              Text(
                'Registrados ',
                style: TextStyle(fontSize: 28, color: Color(0xFF6B6B6B)),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: userState.users!.length,
            itemBuilder: (context, index) {
              final user = userState.users![index];

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 5,
                          offset: const Offset(0, 3))
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user['username'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      user['email'],
                    ),
                    Text(
                      '${user['surveys'].length.toString()} ${user['surveys'].length == 1 ? 'Encuesta' : 'Encuestas'}',
                    ),
                    Text(
                      'Creado el: ${user['createdAt']}',
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
