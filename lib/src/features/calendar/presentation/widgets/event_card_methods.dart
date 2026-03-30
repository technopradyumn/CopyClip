// Methods for EventCard - resolves missing methods

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/calendar_event_model.dart';
import 'calendar_design_picker_sheet.dart';

Future<void> _showDesignPicker(BuildContext context, CalendarEvent event) async {
  final result = await showModalBottomSheet<bool?>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => CalendarDesignPickerSheet(event: event),
  );
  // Auto refresh after design change
  if (result == true && context.mounted) {
    (context as Element).markNeedsBuild();
  }
}

Future<void> _showDeleteConfirmation(BuildContext context, VoidCallback onDelete) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete Event'),
      content: const Text('This action cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
  if (confirmed == true) {
    onDelete();
  }
}

