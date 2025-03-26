# 引導頁面功能實現文檔

## 文件資訊

- **文件名稱**：引導頁面功能實現文檔
- **版本**：1.3
- **最後更新日期**：2024 年 5 月 29 日
- **狀態**：已實現
- **作者**：firstfu

## 需求分析

### 背景

「血壓管家」App 需要一個引導頁面（Onboarding），向新用戶介紹應用程式的主要功能和價值，提高用戶留存率和使用體驗。引導頁面是用戶首次打開應用程式時看到的第一個界面，對於建立良好的第一印象和引導用戶正確使用應用程式至關重要。

### 目標

1. 設計並實現吸引人的引導頁面，展示應用程式的核心功能和價值
2. 提供流暢的頁面切換動畫和直觀的導航控制
3. 允許用戶跳過引導過程，直接進入主應用程式
4. 確保引導頁面只在用戶首次安裝應用程式時顯示
5. 設計配色符合應用程式的整體主題與風格，採用藍色為主色調
6. 添加多國語系支持，實現中英文自動切換

### 實現功能

1. **引導頁面設計**：

   - 設計 3 個引導頁面，每個頁面展示一個核心功能或價值
   - 每個頁面包含吸引人的插圖、簡潔的標題和描述文字
   - 頁面設計完全符合應用程式的整體視覺風格，採用藍色主題，與應用程式的主色調 (0xFF1976D2) 一致

2. **頁面導航**：

   - 水平滑動切換頁面
   - 頁面指示器顯示當前頁面位置，使用與主題匹配的顏色
   - 「下一步」按鈕進入下一頁
   - 「跳過」按鈕直接進入主應用程式
   - 最後一頁顯示「開始！」按鈕

3. **首次使用檢測**：

   - 利用 SharedPreferencesService 檢測是否為用戶首次使用應用程式
   - 只在首次使用時顯示引導頁面
   - 提供在設置中重置引導頁面的選項

4. **多國語系支持**：
   - 創建專用的 Onboarding 翻譯文件，支持中英文切換
   - 使用 AppLocalizations 擴展方法實現文本本地化
   - 頁面內所有文本內容均支持多語言顯示

## 技術架構

### 文件結構

```
lib/
  ├── views/
  │   └── onboarding/
  │       └── onboarding_page.dart       # 引導頁面實現
  ├── services/
  │   └── shared_prefs_service.dart      # 用於存儲首次使用狀態
  ├── l10n/
  │   ├── translations/
  │   │   └── onboarding_translations.dart  # Onboarding 頁面翻譯文件
  │   ├── app_localizations.dart         # 本地化核心類
  │   └── app_localizations_extension.dart  # 便捷使用擴展
  └── assets/
      └── images/
          ├── onboarding_welcome.png
          ├── onboarding_reminder.png
          ├── onboarding_record.png
          └── onboarding_analysis.png
```

### 核心類和方法

1. **OnboardingPage 類**：

   - StatefulWidget，管理整個引導頁面
   - 包含 PageView 用於頁面切換
   - 使用 SmoothPageIndicator 顯示頁面指示器
   - 提供「跳過」和「下一步/開始」按鈕
   - 使用應用程式的主題顏色和文字樣式
   - 使用 context.tr() 和 context.formatTr() 方法實現多語言支持

2. **OnboardingPageContent 類**：

   - StatelessWidget，表示單個引導頁面內容
   - 顯示圖片、標題和描述文字
   - 使用 TypographyTheme 中定義的文字樣式
   - 接收翻譯鍵而非硬編碼文本，支持多語言

3. **SharedPrefsService 類**：

   - 用於存儲和檢索 onBoarding 完成狀態
   - 提供 `isOnBoardingCompleted()` 和 `setOnBoardingCompleted()` 方法
   - 提供 `resetOnBoardingStatus()` 方法用於重置狀態

4. **翻譯文件**：
   - `onboarding_translations.dart` 包含所有 Onboarding 頁面的文本翻譯
   - 支持繁體中文（zhTW）和英文（enUS）
   - 通過 AppLocalizations 系統集成到應用程式中

## 代碼實現

### OnboardingPage

```dart
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> with SingleTickerProviderStateMixin {
  final controller = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// 完成 Onboarding 並導航到主頁
  Future<void> _completeOnboarding() async {
    // 設置 onBoarding 完成狀態
    await SharedPrefsService.setOnBoardingCompleted();

    // 導航到主頁
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        color: theme.primaryColor.withOpacity(0.1),
        child: PageView(
          controller: controller,
          onPageChanged: (index) {
            setState(() {
              isLastPage = index == 2; // 3 頁，最後一頁索引為 2
            });
          },
          children: [
            OnboardingPageContent(
              image: 'assets/images/onboarding_welcome.png',
              title: context.tr('歡迎使用血壓管家'),
              description: context.tr('簡單易用的血壓管理應用，幫助您追蹤健康狀況'),
            ),
            OnboardingPageContent(
              image: 'assets/images/onboarding_record.png',
              title: context.tr('輕鬆記錄血壓數據'),
              description: context.tr('快速記錄收縮壓、舒張壓和心率，支持添加備註'),
            ),
            OnboardingPageContent(
              image: 'assets/images/onboarding_analysis.png',
              title: context.tr('專業分析健康趨勢'),
              description: context.tr('詳細的統計圖表，幫助您了解血壓變化趨勢'),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        color: theme.primaryColor.withOpacity(0.1),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 跳過按鈕
            TextButton(
              onPressed: _completeOnboarding,
              child: Text(
                context.tr('跳過'),
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.primaryColor,
                ),
              ),
            ),
            // 頁面指示器
            Center(
              child: SmoothPageIndicator(
                controller: controller,
                count: 3,
                effect: WormEffect(
                  spacing: 16,
                  dotColor: theme.disabledColor.withOpacity(0.3),
                  activeDotColor: theme.primaryColor,
                  dotHeight: 10,
                  dotWidth: 10,
                ),
                onDotClicked: (index) => controller.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                ),
              ),
            ),
            // 下一步/開始按鈕
            TextButton(
              onPressed: () {
                if (isLastPage) {
                  _completeOnboarding();
                } else {
                  controller.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                }
              },
              child: Text(
                isLastPage ? context.tr('開始！') : context.tr('下一步'),
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### OnboardingPageContent

```dart
class OnboardingPageContent extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const OnboardingPageContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 圖片
        Image.asset(
          image,
          height: 250,
          width: 250,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 30),
        // 標題
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        // 描述
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
```

### 翻譯文件

```dart
// onboarding_translations.dart
const Map<String, String> zhTWOnboarding = {
  // Onboarding 頁面標題
  '歡迎使用血壓管家': '歡迎使用血壓管家',
  '輕鬆記錄血壓數據': '輕鬆記錄血壓數據',
  '專業分析健康趨勢': '專業分析健康趨勢',
  '貼心提醒不遺漏': '貼心提醒不遺漏',

  // Onboarding 頁面描述
  '簡單易用的血壓管理應用，幫助您追蹤健康狀況': '簡單易用的血壓管理應用，幫助您追蹤健康狀況',
  '快速記錄收縮壓、舒張壓和心率，支持添加備註': '快速記錄收縮壓、舒張壓和心率，支持添加備註',
  '詳細的統計圖表，幫助您了解血壓變化趨勢': '詳細的統計圖表，幫助您了解血壓變化趨勢',
  '自定義測量提醒，幫助您養成定期測量的習慣': '自定義測量提醒，幫助您養成定期測量的習慣',

  // Onboarding 頁面按鈕
  '跳過': '跳過',
  '下一步': '下一步',
  '開始！': '開始！',

  // Onboarding 頁面指示器
  '頁面指示器': '頁面指示器',
};

const Map<String, String> enUSOnboarding = {
  // Onboarding page titles
  '歡迎使用血壓管家': 'Welcome to Blood Pressure Manager',
  '輕鬆記錄血壓數據': 'Easy Blood Pressure Recording',
  '專業分析健康趨勢': 'Professional Health Trend Analysis',
  '貼心提醒不遺漏': 'Thoughtful Measurement Reminders',

  // Onboarding page descriptions
  '簡單易用的血壓管理應用，幫助您追蹤健康狀況': 'A simple blood pressure management app to help you track your health',
  '快速記錄收縮壓、舒張壓和心率，支持添加備註': 'Quickly record systolic, diastolic pressure and heart rate with notes',
  '詳細的統計圖表，幫助您了解血壓變化趨勢': 'Detailed statistical charts to help you understand blood pressure trends',
  '自定義測量提醒，幫助您養成定期測量的習慣': 'Custom measurement reminders to help develop regular testing habits',

  // Onboarding page buttons
  '跳過': 'Skip',
  '下一步': 'Next',
  '開始！': 'Start!',

  // Onboarding page indicator
  '頁面指示器': 'Page indicator',
};
```

## 已完成工作

1. **設計和實現**

   - [x] 實現三頁引導頁面設計
   - [x] 添加頁面切換動畫和指示器
   - [x] 實現「跳過」和「開始」按鈕功能
   - [x] 調整配色方案，使用應用程式的主色調 (藍色) 替代初始設計
   - [x] 應用 TypographyTheme 中定義的文字樣式，確保風格一致性

2. **集成**
   - [x] 與 SharedPreferencesService 集成，實現首次使用檢測
   - [x] 與應用程式主題適配
   - [x] 添加多國語系支持，實現文本本地化
   - [x] 集成到應用程式的翻譯系統中
   - [x] 在設置頁面中添加重置引導頁面的選項

## 下一步計劃

1. **優化**

   - [ ] 優化頁面內容和圖片資源
   - [ ] 添加更多動畫效果
   - [ ] 支持深色模式

2. **擴展**
   - [ ] 增加更多引導頁面
   - [ ] 添加用戶互動元素
   - [ ] 擴展支持更多語言（如：日文、韓文等）

## 測試與效果評估

1. **用戶測試**：

   - 在不同設備和系統版本上測試，確認頁面顯示正常
   - 測試多語言切換功能，確認所有文字正確顯示
   - 確認在第一次安裝和第二次啟動時的行為正確

2. **效果評估**：
   - 收集用戶對引導頁面的反饋意見
   - 分析引導頁面完成率和「跳過」按鈕使用率
   - 評估引導頁面對用戶留存率的影響

## 總結

本功能實現了 Onboarding 頁面的完整流程，包括多頁面展示、頁面切換、跳過功能等。使用 Flutter 的 PageView 和 SmoothPageIndicator 實現了流暢的頁面切換效果，並與 SharedPreferencesService 集成，確保引導頁面只在用戶首次使用應用程式時顯示。

配色方案完全符合應用程式整體主題的藍色系列，並使用了 TypographyTheme 中定義的文字樣式，確保了設計的一致性和專業性。這使得 Onboarding 頁面與整個應用程式的設計語言保持一致，讓用戶從一開始就能感受到統一的視覺體驗。

添加了多國語系支持，使 Onboarding 頁面能夠根據用戶的系統語言設置自動切換顯示語言，提升了應用程式的國際化水平和用戶體驗。所有頁面文本內容都使用翻譯鍵進行引用，避免了硬編碼文本，便於後續維護和擴展。

引導頁面功能的實現不僅提升了新用戶的首次使用體驗，也為用戶快速了解應用程式的主要功能提供了直觀的介紹，有助於提高用戶留存率和使用滿意度。
