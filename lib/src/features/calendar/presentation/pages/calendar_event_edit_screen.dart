import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:copyclip/src/core/router/app_router.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/widgets/dynamic_background.dart';
import 'package:copyclip/src/core/widgets/seamless_header.dart';
import 'package:copyclip/src/core/const/constant.dart';
import '../../data/calendar_event_model.dart';
import '../widgets/calendar_design_picker_sheet.dart';
import '../../services/event_notification_service.dart';

class CalendarEventEditScreen extends StatefulWidget {
  final CalendarEvent? event;
  const CalendarEventEditScreen({super.key, this.event});

  @override
  State<CalendarEventEditScreen> createState() => _CalendarEventEditScreenState();
}

class _CalendarEventEditScreenState extends State<CalendarEventEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _locationController;
  late final TextEditingController _urlController;
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  bool _allDay = false;
  String? _selectedDesignId = 'min_1';
  String? _repeatInterval;
  int _reminderMinutesBefore = 0;
  
  final List<String> _repeats = ['None', 'Daily', 'Weekly', 'Monthly', 'Yearly'];
  final Map<int, String> _reminders = {
    0: 'No reminder',
    5: '5 minutes before',
    15: '15 minutes before',
    30: '30 minutes before',
    60: '1 hour before',
    1440: '1 day before'
  };

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event?.title);
    _descriptionController = TextEditingController(text: widget.event?.description);
    _locationController = TextEditingController(text: widget.event?.location);
    _urlController = TextEditingController(text: widget.event?.url);
    if (widget.event != null) {
      _startDate = widget.event!.startDate;
      _endDate = widget.event!.endDate;
      _allDay = widget.event!.isAllDay;
      _selectedDesignId = widget.event!.designPatternId ?? 'min_1';
      _repeatInterval = widget.event!.repeatInterval;
      _reminderMinutesBefore = widget.event!.reminderMinutesBefore;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime(bool isStart) async {
    final now = DateTime.now();
    final initialDate = isStart ? _startDate : (_endDate ?? now);
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );
      if (time != null) {
        final dateTime = DateTime(picked.year, picked.month, picked.day, time.hour, time.minute);
        setState(() {
          if (isStart) {
            _startDate = dateTime;
            if (_allDay) _endDate = dateTime;
          } else {
            _endDate = dateTime;
          }
        });
      }
    }
  }

  Future<void> _saveEvent() async {
    if (_formKey.currentState!.validate()) {
      final box = Hive.box<CalendarEvent>('calendar_events_box');
      final event = widget.event ?? CalendarEvent(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        startDate: _startDate,
        endDate: _endDate ?? _startDate,
        isAllDay: _allDay,
        location: _locationController.text.isNotEmpty ? _locationController.text : null,
        url: _urlController.text.isNotEmpty ? _urlController.text : null,
        createdAt: DateTime.now(),
        designPatternId: _selectedDesignId,
        repeatInterval: _repeatInterval,
        reminderMinutesBefore: _reminderMinutesBefore,
      );
      event
        ..title = _titleController.text
        ..description = _descriptionController.text
        ..location = _locationController.text.isNotEmpty ? _locationController.text : null
        ..url = _urlController.text.isNotEmpty ? _urlController.text : null
        ..startDate = _startDate
        ..endDate = _endDate ?? _startDate
        ..isAllDay = _allDay
        ..designPatternId = _selectedDesignId
        ..repeatInterval = _repeatInterval
        ..reminderMinutesBefore = _reminderMinutesBefore;
      await box.put(event.id, event);
      
      // ✅ NEW: Schedule notifications for the event
      await EventNotificationService.scheduleNotifications(event);
      
      if (context.mounted) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassScaffold(
      showBackArrow: false,
      title: null,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveEvent,
        backgroundColor: theme.colorScheme.primary,
        icon: const Icon(CupertinoIcons.checkmark_alt, color: Colors.white),
        label: const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: DynamicBackground(
        child: Column(
          children: [
            SeamlessHeader(
              title: widget.event == null ? 'New Event' : 'Edit Event',
              icon: CupertinoIcons.calendar_today,
              iconColor: const Color(0xFFAB47BC),
              heroTagPrefix: 'events',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title *',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(CupertinoIcons.text_cursor),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Title required' : null,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.description_outlined),
                ),
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(CupertinoIcons.location),
                ),
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _urlController,
                decoration: InputDecoration(
                  labelText: 'URL (Optional)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(CupertinoIcons.link),
                ),
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Time',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () => _pickDateTime(true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceVariant,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(CupertinoIcons.clock, color: theme.colorScheme.onSurfaceVariant),
                                  const SizedBox(width: 12),
                                  Text(
                                    DateFormat('MMM dd, yyyy h:mm a').format(_startDate),
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: () => _pickDateTime(false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceVariant,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.access_time_filled, color: theme.colorScheme.onSurfaceVariant),
                                  const SizedBox(width: 12),
                                  Text(
                                    _endDate == null ? 'No end time' : DateFormat('MMM dd, yyyy h:mm a').format(_endDate!),
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SwitchListTile.adaptive(
                value: _allDay,
                onChanged: (value) {
                  setState(() {
                    _allDay = value;
                    if (value) {
                      _endDate = _startDate;
                    }
                  });
                },
                title: const Text('All-day'),
                subtitle: Text(_allDay 
                  ? 'No specific time' 
                  : 'Has start and end time'),
                secondary: Icon(_allDay 
                  ? CupertinoIcons.sun_max 
                  : CupertinoIcons.clock),
                controlAffinity: ListTileControlAffinity.trailing,
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reminders & Repeat',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(CupertinoIcons.bell),
                        title: const Text('Alert'),
                        trailing: DropdownButton<int>(
                          value: _reminderMinutesBefore,
                          underline: const SizedBox(),
                          items: _reminders.entries.map((entry) {
                            return DropdownMenuItem<int>(
                              value: entry.key,
                              child: Text(entry.value),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _reminderMinutesBefore = val ?? 0),
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(CupertinoIcons.repeat),
                        title: const Text('Repeat'),
                        trailing: DropdownButton<String>(
                          value: _repeatInterval ?? 'None',
                          underline: const SizedBox(),
                          items: _repeats.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _repeatInterval = val == 'None' ? null : val),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  final selectedDesign = await showModalBottomSheet<String?>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (ctx) => CalendarDesignPickerSheet(
                      currentDesignId: _selectedDesignId,
                    ),
                  );
                  if (selectedDesign != null) {
                    setState(() {
                      _selectedDesignId = selectedDesign;
                    });
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.paintbrush, color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 12),
                      Text(
                        'Card Design: $_selectedDesignId',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      const Icon(CupertinoIcons.chevron_right, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ],
),
      ),
    );
  }
}
