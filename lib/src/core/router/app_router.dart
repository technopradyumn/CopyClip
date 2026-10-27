import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/clipboard/data/clipboard_model.dart';
import '../../features/clipboard/presentation/pages/clipboard_edit_screen.dart';
import '../../features/dashboard/presentation/pages/global_search_screen.dart';
import '../../features/journal/data/journal_model.dart';
import '../../features/journal/presentation/pages/journal_edit_screen.dart';
import '../../features/notes/data/note_model.dart';
import '../../features/notes/presentation/pages/note_edit_screen.dart';
import '../../features/notes/presentation/pages/notes_screen.dart';
import '../../features/settings/feedback_screen.dart';
import '../../features/settings/privacy_policy_screen.dart';
import '../../features/settings/recycle_bin_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/settings/background_picker_screen.dart';
import '../../features/todos/data/todo_model.dart';
import '../../features/todos/presentation/pages/todo_edit_screen.dart';
import '../../features/todos/presentation/pages/todos_screen.dart';
import '../../features/journal/presentation/pages/journal_screen.dart';
import '../../features/clipboard/presentation/pages/clipboard_screen.dart';
import '../../features/premium/presentation/pages/premium_screen.dart';

class AppRouter {
  static const String root = '/';

  static const String notes = '/notes';
  static const String noteEdit = '/notes/edit';

  static const String todos = "/todos";
  static const String todoEdit = '/todos/edit';

  static const String journal = '/journal';
  static const String journalEdit = "/journal/edit";

  static const String clipboard = '/clipboard';
  static const String clipboardEdit = "/clipboard/edit";

  static const String settings = "/settings";
  static const String recycleBin = "/settings/recycle-bin";
  static const String privacyPolicy = "/settings/privacy-policy";
  static const String feedback = "/settings/feedback";
  static const String backgroundPicker = "/settings/background-picker";

  static const String globalSearch = "/global-search";
  static const String premium = "/premium";
}

List<GoRoute> getAuthRoutes() {
  return [
    GoRoute(
      path: AppRouter.root,
      redirect: (context, state) => AppRouter.notes,
    ),
    GoRoute(
      path: AppRouter.premium,
      builder: (context, state) => PremiumScreen(),
    ),
    GoRoute(
      path: AppRouter.notes,
      builder: (context, state) => NotesScreen(),
    ),
    GoRoute(
      path: AppRouter.noteEdit,
      builder: (context, state) {
        final note = state.extra as Note?;
        final id = state.uri.queryParameters['id'];
        debugPrint("ROUTER: NoteEditScreen -> ID: $id, URI: ${state.uri}");
        return NoteEditScreen(note: note, noteId: id);
      },
    ),
    GoRoute(
      path: AppRouter.todos,
      builder: (context, state) => TodosScreen(),
    ),
    GoRoute(
      path: AppRouter.todoEdit,
      builder: (context, state) {
        final todo = state.extra as Todo?;
        final id = state.uri.queryParameters['id'];
        debugPrint("ROUTER: TodoEditScreen -> ID: $id, URI: ${state.uri}");
        return TodoEditScreen(todo: todo, todoId: id);
      },
    ),
    GoRoute(
      path: AppRouter.journal,
      builder: (context, state) => JournalScreen(),
    ),
    GoRoute(
      path: AppRouter.journalEdit,
      builder: (context, state) {
        final entry = state.extra as JournalEntry?;
        final id = state.uri.queryParameters['id']; // Support Deep Link ID
        return JournalEditScreen(entry: entry, entryId: id);
      },
    ),
    GoRoute(
      path: AppRouter.clipboard,
      builder: (context, state) => ClipboardScreen(),
    ),

    GoRoute(
      path: AppRouter.clipboardEdit,
      builder: (context, state) {
        final item = state.extra as ClipboardItem?;
        final id = state.uri.queryParameters['id'];
        return ClipboardEditScreen(item: item, itemId: id);
      },
    ),

    GoRoute(
      path: AppRouter.settings,
      builder: (context, state) => const SettingsScreen(),
    ),

    GoRoute(
      path: AppRouter.recycleBin,
      builder: (context, state) => const RecycleBinScreen(),
    ),

    GoRoute(
      path: AppRouter.privacyPolicy,
      builder: (context, state) => const PrivacyPolicyScreen(),
    ),
    GoRoute(
      path: AppRouter.feedback,
      builder: (context, state) => const FeedbackScreen(),
    ),
    GoRoute(
      path: AppRouter.backgroundPicker,
      builder: (context, state) => const BackgroundPickerScreen(),
    ),

    GoRoute(
      path: AppRouter.globalSearch,
      builder: (context, state) => GlobalSearchScreen(
        initialQuery: state.uri.queryParameters['q'] ?? '',
      ),
    ),
  ];
}
