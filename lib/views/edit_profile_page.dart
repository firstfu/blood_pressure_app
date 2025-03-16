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

  // 定義現代化設計常量
  final double _borderRadius = 16.0;
  final double _spacing = 16.0;
  final double _smallSpacing = 8.0;

  // 主色調
  final Color _primaryColor = const Color(0xFF4A7BF7);
  final Color _backgroundColor = const Color(0xFFF5F7FA);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF2D3748);
  final Color _secondaryTextColor = const Color(0xFF718096);
  final Color _borderColor = const Color(0xFFE2E8F0);
  final Color _iconColor = const Color(0xFF4A7BF7);

  // 字體大小
  final double _titleFontSize = 20.0;
  final double _sectionTitleFontSize = 16.0;
  final double _contentFontSize = 15.0;
  final double _smallFontSize = 13.0;

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.tr('個人資料已更新')),
            backgroundColor: _primaryColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(16),
          ),
        );
        Navigator.pop(context, _profile);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _primaryColor,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light),
        title: Text(context.tr('編輯個人資料'), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: _titleFontSize)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: Text(context.tr('保存'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Container(
        color: _backgroundColor,
        child: SingleChildScrollView(
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
                  label: context.tr('姓名'),
                  hint: context.tr('請輸入您的姓名'),
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
                        label: context.tr('年齡'),
                        hint: context.tr('歲'),
                        icon: Icons.cake,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                    ),
                    SizedBox(width: _spacing),
                    Expanded(
                      child: _buildDropdown<String>(
                        label: context.tr('性別'),
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
                        label: context.tr('身高'),
                        hint: context.tr('厘米'),
                        icon: Icons.height,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                      ),
                    ),
                    SizedBox(width: _spacing),
                    Expanded(
                      child: _buildTextField(
                        controller: _weightController,
                        label: context.tr('體重'),
                        hint: context.tr('公斤'),
                        icon: Icons.monitor_weight,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                      ),
                    ),
                  ],
                ),
                _buildDropdown<String>(
                  label: context.tr('血型'),
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
                  label: context.tr('電子郵件'),
                  hint: context.tr('請輸入您的電子郵件'),
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                _buildTextField(
                  controller: _phoneController,
                  label: context.tr('電話號碼'),
                  hint: context.tr('請輸入您的電話號碼'),
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                ),
                _buildTextField(
                  controller: _emergencyContactController,
                  label: context.tr('緊急聯絡人'),
                  hint: context.tr('請輸入緊急聯絡人信息'),
                  icon: Icons.contact_phone,
                ),

                // 健康信息
                _buildSectionTitle(context.tr('健康信息')),
                Row(
                  children: [
                    Expanded(
                      child: _buildSwitchOption(
                        title: context.tr('糖尿病'),
                        subtitle: '',
                        value: _profile.hasDiabetes,
                        onChanged: (value) {
                          setState(() {
                            _profile.hasDiabetes = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildSwitchOption(
                        title: context.tr('吸煙者'),
                        subtitle: '',
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
                  label: context.tr('膽固醇水平'),
                  hint: context.tr('mg/dL'),
                  icon: Icons.science,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                ),
                _buildTextField(
                  controller: _medicalConditionsController,
                  label: context.tr('醫療狀況'),
                  hint: context.tr('請輸入您的醫療狀況'),
                  icon: Icons.medical_services,
                  maxLines: 3,
                ),
                _buildTextField(
                  controller: _medicationsController,
                  label: context.tr('正在服用的藥物'),
                  hint: context.tr('請輸入您正在服用的藥物'),
                  icon: Icons.medication,
                  maxLines: 3,
                ),
                _buildTextField(
                  controller: _allergiesController,
                  label: context.tr('過敏史'),
                  hint: context.tr('請輸入您的過敏史'),
                  icon: Icons.warning,
                  maxLines: 3,
                ),

                // 其他信息
                _buildSectionTitle(context.tr('其他信息')),
                _buildTextField(controller: _notesController, label: context.tr('備註'), hint: context.tr('請輸入其他備註信息'), icon: Icons.note, maxLines: 5),

                SizedBox(height: _spacing),
                _buildButton(text: context.tr('保存個人資料'), onPressed: _saveProfile, isPrimary: true),
                SizedBox(height: _spacing),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 構建區段標題
  Widget _buildSectionTitle(String title) {
    return Container(
      margin: EdgeInsets.only(top: _spacing, bottom: _smallSpacing),
      child: Row(
        children: [
          Container(width: 4, height: 20, decoration: BoxDecoration(color: _primaryColor, borderRadius: BorderRadius.circular(2))),
          SizedBox(width: _smallSpacing),
          Text(title, style: TextStyle(fontSize: _sectionTitleFontSize, fontWeight: FontWeight.bold, color: _textColor)),
        ],
      ),
    );
  }

  /// 構建文本輸入框
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: _spacing),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: _iconColor),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(_borderRadius), borderSide: BorderSide(color: _borderColor)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(_borderRadius), borderSide: BorderSide(color: _borderColor)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
            borderSide: BorderSide(color: _primaryColor, width: 1.5),
          ),
          filled: true,
          fillColor: _cardColor,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        style: TextStyle(fontSize: _contentFontSize, color: _textColor),
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
        maxLines: maxLines,
      ),
    );
  }

  /// 構建下拉選擇框
  Widget _buildDropdown<T>({
    required String label,
    required IconData icon,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: _spacing),
      child: DropdownButtonFormField<T>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: _iconColor),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(_borderRadius), borderSide: BorderSide(color: _borderColor)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(_borderRadius), borderSide: BorderSide(color: _borderColor)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
            borderSide: BorderSide(color: _primaryColor, width: 1.5),
          ),
          filled: true,
          fillColor: _cardColor,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        style: TextStyle(fontSize: _contentFontSize, color: _textColor),
        dropdownColor: _cardColor,
        items: items,
        onChanged: onChanged,
      ),
    );
  }

  /// 構建開關選項
  Widget _buildSwitchOption({required String title, required String subtitle, required bool value, required Function(bool) onChanged}) {
    return Container(
      margin: EdgeInsets.only(bottom: _spacing),
      decoration: BoxDecoration(color: _cardColor, borderRadius: BorderRadius.circular(_borderRadius), border: Border.all(color: _borderColor)),
      child: SwitchListTile(
        title: Text(title, style: TextStyle(fontSize: _contentFontSize, color: _textColor)),
        subtitle: subtitle.isNotEmpty ? Text(subtitle, style: TextStyle(fontSize: _smallFontSize, color: _secondaryTextColor)) : null,
        value: value,
        activeColor: _primaryColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onChanged: onChanged,
      ),
    );
  }

  /// 構建按鈕
  Widget _buildButton({required String text, required VoidCallback onPressed, bool isPrimary = true}) {
    return Container(
      margin: EdgeInsets.only(bottom: _spacing),
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? _primaryColor : Colors.transparent,
          foregroundColor: isPrimary ? Colors.white : _primaryColor,
          elevation: isPrimary ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
            side: isPrimary ? BorderSide.none : BorderSide(color: _primaryColor),
          ),
        ),
        child: Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
