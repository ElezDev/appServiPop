import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'l10n/messages_all.dart'; // Importa el archivo generado

class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode == null ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  String get appTitle => Intl.message('Domestic Services', name: 'appTitle');
  String get home => Intl.message('Home', name: 'home');
  String get search => Intl.message('Search', name: 'search');
  String get favorites => Intl.message('Favorites', name: 'favorites');
  String get profile => Intl.message('Profile', name: 'profile');
   String get helpTitle => Intl.message('Help', name: 'helpTitle');
  String get howToUse => Intl.message('How to use the app?', name: 'howToUse');
  String get howToUseDescription => Intl.message(
      'Explore our step-by-step guide to learn how to use all the features of the app.',
      name: 'howToUseDescription');
  String get paymentMethods => Intl.message('Payment Methods', name: 'paymentMethods');
  String get paymentMethodsDescription => Intl.message(
      'Check the available payment methods and how to make secure transactions.',
      name: 'paymentMethodsDescription');
  String get securityAndPrivacy => Intl.message('Security and Privacy', name: 'securityAndPrivacy');
  String get securityAndPrivacyDescription => Intl.message(
      'Learn how we protect your data and ensure your privacy.',
      name: 'securityAndPrivacyDescription');
  String get contact => Intl.message('Contact', name: 'contact');
  String get contactDescription => Intl.message(
      'Need additional help? Contact us directly from here.',
      name: 'contactDescription');
  String get developedBy => Intl.message('Developed by ElezDevTech', name: 'developedBy');
  String get copyright => Intl.message('© 2025 - All rights reserved', name: 'copyright');

  getString(String s) {}
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'es'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}