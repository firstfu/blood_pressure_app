// @ Author: firstfu
// @ Create Time: 2024-03-14 12:15:30
// @ Description: 血壓記錄 App 記錄頁面，用於新增和編輯血壓數據

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import '../../models/blood_pressure_record.dart';
import '../../l10n/app_localizations_extension.dart';

class RecordPage extends StatefulWidget {
  final BloodPressureRecord? recordToEdit;
  final bool isFromTabNav;

  const RecordPage({super.key, this.recordToEdit, this.isFromTabNav = false});

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
  // 使用語言無關的鍵來存儲選擇的值
  String _selectedPositionKey = 'sitting';
  String _selectedArmKey = 'left_arm';
  bool _isMedicated = false;
  bool _isEditing = false;

  // 定義選項的鍵值對
  final Map<String, String> _positionKeys = {'sitting': '坐姿', 'lying': '臥姿', 'standing': '站姿'};

  final Map<String, String> _armKeys = {'left_arm': '左臂', 'right_arm': '右臂'};

  // 定義現代化設計常量
  final double _borderRadius = 16.0;
  final double _spacing = 16.0;
  final double _smallSpacing = 8.0;

  // 字體大小
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

      // 根據記錄中的姿勢和部位找到對應的鍵
      final position = widget.recordToEdit!.position;
      final arm = widget.recordToEdit!.arm;

      _selectedPositionKey = _positionKeys.entries.firstWhere((entry) => entry.value == position, orElse: () => MapEntry('sitting', '坐姿')).key;

      _selectedArmKey = _armKeys.entries.firstWhere((entry) => entry.value == arm, orElse: () => MapEntry('left_arm', '左臂')).key;

      _isMedicated = widget.recordToEdit!.isMedicated;
    }
  }

  // 獲取當前語系的姿勢選項
  List<DropdownMenuItem<String>> _getPositionItems() {
    return _positionKeys.entries.map((entry) {
      return DropdownMenuItem<String>(value: entry.key, child: Text(context.tr(entry.value)));
    }).toList();
  }

  // 獲取當前語系的測量部位選項
  List<DropdownMenuItem<String>> _getArmItems() {
    return _armKeys.entries.map((entry) {
      return DropdownMenuItem<String>(value: entry.key, child: Text(context.tr(entry.value)));
    }).toList();
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
    DateTime? pickedDate = _selectedDate;

    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: Text(context.tr('取消')),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoButton(
                    child: Text(context.tr('確定')),
                    onPressed: () {
                      Navigator.of(context).pop(pickedDate);
                    },
                  ),
                ],
              ),
              const Divider(height: 0),
              Expanded(
                child: CupertinoDatePicker(
                  initialDateTime: _selectedDate,
                  maximumDate: DateTime.now(),
                  minimumDate: DateTime(2020),
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (DateTime newDate) {
                    pickedDate = newDate;
                  },
                  dateOrder: DatePickerDateOrder.ymd,
                  use24hFormat: true,
                  backgroundColor: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    ).then((value) {
      if (value != null && value != _selectedDate) {
        setState(() {
          _selectedDate = value;
        });
      }
    });
  }

  // 選擇時間
  Future<void> _selectTime(BuildContext context) async {
    DateTime initialDateTime = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _selectedTime.hour, _selectedTime.minute);
    DateTime? pickedDateTime = initialDateTime;

    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: Text(context.tr('取消')),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoButton(
                    child: Text(context.tr('確定')),
                    onPressed: () {
                      Navigator.of(context).pop(pickedDateTime);
                    },
                  ),
                ],
              ),
              const Divider(height: 0),
              Expanded(
                child: CupertinoDatePicker(
                  initialDateTime: initialDateTime,
                  mode: CupertinoDatePickerMode.time,
                  use24hFormat: false,
                  onDateTimeChanged: (DateTime newDateTime) {
                    pickedDateTime = newDateTime;
                  },
                  backgroundColor: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          _selectedTime = TimeOfDay(hour: value.hour, minute: value.minute);
        });
      }
    });
  }

  // 保存記錄
  void _saveRecord() {
    if (_formKey.currentState!.validate()) {
      // 創建測量時間
      final measureTime = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _selectedTime.hour, _selectedTime.minute);

      // 檢查輸入值是否為有效數字
      int? systolic = int.tryParse(_systolicController.text);
      int? diastolic = int.tryParse(_diastolicController.text);
      int? pulse = int.tryParse(_pulseController.text);

      // 如果任一輸入不是有效數字，顯示錯誤並返回
      if (systolic == null || diastolic == null || pulse == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.tr('請輸入有效的數字'), style: TextStyle(fontSize: _contentFontSize)),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(8),
            duration: const Duration(milliseconds: 1500),
          ),
        );
        return;
      }

      // 創建血壓記錄
      final record = BloodPressureRecord(
        id: _isEditing ? widget.recordToEdit!.id : const Uuid().v4(),
        systolic: systolic,
        diastolic: diastolic,
        pulse: pulse,
        measureTime: measureTime,
        position: _positionKeys[_selectedPositionKey]!,
        arm: _armKeys[_selectedArmKey]!,
        note: _noteController.text.isEmpty ? null : _noteController.text,
        isMedicated: _isMedicated,
      );

      try {
        // 先顯示成功消息
        final snackBar = SnackBar(
          content: Text(_isEditing ? context.tr('記錄已更新') : context.tr('記錄已保存'), style: TextStyle(fontSize: _contentFontSize)),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(8),
          duration: const Duration(milliseconds: 1500),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        // 使用延遲來確保 SnackBar 顯示完整
        Future.delayed(const Duration(milliseconds: 200), () {
          // 檢查 widget 是否仍然掛載
          if (mounted) {
            // 如果是從 Tab 導航欄進入，則不進行導航操作，只重置表單
            if (widget.isFromTabNav) {
              _resetForm();
            } else {
              // 如果是從其他地方進入，則返回記錄對象
              Navigator.of(context).pop(record);
            }
          }
        });
      } catch (e) {
        // 捕獲導航過程中可能出現的異常
        debugPrint('保存記錄時發生錯誤: $e');

        // 最後嘗試直接返回
        if (mounted) {
          if (widget.isFromTabNav) {
            _resetForm();
          } else {
            Navigator.of(context).pop(record);
          }
        }
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
      _selectedPositionKey = 'sitting';
      _selectedArmKey = 'left_arm';
      _isMedicated = false;
    });
  }

  // 構建標題
  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: _spacing),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).primaryColor),
          SizedBox(width: _smallSpacing),
          Text(
            title,
            style: TextStyle(fontSize: _sectionTitleFontSize, fontWeight: FontWeight.w600, color: Theme.of(context).textTheme.bodyLarge!.color),
          ),
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
        maxLines: maxLines,
        validator: validator,
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
        style: TextStyle(fontSize: _contentFontSize, color: Theme.of(context).textTheme.bodyLarge!.color),
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
      ),
    );
  }

  // 構建下拉選擇器
  Widget _buildDropdown({
    required String label,
    required IconData icon,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: _spacing),
      child: DropdownButtonFormField<String>(
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        ),
        value: value,
        style: TextStyle(fontSize: _contentFontSize, color: Theme.of(context).textTheme.bodyLarge!.color),
        dropdownColor: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(_borderRadius),
        items: items,
        onChanged: onChanged,
      ),
    );
  }

  // 構建日期選擇器
  Widget _buildDatePicker() {
    return Container(
      margin: EdgeInsets.only(bottom: _spacing),
      child: GestureDetector(
        onTap: () => _selectDate(context),
        child: AbsorbPointer(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(_borderRadius),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 20, color: Theme.of(context).primaryColor),
                SizedBox(width: _smallSpacing),
                // 使用中文格式顯示日期
                Flexible(
                  child: Text(
                    _formatDateInChinese(_selectedDate),
                    style: TextStyle(fontSize: _contentFontSize, color: Theme.of(context).textTheme.bodyLarge!.color),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 構建時間選擇器
  Widget _buildTimePicker() {
    return Container(
      margin: EdgeInsets.only(bottom: _spacing),
      child: GestureDetector(
        onTap: () => _selectTime(context),
        child: AbsorbPointer(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(_borderRadius),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Row(
              children: [
                Icon(Icons.access_time, size: 20, color: Theme.of(context).primaryColor),
                SizedBox(width: _smallSpacing),
                // 使用中文格式顯示時間
                Flexible(
                  child: Text(
                    _formatTimeInChinese(_selectedTime),
                    style: TextStyle(fontSize: _contentFontSize, color: Theme.of(context).textTheme.bodyLarge!.color),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 構建開關
  Widget _buildSwitchField({required String title, required String subtitle, required bool value, required Function(bool) onChanged}) {
    return Container(
      margin: EdgeInsets.only(bottom: _spacing),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(_borderRadius),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: SwitchListTile(
        title: Text(title, style: TextStyle(fontSize: _contentFontSize, color: Theme.of(context).textTheme.bodyLarge!.color)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: _smallFontSize, color: Theme.of(context).textTheme.bodyMedium!.color)),
        value: value,
        activeColor: Theme.of(context).primaryColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onChanged: onChanged,
      ),
    );
  }

  // 將日期格式化為中文顯示
  String _formatDateInChinese(DateTime date) {
    // 根據當前語系決定日期格式
    final locale = Localizations.localeOf(context).toString();

    if (locale == 'zh_TW') {
      final List<String> chineseMonths = ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'];
      return '${date.year}年${chineseMonths[date.month - 1]}${date.day}日';
    } else {
      // 英文格式
      final List<String> englishMonths = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${englishMonths[date.month - 1]} ${date.day}, ${date.year}';
    }
  }

  // 將時間格式化為顯示
  String _formatTimeInChinese(TimeOfDay time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final locale = Localizations.localeOf(context).toString();

    if (locale == 'zh_TW') {
      if (hour < 12) {
        return '上午 ${hour == 0 ? 12 : hour}:$minute';
      } else {
        return '下午 ${hour == 12 ? 12 : hour - 12}:$minute';
      }
    } else {
      // 英文格式
      final period = hour < 12 ? 'AM' : 'PM';
      final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
      return '$hour12:$minute $period';
    }
  }

  // 構建血壓等級描述
  Widget _buildBPStatusDescription(int systolic, int diastolic) {
    // 根據收縮壓和舒張壓判斷血壓等級
    String status = '';
    String description = '';

    // ... 省略血壓判定邏輯 ...

    if (status.isEmpty) {
      return Container();
    }

    return Text(description, style: TextStyle(fontSize: _smallFontSize, height: 1.5, color: Theme.of(context).textTheme.bodyLarge!.color));
  }

  // 構建按鈕
  Widget _buildButton({required String title, required VoidCallback onPressed, bool isPrimary = true}) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? Theme.of(context).primaryColor : Colors.transparent,
          foregroundColor: isPrimary ? Colors.white : Theme.of(context).primaryColor,
          elevation: isPrimary ? 2 : 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
            side: isPrimary ? BorderSide.none : BorderSide(color: Theme.of(context).primaryColor),
          ),
          shadowColor: Theme.of(context).primaryColor.withAlpha(128),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.visible),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: brightness == Brightness.dark ? const Color(0xFF121212) : theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: brightness == Brightness.light ? Brightness.dark : Brightness.light,
          statusBarBrightness: brightness == Brightness.light ? Brightness.light : Brightness.dark,
        ),
        title: Text(_isEditing ? context.tr('編輯記錄') : context.tr('新增記錄')),
        centerTitle: true,
        automaticallyImplyLeading: !widget.isFromTabNav,
        leading: widget.isFromTabNav ? null : IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () => Navigator.of(context).pop()),
        actions: [
          IconButton(icon: const Icon(Icons.save), tooltip: context.tr('保存記錄'), onPressed: _saveRecord),
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(context.tr('確認刪除')),
                      content: Text(context.tr('確定要刪除這條記錄嗎？此操作不可撤銷。')),
                      actions: [
                        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(context.tr('取消'))),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop(null); // 返回 null 表示記錄已被刪除
                          },
                          child: Text(context.tr('刪除'), style: const TextStyle(color: Colors.red)),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(_spacing),
          children: [
            // 基本血壓數據
            Container(
              padding: EdgeInsets.all(_spacing),
              decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(_borderRadius)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context.tr('血壓數據'), Icons.favorite),
                  _buildTextField(
                    controller: _systolicController,
                    label: context.tr('收縮壓 (SYS)'),
                    hint: context.tr('收縮壓，單位 mmHg'),
                    icon: Icons.arrow_upward,
                    keyboardType: const TextInputType.numberWithOptions(decimal: false),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.tr('請輸入收縮壓');
                      }
                      int? systolic = int.tryParse(value);
                      if (systolic == null || systolic < 60 || systolic > 250) {
                        return context.tr('收縮壓應在 60-250 mmHg 範圍內');
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _diastolicController,
                    label: context.tr('舒張壓 (DIA)'),
                    hint: context.tr('舒張壓，單位 mmHg'),
                    icon: Icons.arrow_downward,
                    keyboardType: const TextInputType.numberWithOptions(decimal: false),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.tr('請輸入舒張壓');
                      }
                      int? diastolic = int.tryParse(value);
                      if (diastolic == null || diastolic < 40 || diastolic > 180) {
                        return context.tr('舒張壓應在 40-180 mmHg 範圍內');
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _pulseController,
                    label: context.tr('心率 (PULSE)'),
                    hint: context.tr('心率，單位 bpm'),
                    icon: Icons.favorite,
                    keyboardType: const TextInputType.numberWithOptions(decimal: false),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.tr('請輸入心率');
                      }
                      int? pulse = int.tryParse(value);
                      if (pulse == null || pulse < 30 || pulse > 180) {
                        return context.tr('心率應在 30-180 bpm 範圍內');
                      }
                      return null;
                    },
                  ),
                  if (_systolicController.text.isNotEmpty && _diastolicController.text.isNotEmpty)
                    _buildBPStatusDescription(int.tryParse(_systolicController.text) ?? 0, int.tryParse(_diastolicController.text) ?? 0),
                ],
              ),
            ),
            SizedBox(height: _spacing),

            // 測量時間
            Container(
              padding: EdgeInsets.all(_spacing),
              decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(_borderRadius)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [_buildSectionTitle(context.tr('測量時間'), Icons.access_time), _buildDatePicker(), _buildTimePicker()],
              ),
            ),
            SizedBox(height: _spacing),

            // 測量狀態
            Container(
              padding: EdgeInsets.all(_spacing),
              decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(_borderRadius)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context.tr('測量狀態'), Icons.info_outline),
                  _buildDropdown(
                    label: context.tr('測量姿勢'),
                    icon: Icons.accessibility_new,
                    value: _selectedPositionKey,
                    items: _getPositionItems(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedPositionKey = newValue;
                        });
                      }
                    },
                  ),
                  _buildDropdown(
                    label: context.tr('測量部位'),
                    icon: Icons.straighten,
                    value: _selectedArmKey,
                    items: _getArmItems(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedArmKey = newValue;
                        });
                      }
                    },
                  ),
                  _buildSwitchField(
                    title: context.tr('測量前是否服用降壓藥物'),
                    subtitle: context.tr('服用降壓藥物可能會影響測量結果'),
                    value: _isMedicated,
                    onChanged: (bool value) {
                      setState(() {
                        _isMedicated = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: _spacing),

            // 備註
            Container(
              padding: EdgeInsets.all(_spacing),
              decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(_borderRadius)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context.tr('備註'), Icons.note),
                  _buildTextField(
                    controller: _noteController,
                    label: context.tr('備註'),
                    hint: context.tr('輸入備註內容'),
                    icon: Icons.note_add,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            SizedBox(height: _spacing * 2),

            // 按鈕組
            Row(
              children: [
                Expanded(child: _buildButton(title: _isEditing ? context.tr('重置變更') : context.tr('重置表單'), onPressed: _resetForm, isPrimary: false)),
                SizedBox(width: _spacing),
                Expanded(child: _buildButton(title: _isEditing ? context.tr('保存變更') : context.tr('保存記錄'), onPressed: _saveRecord, isPrimary: true)),
              ],
            ),
            SizedBox(height: _spacing * 2),
          ],
        ),
      ),
      bottomNavigationBar: null,
    );
  }
}
