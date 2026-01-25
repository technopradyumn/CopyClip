import 'package:copyclip/src/features/journal/presentation/designs/journal_design_registry.dart';
import 'package:flutter/material.dart';

class DesignPickerSheet extends StatelessWidget {
  final String? currentDesignId;
  final Function(String) onDesignSelected;

  const DesignPickerSheet({
    super.key,
    this.currentDesignId,
    required this.onDesignSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
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
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Choose a Design",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8, // Card shape
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: JournalDesignRegistry.designs.length,
              itemBuilder: (context, index) {
                final design = JournalDesignRegistry.designs[index];
                final isSelected = design.id == currentDesignId;

                return GestureDetector(
                  onTap: () {
                    onDesignSelected(design.id);
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          design.defaultColor ??
                          theme.colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : Colors.black.withOpacity(0.1),
                        width: isSelected ? 3 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CustomPaint(
                        painter: design.painterBuilder(
                          design.defaultColor ??
                              theme.colorScheme.surfaceVariant,
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    design.icon,
                                    size: 24,
                                    color: design.isDark
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    design.name,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          color: design.isDark
                                              ? Colors.white
                                              : Colors.black87,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    size: 16,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                          ],
                        ),
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
