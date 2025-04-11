import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:servipopapp/core/theme_provider.dart';
import 'package:servipopapp/views/auth/providers/auth_provider.dart';
import 'package:servipopapp/views/auth/providers/language_provider.dart';
import 'package:servipopapp/views/auth/providers/user_provider.dart';
import 'package:servipopapp/services/storage_service.dart';

class UserDrawer extends StatelessWidget {
  const UserDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: false,
    );
    final themeProvider = Provider.of<ThemeProvider>(
      context,
      listen: false,
    ); // Obtener el ThemeProvider
    final storageService = StorageService();

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              userProvider.user?.name ?? 'Usuario',
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              userProvider.user?.email ?? 'correo@ejemplo.com',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            currentAccountPicture: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              backgroundImage:
                  userProvider.user?.avatar != null
                      ? CachedNetworkImageProvider(userProvider.user!.avatar!)
                      : const AssetImage('assets/images/default_profile.png')
                          as ImageProvider,
              child:
                  userProvider.user?.avatar == null
                      ? Icon(Icons.person, size: 30, color: theme.primaryColor)
                      : null,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.primaryColor, theme.colorScheme.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<String?>(
              future: storageService.getUserRole(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Center(
                    child: CircularProgressIndicator(color: theme.primaryColor),
                  );
                }

                final userRole = snapshot.data;
                return ListView(
                  padding: EdgeInsets.zero,
                  children: _buildDrawerItems(context, userRole, theme),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: theme.dividerColor, width: 1.0),
              ),
            ),
            child: Column(
              children: [
                // Botón para cambiar tema
                ListTile(
                  leading: Icon(
                    themeProvider.themeMode == ThemeMode.dark
                        ? Icons.light_mode
                        : Icons.dark_mode,
                    color: theme.primaryColor,
                  ),
                  title: Text(
                    themeProvider.themeMode == ThemeMode.dark
                        ? 'Modo claro'
                        : 'Modo oscuro',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.textTheme.bodyLarge?.color?.withOpacity(0.9),
                    ),
                  ),
                  onTap: () {
                    themeProvider.toggleTheme();
                    Navigator.pop(context);
                  },
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  minLeadingWidth: 24,
                ),
                const SizedBox(height: 8),
                Row(
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDrawerItems(
    BuildContext context,
    String? userRole,
    ThemeData theme,
  ) {
    final commonItems = [
    
    ];

    final roleSpecificItems = <Widget>[];
    switch (userRole) {
      case 'serviceProvider':
        roleSpecificItems.addAll([
          _buildDrawerItem(
            context: context,
            icon: Icons.work,
            title: 'Publicar Servicio',
            theme: theme,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/service-form');
            },
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.book,
            title: 'Mis Bookings',
            theme: theme,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/bookinsProvider');
            },
          ),
        ]);
        break;
      case 'user':
        roleSpecificItems.addAll([
          _buildDrawerItem(
            context: context,
            icon: Icons.analytics,
            title: 'Estadísticas',
            theme: theme,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/stats');
            },
          ),
        ]);
        break;
    }

    return [
      ...commonItems,
      ...roleSpecificItems,
       _buildDrawerItem(
        context: context,
        icon: Icons.settings,
        title: 'Configuración',
        theme: theme,
        onTap: () => Navigator.pop(context),
      ),
      _buildDrawerItem(
        context: context,
        icon: Icons.logout,
        title: 'Cerrar sesión',
        theme: theme,
        onTap: () async {
          final authProvider = Provider.of<AuthProvider>(
            context,
            listen: false,
          );
          await authProvider.logout();
          Navigator.pushReplacementNamed(context, '/login');
        },
      ),
      
      _buildDrawerItem(
        context: context,
        icon: Icons.help_outline,
        title: 'Ayuda',
        theme: theme,
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/help');
        },
      ),
    ];
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required ThemeData theme,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: theme.primaryColor),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.textTheme.bodyLarge?.color?.withOpacity(0.9),
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      minLeadingWidth: 24,
    );
  }
}
