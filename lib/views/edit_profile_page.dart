/*
 * @ Author: firstfu
 * @ Create Time: 2024-05-16 16:16:42
 * @ Description: 編輯個人資料頁面，用於編輯用戶的基本信息
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations_extension.dart';
import '../models/user_profile.dart';
import '../services/shared_prefs_service.dart';
import '../themes/app_theme.dart';

/// 編輯個人資料頁面
///
/// 用於編輯用戶的基本信息，如姓名、年齡、性別、身高、體重等
class EditProfilePage extends StatefulWidget {
  final UserProfile userProfile;

  const EditProfilePage({super.key, required this.userProfile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late UserProfile _profile;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emergencyContactController = TextEditingController();
  final TextEditingController _cholesterolController = TextEditingController();
  final TextEditingController _medicalConditionsController = TextEditingController();
  final TextEditingController _medicationsController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // 血型選項
  final List<String> _bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-', '未知'];

  @override
  void initState() {
    super.initState();
    _profile = widget.userProfile;
    _initControllers();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _emergencyContactController.dispose();
    _cholesterolController.dispose();
    _medicalConditionsController.dispose();
    _medicationsController.dispose();
    _allergiesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  /// 初始化控制器
  void _initControllers() {
    _nameController.text = _profile.name;
    _ageController.text = _profile.age?.toString() ?? '';
    _heightController.text = _profile.height?.toString() ?? '';
    _weightController.text = _profile.weight?.toString() ?? '';
    _emailController.text = _profile.email ?? '';
    _phoneController.text = _profile.phoneNumber ?? '';
    _emergencyContactController.text = _profile.emergencyContact ?? '';
    _cholesterolController.text = _profile.cholesterolLevel?.toString() ?? '';
    _medicalConditionsController.text = _profile.medicalConditions ?? '';
    _medicationsController.text = _profile.medications ?? '';
    _allergiesController.text = _profile.allergies ?? '';
    _notesController.text = _profile.notes ?? '';
  }

  /// 保存個人資料
  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      // 更新用戶資料
      _profile.name = _nameController.text.trim();
      _profile.age = _ageController.text.isEmpty ? null : int.tryParse(_ageController.text);
      _profile.height = _heightController.text.isEmpty ? null : double.tryParse(_heightController.text);
      _profile.weight = _weightController.text.isEmpty ? null : double.tryParse(_weightController.text);
      _profile.email = _emailController.text.trim().isEmpty ? null : _emailController.text.trim();
      _profile.phoneNumber = _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim();
      _profile.emergencyContact = _emergencyContactController.text.trim().isEmpty ? null : _emergencyContactController.text.trim();
      _profile.cholesterolLevel = _cholesterolController.text.isEmpty ? null : double.tryParse(_cholesterolController.text);
      _profile.medicalConditions = _medicalConditionsController.text.trim().isEmpty ? null : _medicalConditionsController.text.trim();
      _profile.medications = _medicationsController.text.trim().isEmpty ? null : _medicationsController.text.trim();
      _profile.allergies = _allergiesController.text.trim().isEmpty ? null : _allergiesController.text.trim();
      _profile.notes = _notesController.text.trim().isEmpty ? null : _notesController.text.trim();

      // 保存到 SharedPreferences
      await SharedPrefsService.saveUserProfile(_profile);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.tr('個人資料已更新')), backgroundColor: Colors.green));
        Navigator.pop(context, _profile);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('編輯個人資料')),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: Text(context.tr('保存'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 基本信息
              _buildSectionTitle(context.tr('基本信息')),
              _buildTextField(
                controller: _nameController,
                labelText: context.tr('姓名'),
                hintText: context.tr('請輸入您的姓名'),
                icon: Icons.person,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return context.tr('請輸入姓名');
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _ageController,
                      labelText: context.tr('年齡'),
                      hintText: context.tr('歲'),
                      icon: Icons.cake,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdownField(
                      labelText: context.tr('性別'),
                      icon: Icons.wc,
                      value: _profile.gender,
                      items: [
                        DropdownMenuItem(value: 'male', child: Text(context.tr('男'))),
                        DropdownMenuItem(value: 'female', child: Text(context.tr('女'))),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _profile.gender = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _heightController,
                      labelText: context.tr('身高'),
                      hintText: context.tr('厘米'),
                      icon: Icons.height,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _weightController,
                      labelText: context.tr('體重'),
                      hintText: context.tr('公斤'),
                      icon: Icons.monitor_weight,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                    ),
                  ),
                ],
              ),
              _buildDropdownField(
                labelText: context.tr('血型'),
                icon: Icons.bloodtype,
                value: _profile.bloodType,
                items: _bloodTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                onChanged: (value) {
                  setState(() {
                    _profile.bloodType = value;
                  });
                },
              ),

              // 聯絡信息
              _buildSectionTitle(context.tr('聯絡信息')),
              _buildTextField(
                controller: _emailController,
                labelText: context.tr('電子郵件'),
                hintText: context.tr('請輸入您的電子郵件'),
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              _buildTextField(
                controller: _phoneController,
                labelText: context.tr('電話號碼'),
                hintText: context.tr('請輸入您的電話號碼'),
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              _buildTextField(
                controller: _emergencyContactController,
                labelText: context.tr('緊急聯絡人'),
                hintText: context.tr('請輸入緊急聯絡人信息'),
                icon: Icons.contact_phone,
              ),

              // 健康信息
              _buildSectionTitle(context.tr('健康信息')),
              Row(
                children: [
                  Expanded(
                    child: _buildSwitchField(
                      labelText: context.tr('糖尿病'),
                      value: _profile.hasDiabetes,
                      onChanged: (value) {
                        setState(() {
                          _profile.hasDiabetes = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSwitchField(
                      labelText: context.tr('吸煙者'),
                      value: _profile.isSmoker,
                      onChanged: (value) {
                        setState(() {
                          _profile.isSmoker = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              _buildTextField(
                controller: _cholesterolController,
                labelText: context.tr('膽固醇水平'),
                hintText: context.tr('mg/dL'),
                icon: Icons.science,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
              ),
              _buildTextField(
                controller: _medicalConditionsController,
                labelText: context.tr('醫療狀況'),
                hintText: context.tr('請輸入您的醫療狀況'),
                icon: Icons.medical_services,
                maxLines: 3,
              ),
              _buildTextField(
                controller: _medicationsController,
                labelText: context.tr('正在服用的藥物'),
                hintText: context.tr('請輸入您正在服用的藥物'),
                icon: Icons.medication,
                maxLines: 3,
              ),
              _buildTextField(
                controller: _allergiesController,
                labelText: context.tr('過敏史'),
                hintText: context.tr('請輸入您的過敏史'),
                icon: Icons.warning,
                maxLines: 3,
              ),

              // 其他信息
              _buildSectionTitle(context.tr('其他信息')),
              _buildTextField(
                controller: _notesController,
                labelText: context.tr('備註'),
                hintText: context.tr('請輸入其他備註信息'),
                icon: Icons.note,
                maxLines: 5,
              ),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(context.tr('保存個人資料'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  /// 構建區段標題
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
    );
  }

  /// 構建文本輸入框
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: Icon(icon, color: AppTheme.primaryColor),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLines: maxLines,
        validator: validator,
      ),
    );
  }

  /// 構建下拉選擇框
  Widget _buildDropdownField({
    required String labelText,
    required IconData icon,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(icon, color: AppTheme.primaryColor),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        items: items,
        onChanged: onChanged,
      ),
    );
  }

  /// 構建開關選擇框
  Widget _buildSwitchField({required String labelText, required bool value, required void Function(bool) onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Text(labelText, style: const TextStyle(fontSize: 16)),
          const Spacer(),
          Switch(value: value, onChanged: onChanged, activeColor: AppTheme.primaryColor),
        ],
      ),
    );
  }
}
