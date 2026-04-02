import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/common_widgets/mascot_character.dart';

class AuraPickerSheet extends StatefulWidget {
  const AuraPickerSheet({super.key});

  @override
  State<AuraPickerSheet> createState() => _AuraPickerSheetState();
}

class _AuraPickerSheetState extends State<AuraPickerSheet> {
  late MascotState _currentState;
  late Color _currentAuraColor;
  late double _currentHue;

  @override
  void initState() {
    super.initState();
    final box = Hive.box('settings');
    final stateIndex = box.get('mascot_state', defaultValue: MascotState.happy.index);
    _currentState = MascotState.values[stateIndex];
    
    final colorValue = box.get('mascot_aura_color', defaultValue: const Color(0xFF6C63FF).value);
    _currentAuraColor = Color(colorValue);
    _currentHue = HSVColor.fromColor(_currentAuraColor).hue;
  }

  void _updateState(MascotState state) {
    setState(() => _currentState = state);
    Hive.box('settings').put('mascot_state', state.index);
  }

  void _updateColor(Color color) {
    setState(() {
      _currentAuraColor = color;
      _currentHue = HSVColor.fromColor(color).hue;
    });
    Hive.box('settings').put('mascot_aura_color', color.value);
  }

  void _updateHue(double hue) {
    setState(() {
      _currentHue = hue;
      _currentAuraColor = HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor();
    });
    Hive.box('settings').put('mascot_aura_color', _currentAuraColor.value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withOpacity(0.1),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Mascot Aura',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Customize your companion\'s mood and aura',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 32),
          
          // Mascot Preview
          MascotCharacter(
            size: 100,
            state: _currentState,
            useThemeColor: false,
            color: _currentAuraColor,
          ),
          
          const SizedBox(height: 32),
          
          // Mood Selector
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Mood',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: MascotState.values.map((state) {
                final isSelected = _currentState == state;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ChoiceChip(
                    label: Text(state.name[0].toUpperCase() + state.name.substring(1)),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) _updateState(state);
                    },
                    selectedColor: _currentAuraColor.withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: isSelected ? _currentAuraColor : theme.colorScheme.onSurface,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Color Selector
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Preset Colors',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.spaceBetween,
            children: [
              _ColorDot(color: theme.colorScheme.primary, isSelected: _currentAuraColor.value == theme.colorScheme.primary.value, onTap: () => _updateColor(theme.colorScheme.primary)),
              _ColorDot(color: const Color(0xFF6C63FF), isSelected: _currentAuraColor.value == 0xFF6C63FF, onTap: () => _updateColor(const Color(0xFF6C63FF))),
              _ColorDot(color: const Color(0xFF4CAF50), isSelected: _currentAuraColor.value == 0xFF4CAF50, onTap: () => _updateColor(const Color(0xFF4CAF50))),
              _ColorDot(color: const Color(0xFFFF9800), isSelected: _currentAuraColor.value == 0xFFFF9800, onTap: () => _updateColor(const Color(0xFFFF9800))),
              _ColorDot(color: const Color(0xFFE91E63), isSelected: _currentAuraColor.value == 0xFFE91E63, onTap: () => _updateColor(const Color(0xFFE91E63))),
              _ColorDot(color: const Color(0xFF00BCD4), isSelected: _currentAuraColor.value == 0xFF00BCD4, onTap: () => _updateColor(const Color(0xFF00BCD4))),
              _ColorDot(color: const Color(0xFF9C27B0), isSelected: _currentAuraColor.value == 0xFF9C27B0, onTap: () => _updateColor(const Color(0xFF9C27B0))),
            ],
          ),
          
          const SizedBox(height: 24),
          
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Custom Color',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFF0000),
                  Color(0xFFFFFF00),
                  Color(0xFF00FF00),
                  Color(0xFF00FFFF),
                  Color(0xFF0000FF),
                  Color(0xFFFF00FF),
                  Color(0xFFFF0000),
                ],
              ),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, spreadRadius: 1),
              ],
            ),
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: 0,
                thumbColor: Colors.white,
                activeTrackColor: Colors.transparent,
                inactiveTrackColor: Colors.transparent,
                overlayColor: Colors.white.withOpacity(0.2),
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14, elevation: 4),
              ),
              child: Slider(
                value: _currentHue,
                min: 0,
                max: 360,
                onChanged: _updateHue,
              ),
            ),
          ),

          const SizedBox(height: 32),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: _currentAuraColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Confirm Changes', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorDot({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 3,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: color.withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 1,
              ),
          ],
        ),
      ),
    );
  }
}
