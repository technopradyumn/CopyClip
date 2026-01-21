import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:copyclip/src/features/expenses/data/expense_model.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const ExpenseCard({
    super.key,
    required this.expense,
    required this.isSelected,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurfaceColor = theme.colorScheme.onSurface;

    final incomeColor = Colors.greenAccent;
    final expenseColor = Colors.redAccent;
    final sign = expense.isIncome ? '+' : '-';

    // ✅ OPTIMIZATION: High-performance Decoration
    final decoration = BoxDecoration(
      color: theme.colorScheme.surface.withOpacity(isSelected ? 0.3 : 0.15),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(
        color: isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.outline.withOpacity(0.2), // Adaptive
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Stack(
        children: [
          // ✅ Replaced GlassContainer with fast AnimatedContainer
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: decoration,
            child: Row(
              children: [
                // 1. ICON SECTION
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (expense.isIncome ? incomeColor : expenseColor)
                        .withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    expense.isIncome
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                    color: expense.isIncome ? incomeColor : expenseColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),

                // 2. TITLE & CATEGORY
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: 'expense_title_${expense.id}',
                        child: Material(
                          type: MaterialType.transparency,
                          child: Text(
                            expense.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: onSurfaceColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${expense.category} • ${DateFormat('h:mm a').format(expense.date)}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: onSurfaceColor.withOpacity(0.54),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // 3. AMOUNT SECTION
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.4,
                  ),
                  child: Hero(
                    tag: 'expense_amount_${expense.id}',
                    child: Material(
                      type: MaterialType.transparency,
                      child: Text(
                        "$sign ${expense.currency}${expense.amount.toStringAsFixed(2)}",
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        softWrap: false,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: expense.isIncome ? incomeColor : expenseColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isSelected)
            Positioned(
              top: 10,
              right: 10,
              child: Icon(
                Icons.check_circle,
                size: 16,
                color: theme.colorScheme.primary,
              ),
            ),
        ],
      ),
    );
  }
}
