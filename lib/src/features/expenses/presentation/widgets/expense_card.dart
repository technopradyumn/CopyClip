import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:copyclip/src/features/expenses/data/expense_model.dart';
import 'package:copyclip/src/core/const/constant.dart';

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
    final isDark = theme.brightness == Brightness.dark;

    final incomeColor = Colors.greenAccent;
    final expenseColor = Colors.redAccent;
    final sign = expense.isIncome ? '+' : '-';
    final accentColor = expense.isIncome ? incomeColor : expenseColor;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: isSelected
            ? Matrix4.identity().scaled(0.98)
            : Matrix4.identity(),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDark
              ? theme.colorScheme.surface.withValues(alpha: isSelected ? 0.4 : 0.6)
              : Colors.white.withValues(alpha: isSelected ? 0.7 : 0.9),
          borderRadius: BorderRadius.circular(AppConstants.cornerRadius),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withValues(alpha: 0.08),
            width: isSelected ? 2.5 : AppConstants.borderWidth,
          ),
          boxShadow: [
            BoxShadow(
              color: (isSelected ? theme.colorScheme.primary : Colors.black)
                  .withValues(alpha: isSelected ? 0.15 : 0.04),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.cornerRadius),
          child: Stack(
            children: [
              // Subtle background glow for selected
              if (isSelected)
                Positioned(
                  left: -50,
                  top: -50,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.primary.withValues(alpha: 0.05),
                    ),
                  ),
                ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    // 1. ICON / CATEGORY MARKER
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        expense.isIncome
                            ? CupertinoIcons.arrow_down_left
                            : CupertinoIcons.arrow_up_right,
                        color: accentColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 16),

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
                                expense.title.isNotEmpty
                                    ? expense.title
                                    : "Untitled",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "${expense.category} • ${DateFormat('MMM d, h:mm a').format(expense.date)}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 
                                0.5,
                              ),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.1,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 3. AMOUNT SECTION
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Hero(
                          tag: 'expense_amount_${expense.id}',
                          child: Material(
                            type: MaterialType.transparency,
                            child: Text(
                              "$sign${expense.currency}${expense.amount.toStringAsFixed(2)}",
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                                color: accentColor,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                        ),
                        if (isSelected)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Icon(
                              CupertinoIcons.checkmark_circle_fill,
                              size: 14,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
