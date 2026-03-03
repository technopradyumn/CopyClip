import 'package:flutter/material.dart';
import '../designs/journal_page_registry.dart';

class PageDesignPickerSheet extends StatelessWidget {
  final String? selectedDesignId;
  final Function(String) onDesignSelected;

  const PageDesignPickerSheet({
    super.key,
    this.selectedDesignId,
    required this.onDesignSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final designs = JournalPageRegistry.designs;

    // Group designs by category
    final Map<String, List<JournalPageDesign>> categorizedDesigns = {};
    for (var design in designs) {
      categorizedDesigns.putIfAbsent(design.category, () => []).add(design);
    }

    final categories = categorizedDesigns.keys.toList();

    return DefaultTabController(
      length: categories.length,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Text(
                    "Page Style",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
              tabs: categories.map((cat) => Tab(text: cat)).toList(),
            ),
            const Divider(height: 1),
            Expanded(
              child: TabBarView(
                children: categories.map((cat) {
                  final items = categorizedDesigns[cat] ?? [];
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.4,
                        ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final design = items[index];
                      final isSelected =
                          selectedDesignId == design.id ||
                          (selectedDesignId == null && design.id == 'default');

                      return _PageDesignTile(
                        design: design,
                        isSelected: isSelected,
                        onTap: () {
                          onDesignSelected(design.id);
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageDesignTile extends StatelessWidget {
  final JournalPageDesign design;
  final bool isSelected;
  final VoidCallback onTap;

  const _PageDesignTile({
    required this.design,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.dividerColor.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
                blurRadius: 8,
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: design.painterBuilder(
                    theme.brightness == Brightness.dark
                        ? (Colors.grey[900] ?? Colors.black)
                        : Colors.white,
                  ),
                ),
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        design.icon,
                        size: 16,
                        color: theme.colorScheme.onSurface,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        design.name,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isSelected)
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: theme.colorScheme.primary,
                    child: const Icon(
                      Icons.check,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
