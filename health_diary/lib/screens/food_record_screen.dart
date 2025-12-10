import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/food_record.dart';
import '../providers/records_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/action_button.dart';
import '../widgets/custom_toast.dart';
import '../widgets/labeled_field.dart';
import 'home_screen_controller.dart';

class FoodRecordScreen extends StatefulWidget {
  final HomeScreenController? controller;
  final FoodRecord? recordToEdit;

  const FoodRecordScreen({super.key, this.controller, this.recordToEdit});

  @override
  State<FoodRecordScreen> createState() => _FoodRecordScreenState();
}

class _FoodRecordScreenState extends State<FoodRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dishCtrl = TextEditingController();
  final _calCtrl = TextEditingController();
  final _proteinCtrl = TextEditingController();
  final _fatCtrl = TextEditingController();
  final _carbCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  DateTime _selectedDateTime = DateTime.now();
  final List<XFile> _imageFiles = [];
  final List<Uint8List> _imageBytesList = [];
  List<String> _existingPhotoUrls = [];

  @override
  void initState() {
    super.initState();
    if (widget.recordToEdit != null) {
      final r = widget.recordToEdit!;
      _dishCtrl.text = r.dishName;
      _calCtrl.text = r.calories.toString();
      _proteinCtrl.text = r.protein.toString();
      _fatCtrl.text = r.fat.toString();
      _carbCtrl.text = r.carbs.toString();
      _notesCtrl.text = r.notes ?? '';
      _selectedDateTime = r.date;
      _existingPhotoUrls = List.from(r.photoUrls);
    }
  }

  @override
  void dispose() {
    _dishCtrl.dispose();
    _calCtrl.dispose();
    _proteinCtrl.dispose();
    _fatCtrl.dispose();
    _carbCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final List<XFile> pickedFiles = await picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      for (var file in pickedFiles) {
        final bytes = await file.readAsBytes();
        setState(() {
          _imageFiles.add(file);
          _imageBytesList.add(bytes);
        });
      }
    }
  }

  void _removeNewImage(int index) {
    setState(() {
      _imageFiles.removeAt(index);
      _imageBytesList.removeAt(index);
    });
  }

  void _removeExistingImage(int index) {
    setState(() {
      _existingPhotoUrls.removeAt(index);
    });
  }

  Future<void> _onSave() async {
    final loc = AppLocalizations.of(context)!;
    final provider = context.read<RecordsProvider>();

    if (provider.isLoading) return;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final calories = int.tryParse(_calCtrl.text);
    final protein = double.tryParse(_proteinCtrl.text) ?? 0.0;
    final fat = double.tryParse(_fatCtrl.text) ?? 0.0;
    final carbs = double.tryParse(_carbCtrl.text) ?? 0.0;

    if (_dishCtrl.text.isEmpty || calories == null || calories <= 0) {
      return;
    }

    final record = FoodRecord(
      id: widget.recordToEdit?.id ?? '',
      date: _selectedDateTime,
      dishName: _dishCtrl.text,
      calories: calories,
      protein: protein,
      fat: fat,
      carbs: carbs,
      notes: _notesCtrl.text.isEmpty ? null : _notesCtrl.text,
      photoUrls:
          _existingPhotoUrls, // Only existing ones, new ones handled by provider
      createdAt: widget.recordToEdit?.createdAt ?? DateTime.now(),
    );

    bool success;
    if (widget.recordToEdit != null) {
      success = await provider.updateFoodRecord(
        record,
        _imageFiles,
        _imageBytesList,
      );
    } else {
      success = await provider.addFoodRecord(
        record,
        _imageFiles,
        _imageBytesList,
      );
    }

    if (mounted) {
      if (success) {
        CustomToast.showSuccess(context, loc.foodSaved);
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
        title: Text(isEditing ? loc.edit : loc.foodRecord),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (widget.controller != null) {
              widget.controller!.goHome();
            } else {
              Navigator.pop(context);
            }
          },
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
                controller: _dishCtrl,
                label: loc.dishName,
                hint: loc.dishHint,
                icon: Icons.restaurant_menu,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return loc.enterDishName;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _calCtrl,
                label: loc.calories,
                hint: '0',
                icon: Icons.local_fire_department,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return loc.enterCalories;
                  }
                  if (int.tryParse(value) == null) {
                    return loc.enterValidNumber;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _proteinCtrl,
                      label: loc.proteins,
                      hint: '0',
                      icon: Icons.fitness_center,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      controller: _fatCtrl,
                      label: loc.fats,
                      hint: '0',
                      icon: Icons.opacity,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      controller: _carbCtrl,
                      label: loc.carbs,
                      hint: '0',
                      icon: Icons.grain,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              LabeledField(
                field: CustomTextField(
                  label: loc.notes,
                  hint: loc.notesHint,
                  icon: Icons.note,
                  controller: _notesCtrl,
                ),
              ),
              const SizedBox(height: 20),

              GestureDetector(
                onTap: _pickImages,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: _existingPhotoUrls.isEmpty && _imageBytesList.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.add_a_photo,
                              size: 40,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Add Photos',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        )
                      : ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.all(8),
                          children: [
                            ..._existingPhotoUrls.asMap().entries.map((entry) {
                              final index = entry.key;
                              final url = entry.value;
                              return Stack(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    width: 130,
                                    height: 130,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: NetworkImage(url),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 12,
                                    child: GestureDetector(
                                      onTap: () => _removeExistingImage(index),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                            ..._imageBytesList.asMap().entries.map((entry) {
                              final index = entry.key;
                              final bytes = entry.value;
                              return Stack(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    width: 130,
                                    height: 130,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: MemoryImage(bytes),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 12,
                                    child: GestureDetector(
                                      onTap: () => _removeNewImage(index),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                            GestureDetector(
                              onTap: _pickImages,
                              child: Container(
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: ActionButton(
                      text: loc.cancel,
                      color: Colors.grey,
                      onPressed: () {
                        if (widget.controller != null) {
                          widget.controller!.goHome();
                        } else {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
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
