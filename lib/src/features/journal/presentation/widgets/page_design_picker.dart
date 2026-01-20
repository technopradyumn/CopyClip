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

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
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
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.4,
              ),
              itemCount: designs.length,
              itemBuilder: (context, index) {
                final design = designs[index];
                final isSelected =
                    selectedDesignId == design.id ||
                    (selectedDesignId == null && design.id == 'default');

                return GestureDetector(
                  onTap: () {
                    onDesignSelected(design.id);
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.dividerColor.withOpacity(0.2),
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.2),
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
                                // Preview with neutral color or white/black depending on theme
                                theme.brightness == Brightness.dark
                                    ? Colors.grey[900]!
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
                                color: theme.colorScheme.surface.withOpacity(
                                  0.85,
                                ),
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
              },
            ),
          ),
        ],
      ),
    );
  }
}
