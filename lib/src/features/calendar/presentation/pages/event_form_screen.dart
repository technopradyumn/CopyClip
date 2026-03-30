import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/widgets/dynamic_background.dart';
import '../../../../features/calendar/data/calendar_event_model.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';
import 'package:copyclip/src/core/services/gamification_service.dart';

class EventFormScreen extends StatefulWidget {
  final CalendarEvent? event;
  final String? eventId;
  final DateTime? selectedDate;

  const EventFormScreen({super.key, this.event, this.eventId, this.selectedDate});

  @override
  State<EventFormScreen> createState() => _EventFormScreenState();
}

class _EventFormScreenState extends State<EventFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _locationController;
  late TextEditingController _urlController;

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(hours: 1));
  bool _isAllDay = false;
  String _colorCode = '#FF6C00'; // Default Orange
  String? _repeatInterval;
  int _reminderMinutes = 0;

  final List<String> _colors = ['#FF6C00', '#2196F3', '#4CAF50', '#F44336', '#9C27B0'];
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
    _titleController = TextEditingController();
    _descController = TextEditingController();
    _locationController = TextEditingController();
    _urlController = TextEditingController();

    if (widget.event != null) {
      _loadEvent(widget.event!);
    } else if (widget.eventId != null) {
      final box = Hive.box<CalendarEvent>('calendar_events_box');
      final ev = box.values.firstWhere((e) => e.id == widget.eventId, orElse: () => _createEmptyEvent());
      if (ev.id.isNotEmpty) _loadEvent(ev);
    } else if (widget.selectedDate != null) {
      _startDate = widget.selectedDate!;
      _endDate = _startDate.add(const Duration(hours: 1));
    }
  }

  CalendarEvent _createEmptyEvent() => CalendarEvent(id: '', title: '', startDate: DateTime.now(), endDate: DateTime.now());

  void _loadEvent(CalendarEvent ev) {
    _titleController.text = ev.title;
    _descController.text = ev.description;
    _locationController.text = ev.location ?? '';
    _urlController.text = ev.url ?? '';
    _startDate = ev.startDate;
    _endDate = ev.endDate;
    _isAllDay = ev.isAllDay;
    _colorCode = ev.colorCode ?? _colors.first;
    _repeatInterval = ev.repeatInterval;
    _reminderMinutes = ev.reminderMinutesBefore;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _locationController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  void _saveEvent() async {
    if (!_formKey.currentState!.validate()) return;
    
    final box = Hive.box<CalendarEvent>('calendar_events_box');
    
    final ev = widget.event ?? CalendarEvent(
      id: widget.eventId ?? const Uuid().v4(),
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      startDate: _startDate,
      endDate: _endDate,
    );

    ev.title = _titleController.text.trim();
    ev.description = _descController.text.trim();
    ev.location = _locationController.text.trim().isEmpty ? null : _locationController.text.trim();
    ev.url = _urlController.text.trim().isEmpty ? null : _urlController.text.trim();
    ev.startDate = _startDate;
    ev.endDate = _endDate;
    ev.isAllDay = _isAllDay;
    ev.colorCode = _colorCode;
    ev.repeatInterval = _repeatInterval == 'None' ? null : _repeatInterval;
    ev.reminderMinutesBefore = _reminderMinutes;
    ev.isDeleted = false;

    if (!box.containsKey(ev.key)) {
      await box.add(ev);
    } else {
      await ev.save();
    }

    // Award XP
    if (mounted) {
      try {
        Provider.of<GamificationService>(context, listen: false)
            .recordFeatureUsage('calendar_event');
      } catch (_) {}
    }

    if (mounted) context.pop();
  }

  void _deleteEvent() async {
    if (widget.event != null) {
      widget.event!.isDeleted = true;
      await widget.event!.save();
      if (mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurf = theme.colorScheme.onSurface;

    return GlassScaffold(
      showBackArrow: true,
      title: Text(
        widget.event == null ? "New Event" : "Edit Event",
        style: TextStyle(color: onSurf, fontWeight: FontWeight.bold),
      ),
      actions: [
        if (widget.event != null)
          IconButton(
            icon: const Icon(CupertinoIcons.trash, color: Colors.redAccent),
            onPressed: () => _deleteEvent(),
          ),
        TextButton(
          onPressed: _saveEvent,
          child: const Text(
            "Save",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        )
      ],
      body: DynamicBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(_titleController, "Title", Icons.title, true),
                const SizedBox(height: 16),
                _buildTextField(_descController, "Description (Optional)", Icons.description, false, maxLines: 3),
                const SizedBox(height: 24),
                
                // Dates
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
                  ),
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text("All-day"),
                        value: _isAllDay,
                        onChanged: (val) => setState(() => _isAllDay = val),
                        activeColor: theme.colorScheme.primary,
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: const Text("Starts"),
                        trailing: Text(
                          _isAllDay ? DateFormat.yMMMd().format(_startDate) : DateFormat('MMM d, yyyy h:mm a').format(_startDate),
                          style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                        ),
                        onTap: () => _pickDateTime(true),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: const Text("Ends"),
                        trailing: Text(
                          _isAllDay ? DateFormat.yMMMd().format(_endDate) : DateFormat('MMM d, yyyy h:mm a').format(_endDate),
                          style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                        ),
                        onTap: () => _pickDateTime(false),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Details
                _buildTextField(_locationController, "Location", CupertinoIcons.location, false),
                const SizedBox(height: 16),
                _buildTextField(_urlController, "URL", CupertinoIcons.link, false),
                const SizedBox(height: 24),

                // Repeat & Alert
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(CupertinoIcons.repeat),
                        title: const Text("Repeat"),
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
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(CupertinoIcons.bell),
                        title: const Text("Alert"),
                        trailing: DropdownButton<int>(
                          value: _reminderMinutes,
                          underline: const SizedBox(),
                          items: _reminders.entries.map((entry) {
                            return DropdownMenuItem<int>(
                              value: entry.key,
                              child: Text(entry.value),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _reminderMinutes = val!),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Color Picker
                Wrap(
                  spacing: 12,
                  children: _colors.map((c) {
                    final color = Color(int.parse(c.substring(1, 7), radix: 16) + 0xFF000000);
                    return GestureDetector(
                      onTap: () => setState(() => _colorCode = c),
                      child: CircleAvatar(
                        backgroundColor: color,
                        child: _colorCode == c ? const Icon(Icons.check, color: Colors.white) : null,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, bool isRequired, {int maxLines = 1}) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
        filled: true,
        fillColor: theme.colorScheme.surface.withValues(alpha: 0.5),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      validator: (val) {
        if (isRequired && (val == null || val.trim().isEmpty)) {
          return "This field is required";
        }
        return null;
      },
    );
  }

  Future<void> _pickDateTime(bool isStart) async {
    DateTime initial = isStart ? _startDate : _endDate;
    
    if (_isAllDay) {
      final date = await showDatePicker(
        context: context,
        initialDate: initial,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (date != null) {
        setState(() {
          if (isStart) {
            _startDate = date;
            if (_endDate.isBefore(_startDate)) _endDate = _startDate;
          } else {
            _endDate = date;
            if (_startDate.isAfter(_endDate)) _startDate = _endDate;
          }
        });
      }
    } else {
      final date = await showDatePicker(
        context: context,
        initialDate: initial,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (date == null) return;
      
      if (!mounted) return;
      
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initial),
      );
      if (time == null) return;
      
      final dt = DateTime(date.year, date.month, date.day, time.hour, time.minute);
      setState(() {
        if (isStart) {
          _startDate = dt;
          if (_endDate.isBefore(_startDate)) _endDate = _startDate.add(const Duration(hours: 1));
        } else {
          _endDate = dt;
          if (_startDate.isAfter(_endDate)) _startDate = _endDate.subtract(const Duration(hours: 1));
        }
      });
    }
  }
}
