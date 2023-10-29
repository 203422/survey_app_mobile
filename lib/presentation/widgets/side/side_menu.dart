import "package:encuestas_app/config/router/app_router.dart";
import 'package:encuestas_app/presentation/providers/auth/auth_provider.dart';
import "package:encuestas_app/presentation/widgets/side/side_items.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class SideMenu extends ConsumerWidget {

  final GlobalKey<ScaffoldState> scaffoldKey;  
  const SideMenu({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final authState = ref.watch(authProvider);
    final roles = authState.user?.roles.map((rol) => rol.name).toList() ?? [];

    final isAdmin = roles.contains("admin");
    
    return NavigationDrawer(
      backgroundColor: const Color(0xFFf0f4fc),
      onDestinationSelected: (value) {
        final menuItem = appSideItems[value];
        ref.read(appRouterProvider).push(menuItem.link);
        scaffoldKey.currentState?.closeDrawer();
      },


      children: [

        const Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Text('Hola!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
        ),

        Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Text(authState.user?.username ?? 'Username', style: const TextStyle(color: Color(0xFF6B6B6B), fontSize: 15),),
        ),

        const NavigationDrawerDestination(icon: Icon(Icons.home), label:  Text('Encuestas')),

        if(isAdmin) const  NavigationDrawerDestination(icon: Icon(Icons.account_circle), label:  Text('Usuarios')),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: ElevatedButton(onPressed: () {
            ref.read(authProvider.notifier).logout();
          },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF648fe4),
              foregroundColor: Colors.white,
  
            ),
            child: const Text('Cerrar sesión',
            ),
          ),
        )
      ]
    );
  }
}