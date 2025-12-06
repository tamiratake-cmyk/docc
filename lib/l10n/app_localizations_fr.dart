// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Notes & Tâches';

  @override
  String get addNote => 'Ajouter une note';

  @override
  String get addTask => 'Ajouter une tâche';

  @override
  String get delete => 'Supprimer';

  @override
  String get edit => 'Modifier';

  @override
  String get search => 'Chercher';

  @override
  String get summary => 'Résumé';

  @override
  String get askAI => 'Demander à l’IA';

  @override
  String get homeTitle => 'Accueil';

  @override
  String get greetingMorning => 'Bonjour – prêt à écrire votre première note ?';

  @override
  String get greetingAfternoon => 'Bon après-midi – prêt à rassembler vos idées !';

  @override
  String get greetingEvening => 'Bonsoir – détendez-vous et notez vos idées !';

  @override
  String get quickActions => 'Actions rapides';

  @override
  String get quickActionNewNote => 'Nouvelle note';

  @override
  String get quickActionMyNotes => 'Mes notes';

  @override
  String get quickActionProfile => 'Profil';

  @override
  String get quickActionSettings => 'Paramètres';

  @override
  String get startingPointPrompt => 'Besoin d\'un point de départ ?';

  @override
  String get tipCaptureTitle => 'Capturez vos idées instantanément';

  @override
  String get tipCaptureBody => 'Utilisez le raccourci Nouvelle note dès que l\'inspiration arrive ; organisez plus tard avec des étiquettes.';

  @override
  String get tipTagTitle => 'Restez organisé grâce aux étiquettes';

  @override
  String get tipTagBody => 'Regroupez les notes liées avec des étiquettes (travail, personnel, urgent) et filtrez-les dans la page Notes.';

  @override
  String get tipAiTitle => 'Laissez l\'IA vous aider';

  @override
  String get tipAiBody => 'Ouvrez une note et touchez l\'icône robot pour résumer, réécrire ou discuter de votre contenu.';

  @override
  String get changeLanguageTooltip => 'Changer de langue';

  @override
  String get chooseLanguageLabel => 'Choisissez la langue';

  @override
  String get languageEnglish => 'Anglais';

  @override
  String get languageAmharic => 'Amharique';

  @override
  String get languageFrench => 'Français';

  @override
  String get attachments => 'Pièces jointes';

  @override
  String get noImagesAttached => 'Aucune image jointe';

  @override
  String get gallery => 'Galerie';

  @override
  String get camera => 'Appareil photo';
}
