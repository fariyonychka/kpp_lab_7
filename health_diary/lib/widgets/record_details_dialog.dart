import 'package:flutter/material.dart';
import '../models/health_record.dart';
import '../theme/app_colors.dart';
import '../l10n/app_localizations.dart';
import 'photo_gallery.dart';

class RecordDetailsDialog extends StatelessWidget {
  final HealthRecord record;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const RecordDetailsDialog({
    super.key,
    required this.record,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isFood = record.type == RecordType.food;
    final photoUrls = record.details['photoUrls'] as List<dynamic>? ?? [];
    final hasPhotos = isFood && photoUrls.isNotEmpty;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: isFood ? 600 : 400, // Smart layout: wider for food
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: record.color.withValues(alpha: 0.1),
                  radius: 24,
                  child: Icon(record.iconData, color: record.color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${record.date.day}/${record.date.month}/${record.date.year} ${record.date.hour}:${record.date.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Details
            if (isFood) ...[
              _buildDetailRow(loc.calories, '${record.details['calories']}'),
              _buildDetailRow(loc.proteins, '${record.details['protein']}g'),
              _buildDetailRow(loc.fats, '${record.details['fat']}g'),
              _buildDetailRow(loc.carbs, '${record.details['carbs']}g'),
            ] else if (record.type == RecordType.sleep) ...[
              _buildDetailRow(
                loc.duration,
                '${record.details['duration']} ${loc.hours}',
              ),
              _buildDetailRow(loc.quality, record.details['quality']),
            ] else if (record.type == RecordType.mood) ...[
              _buildDetailRow(loc.energy, record.details['energy']),
              _buildDetailRow(loc.physicalState, record.details['physical']),
            ],

            const SizedBox(height: 16),

            // Notes
            if (record.details['notes'] != null) ...[
              Text(
                loc.notes,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(record.details['notes']),
              const SizedBox(height: 16),
            ],

            // Photos
            if (hasPhotos) ...[
              const SizedBox(height: 8),
              PhotoGallery(
                existingPhotoUrls: photoUrls.map((e) => e.toString()).toList(),
                newImageBytes: const [],
                onAddPhoto: () {},
                onRemoveExisting: (_) {},
                onRemoveNew: (_) {},
                readOnly: true,
              ),
              const SizedBox(height: 16),
            ],

            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: Text(
                    loc.delete,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit),
                  label: Text(loc.edit),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
