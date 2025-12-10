import 'package:flutter/material.dart';

import '../models/health_record.dart';
import '../theme/app_colors.dart';
import '../l10n/app_localizations.dart';

class RecordCard extends StatefulWidget {
  final HealthRecord record;
  final VoidCallback onTap;

  const RecordCard({super.key, required this.record, required this.onTap});

  @override
  State<RecordCard> createState() => _RecordCardState();
}

class _RecordCardState extends State<RecordCard> {
  bool _isHovered = false;

  String _getRecordTitle(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    switch (widget.record.type) {
      case RecordType.sleep:
        return loc.sleepRecord;
      case RecordType.mood:
        return loc.moodRecord;
      case RecordType.food:
        return loc.foodRecord;
    }
  }

  String _translateValue(BuildContext context, String key, dynamic value) {
    final loc = AppLocalizations.of(context)!;
    final strVal = value.toString();

    if (key == 'quality') {
      return switch (strVal) {
        'poor' => loc.poor,
        'good' => loc.good,
        'excellent' => loc.sleepExcellent,
        _ => strVal,
      };
    } else if (key == 'mood') {
      return switch (strVal) {
        'happy' => loc.happy,
        'neutral' => loc.neutral,
        'sad' => loc.sad,
        'stressed' => loc.stressed,
        _ => strVal,
      };
    } else if (key == 'physical') {
      return switch (strVal) {
        'bad' => loc.bad,
        'good' => loc.goodState,
        'excellent' => loc.excellent,
        _ => strVal,
      };
    }
    return strVal;
  }

  String _getRecordSubtitle(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    switch (widget.record.type) {
      case RecordType.sleep:
        final duration = widget.record.details['duration'];
        final quality = widget.record.details['quality'];
        final qualityStr = _translateValue(context, 'quality', quality);
        return '$duration ${loc.hours} · $qualityStr';
      case RecordType.mood:
        final energy = widget.record.details['energy'];
        final physical = widget.record.details['physical'];
        final physicalStr = _translateValue(context, 'physical', physical);
        return '${loc.energy}: $energy · $physicalStr';
      case RecordType.food:
        return '${widget.record.title} · ${widget.record.subtitle}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Card(
          elevation: 0,
          color: _isHovered ? Colors.grey[50] : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            leading: CircleAvatar(
              backgroundColor: widget.record.color.withValues(alpha: 0.1),
              radius: 24,
              child: Icon(
                widget.record.iconData,
                color: widget.record.color,
                size: 24,
              ),
            ),
            title: Text(
              _getRecordTitle(context),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(
              _getRecordSubtitle(context),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${widget.record.date.day}/${widget.record.date.month} ${widget.record.date.hour}:${widget.record.date.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
