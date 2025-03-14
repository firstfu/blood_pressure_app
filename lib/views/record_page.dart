// @ Author: 1891_0982
// @ Create Time: 2024-03-14 12:15:30
// @ Description: 血壓記錄 App 記錄頁面，用於新增和編輯血壓數據

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../constants/app_constants.dart';
import '../models/blood_pressure_record.dart';
import '../themes/app_theme.dart';

class RecordPage extends StatefulWidget {
  final BloodPressureRecord? recordToEdit;

  const RecordPage({super.key, this.recordToEdit});

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  final _formKey = GlobalKey<FormState>();
  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();
  final _pulseController = TextEditingController();
  final _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedPosition = '坐姿';
  String _selectedArm = '左臂';
  bool _isMedicated = false;
  bool _isEditing = false;

  final List<String> _positionOptions = ['坐姿', '臥姿', '站姿'];
  final List<String> _armOptions = ['左臂', '右臂'];

  // 定義現代化設計常量
  final double _borderRadius = 16.0;
  final double _spacing = 16.0;
  final double _smallSpacing = 8.0;

  // 主色調
  final Color _primaryColor = const Color(0xFF4A7BF7);
  final Color _primaryLightColor = const Color(0xFF6B92FF);
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

    // 如果是編輯模式，填充現有數據
    if (widget.recordToEdit != null) {
      _isEditing = true;
      _systolicController.text = widget.recordToEdit!.systolic.toString();
      _diastolicController.text = widget.recordToEdit!.diastolic.toString();
      _pulseController.text = widget.recordToEdit!.pulse.toString();
      _noteController.text = widget.recordToEdit!.note ?? '';
      _selectedDate = widget.recordToEdit!.measureTime;
      _selectedTime = TimeOfDay.fromDateTime(widget.recordToEdit!.measureTime);
      _selectedPosition = widget.recordToEdit!.position;
      _selectedArm = widget.recordToEdit!.arm;
      _isMedicated = widget.recordToEdit!.isMedicated;
    }
  }

  @override
  void dispose() {
    _systolicController.dispose();
    _diastolicController.dispose();
    _pulseController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  // 選擇日期
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(colorScheme: ColorScheme.light(primary: _primaryColor), dialogBackgroundColor: _cardColor),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // 選擇時間
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(colorScheme: ColorScheme.light(primary: _primaryColor), dialogBackgroundColor: _cardColor),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // 保存記錄
  void _saveRecord() {
    if (_formKey.currentState!.validate()) {
      // 創建測量時間
      final measureTime = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _selectedTime.hour, _selectedTime.minute);

      // 創建血壓記錄
      final record = BloodPressureRecord(
        id: _isEditing ? widget.recordToEdit!.id : const Uuid().v4(),
        systolic: int.parse(_systolicController.text),
        diastolic: int.parse(_diastolicController.text),
        pulse: int.parse(_pulseController.text),
        measureTime: measureTime,
        position: _selectedPosition,
        arm: _selectedArm,
        note: _noteController.text.isEmpty ? null : _noteController.text,
        isMedicated: _isMedicated,
      );

      // 顯示成功消息
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEditing ? '記錄已更新' : '記錄已保存', style: TextStyle(fontSize: _contentFontSize)),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(8),
        ),
      );

      // 清空表單或返回上一頁
      if (!_isEditing) {
        _resetForm();
        Navigator.pop(context, true);
      } else {
        Navigator.pop(context, record);
      }
    }
  }

  // 重置表單
  void _resetForm() {
    _formKey.currentState!.reset();
    _systolicController.clear();
    _diastolicController.clear();
    _pulseController.clear();
    _noteController.clear();
    setState(() {
      _selectedDate = DateTime.now();
      _selectedTime = TimeOfDay.now();
      _selectedPosition = '坐姿';
      _selectedArm = '左臂';
      _isMedicated = false;
    });
  }

  // 構建標題
  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: _spacing),
      child: Row(
        children: [
          Icon(icon, size: 20, color: _iconColor),
          SizedBox(width: _smallSpacing),
          Text(title, style: TextStyle(fontSize: _sectionTitleFontSize, fontWeight: FontWeight.w600, color: _textColor)),
        ],
      ),
    );
  }

  // 構建輸入框
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int maxLines = 1,
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

  // 構建下拉選擇框
  Widget _buildDropdown<T>({
    required String label,
    required IconData icon,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: _spacing),
      child: DropdownButtonFormField<T>(
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
        value: value,
        style: TextStyle(fontSize: _contentFontSize, color: _textColor),
        dropdownColor: _cardColor,
        borderRadius: BorderRadius.circular(_borderRadius),
        items: items,
        onChanged: onChanged,
      ),
    );
  }

  // 構建日期時間選擇器
  Widget _buildDateTimePicker() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _selectDate(context),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                color: _cardColor,
                borderRadius: BorderRadius.circular(_borderRadius),
                border: Border.all(color: _borderColor),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, size: 20, color: _iconColor),
                  SizedBox(width: _smallSpacing),
                  Text(DateFormat('yyyy-MM-dd').format(_selectedDate), style: TextStyle(fontSize: _contentFontSize, color: _textColor)),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: _smallSpacing),
        Expanded(
          child: GestureDetector(
            onTap: () => _selectTime(context),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                color: _cardColor,
                borderRadius: BorderRadius.circular(_borderRadius),
                border: Border.all(color: _borderColor),
              ),
              child: Row(
                children: [
                  Icon(Icons.access_time, size: 20, color: _iconColor),
                  SizedBox(width: _smallSpacing),
                  Text(_selectedTime.format(context), style: TextStyle(fontSize: _contentFontSize, color: _textColor)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 構建開關選項
  Widget _buildSwitchOption({required String title, required String subtitle, required bool value, required Function(bool) onChanged}) {
    return Container(
      margin: EdgeInsets.only(bottom: _spacing),
      decoration: BoxDecoration(color: _cardColor, borderRadius: BorderRadius.circular(_borderRadius), border: Border.all(color: _borderColor)),
      child: SwitchListTile(
        title: Text(title, style: TextStyle(fontSize: _contentFontSize, color: _textColor)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: _smallFontSize, color: _secondaryTextColor)),
        value: value,
        activeColor: _primaryColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onChanged: onChanged,
      ),
    );
  }

  // 構建按鈕
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
        child: Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
      ),
    );
  }

  // 構建血壓狀態預覽
  Widget _buildBloodPressureStatusPreview() {
    // 只有當收縮壓和舒張壓都有有效值時才顯示預覽
    if (_systolicController.text.isEmpty || _diastolicController.text.isEmpty) {
      return const SizedBox.shrink();
    }

    final systolic = int.tryParse(_systolicController.text);
    final diastolic = int.tryParse(_diastolicController.text);

    if (systolic == null || diastolic == null) {
      return const SizedBox.shrink();
    }

    // 創建臨時記錄以獲取狀態
    final tempRecord = BloodPressureRecord(
      id: 'temp',
      systolic: systolic,
      diastolic: diastolic,
      pulse: int.tryParse(_pulseController.text) ?? 0,
      measureTime: DateTime.now(),
      position: _selectedPosition,
      arm: _selectedArm,
    );

    final status = tempRecord.getBloodPressureStatus();
    final colorCode = tempRecord.getStatusColorCode();
    final statusColor = Color(colorCode);

    return Container(
      margin: EdgeInsets.only(bottom: _spacing),
      padding: EdgeInsets.all(_spacing),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(_borderRadius),
        boxShadow: [BoxShadow(color: statusColor.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))],
        border: Border.all(color: statusColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('血壓狀態預覽', Icons.health_and_safety),
          Row(
            children: [
              Container(width: 16, height: 16, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
              SizedBox(width: _spacing),
              Text(status, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: statusColor)),
            ],
          ),
          SizedBox(height: _spacing),
          Container(
            padding: EdgeInsets.all(_spacing),
            decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(_borderRadius / 2)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '收縮壓: $systolic mmHg, 舒張壓: $diastolic mmHg',
                  style: TextStyle(fontSize: _contentFontSize, color: _textColor, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: _smallSpacing),
                _buildStatusDescription(status),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 構建血壓狀態描述
  Widget _buildStatusDescription(String status) {
    String description = '';

    if (status == AppConstants.normalStatus) {
      description = '您的血壓處於正常範圍，繼續保持健康的生活方式。';
    } else if (status == AppConstants.elevatedStatus) {
      description = '您的血壓略高於正常範圍，建議增加運動並減少鹽分攝入。';
    } else if (status == AppConstants.hypertension1Status) {
      description = '您的血壓處於高血壓一級，建議諮詢醫生並調整生活方式。';
    } else if (status == AppConstants.hypertension2Status) {
      description = '您的血壓處於高血壓二級，請盡快諮詢醫生並遵循治療方案。';
    } else if (status == AppConstants.hypertensionCrisisStatus) {
      description = '您的血壓處於危險水平，請立即就醫！';
    }

    return Text(description, style: TextStyle(fontSize: _smallFontSize, height: 1.5, color: _textColor));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light),
        title: Text(_isEditing ? '編輯血壓記錄' : '新增血壓記錄', style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [if (!_isEditing) IconButton(icon: const Icon(Icons.refresh, color: Colors.white), onPressed: _resetForm, tooltip: '重置表單')],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(_spacing),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 血壓數值輸入區
              Container(
                padding: EdgeInsets.all(_spacing),
                decoration: BoxDecoration(color: _cardColor, borderRadius: BorderRadius.circular(_borderRadius)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('血壓數值', Icons.favorite_border),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _systolicController,
                            label: '收縮壓 (mmHg)',
                            icon: Icons.arrow_upward,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '請輸入收縮壓';
                              }
                              final systolic = int.tryParse(value);
                              if (systolic == null || systolic < 60 || systolic > 250) {
                                return '收縮壓應在60-250之間';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: _smallSpacing),
                        Expanded(
                          child: _buildTextField(
                            controller: _diastolicController,
                            label: '舒張壓 (mmHg)',
                            icon: Icons.arrow_downward,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '請輸入舒張壓';
                              }
                              final diastolic = int.tryParse(value);
                              if (diastolic == null || diastolic < 40 || diastolic > 150) {
                                return '舒張壓應在40-150之間';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    _buildTextField(
                      controller: _pulseController,
                      label: '心率 (bpm)',
                      icon: Icons.favorite,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '請輸入心率';
                        }
                        final pulse = int.tryParse(value);
                        if (pulse == null || pulse < 40 || pulse > 200) {
                          return '心率應在40-200之間';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: _spacing),

              // 測量時間選擇區
              Container(
                padding: EdgeInsets.all(_spacing),
                decoration: BoxDecoration(color: _cardColor, borderRadius: BorderRadius.circular(_borderRadius)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [_buildSectionTitle('測量時間', Icons.access_time), _buildDateTimePicker()],
                ),
              ),

              SizedBox(height: _spacing),

              // 測量條件選擇區
              Container(
                padding: EdgeInsets.all(_spacing),
                decoration: BoxDecoration(color: _cardColor, borderRadius: BorderRadius.circular(_borderRadius)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('測量條件', Icons.settings),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdown<String>(
                            label: '測量姿勢',
                            icon: Icons.accessibility,
                            value: _selectedPosition,
                            items:
                                _positionOptions.map((position) {
                                  return DropdownMenuItem<String>(value: position, child: Text(position));
                                }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedPosition = value;
                                });
                              }
                            },
                          ),
                        ),
                        SizedBox(width: _smallSpacing),
                        Expanded(
                          child: _buildDropdown<String>(
                            label: '測量部位',
                            icon: Icons.pan_tool,
                            value: _selectedArm,
                            items:
                                _armOptions.map((arm) {
                                  return DropdownMenuItem<String>(value: arm, child: Text(arm));
                                }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedArm = value;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    _buildSwitchOption(
                      title: '是否服藥',
                      subtitle: '測量前是否服用降壓藥物',
                      value: _isMedicated,
                      onChanged: (value) {
                        setState(() {
                          _isMedicated = value;
                        });
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: _spacing),

              // 備註輸入區
              Container(
                padding: EdgeInsets.all(_spacing),
                decoration: BoxDecoration(color: _cardColor, borderRadius: BorderRadius.circular(_borderRadius)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('備註', Icons.note_alt),
                    _buildTextField(controller: _noteController, label: '備註（選填）', icon: Icons.note, hint: '例如：飯後測量、運動後測量等', maxLines: 3),
                  ],
                ),
              ),

              SizedBox(height: _spacing),

              // 血壓狀態預覽
              if (_systolicController.text.isNotEmpty && _diastolicController.text.isNotEmpty) _buildBloodPressureStatusPreview(),

              // 保存按鈕
              _buildButton(text: _isEditing ? '更新記錄' : '保存記錄', onPressed: _saveRecord),

              SizedBox(height: _spacing),
            ],
          ),
        ),
      ),
    );
  }
}
