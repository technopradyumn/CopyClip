import 'package:go_router/go_router.dart';
import '../../features/calendar/presentation/pages/calendar_screen.dart';
import '../../features/calendar/presentation/pages/date_detail_screen.dart';
import '../../features/clipboard/data/clipboard_model.dart';
import '../../features/clipboard/presentation/pages/clipboard_edit_screen.dart';
import '../../features/dashboard/presentation/pages/dashboard_screen.dart';
import '../../features/expenses/data/expense_model.dart';
import '../../features/expenses/presentation/pages/expense_edit_screen.dart';
import '../../features/journal/data/journal_model.dart';
import '../../features/journal/presentation/pages/journal_edit_screen.dart';
import '../../features/notes/data/note_model.dart';
import '../../features/notes/presentation/pages/note_edit_screen.dart';
import '../../features/notes/presentation/pages/notes_screen.dart';
import '../../features/settings/presentation/pages/settings_screen.dart';
import '../../features/todos/data/todo_model.dart';
import '../../features/todos/presentation/pages/todo_edit_screen.dart';
import '../../features/todos/presentation/pages/todos_screen.dart';
import '../../features/expenses/presentation/pages/expenses_screen.dart';
import '../../features/journal/presentation/pages/journal_screen.dart';
import '../../features/clipboard/presentation/pages/clipboard_screen.dart';

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
  static const String dateDetail = "/calendar/date";

  static const String settings = "/settings";

}

List<GoRoute> getAuthRoutes() {
  return [
    GoRoute(
      path: AppRouter.root,
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: AppRouter.notes,
      builder: (context, state) => const NotesScreen(),
    ),
    GoRoute(
      path: AppRouter.noteEdit,
      builder: (context, state) {
        final note = state.extra as Note?;
        return NoteEditScreen(note: note);
      },
    ),
    GoRoute(
      path: AppRouter.todos,
      builder: (context, state) => const TodosScreen(),
    ),
    GoRoute(
      path: AppRouter.todoEdit,
      builder: (context, state) {
        final todo = state.extra as Todo?;
        return TodoEditScreen(todo: todo);
      },
    ),
    GoRoute(
      path: AppRouter.expenses,
      builder: (context, state) => const ExpensesScreen(),
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
      builder: (context, state) => const JournalScreen(),
    ),
    GoRoute(
      path: AppRouter.journalEdit,
      builder: (context, state) {
        final entry = state.extra as JournalEntry?;
        return JournalEditScreen(entry: entry);
      },
    ),
    GoRoute(
      path: AppRouter.clipboard,
      builder: (context, state) => const ClipboardScreen(),
    ),

    GoRoute(
      path: AppRouter.clipboardEdit,
      builder: (context, state) {
        final item = state.extra as ClipboardItem?;
        return ClipboardEditScreen(item: item);
      },
    ),

    GoRoute(
      path: AppRouter.calendar,
      builder: (context, state) => const CalendarScreen(),
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
      path: AppRouter.settings,
      builder: (context, state) => const SettingsScreen(),
    ),

  ];
}