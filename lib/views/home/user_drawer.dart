import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:servipopapp/views/auth/providers/auth_provider.dart';
import 'package:servipopapp/views/auth/providers/language_provider.dart';
import 'package:servipopapp/views/auth/providers/user_provider.dart';

class UserDrawer extends StatelessWidget {
  const UserDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              userProvider.user?.name ?? 'Usuario',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              userProvider.user?.email ?? 'correo@ejemplo.com',
              style: const TextStyle(fontSize: 14),
            ),
            currentAccountPicture: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              backgroundImage: userProvider.user?.avatar != null
                  ? CachedNetworkImageProvider(userProvider.user!.avatar!)
                  : const AssetImage('assets/images/default_profile.jpg')
                      as ImageProvider,
              child: userProvider.user?.avatar == null
                  ? const Icon(Icons.person, size: 30, color: Colors.green)
                  : null,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green, Colors.lightGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.green),
                  title: const Text('Perfil'),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigator.pushNamed(context, '/profile');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.green),
                  title: const Text('Configuración'),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigator.pushNamed(context, '/settings');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.help_outline, color: Colors.green),
                  title: const Text('Ayuda'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/help');
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.green),
                  title: const Text('Cerrar sesión'),
                  onTap: () async {
                    await authProvider.logout();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey[300]!, width: 1.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Image.asset(
                    'assets/flags/reino.png', 
                    width: 32,
                    height: 32,
                  ),
                  onPressed: () {
                    languageProvider.setLocale(const Locale('en', ''));
                    Navigator.pop(context); 
                  },
                  tooltip: 'Cambiar a inglés',
                ),
                IconButton(
                  icon: Image.asset(
                    'assets/flags/espana.png', 
                    width: 32,
                    height: 32,
                  ),
                  onPressed: () {
                    languageProvider.setLocale(const Locale('es', ''));
                    Navigator.pop(context);
                  },
                  tooltip: 'Cambiar a español',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}