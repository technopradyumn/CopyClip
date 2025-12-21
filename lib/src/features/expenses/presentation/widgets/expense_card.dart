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
    final primaryColor = theme.colorScheme.primary;

    final incomeColor = Colors.greenAccent;
    final expenseColor = Colors.redAccent;
    final sign = expense.isIncome ? '+' : '-';

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      // Fixed: Removed the outer Hero wrapper here to allow inner Heroes to work
      child: Stack(
        children: [
          GlassContainer(
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            opacity: isSelected ? 0.3 : 0.1,
            child: Row(
              children: [
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
                const SizedBox(width: 16),
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
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: onSurfaceColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Hero(
                            tag: 'expense_category_${expense.id}',
                            child: Material(
                              type: MaterialType.transparency,
                              child: Text(
                                expense.category,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: onSurfaceColor.withOpacity(0.54),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Hero(
                            tag: 'expense_date_${expense.id}',
                            child: Material(
                              type: MaterialType.transparency,
                              child: Text(
                                DateFormat('h:mm a').format(expense.date),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: onSurfaceColor.withOpacity(0.38),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Hero(
                      tag: 'expense_amount_${expense.id}',
                      child: Material(
                        type: MaterialType.transparency,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "$sign ${expense.currency}${expense.amount.toStringAsFixed(2)}",
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
              ],
            ),
          ),
          if (isSelected)
            Positioned(
              top: 10,
              right: 10,
              child: Icon(Icons.check_circle, size: 16, color: primaryColor),
            ),
        ],
      ),
    );
  }
}