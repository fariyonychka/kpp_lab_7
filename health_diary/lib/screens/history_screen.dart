import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../core/record.dart';
import '../core/history_provider.dart';
import '../providers/records_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_toast.dart';
import '../models/food_record.dart';
import '../models/sleep_record.dart';
import '../models/mood_record.dart';
import 'food_record_screen.dart';
import 'sleep_record_screen.dart';
import 'mood_record_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HistoryProvider(),
      child: const _HistoryView(),
    );
  }
}

class _HistoryView extends StatefulWidget {
  const _HistoryView();

  @override
  State<_HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<_HistoryView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<HistoryProvider>().loadRecords();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.historyTitle,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),
          const _FiltersRow(),
          const SizedBox(height: 20),
          const Expanded(child: _RecordsList()),
        ],
      ),
    );
  }
}

class _FiltersRow extends StatelessWidget {
  const _FiltersRow();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final provider = context.watch<HistoryProvider>();

    return Row(
      children: [
        _FilterChip(
          label: loc.all,
          selected: provider.filterType == null,
          onTap: () => provider.clearFilter(),
        ),
        const SizedBox(width: 8),
        _FilterChip(
          label: loc.sleep,
          selected: provider.filterType == RecordType.sleep,
          onTap: () => provider.setFilter(RecordType.sleep),
        ),
        const SizedBox(width: 8),
        _FilterChip(
          label: loc.food,
          selected: provider.filterType == RecordType.food,
          onTap: () => provider.setFilter(RecordType.food),
        ),
        const SizedBox(width: 8),
        _FilterChip(
          label: loc.mood,
          selected: provider.filterType == RecordType.mood,
          onTap: () => provider.setFilter(RecordType.mood),
        ),
        const Spacer(),
        IconButton(
          icon: Icon(
            provider.sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
          ),
          onPressed: () => provider.toggleSort(),
          tooltip: loc.sortByDate,
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(
          label,
          style: TextStyle(color: selected ? Colors.white : Colors.black),
        ),
        backgroundColor: selected ? AppColors.primary : Colors.grey[200],
      ),
    );
  }
}

void showRecordDetail(BuildContext context, HealthRecord record) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: _RecordDetailContent(record: record),
    ),
  );
}

class _RecordDetailContent extends StatefulWidget {
  final HealthRecord record;

  const _RecordDetailContent({required this.record});

  @override
  State<_RecordDetailContent> createState() => _RecordDetailContentState();
}

class _RecordDetailContentState extends State<_RecordDetailContent> {
  String _translateKey(BuildContext context, String key) {
    final loc = AppLocalizations.of(context)!;
    return switch (key) {
      'calories' => loc.calories,
      'protein' => loc.proteins,
      'fat' => loc.fats,
      'carbs' => loc.carbs,
      'duration' => loc.duration,
      'quality' => loc.quality,
      'mood' => loc.mood,
      'energy' => loc.energy,
      'physical' => loc.physicalState,
      'notes' => loc.notes,
      _ => key,
    };
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

  String _getRecordTitle(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    switch (widget.record.type) {
      case RecordType.sleep:
        return loc.sleepRecord;
      case RecordType.mood:
        return loc.moodRecord;
      case RecordType.food:
        return widget.record.title;
    }
  }

  Future<void> _onDelete() async {
    final loc = AppLocalizations.of(context)!;
    final provider = context.read<RecordsProvider>();

    if (provider.isLoading) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(loc.deleteRecord),
        content: Text(
          widget.record.type == RecordType.food
              ? 'Видалити запис та всі фото?'
              : loc.deleteConfirmation,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(loc.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(loc.delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      bool success = false;

      switch (widget.record.type) {
        case RecordType.food:
          success = await provider.deleteFoodRecord(widget.record.id);
          break;
        case RecordType.sleep:
          success = await provider.deleteSleepRecord(widget.record.id);
          break;
        case RecordType.mood:
          success = await provider.deleteMoodRecord(widget.record.id);
          break;
      }

      if (mounted) {
        if (success) {
          Navigator.pop(context); // Close detail dialog
          context.read<HistoryProvider>().loadRecords(); // Refresh list
          CustomToast.showInfo(
            context,
            widget.record.type == RecordType.food
                ? 'Запис та фото видалено'
                : loc.recordDeleted,
          );
        } else {
          CustomToast.showInfo(context, provider.error ?? loc.errorDeleting);
        }
      }
    }
  }

  void _onEdit() {
    Navigator.pop(context); // Close dialog first

    if (widget.record.type == RecordType.food) {
      final foodRecord = FoodRecord(
        id: widget.record.id,
        date: widget.record.date,
        dishName: widget.record.title,
        calories: widget.record.details['calories'] as int,
        protein: (widget.record.details['protein'] as num).toDouble(),
        fat: (widget.record.details['fat'] as num).toDouble(),
        carbs: (widget.record.details['carbs'] as num).toDouble(),
        notes: widget.record.details['notes'] as String?,
        photoUrls: List<String>.from(widget.record.details['photoUrls'] ?? []),
        createdAt:
            widget.record.details['createdAt'] as DateTime? ?? DateTime.now(),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FoodRecordScreen(recordToEdit: foodRecord),
        ),
      );
    } else if (widget.record.type == RecordType.sleep) {
      final sleepRecord = SleepRecord(
        id: widget.record.id,
        date: widget.record.date,
        durationHours: double.parse(widget.record.details['duration']),
        quality: widget.record.details['quality'] as String,
        notes: widget.record.details['notes'] as String?,
        createdAt:
            widget.record.details['createdAt'] as DateTime? ?? DateTime.now(),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SleepRecordScreen(recordToEdit: sleepRecord),
        ),
      );
    } else if (widget.record.type == RecordType.mood) {
      final energyStr = widget.record.details['energy'] as String;
      final energy = int.parse(energyStr.split('/')[0]);

      final moodRecord = MoodRecord(
        id: widget.record.id,
        date: widget.record.date,
        mood: widget.record.details['mood'] as String,
        energyLevel: energy,
        physicalState: widget.record.details['physical'] as String,
        notes: widget.record.details['notes'] as String?,
        createdAt:
            widget.record.details['createdAt'] as DateTime? ?? DateTime.now(),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MoodRecordScreen(recordToEdit: moodRecord),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final photoUrls = widget.record.details['photoUrls'] as List<String>? ?? [];
    final isFood = widget.record.type == RecordType.food;
    final isLargeLayout = isFood && photoUrls.isNotEmpty;

    return Center(
      child: Container(
        width: isLargeLayout ? 1000 : 800,
        height: isLargeLayout ? MediaQuery.of(context).size.height * 0.9 : null,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: isLargeLayout ? _buildLargeLayout() : _buildCompactLayout(),
        ),
      ),
    );
  }

  Widget _buildLargeLayout() {
    final loc = AppLocalizations.of(context)!;
    final photoUrls = widget.record.details['photoUrls'] as List<String>? ?? [];
    final notes = widget.record.details['notes'] as String?;

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.record.color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.record.iconData,
                  size: 32,
                  color: widget.record.color,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.recordDetails,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.record.date.day} ${_monthName(context, widget.record.date.month)} ${widget.record.date.year}, '
                      '${widget.record.date.hour}:${widget.record.date.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, size: 28),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  hoverColor: Colors.grey[200],
                ),
              ),
            ],
          ),
        ),

        // Content
        Expanded(
          child: Column(
            children: [
              // Photos
              Expanded(
                flex: 6,
                child: Container(
                  width: double.infinity,
                  color: Colors.grey[50],
                  child: ScrollConfiguration(
                    behavior: const ScrollBehavior().copyWith(
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                      },
                    ),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 32,
                      ),
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: photoUrls.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 24),
                      itemBuilder: (ctx, index) {
                        return _LargePhotoItem(
                          url: photoUrls[index],
                          onTap: () => _openGallery(context, photoUrls, index),
                        );
                      },
                    ),
                  ),
                ),
              ),

              // Details
              Expanded(
                flex: 4,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getRecordTitle(context),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildDetailsGrid(isCompact: true),
                      if (notes != null && notes.isNotEmpty) ...[
                        const SizedBox(height: 32),
                        const Divider(),
                        const SizedBox(height: 24),
                        _buildNotesSection(notes),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Footer
        _buildFooter(),
      ],
    );
  }

  Widget _buildCompactLayout() {
    final notes = widget.record.details['notes'] as String?;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header with Close Button
        Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 28),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 20),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: widget.record.color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.record.iconData,
                    size: 48,
                    color: widget.record.color,
                  ),
                ),
              ),
            ),
          ],
        ),

        // Title & Date
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              Text(
                '${widget.record.date.day} ${_monthName(context, widget.record.date.month)} ${widget.record.date.year}, '
                '${widget.record.date.hour}:${widget.record.date.minute.toString().padLeft(2, '0')}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _getRecordTitle(context),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Scrollable Content
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                _buildDetailsGrid(isCompact: true),
                if (notes != null && notes.isNotEmpty) ...[
                  const SizedBox(height: 32),
                  _buildNotesSection(notes),
                ],
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),

        // Footer
        _buildFooter(),
      ],
    );
  }

  Widget _buildDetailsGrid({bool isCompact = false}) {
    final items = widget.record.details.entries
        .where(
          (e) =>
              e.key != 'photoUrls' && e.key != 'notes' && e.key != 'createdAt',
        )
        .toList();

    if (isCompact) {
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: items.map((e) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: _buildDetailItem(e.key, e.value, isCompact: true),
              ),
            );
          }).toList(),
        ),
      );
    }

    return Wrap(
      spacing: 24,
      runSpacing: 24,
      children: items.map((e) {
        return Container(
          constraints: const BoxConstraints(minWidth: 150),
          child: _buildDetailItem(e.key, e.value),
        );
      }).toList(),
    );
  }

  Widget _buildDetailItem(String key, dynamic value, {bool isCompact = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: isCompact
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        mainAxisSize: isCompact ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: isCompact
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          Text(
            _translateKey(context, key).toUpperCase(),
            textAlign: isCompact ? TextAlign.center : TextAlign.start,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _translateValue(context, key, value),
            textAlign: isCompact ? TextAlign.center : TextAlign.start,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection(String notes) {
    final loc = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.notes, color: AppColors.primary, size: 24),
            const SizedBox(width: 12),
            Text(
              loc.notes,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8E1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFFE082), width: 1),
          ),
          child: Text(
            notes,
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Color(0xFF5D4037),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    final loc = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton.icon(
            onPressed: _onDelete,
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            label: Text(
              loc.delete,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: _onEdit,
            icon: const Icon(Icons.edit, color: Colors.white),
            label: Text(
              loc.edit,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openGallery(BuildContext context, List<String> urls, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              PhotoViewGallery.builder(
                scrollPhysics: const BouncingScrollPhysics(),
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: CachedNetworkImageProvider(urls[index]),
                    initialScale: PhotoViewComputedScale.contained,
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 2,
                    heroAttributes: PhotoViewHeroAttributes(tag: urls[index]),
                  );
                },
                itemCount: urls.length,
                loadingBuilder: (context, event) => const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
                pageController: PageController(initialPage: initialIndex),
              ),
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _monthName(BuildContext context, int month) {
    final loc = AppLocalizations.of(context)!;
    final months = [
      loc.january,
      loc.february,
      loc.march,
      loc.april,
      loc.may,
      loc.june,
      loc.july,
      loc.august,
      loc.september,
      loc.october,
      loc.november,
      loc.december,
    ];
    return months[month - 1];
  }
}

class _LargePhotoItem extends StatefulWidget {
  final String url;
  final VoidCallback onTap;

  const _LargePhotoItem({required this.url, required this.onTap});

  @override
  State<_LargePhotoItem> createState() => _LargePhotoItemState();
}

class _LargePhotoItemState extends State<_LargePhotoItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()..scale(_isHovered ? 1.02 : 1.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.15 : 0.05),
                blurRadius: _isHovered ? 20 : 10,
                offset: Offset(0, _isHovered ? 8 : 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: widget.url,
              fit: BoxFit.contain, // Never cropped!
              placeholder: (context, url) => Container(
                width: 300,
                color: Colors.grey[100],
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                width: 300,
                color: Colors.grey[100],
                child: const Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RecordsList extends StatelessWidget {
  const _RecordsList();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final provider = context.watch<HistoryProvider>();

    if (provider.status == HistoryStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.status == HistoryStatus.error) {
      return Center(child: Text(loc.loadingError));
    }

    final records = provider.filteredRecords;

    if (records.isEmpty) {
      return Center(child: Text(loc.noRecords));
    }

    return ListView.builder(
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];
        return _HistoryCard(record: record);
      },
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final HealthRecord record;
  const _HistoryCard({required this.record});

  String _getRecordTitle(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    switch (record.type) {
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
    switch (record.type) {
      case RecordType.sleep:
        final duration = record.details['duration'];
        final quality = record.details['quality'];
        final qualityStr = _translateValue(context, 'quality', quality);
        return '$duration ${loc.hours} · $qualityStr';
      case RecordType.mood:
        final energy = record.details['energy'];
        final physical = record.details['physical'];
        final physicalStr = _translateValue(context, 'physical', physical);
        return '${loc.energy}: $energy · $physicalStr';
      case RecordType.food:
        return '${record.title} · ${record.subtitle}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: record.color.withOpacity(0.1),
          child: Center(
            child: Icon(record.iconData, size: 24, color: record.color),
          ),
        ),
        title: Text(
          _getRecordTitle(context),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(_getRecordSubtitle(context)),
        trailing: Text(
          '${record.date.day}/${record.date.month}/${record.date.year}',
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        onTap: () => showRecordDetail(context, record),
      ),
    );
  }
}
