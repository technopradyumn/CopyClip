import 'package:copyclip/src/features/journal/presentation/designs/journal_design_registry.dart';
import 'package:copyclip/src/features/premium/presentation/bloc/premium_bloc.dart';
import 'package:copyclip/src/features/premium/presentation/bloc/premium_state.dart';
import 'package:copyclip/src/features/premium/presentation/widgets/premium_lock_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    final designs = JournalDesignRegistry.designs;

    // Group designs by category
    final Map<String, List<JournalDesign>> categorizedDesigns = {};
    for (var design in designs) {
      categorizedDesigns.putIfAbsent(design.category, () => []).add(design);
    }

    final categories = categorizedDesigns.keys.toList();

    return BlocBuilder<PremiumBloc, PremiumState>(
      builder: (context, state) {
        final isPremium = state.isPremium;

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
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Row(
                    children: [
                      Text(
                        "Card Design",
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
                  tabs: categories.map((cat) => Tab(text: cat)).toList(),
                ),
                const Divider(height: 1),
                Expanded(
                  child: TabBarView(
                    children: categories.map((cat) {
                      final items = categorizedDesigns[cat] ?? [];
                      return GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final design = items[index];
                          final isSelected = design.id == currentDesignId;
                          
                          // Simplified locking logic for now: first 3 total or specific ones
                          final isLocked = !isPremium && 
                              !['default', 'classic_ruled', 'grid_paper'].contains(design.id);

                          return _DesignTile(
                            design: design,
                            isSelected: isSelected,
                            isLocked: isLocked,
                            onTap: () {
                              if (isLocked) {
                                PremiumLockDialog.show(
                                  context,
                                  featureName: '${design.name} Design',
                                  onUnlockOnce: () {
                                    onDesignSelected(design.id);
                                    Navigator.pop(context);
                                  },
                                );
                              } else {
                                onDesignSelected(design.id);
                                Navigator.pop(context);
                              }
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
      },
    );
  }
}

class _DesignTile extends StatelessWidget {
  final JournalDesign design;
  final bool isSelected;
  final bool isLocked;
  final VoidCallback onTap;

  const _DesignTile({
    required this.design,
    required this.isSelected,
    required this.isLocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardBaseColor =
        design.defaultColor ?? theme.colorScheme.surfaceContainerHighest;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cardBaseColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : Colors.black.withValues(alpha: 0.1),
            width: isSelected ? 3 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: RepaintBoundary(
            child: CustomPaint(
              painter: design.painterBuilder(cardBaseColor),
              child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        design.icon,
                        size: 28,
                        color: design.isDark ? Colors.white : Colors.black87,
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          design.name,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: design.isDark ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
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
                if (isLocked)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.35),
                      child: const Center(
                        child: Icon(
                          Icons.lock_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                if (isLocked)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "PRO",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      )
    );
  }
}
