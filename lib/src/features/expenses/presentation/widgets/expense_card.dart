import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:copyclip/src/core/widgets/glass_container.dart';
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

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Stack(
        children: [
          GlassContainer(
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            opacity: isSelected ? 0.3 : 0.1,
            child: Row(
              children: [
                // 1. ICON SECTION (Fixed size)
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (expense.isIncome ? incomeColor : expenseColor).withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    expense.isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                    color: expense.isIncome ? incomeColor : expenseColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),

                // 2. TITLE & CATEGORY SECTION (Takes remaining space)
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
                            maxLines: 1, // Prevents title from pushing amount down
                            overflow: TextOverflow.ellipsis, // Adds '...' if too long
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: onSurfaceColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Using a Wrap or a single Text line to avoid overflow here too
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

                // 3. AMOUNT SECTION (Flexible but prioritized)
                // Use ConstrainedBox to ensure it doesn't take more than 40% of the screen
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
                        // This handles massive numbers by shrinking the text size automatically
                        softWrap: false,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: expense.isIncome ? incomeColor : expenseColor,
                          // Optional: define a specific font size for consistency
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
              child: Icon(Icons.check_circle, size: 16, color: theme.colorScheme.primary),
            ),
        ],
      ),
    );
  }
}