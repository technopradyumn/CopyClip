/// A single search result returned by the global search panel.
///
/// Used by [GlobalSearchScreen] and surfaced from the navigation drawer's
/// global search so users can jump straight to any note, todo, journal
/// entry or clipboard item.
class GlobalSearchResult {
  final String id;
  final String title;
  final String subtitle;
  final String type;
  final String route;
  final dynamic argument;
  final bool? isCompleted;

  GlobalSearchResult({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.route,
    this.argument,
    this.isCompleted,
  });
}
