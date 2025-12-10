import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/sleep_record.dart';
import '../providers/records_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/action_button.dart';
import '../widgets/custom_toast.dart';
import '../widgets/labeled_field.dart';
import '../widgets/selectable_button.dart';
import 'home_screen_controller.dart';

class SleepRecordScreen extends StatefulWidget {
  final HomeScreenController? controller;
  final SleepRecord? recordToEdit;

  const SleepRecordScreen({super.key, this.controller, this.recordToEdit});

  @override
  State<SleepRecordScreen> createState() => _SleepRecordScreenState();
}

class _SleepRecordScreenState extends State<SleepRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _durationCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  DateTime _selectedDateTime = DateTime.now();
  String _selectedQuality = 'good';

  final List<String> _qualityOptions = ['poor', 'good', 'excellent'];

  @override
  void initState() {
    super.initState();
    if (widget.recordToEdit != null) {
      final r = widget.recordToEdit!;
      _durationCtrl.text = r.durationHours.toString();
      _selectedQuality = r.quality;
      _notesCtrl.text = r.notes ?? '';
      _selectedDateTime = r.date;
    }
  }

  @override
  void dispose() {
    _durationCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    final loc = AppLocalizations.of(context)!;
    final provider = context.read<RecordsProvider>();

    if (provider.isLoading) return;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final duration = double.tryParse(_durationCtrl.text);
    if (duration == null || duration <= 0) {
      CustomToast.showError(context, loc.invalidDuration);
      return;
    }

    final record = SleepRecord(
      id: widget.recordToEdit?.id ?? '',
      date: _selectedDateTime,
      durationHours: duration,
      quality: _selectedQuality,
      notes: _notesCtrl.text.isEmpty ? null : _notesCtrl.text,
      createdAt: widget.recordToEdit?.createdAt ?? DateTime.now(),
    );

    bool success;
    if (widget.recordToEdit != null) {
      success = await provider.updateSleepRecord(record);
    } else {
      success = await provider.addSleepRecord(record);
    }

    if (mounted) {
      if (success) {
        CustomToast.showSuccess(context, loc.sleepSaved);
        if (widget.controller != null) {
          widget.controller!.goHome();
        } else {
          Navigator.pop(context);
        }
      } else {
        CustomToast.showError(context, provider.error ?? loc.errorSaving);
      }
    }
  }

  String _getQualityLabel(String q, AppLocalizations loc) {
    switch (q) {
      case 'poor':
        return loc.poor;
      case 'good':
        return loc.good;
      case 'excellent':
        return loc.sleepExcellent;
      default:
        return q;
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

  void _onCancel() {
    if (widget.controller != null) {
      widget.controller!.goHome();
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isEditing = widget.recordToEdit != null;
    final isLoading = context.select<RecordsProvider, bool>((p) => p.isLoading);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(isEditing ? loc.edit : loc.sleepRecord),
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

              CustomTextField(
                controller: _durationCtrl,
                label: loc.duration,
                hint: '8',
                icon: Icons.access_time,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return loc.fieldRequired;
                  }
                  if (double.tryParse(value) == null) {
                    return loc.enterValidNumber;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              LabeledField(
                label: loc.quality,
                field: Row(
                  children: [
                    for (int i = 0; i < _qualityOptions.length; i++) ...[
                      if (i > 0) const SizedBox(width: 12),
                      SelectableButton(
                        title: _getQualityLabel(_qualityOptions[i], loc),
                        selected: _selectedQuality == _qualityOptions[i],
                        onTap: () => setState(
                          () => _selectedQuality = _qualityOptions[i],
                        ),
                        height: 80,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),

              LabeledField(
                field: CustomTextField(
                  label: loc.notes,
                  hint: loc.sleepNotesHint,
                  icon: Icons.note,
                  controller: _notesCtrl,
                ),
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
