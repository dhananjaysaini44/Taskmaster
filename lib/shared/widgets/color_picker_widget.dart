import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../core/theme/app_theme_extension.dart';

class ColorPickerWidget extends StatelessWidget {
  final List<Color> presets;
  final Color selected;
  final ValueChanged<Color> onChanged;

  const ColorPickerWidget({
    super.key,
    required this.presets,
    required this.selected,
    required this.onChanged,
  });

  void _showCustomColorPicker(BuildContext context) {
    Color pickerColor = selected;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a custom color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: (color) => pickerColor = color,
            pickerAreaHeightPercent: 0.8,
            enableAlpha: false,
            displayThumbColor: true,
            labelTypes: const [ColorLabelType.hsl, ColorLabelType.rgb],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: const Text('Select'),
            onPressed: () {
              onChanged(pickerColor);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).appTheme;

    return Wrap(
      spacing: theme.spacingMD,
      runSpacing: theme.spacingMD,
      children: [
        ...presets.map((color) {
          final isSelected = color.toARGB32() == selected.toARGB32();
          return _ColorCircle(
            color: color,
            isSelected: isSelected,
            onTap: () => onChanged(color),
            theme: theme,
          );
        }),
        _CustomColorCircle(
          isSelected: !presets.any((c) => c.toARGB32() == selected.toARGB32()),
          onTap: () => _showCustomColorPicker(context),
          theme: theme,
          activeColor: selected,
        ),
      ],
    );
  }
}

class _ColorCircle extends StatefulWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;
  final AppThemeExtension theme;

  const _ColorCircle({
    required this.color,
    required this.isSelected,
    required this.onTap,
    required this.theme,
  });

  @override
  State<_ColorCircle> createState() => _ColorCircleState();
}

class _ColorCircleState extends State<_ColorCircle> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 200),
          scale: widget.isSelected || _isHovered ? 1.2 : 1.0,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: widget.color,
              shape: BoxShape.circle,
              border: widget.isSelected
                  ? Border.all(color: widget.theme.primary, width: 3)
                  : Border.all(
                      color:
                          widget.theme.labelSmall.color?.withValues(
                            alpha: 0.1,
                          ) ??
                          Colors.grey,
                      width: 1,
                    ),
              boxShadow: [
                if (widget.isSelected)
                  BoxShadow(
                    color: widget.color.withValues(alpha: 0.4),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
              ],
            ),
            child: widget.isSelected
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : null,
          ),
        ),
      ),
    );
  }
}

class _CustomColorCircle extends StatefulWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final AppThemeExtension theme;
  final Color activeColor;

  const _CustomColorCircle({
    required this.isSelected,
    required this.onTap,
    required this.theme,
    required this.activeColor,
  });

  @override
  State<_CustomColorCircle> createState() => _CustomColorCircleState();
}

class _CustomColorCircleState extends State<_CustomColorCircle> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 200),
          scale: widget.isSelected || _isHovered ? 1.2 : 1.0,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: widget.isSelected
                  ? null
                  : const SweepGradient(
                      colors: [
                        Colors.red,
                        Colors.yellow,
                        Colors.green,
                        Colors.cyan,
                        Colors.blue,
                        Colors.pink,
                        Colors.red,
                      ],
                    ),
              color: widget.isSelected ? widget.activeColor : null,
              shape: BoxShape.circle,
              border: widget.isSelected
                  ? Border.all(color: widget.theme.primary, width: 3)
                  : null,
            ),
            child: widget.isSelected
                ? const Icon(Icons.colorize, size: 16, color: Colors.white)
                : const Icon(Icons.add, size: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
