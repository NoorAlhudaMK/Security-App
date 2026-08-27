import 'package:flutter/material.dart';
import 'package:security_app/Core/Colors/app_colors.dart';

import '../../../Core/UIConstants/aivio_icon_sizes.dart';
import '../../../Data/Models/resident_model.dart';

class ResidentProfilePage extends StatelessWidget {
  final ResidentModel resident;

  ResidentProfilePage({Key? key, required this.resident}) : super(key: key);

  AppColors colors = AppColors();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: colors.scaffoldBackground,
          appBar: AppBar(
            title: Text('ملف الساكن', style: TextStyle(color: colors.textMain)),
            centerTitle: true,
            elevation: 0,
            backgroundColor: colors.scaffoldBackground,
            automaticallyImplyActions: false,
            automaticallyImplyLeading: false,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: AppIconSizes.md,
                color: colors.textMain,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderCard(context),
                const SizedBox(height: 20),

                // معلومات الوحدة السكنية
                _buildSectionTitle('معلومات الوحدة'),
                _buildInfoTile(
                  icon: Icons.home_rounded,
                  title: 'اسم الوحدة',
                  subtitle: resident.unitName,
                ),
                _buildInfoTile(
                  icon: Icons.confirmation_number_outlined,
                  title: 'معرف الوحدة (Unit ID)',
                  subtitle: resident.unitID,
                ),
                const SizedBox(height: 10),

                // معلومات التواصل والطوارئ
                _buildSectionTitle('معلومات الاتصال والطوارئ'),
                _buildInfoTile(
                  icon: Icons.phone_rounded,
                  title: 'رقم الهاتف',
                  subtitle: resident.phone.isNotEmpty
                      ? resident.phone
                      : 'غير متوفر',
                ),
                if (resident.emergencyContactName != null &&
                    resident.emergencyContactName!.isNotEmpty)
                  _buildInfoTile(
                    icon: Icons.contact_emergency_rounded,
                    title: 'جهة الاتصال في الطوارئ',
                    subtitle:
                        '${resident.emergencyContactName} (${resident.emergencyContactPhone ?? ''})',
                  ),
                const SizedBox(height: 10),

                // المركبات
                _buildSectionTitle('المركبات (${resident.vehicles.length})'),
                _buildVehiclesList(),
                const SizedBox(height: 10),

                // أفراد العائلة
                _buildSectionTitle(
                  'أفراد العائلة (${resident.familyMembers.length})',
                ),
                _buildFamilyMembersList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    bool isOwner = resident.residentType == 'owner';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: colors.primary,
            child: Text(
              resident.name.isNotEmpty ? resident.name[0].toUpperCase() : '?',
              style: const TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            resident.name,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colors.textMain,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isOwner
                  ? colors.accentGreen.withOpacity(0.1)
                  : colors.accentBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              resident.tag,
              style: TextStyle(
                color: isOwner ? colors.accentGreen : colors.accentBlue,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: colors.textMain,
        ),
      ),
    );
  }

  // عنصر معلومات مفرد
  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: colors.cardBackground,
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(
          title,
          style: TextStyle(fontSize: 13, color: colors.textSecondary),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: colors.textSecondary,
          ),
        ),
      ),
    );
  }

  // قائمة المركبات
  Widget _buildVehiclesList() {
    if (resident.vehicles.isEmpty) {
      return Card(
        elevation: 0,
        color: colors.cardBackground,
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            'لا توجد مركبات مسجلة',
            style: TextStyle(color: colors.textSecondary),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: resident.vehicles.length,
      itemBuilder: (context, index) {
        final vehicle = resident.vehicles[index];
        final plateNumber = vehicle is Map
            ? (vehicle['plate_number'] ?? 'غير معروف')
            : vehicle.toString();

        return Card(
          elevation: 0,
          color: colors.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: ListTile(
            leading: const Icon(
              Icons.directions_car_rounded,
              color: Colors.orangeAccent,
            ),
            title: Text(
              'لوحة السيارة: $plateNumber',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFamilyMembersList() {
    if (resident.familyMembers.isEmpty) {
      return Card(
        elevation: 0,
        color: colors.cardBackground,
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            'لا يوجد أفراد عائلة مسجلين',
            style: TextStyle(color: colors.textSecondary),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: resident.familyMembers.length,
      itemBuilder: (context, index) {
        final member = resident.familyMembers[index];
        final memberName = member is Map
            ? (member['name'] ?? 'عضو بدون اسم')
            : member.toString();

        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          color: colors.cardBackground,
          child: ListTile(
            leading: const Icon(
              Icons.person_outline_rounded,
              color: Colors.purpleAccent,
            ),
            title: Text(
              memberName,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
              ),
            ),
          ),
        );
      },
    );
  }
}
