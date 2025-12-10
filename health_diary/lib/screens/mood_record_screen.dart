import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../widgets/labeled_field.dart';
import '../widgets/selectable_button.dart';
import '../widgets/action_button.dart';

import '../theme/app_colors.dart';
import '../widgets/custom_toast.dart';
import 'home_screen_controller.dart';
import '../providers/records_provider.dart';
import '../models/mood_record.dart';

class MoodRecordScreen extends StatefulWidget {
  final HomeScreenController? controller;
  final MoodRecord? recordToEdit;

  const MoodRecordScreen({super.key, this.controller, this.recordToEdit});

  @override
  State<MoodRecordScreen> createState() => _MoodRecordScreenState();
}

class _MoodRecordScreenState extends State<MoodRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  String _mood = 'happy';
  int _energy = 7;
  String _physical = 'good';
  final _notesCtrl = TextEditingController();
  DateTime _selectedDateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.recordToEdit != null) {
      final r = widget.recordToEdit!;
      _mood = r.mood;
      _energy = r.energyLevel;
      _physical = r.physicalState;
      _notesCtrl.text = r.notes ?? '';
      _selectedDateTime = r.date;
    }
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  void _onCancel() {
    if (widget.controller != null) {
      widget.controller!.goHome();
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _onSave() async {
    final loc = AppLocalizations.of(context)!;
    final provider = context.read<RecordsProvider>();

    if (provider.isLoading) return;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final record = MoodRecord(
      id: widget.recordToEdit?.id ?? '',
      date: _selectedDateTime,
      mood: _mood,
      energyLevel: _energy,
      physicalState: _physical,
      notes: _notesCtrl.text.isEmpty ? null : _notesCtrl.text,
      createdAt: widget.recordToEdit?.createdAt ?? DateTime.now(),
    );

    bool success;
    if (widget.recordToEdit != null) {
      success = await provider.updateMoodRecord(record);
    } else {
      success = await provider.addMoodRecord(record);
    }

    if (!mounted) return;

    if (success) {
      CustomToast.showSuccess(context, loc.recordSaved);
      if (widget.controller != null) {
        widget.controller!.goHome();
      } else {
        Navigator.pop(context);
      }
    } else {
      CustomToast.showError(context, provider.error ?? loc.errorSaving);
    }
  }

  Future<void> _selectDateTime() async {
    if (!mounted) return;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: Localizations.localeOf(context),
      builder: (ctx, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: Colors.black,
          ),
        ),
        child: child!,
      ),
    );

    if (!mounted || pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      builder: (ctx, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );

    if (!mounted || pickedTime == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  String _formatDateTime(DateTime dt, AppLocalizations loc) {
    final isToday =
        dt.year == DateTime.now().year &&
        dt.month == DateTime.now().month &&
        dt.day == DateTime.now().day;

    final dateStr = isToday
        ? loc.today
        : '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';

    final timeStr = MaterialLocalizations.of(
      context,
    ).formatTimeOfDay(TimeOfDay.fromDateTime(dt), alwaysUse24HourFormat: false);

    return '$dateStr, $timeStr';
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isEditing = widget.recordToEdit != null;
    final isLoading = context.select<RecordsProvider, bool>((p) => p.isLoading);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(isEditing ? loc.edit : loc.moodRecord),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: _onCancel,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabeledField(
                label: loc.dateTime,
                field: GestureDetector(
                  onTap: _selectDateTime,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 2,
                          color: AppColors.placeholder,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            child: Text(
                              _formatDateTime(_selectedDateTime, loc),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: Icon(
                            Icons.calendar_today,
                            size: 18,
                            color: AppColors.placeholder,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              LabeledField(
                label: loc.mood,
                field: Row(
                  children: [
                    SelectableButton(
                      title: loc.happy,
                      selected: _mood == 'happy',
                      onTap: () => setState(() => _mood = 'happy'),
                    ),
                    const SizedBox(width: 12),
                    SelectableButton(
                      title: loc.neutral,
                      selected: _mood == 'neutral',
                      onTap: () => setState(() => _mood = 'neutral'),
                    ),
                    const SizedBox(width: 12),
                    SelectableButton(
                      title: loc.sad,
                      selected: _mood == 'sad',
                      onTap: () => setState(() => _mood = 'sad'),
                    ),
                    const SizedBox(width: 12),
                    SelectableButton(
                      title: loc.stressed,
                      selected: _mood == 'stressed',
                      onTap: () => setState(() => _mood = 'stressed'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              LabeledField(
                label: loc.energyLevel(_energy),
                field: Slider(
                  value: _energy.toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  activeColor: AppColors.primary,
                  onChanged: (v) => setState(() => _energy = v.round()),
                ),
              ),
              const SizedBox(height: 20),

              LabeledField(
                label: loc.physicalState,
                field: Row(
                  children: [
                    SelectableButton(
                      title: loc.bad,
                      selected: _physical == 'bad',
                      onTap: () => setState(() => _physical = 'bad'),
                    ),
                    const SizedBox(width: 10),
                    SelectableButton(
                      title: loc.goodState,
                      selected: _physical == 'good',
                      onTap: () => setState(() => _physical = 'good'),
                    ),
                    const SizedBox(width: 10),
                    SelectableButton(
                      title: loc.excellent,
                      selected: _physical == 'excellent',
                      onTap: () => setState(() => _physical = 'excellent'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.notes,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      border: Border.all(color: AppColors.border, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.note,
                          size: 18,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _notesCtrl,
                            maxLines: 3,
                            style: const TextStyle(
                              fontSize: 15,
                              color: AppColors.textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: loc.notesHint,
                              hintStyle: const TextStyle(
                                color: AppColors.placeholder,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: ActionButton(
                      text: loc.cancel,
                      color: Colors.grey,
                      onPressed: _onCancel,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ActionButton(
                      text: isLoading ? loc.saving : loc.save,
                      color: AppColors.primary,
                      onPressed: isLoading ? () {} : _onSave,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
