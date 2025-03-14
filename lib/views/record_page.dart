// @ Author: 1891_0982
// @ Create Time: 2024-03-14 12:15:30
// @ Description: 血壓記錄 App 記錄頁面，用於新增和編輯血壓數據

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../constants/app_constants.dart';
import '../models/blood_pressure_record.dart';

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

  // 定義統一的樣式常量
  final double _sectionTitleFontSize = 16.0;
  final double _contentFontSize = 14.0;
  final double _smallFontSize = 13.0;
  final double _cardBorderRadius = 12.0;
  final double _cardElevation = 1.5;
  final EdgeInsets _cardPadding = const EdgeInsets.all(16.0);

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
        return Theme(data: Theme.of(context).copyWith(colorScheme: ColorScheme.light(primary: Theme.of(context).primaryColor)), child: child!);
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
        return Theme(data: Theme.of(context).copyWith(colorScheme: ColorScheme.light(primary: Theme.of(context).primaryColor)), child: child!);
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

      // 在實際應用中，這裡會調用服務來保存記錄
      // 目前僅顯示一個成功消息
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
        // 返回 true 表示已添加新記錄，主頁面需要刷新
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

  // 自定義卡片標題
  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).primaryColor),
        const SizedBox(width: 8),
        Text(title, style: TextStyle(fontSize: _sectionTitleFontSize, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
      ],
    );
  }

  // 自定義輸入裝飾
  InputDecoration _getInputDecoration({required String label, required IconData icon, String? hint}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(fontSize: _contentFontSize),
      hintText: hint,
      hintStyle: hint != null ? TextStyle(fontSize: _smallFontSize, color: Colors.grey) : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Theme.of(context).primaryColor)),
      prefixIcon: Icon(icon, size: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? '編輯血壓記錄' : '新增血壓記錄', style: TextStyle(fontSize: _sectionTitleFontSize)),
        actions: [if (!_isEditing) IconButton(icon: const Icon(Icons.refresh, size: 22), onPressed: _resetForm, tooltip: '重置表單')],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 血壓數值輸入區
              Card(
                elevation: _cardElevation,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_cardBorderRadius)),
                child: Padding(
                  padding: _cardPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('血壓數值', Icons.favorite_border),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _systolicController,
                              decoration: _getInputDecoration(label: '收縮壓 (mmHg)', icon: Icons.arrow_upward),
                              style: TextStyle(fontSize: _contentFontSize),
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
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _diastolicController,
                              decoration: _getInputDecoration(label: '舒張壓 (mmHg)', icon: Icons.arrow_downward),
                              style: TextStyle(fontSize: _contentFontSize),
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
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _pulseController,
                        decoration: _getInputDecoration(label: '心率 (bpm)', icon: Icons.favorite),
                        style: TextStyle(fontSize: _contentFontSize),
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
              ),

              const SizedBox(height: 12),

              // 測量時間選擇區
              Card(
                elevation: _cardElevation,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_cardBorderRadius)),
                child: Padding(
                  padding: _cardPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('測量時間', Icons.access_time),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => _selectDate(context),
                              borderRadius: BorderRadius.circular(8),
                              child: InputDecorator(
                                decoration: _getInputDecoration(label: '日期', icon: Icons.calendar_today),
                                child: Text(DateFormat('yyyy-MM-dd').format(_selectedDate), style: TextStyle(fontSize: _contentFontSize)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: InkWell(
                              onTap: () => _selectTime(context),
                              borderRadius: BorderRadius.circular(8),
                              child: InputDecorator(
                                decoration: _getInputDecoration(label: '時間', icon: Icons.access_time),
                                child: Text(_selectedTime.format(context), style: TextStyle(fontSize: _contentFontSize)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // 測量條件選擇區
              Card(
                elevation: _cardElevation,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_cardBorderRadius)),
                child: Padding(
                  padding: _cardPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('測量條件', Icons.settings),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: _getInputDecoration(label: '測量姿勢', icon: Icons.accessibility),
                              value: _selectedPosition,
                              style: TextStyle(fontSize: _contentFontSize, color: Colors.black87),
                              dropdownColor: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              items:
                                  _positionOptions.map((position) {
                                    return DropdownMenuItem<String>(
                                      value: position,
                                      child: Text(position, style: TextStyle(fontSize: _contentFontSize)),
                                    );
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
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: _getInputDecoration(label: '測量部位', icon: Icons.pan_tool),
                              value: _selectedArm,
                              style: TextStyle(fontSize: _contentFontSize, color: Colors.black87),
                              dropdownColor: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              items:
                                  _armOptions.map((arm) {
                                    return DropdownMenuItem<String>(value: arm, child: Text(arm, style: TextStyle(fontSize: _contentFontSize)));
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
                      const SizedBox(height: 12),
                      SwitchListTile(
                        title: Text('是否服藥', style: TextStyle(fontSize: _contentFontSize)),
                        subtitle: Text('測量前是否服用降壓藥物', style: TextStyle(fontSize: _smallFontSize)),
                        value: _isMedicated,
                        activeColor: Theme.of(context).primaryColor,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                        dense: true,
                        onChanged: (value) {
                          setState(() {
                            _isMedicated = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // 備註輸入區
              Card(
                elevation: _cardElevation,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_cardBorderRadius)),
                child: Padding(
                  padding: _cardPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('備註', Icons.note_alt),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _noteController,
                        decoration: _getInputDecoration(label: '備註（選填）', icon: Icons.note, hint: '例如：飯後測量、運動後測量等'),
                        style: TextStyle(fontSize: _contentFontSize),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 血壓狀態預覽
              if (_systolicController.text.isNotEmpty && _diastolicController.text.isNotEmpty) _buildBloodPressureStatusPreview(),

              const SizedBox(height: 20),

              // 保存按鈕
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: ElevatedButton(
                  onPressed: _saveRecord,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    _isEditing ? '更新記錄' : '保存記錄',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.0, // 增加字間距
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
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

    return Card(
      elevation: _cardElevation,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_cardBorderRadius)),
      child: Padding(
        padding: _cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('血壓狀態預覽', Icons.health_and_safety),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Color(colorCode),
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Color(colorCode).withValues(alpha: 100), blurRadius: 4, spreadRadius: 1)],
                  ),
                ),
                const SizedBox(width: 8),
                Text(status, style: TextStyle(fontSize: _contentFontSize, fontWeight: FontWeight.bold, color: Color(colorCode))),
              ],
            ),
            const SizedBox(height: 8),
            Text('收縮壓: $systolic mmHg, 舒張壓: $diastolic mmHg', style: TextStyle(fontSize: _smallFontSize)),
            const SizedBox(height: 8),
            _buildStatusDescription(status),
          ],
        ),
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

    return Text(description, style: TextStyle(fontSize: _smallFontSize, height: 1.4));
  }
}
