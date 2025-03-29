/*
 * @ Author: firstfu
 * @ Create Time: 2024-05-16 16:16:42
 * @ Description: 用戶個人資料模型，用於存儲用戶的基本信息
 */

import 'dart:convert';

/// 用戶個人資料模型
///
/// 用於存儲用戶的基本信息，如姓名、年齡、性別、身高、體重等
class UserProfile {
  String name;
  int? age;
  String? gender; // 'male' 或 'female'
  double? height; // 單位：厘米
  double? weight; // 單位：公斤
  String? bloodType; // 血型，如 'A+', 'B-' 等
  bool hasDiabetes;
  bool isSmoker;
  double? cholesterolLevel; // 膽固醇水平，單位：mg/dL
  String? medicalConditions; // 其他醫療狀況
  String? medications; // 正在服用的藥物
  String? allergies; // 過敏史
  String? notes; // 其他備註
  String? avatarPath; // 頭像圖片路徑
  String? photoUrl; // 用戶頭像 URL (用於社交登入)

  // 認證相關屬性
  String? userId; // 用戶唯一ID
  String? email; // 電子郵件
  String? phoneNumber; // 手機號碼
  bool isGuest; // 是否為遊客
  DateTime? lastLogin; // 最後登入時間

  /// 構造函數
  UserProfile({
    this.name = '',
    this.age,
    this.gender,
    this.height,
    this.weight,
    this.bloodType,
    this.hasDiabetes = false,
    this.isSmoker = false,
    this.cholesterolLevel,
    this.medicalConditions,
    this.medications,
    this.allergies,
    this.notes,
    this.avatarPath,
    this.photoUrl,
    // 認證相關屬性初始化
    this.userId,
    this.email,
    this.phoneNumber,
    this.isGuest = true, // 默認為遊客模式
    this.lastLogin,
  });

  /// 從 JSON 創建 UserProfile 對象
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String? ?? '',
      age: json['age'] as int?,
      gender: json['gender'] as String?,
      height: json['height'] as double?,
      weight: json['weight'] as double?,
      bloodType: json['bloodType'] as String?,
      hasDiabetes: json['hasDiabetes'] as bool? ?? false,
      isSmoker: json['isSmoker'] as bool? ?? false,
      cholesterolLevel: json['cholesterolLevel'] as double?,
      medicalConditions: json['medicalConditions'] as String?,
      medications: json['medications'] as String?,
      allergies: json['allergies'] as String?,
      notes: json['notes'] as String?,
      avatarPath: json['avatarPath'] as String?,
      photoUrl: json['photoUrl'] as String?,
      // 認證相關屬性解析
      userId: json['userId'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      isGuest: json['isGuest'] as bool? ?? true,
      lastLogin: json['lastLogin'] != null ? DateTime.parse(json['lastLogin'] as String) : null,
    );
  }

  /// 將 UserProfile 對象轉換為 JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'gender': gender,
      'height': height,
      'weight': weight,
      'bloodType': bloodType,
      'hasDiabetes': hasDiabetes,
      'isSmoker': isSmoker,
      'cholesterolLevel': cholesterolLevel,
      'medicalConditions': medicalConditions,
      'medications': medications,
      'allergies': allergies,
      'notes': notes,
      'avatarPath': avatarPath,
      'photoUrl': photoUrl,
      // 認證相關屬性序列化
      'userId': userId,
      'email': email,
      'phoneNumber': phoneNumber,
      'isGuest': isGuest,
      'lastLogin': lastLogin?.toIso8601String(),
    };
  }

  /// 從 JSON 字符串創建 UserProfile 對象
  static UserProfile fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return UserProfile.fromJson(json);
  }

  /// 將 UserProfile 對象轉換為 JSON 字符串
  String toJsonString() {
    return jsonEncode(toJson());
  }

  /// 創建默認的用戶資料
  static UserProfile createDefault() {
    return UserProfile(name: '', age: 45, gender: 'male', hasDiabetes: false, isSmoker: false, cholesterolLevel: 180.0);
  }

  /// 創建遊客用戶
  static UserProfile createGuestUser() {
    return UserProfile(name: '遊客', userId: 'guest_${DateTime.now().millisecondsSinceEpoch}', isGuest: true, lastLogin: DateTime.now());
  }
}
