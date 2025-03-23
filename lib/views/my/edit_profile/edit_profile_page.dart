/*
 * @ Author: firstfu
 * @ Create Time: 2024-05-16 16:16:42
 * @ Description: 編輯個人資料頁面，用於編輯用戶的基本信息
 */

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_settings/app_settings.dart';
import '../../../l10n/app_localizations_extension.dart';
import '../../../models/user_profile.dart';
import '../../../services/shared_prefs_service.dart';

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
  final TextEditingController _cholesterolController = TextEditingController();
  final TextEditingController _medicalConditionsController = TextEditingController();
  final TextEditingController _medicationsController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // 頭像相關
  final ImagePicker _imagePicker = ImagePicker();
  String? _avatarPath;
  File? _avatarFile;

  // 血型選項
  final List<String> _bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-', '未知'];

  // 定義現代化設計常量
  final double _borderRadius = 16.0;
  final double _spacing = 16.0;
  final double _smallSpacing = 8.0;

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
    _avatarPath = _profile.avatarPath;
    if (_avatarPath != null && _avatarPath!.isNotEmpty) {
      _avatarFile = File(_avatarPath!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
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
    _cholesterolController.text = _profile.cholesterolLevel?.toString() ?? '';
    _medicalConditionsController.text = _profile.medicalConditions ?? '';
    _medicationsController.text = _profile.medications ?? '';
    _allergiesController.text = _profile.allergies ?? '';
    _notesController.text = _profile.notes ?? '';
  }

  /// 顯示選擇頭像來源的對話框
  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(_borderRadius))),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: Text(context.tr('拍攝照片')),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(context.tr('從相冊選擇')),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              if (_avatarFile != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: Text(context.tr('移除頭像'), style: const TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    _removeAvatar();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  /// 選擇頭像
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(source: source, maxWidth: 800, maxHeight: 800, imageQuality: 85);

      if (pickedFile != null) {
        setState(() {
          _avatarFile = File(pickedFile.path);
          _avatarPath = pickedFile.path;
        });
      }
    } catch (e) {
      // 處理權限被拒絕的情況
      if (e is PlatformException) {
        if (e.code == 'photo_access_denied' || e.code == 'camera_access_denied') {
          if (mounted) {
            _showPermissionDeniedDialog(source);
          }
        } else {
          if (mounted) {
            _showErrorDialog(e.message ?? context.tr('未知錯誤'));
          }
        }
      } else {
        if (mounted) {
          _showErrorDialog(e.toString());
        }
      }
    }
  }

  /// 移除頭像
  void _removeAvatar() {
    setState(() {
      _avatarFile = null;
      _avatarPath = null;
    });
  }

  /// 顯示權限被拒絕的對話框
  void _showPermissionDeniedDialog(ImageSource source) {
    final String permissionType = source == ImageSource.camera ? context.tr('相機') : context.tr('相冊');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(context.tr('權限被拒絕')),
          content: Text(context.formatTr('無法存取您的%s。請前往設定開啟權限。', [permissionType])),
          actions: <Widget>[
            TextButton(
              child: Text(context.tr('取消')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(context.tr('前往設定')),
              onPressed: () {
                Navigator.of(context).pop();
                // 導航到應用設定頁面
                AppSettings.openAppSettings();
              },
            ),
          ],
        );
      },
    );
  }

  /// 顯示錯誤對話框
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(context.tr('發生錯誤')),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text(context.tr('確定')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// 保存個人資料
  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      // 更新用戶資料
      _profile.name = _nameController.text.trim();
      _profile.age = _ageController.text.isEmpty ? null : int.tryParse(_ageController.text);
      _profile.height = _heightController.text.isEmpty ? null : double.tryParse(_heightController.text);
      _profile.weight = _weightController.text.isEmpty ? null : double.tryParse(_weightController.text);
      _profile.cholesterolLevel = _cholesterolController.text.isEmpty ? null : double.tryParse(_cholesterolController.text);
      _profile.medicalConditions = _medicalConditionsController.text.trim().isEmpty ? null : _medicalConditionsController.text.trim();
      _profile.medications = _medicationsController.text.trim().isEmpty ? null : _medicationsController.text.trim();
      _profile.allergies = _allergiesController.text.trim().isEmpty ? null : _allergiesController.text.trim();
      _profile.notes = _notesController.text.trim().isEmpty ? null : _notesController.text.trim();
      _profile.avatarPath = _avatarPath;

      // 保存到 SharedPreferences
      await SharedPrefsService.saveUserProfile(_profile);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.tr('個人資料已更新')),
            backgroundColor: Theme.of(context).primaryColor,
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
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: brightness == Brightness.light ? Brightness.dark : Brightness.light,
          statusBarBrightness: brightness == Brightness.light ? Brightness.light : Brightness.dark,
        ),
        title: Text(context.tr('編輯個人資料'), style: TextStyle(fontWeight: FontWeight.bold, fontSize: _titleFontSize)),
        centerTitle: true,
        actions: [TextButton(onPressed: _saveProfile, child: Text(context.tr('保存'), style: TextStyle(fontWeight: FontWeight.bold)))],
      ),
      body: Container(
        color: theme.scaffoldBackgroundColor,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 頭像
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _showImageSourceActionSheet,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Theme.of(context).dividerColor,
                              backgroundImage: _getAvatarImage(),
                              child: _avatarFile == null ? Icon(Icons.person, size: 50, color: Theme.of(context).primaryColor) : null,
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: theme.primaryColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: theme.cardColor, width: 2),
                                ),
                                child: Icon(Icons.camera_alt, color: theme.colorScheme.onPrimary, size: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: _smallSpacing),
                      Text(context.tr('點擊更換頭像'), style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: _smallFontSize)),
                      SizedBox(height: _spacing),
                    ],
                  ),
                ),

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

  /// 獲取頭像圖片
  ImageProvider? _getAvatarImage() {
    if (_avatarFile != null && _avatarFile!.existsSync()) {
      return FileImage(_avatarFile!);
    }
    return null;
  }

  /// 構建區段標題
  Widget _buildSectionTitle(String title) {
    return Container(
      margin: EdgeInsets.only(top: _spacing, bottom: _smallSpacing),
      child: Row(
        children: [
          Container(width: 4, height: 20, decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(2))),
          SizedBox(width: _smallSpacing),
          Text(
            title,
            style: TextStyle(fontSize: _sectionTitleFontSize, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color),
          ),
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
          prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
            borderSide: BorderSide(color: Theme.of(context).dividerColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
            borderSide: BorderSide(color: Theme.of(context).dividerColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
          ),
          filled: true,
          fillColor: Theme.of(context).cardColor,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        style: TextStyle(fontSize: _contentFontSize, color: Theme.of(context).textTheme.bodyLarge?.color),
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
          prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
            borderSide: BorderSide(color: Theme.of(context).dividerColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
            borderSide: BorderSide(color: Theme.of(context).dividerColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
          ),
          filled: true,
          fillColor: Theme.of(context).cardColor,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        style: TextStyle(fontSize: _contentFontSize, color: Theme.of(context).textTheme.bodyLarge?.color),
        dropdownColor: Theme.of(context).cardColor,
        items: items,
        onChanged: onChanged,
      ),
    );
  }

  /// 構建開關選項
  Widget _buildSwitchOption({required String title, required String subtitle, required bool value, required Function(bool) onChanged}) {
    return Container(
      margin: EdgeInsets.only(bottom: _spacing),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(_borderRadius),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: SwitchListTile(
        title: Text(title, style: TextStyle(fontSize: _contentFontSize, color: Theme.of(context).textTheme.bodyLarge?.color)),
        subtitle:
            subtitle.isNotEmpty
                ? Text(subtitle, style: TextStyle(fontSize: _smallFontSize, color: Theme.of(context).textTheme.bodySmall?.color))
                : null,
        value: value,
        activeColor: Theme.of(context).primaryColor,
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
          backgroundColor: isPrimary ? Theme.of(context).primaryColor : Colors.transparent,
          foregroundColor: isPrimary ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).primaryColor,
          elevation: isPrimary ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
            side: isPrimary ? BorderSide.none : BorderSide(color: Theme.of(context).primaryColor),
          ),
        ),
        child: Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
