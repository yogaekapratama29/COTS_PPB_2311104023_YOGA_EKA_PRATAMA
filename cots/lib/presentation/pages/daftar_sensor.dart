import 'package:cots/config/providers.dart';
import 'package:cots/core/app_route.dart';
import 'package:cots/design_system/appColors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../design_system/spacing.dart';
import '../../design_system/typography.dart';
import '../../design_system/layout_tokens.dart';

class DaftarSensor extends StatefulWidget {
  const DaftarSensor({super.key});

  @override
  State<DaftarSensor> createState() => _DaftarSensorState();
}

class _DaftarSensorState extends State<DaftarSensor> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Semua';
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Sensor'),
        actions: [
          TextButton(
            onPressed: () => AppRoutes.navigateTo(context, AppRoutes.addSensor),
            child: Text(
              'Tambah',
              style: AppTypography.body.copyWith(color: AppColors.white),
            ),
          ),
        ],
      ),
      body: Consumer<SensorProvider>(
        builder: (context, provider, child) {
          var sensors = provider.sensors;
          if (_selectedFilter == 'Aktif') {
            sensors = sensors.where((s) => s.isActive).toList();
          } else if (_selectedFilter == 'Nonaktif') {
            sensors = sensors.where((s) => !s.isActive).toList();
          } else if (_selectedFilter == 'Peringatan') {
            sensors = sensors.where((s) => s.status == 'Peringatan' || s.status == 'Bahaya').toList();
          }
          if (_searchQuery.isNotEmpty) {
            sensors = sensors.where((s) =>
              s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              s.location.toLowerCase().contains(_searchQuery.toLowerCase())
            ).toList();
          }
          return Column(
            children: [
              Container(
                color: AppColors.elevated,
                padding: EdgeInsets.all(AppSpacing.md),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Cari sensor atau lokasi...',
                    hintStyle: AppTypography.body.copyWith(
                      color: AppColors.textSecondary.withOpacity(0.5),
                    ),
                    prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: LayoutTokens.borderRadius,
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                  ),
                ),
              ),
              Container(
                color: AppColors.elevated,
                padding: EdgeInsets.only(
                  left: AppSpacing.md,
                  right: AppSpacing.md,
                  bottom: AppSpacing.md,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterChip(
                        label: 'Semua',
                        isSelected: _selectedFilter == 'Semua',
                        onTap: () => setState(() => _selectedFilter = 'Semua'),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      _FilterChip(
                        label: 'Aktif',
                        isSelected: _selectedFilter == 'Aktif',
                        onTap: () => setState(() => _selectedFilter = 'Aktif'),
                        color: AppColors.success,
                      ),
                      SizedBox(width: AppSpacing.sm),
                      _FilterChip(
                        label: 'Nonaktif',
                        isSelected: _selectedFilter == 'Nonaktif',
                        onTap: () => setState(() => _selectedFilter = 'Nonaktif'),
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: AppSpacing.sm),
                      _FilterChip(
                        label: 'Peringatan',
                        isSelected: _selectedFilter == 'Peringatan',
                        onTap: () => setState(() => _selectedFilter = 'Peringatan'),
                        color: AppColors.warning,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: sensors.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: AppColors.textSecondary.withOpacity(0.5),
                            ),
                            SizedBox(height: AppSpacing.md),
                            Text(
                              'Tidak ada sensor ditemukan',
                              style: AppTypography.body.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(AppSpacing.md),
                        itemCount: sensors.length,
                        itemBuilder: (context, index) {
                          final sensor = sensors[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: AppSpacing.md),
                            child: _SensorListItem(
                              sensorName: sensor.name,
                              location: sensor.location,
                              time: _formatTime(sensor.lastUpdated),
                              isActive: sensor.isActive,
                              statusColor: _getStatusColor(sensor.status),
                              onTap: () => AppRoutes.navigateTo(
                                context,
                                AppRoutes.sensorDetail,
                                arguments: {'sensorId': sensor.id},
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Bahaya':
        return AppColors.danger;
      case 'Peringatan':
        return AppColors.warning;
      default:
        return AppColors.success;
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? AppColors.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? chipColor : Colors.transparent,
          border: Border.all(
            color: isSelected ? chipColor : AppColors.border,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: AppTypography.body.copyWith(
            color: isSelected ? AppColors.white : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _SensorListItem extends StatelessWidget {
  final String sensorName;
  final String location;
  final String time;
  final bool isActive;
  final Color statusColor;
  final VoidCallback onTap;

  const _SensorListItem({
    required this.sensorName,
    required this.location,
    required this.time,
    required this.isActive,
    required this.statusColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.elevated,
        borderRadius: LayoutTokens.borderRadius,
        border: Border.all(color: statusColor, width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: LayoutTokens.borderRadius,
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 48,
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(sensorName, style: AppTypography.heading2),
                      SizedBox(height: AppSpacing.xs),
                      Text(location, style: AppTypography.caption),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      time,
                      style: AppTypography.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      isActive ? 'Aktif' : 'Kemarin',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: AppSpacing.sm),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}