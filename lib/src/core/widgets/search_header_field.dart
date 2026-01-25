import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../const/constant.dart';

class SearchHeaderField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hintText;
  final VoidCallback? onClear;
  final String heroTag;

  const SearchHeaderField({
    super.key,
    required this.controller,
    this.focusNode,
    this.hintText = "Search...",
    this.onClear,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return Hero(
      tag: heroTag,
      child: Material(
        color: Colors.transparent,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: onSurface.withOpacity(0.08),
            borderRadius: BorderRadius.circular(
              AppConstants.cornerRadius * 0.75,
            ),
            border: Border.all(
              color: theme.dividerColor.withOpacity(0.1),
              width: AppConstants.borderWidth,
            ),
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            autofocus: true,
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: onSurface.withOpacity(0.5),
              ),
              prefixIcon: Icon(
                CupertinoIcons.search,
                color: onSurface.withOpacity(0.5),
                size: 20,
              ),
              suffixIcon: ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller,
                builder: (context, value, _) {
                  return value.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(CupertinoIcons.xmark, size: 18),
                          onPressed: () {
                            controller.clear();
                            onClear?.call();
                          },
                        )
                      : const SizedBox.shrink();
                },
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 11),
            ),
          ),
        ),
      ),
    );
  }
}
