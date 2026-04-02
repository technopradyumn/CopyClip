import 'package:copyclip/src/features/canvas/presentation/pages/canvas_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


// Deferred Imports for Tip 06: Performance
import '../../features/calendar/data/calendar_event_model.dart';
import '../../features/calendar/presentation/pages/calendar_event_edit_screen.dart';
import '../../features/calendar/presentation/pages/calendar_screen.dart';
import '../../features/calendar/presentation/pages/date_detail_screen.dart';
import '../../features/calendar/presentation/pages/event_form_screen.dart';
import '../../features/calendar/presentation/pages/all_events_screen.dart';
import '../../features/calendar/presentation/pages/event_detail_screen.dart';
import '../../features/canvas/presentation/pages/canvas_folder_screen.dart';
import '../../features/canvas/presentation/pages/canvas_screen.dart';
import '../../features/clipboard/data/clipboard_model.dart';
import '../../features/clipboard/presentation/pages/clipboard_edit_screen.dart';
import '../../features/dashboard/presentation/pages/dashboard_screen.dart';
import '../../features/dashboard/presentation/pages/global_search_screen.dart';
import '../../features/expenses/data/expense_model.dart';
import '../../features/expenses/presentation/pages/expense_edit_screen.dart';
import '../../features/journal/data/journal_model.dart';
import '../../features/journal/presentation/pages/journal_edit_screen.dart';
import '../../features/notes/data/note_model.dart';
import '../../features/notes/presentation/pages/note_edit_screen.dart';
import '../../features/notes/presentation/pages/notes_screen.dart';
import '../../features/settings/presentation/pages/feedback_screen.dart';
import '../../features/settings/presentation/pages/privacy_policy_screen.dart';
import '../../features/settings/presentation/pages/recycle_bin_screen.dart';
import '../../features/settings/presentation/pages/settings_screen.dart';
import '../../features/settings/presentation/pages/background_picker_screen.dart';
import '../../features/todos/data/todo_model.dart';
import '../../features/todos/presentation/pages/todo_edit_screen.dart';
import '../../features/todos/presentation/pages/todos_screen.dart';
import '../../features/expenses/presentation/pages/expenses_screen.dart';
import '../../features/journal/presentation/pages/journal_screen.dart';
import '../../features/clipboard/presentation/pages/clipboard_screen.dart';
import '../../features/premium/presentation/pages/premium_screen.dart';
import 'package:copyclip/src/features/social_post/presentation/pages/social_post_tabs_screen.dart'; 
import 'package:copyclip/src/features/social_post/presentation/pages/social_post_screen.dart'; 
import 'package:copyclip/src/features/social_post/data/social_post_model.dart'; 
import 'package:copyclip/src/features/gamification/presentation/pages/xp_detail_screen.dart';

class AppRouter {
  static const String root = '/';

  static const String notes = '/notes';
  static const String noteEdit = '/notes/edit';

  static const String todos = "/todos";
  static const String todoEdit = '/todos/edit';

  static const String journal = '/journal';
  static const String journalEdit = "/journal/edit";

  static const String expenses = '/expenses';
  static const String expenseEdit = '/expenses/edit';

  static const String clipboard = '/clipboard';
  static const String clipboardEdit = "/clipboard/edit";

  static const String calendar = "/calendar";
  static const String calendarEventEdit = "/calendar/edit";
  static const String calendarEventDetail = "/calendar/detail/:id";
  static const String allEvents = "/calendar/all-events";
  static const String dateDetail = "/calendar/date";

  static const String canvas = '/canvas';
  static const String canvasFolder = '/canvas/folder';
  static const String canvasEdit = '/canvas/edit';

  static const String settings = "/settings";
  static const String recycleBin = "/settings/recycle-bin";
  static const String privacyPolicy = "/settings/privacy-policy";
  static const String feedback = "/settings/feedback";
  static const String backgroundPicker = "/settings/background-picker";

  static const String globalSearch = "/global-search";
  static const String socialPost = '/social-post';
  static const String socialPostEdit = '/social-post/edit';
  static const String premium = "/premium";
  static const String xpDetail = '/xp-detail';
}

List<GoRoute> getAuthRoutes() {
  return [
    GoRoute(
      path: AppRouter.root,
      builder: (context, state) => const DashboardScreen(),
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
      path: AppRouter.expenses,
      builder: (context, state) => ExpensesScreen(),
    ),
    GoRoute(
      path: AppRouter.expenseEdit,
      builder: (context, state) {
        final expense = state.extra as Expense?;
        return ExpenseEditScreen(expense: expense);
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
      path: AppRouter.calendar,
      builder: (context, state) => CalendarScreen(),
    ),

    GoRoute(
      path: AppRouter.xpDetail,
      builder: (context, state) => XpDetailScreen(),
    ),

    GoRoute(
      path: AppRouter.calendarEventEdit,
      builder: (context, state) {
        final event = state.extra as CalendarEvent?;
        return CalendarEventEditScreen(event: event);
      },
    ),

    GoRoute(
      path: AppRouter.dateDetail,
      builder: (context, state) {
        final Map<String, dynamic> extras = state.extra as Map<String, dynamic>;
        return DateDetailsScreen(
          date: extras['date'] as DateTime,
          items: extras['items'] as List<GlobalSearchResult>,
        );
      },
    ),
    GoRoute(
      path: AppRouter.allEvents,
      builder: (context, state) => const AllEventsScreen(),
    ),
    GoRoute(
      path: AppRouter.calendarEventDetail,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return EventDetailScreen(eventId: id);
      },
    ),

    GoRoute(
      path: AppRouter.canvas,
      builder: (context, state) => CanvasScreen(),
    ),

    // Canvas Folder Screen (shows all notes in a folder)
    GoRoute(
      path: AppRouter.canvasFolder,
      builder: (context, state) {
        // Expecting folderId as extra parameter
        final String folderId = state.extra as String;
        return CanvasFolderScreen(folderId: folderId);
      },
    ),

    GoRoute(
      path: AppRouter.canvasEdit,
      builder: (context, state) {
        final extra = state.extra;
        String? noteId;
        String? folderId;

        if (extra is String) {
          noteId = extra;
        } else if (extra is Map<String, dynamic>) {
          noteId = extra['noteId'] as String?;
          folderId = extra['folderId'] as String?;
        }

        // Deep Link Support
        noteId ??= state.uri.queryParameters['id'];

        return CanvasEditScreen(noteId: noteId, folderId: folderId);
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
      builder: (context, state) => const GlobalSearchScreen(),
    ),
    GoRoute(
      path: AppRouter.socialPost,
      builder: (context, state) => SocialPostTabsScreen(),
    ),
    GoRoute(
      path: AppRouter.socialPostEdit,
      builder: (context, state) {
        final post = state.extra as SocialPost?;
        return SocialPostScreen(postToEdit: post);
      },
    ),
  ];
}
