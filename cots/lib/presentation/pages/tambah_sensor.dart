import 'package:cots/config/providers.dart';
import 'package:cots/core/app_route.dart';
import 'package:cots/design_system/appColors.dart';
import 'package:cots/models/sensor_model.dart';
import 'package:cots/presentation/widgets/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../design_system/spacing.dart';
import '../../design_system/typography.dart';
import '../../design_system/layout_tokens.dart';
import '../widgets/custom_button.dart';

class TambahSensor extends StatefulWidget {
  const TambahSensor({super.key});

  @override
  State<TambahSensor> createState() => _TambahSensorState();
}

class _TambahSensorState extends State<TambahSensor> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _minValueController = TextEditingController();
  final _maxValueController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedType = 'Temperature';
  bool _isActive = true;

  final List<String> _sensorTypes = [
    'Temperature',
    'Humidity',
    'Pressure',
    'Light',
    'Sound',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _minValueController.dispose();
    _maxValueController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _getUnitByType(String type) {
    switch (type) {
      case 'Temperature':
        return '°C';
      case 'Humidity':
        return '%';
      case 'Pressure':
        return 'hPa';
      case 'Light':
        return 'lux';
      case 'Sound':
        return 'dB';
      default:
        return '';
    }
  }

  void _saveSensor() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<SensorProvider>(context, listen: false);

      final newSensor = Sensor(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        type: _selectedType,
        location: _locationController.text,
        isActive: _isActive,
        currentValue: 0.0,
        unit: _getUnitByType(_selectedType),
        lastUpdated: DateTime.now(),
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
        minValue: _minValueController.text.isEmpty
            ? null
            : double.tryParse(_minValueController.text),
        maxValue: _maxValueController.text.isEmpty
            ? null
            : double.tryParse(_maxValueController.text),
      );

      provider.addSensor(newSensor);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sensor berhasil ditambahkan'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );

      AppRoutes.goBack(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Sensor'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(AppSpacing.md),
          children: [
            CustomInput(
              label: 'Nama Sensor',
              hint: 'Masukkan nama sensor',
              controller: _nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama sensor harus diisi';
                }
                return null;
              },
            ),
            SizedBox(height: AppSpacing.md),
            CustomInput(
              label: 'Lokasi',
              hint: 'Masukkan lokasi',
              controller: _locationController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lokasi harus diisi';
                }
                return null;
              },
            ),
            SizedBox(height: AppSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tipe Sensor', style: AppTypography.labelMedium),
                SizedBox(height: AppSpacing.sm),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.elevated,
                    borderRadius: LayoutTokens.borderRadius,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedType,
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                      style: AppTypography.body,
                      items: _sensorTypes.map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() => _selectedType = newValue);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md),
            CustomInput(
              label: 'Satuan',
              hint: _getUnitByType(_selectedType),
              readOnly: true,
              enabled: false,
            ),
            SizedBox(height: AppSpacing.md),

            Text(
              'Batas Normal (min - max)',
              style: AppTypography.labelMedium,
            ),
            SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: CustomInput(
                    label: '',
                    hint: 'Min',
                    controller: _minValueController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: CustomInput(
                    label: '',
                    hint: 'Max',
                    controller: _maxValueController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md),
            Container(
              padding: EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.elevated,
                borderRadius: LayoutTokens.borderRadius,
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Aktifkan Sensor', style: AppTypography.body),
                  Switch(
                    value: _isActive,
                    onChanged: (value) => setState(() => _isActive = value),
                    activeColor: AppColors.primary,
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.md),
            CustomInput(
              label: 'Catatan',
              hint: 'Catatan tambahan (opsional)',
              controller: _descriptionController,
              maxLines: 3,
            ),
            SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Batal',
                    onPressed: () => AppRoutes.goBack(context),
                    type: ButtonType.outlined,
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  flex: 2,
                  child: CustomButton(
                    text: 'Simpan',
                    onPressed: _saveSensor,
                    type: ButtonType.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}