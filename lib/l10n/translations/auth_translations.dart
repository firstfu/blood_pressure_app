/*
 * @ Author: firstfu
 * @ Create Time: 2024-04-05 12:28:14
 * @ Description: 認證頁面翻譯檔案 - 包含登入、註冊等相關翻譯
 */

// 繁體中文登入/註冊介面翻譯
const Map<String, String> zhTWAuth = {
  // 歡迎回來畫面
  '歡迎回來': '歡迎回來',
  '登入您的帳號繼續': '登入您的帳號繼續',
  '電子郵件': '電子郵件',
  '請輸入您的電子郵件': '請輸入您的電子郵件',
  '密碼': '密碼',
  '請輸入您的密碼': '請輸入您的密碼',
  '忘記密碼？': '忘記密碼？',
  '登入': '登入',
  '使用 Apple 帳號繼續': '使用 Apple 帳號繼續',
  '使用 Google 帳號繼續': '使用 Google 帳號繼續',
  '還沒有帳號？': '還沒有帳號？',
  '立即註冊': '立即註冊',
  '或者使用其他方式登入': '或者使用其他方式登入',

  // 註冊頁面
  '創建新帳號': '創建新帳號',
  '註冊': '註冊',
  '已有帳號？': '已有帳號？',
  '立即登入': '立即登入',
  '確認密碼': '確認密碼',
  '請再次輸入密碼': '請再次輸入密碼',
  '接受條款': '我同意相關的隱私政策與使用條款',
  '個人資料': '個人資料',
  '名字': '名字',
  '姓氏': '姓氏',
  '請輸入您的名字': '請輸入您的名字',
  '請輸入您的姓氏': '請輸入您的姓氏',

  // 驗證訊息
  '電子郵件格式不正確': '電子郵件格式不正確',
  '密碼不能為空': '密碼不能為空',
  '密碼至少需要6個字符': '密碼至少需要6個字符',
  '密碼不匹配': '密碼不匹配',
  '請同意條款才能繼續': '請同意條款才能繼續',
  '名字不能為空': '名字不能為空',

  // 錯誤訊息
  '登入失敗': '登入失敗',
  '註冊失敗': '註冊失敗',
  '此電子郵件已被註冊': '此電子郵件已被註冊',
  '帳號密碼不匹配': '帳號密碼不匹配',
  '請先驗證您的電子郵件再登入': '請先驗證您的電子郵件再登入',
  '您需要登入才能繼續': '您需要登入才能繼續',

  // 狀態提示
  '處理中': '處理中',
  '登入中': '登入中',
  '註冊中': '註冊中',
  '已登入': '已登入',
  '未登入': '未登入',
  '登入狀態': '登入狀態',
  '登入已取消': '登入已取消',
  '登入成功': '登入成功',
  '註冊成功': '註冊成功',
  '請檢查您的郵箱激活帳號': '請檢查您的郵箱激活帳號',

  // 新增記錄特有提示
  '您需要登入才能記錄血壓': '您需要登入才能記錄血壓',
  '您需要登入才能查看統計': '您需要登入才能查看統計',
  '您需要登入才能使用報告功能': '您需要登入才能使用報告功能',
  '您需要登入才能設定提醒': '您需要登入才能設定提醒',
  '您需要登入才能同步數據': '您需要登入才能同步數據',
  '新增記錄需要登入。您想現在登入嗎？': '新增記錄需要登入。您想現在登入嗎？',
  '查看報表需要登入。您想現在登入嗎？': '查看報表需要登入。您想現在登入嗎？',
};

// 英文登入/註冊介面翻譯
const Map<String, String> enUSAuth = {
  // Welcome screen
  '歡迎回來': 'Welcome Back',
  '登入您的帳號繼續': 'Sign in to your account to continue',
  '電子郵件': 'Email',
  '請輸入您的電子郵件': 'Enter your email',
  '密碼': 'Password',
  '請輸入您的密碼': 'Enter your password',
  '忘記密碼？': 'Forgot password?',
  '登入': 'Sign In',
  '使用 Apple 帳號繼續': 'Continue with Apple',
  '使用 Google 帳號繼續': 'Continue with Google',
  '還沒有帳號？': 'Don\'t have an account?',
  '立即註冊': 'Register Now',
  '或者使用其他方式登入': 'Or sign in with',

  // Registration page
  '創建新帳號': 'Create New Account',
  '註冊': 'Register',
  '已有帳號？': 'Already have an account?',
  '立即登入': 'Sign In Now',
  '確認密碼': 'Confirm Password',
  '請再次輸入密碼': 'Re-enter your password',
  '接受條款': 'I agree to the Privacy Policy and Terms of Use',
  '個人資料': 'Personal Information',
  '名字': 'First Name',
  '姓氏': 'Last Name',
  '請輸入您的名字': 'Enter your first name',
  '請輸入您的姓氏': 'Enter your last name',

  // Validation messages
  '電子郵件格式不正確': 'Invalid email format',
  '密碼不能為空': 'Password cannot be empty',
  '密碼至少需要6個字符': 'Password must be at least 6 characters',
  '密碼不匹配': 'Passwords do not match',
  '請同意條款才能繼續': 'Please agree to the terms to continue',
  '名字不能為空': 'Name cannot be empty',

  // Error messages
  '登入失敗': 'Sign in failed',
  '註冊失敗': 'Registration failed',
  '此電子郵件已被註冊': 'This email is already registered',
  '帳號密碼不匹配': 'Email and password do not match',
  '請先驗證您的電子郵件再登入': 'Please verify your email before signing in',
  '您需要登入才能繼續': 'You need to sign in to continue',

  // Status prompts
  '處理中': 'Processing',
  '登入中': 'Signing in',
  '註冊中': 'Registering',
  '已登入': 'Signed in',
  '未登入': 'Not signed in',
  '登入狀態': 'Login Status',
  '登入已取消': 'Login canceled',
  '登入成功': 'Sign in successful',
  '註冊成功': 'Registration successful',
  '請檢查您的郵箱激活帳號': 'Please check your email to activate your account',

  // Specific prompts for feature access
  '您需要登入才能記錄血壓': 'You need to sign in to record blood pressure',
  '您需要登入才能查看統計': 'You need to sign in to view statistics',
  '您需要登入才能使用報告功能': 'You need to sign in to use the report feature',
  '您需要登入才能設定提醒': 'You need to sign in to set reminders',
  '您需要登入才能同步數據': 'You need to sign in to sync data',
  '新增記錄需要登入。您想現在登入嗎？': 'Adding records requires login. Would you like to sign in now?',
  '查看報表需要登入。您想現在登入嗎？': 'Viewing reports requires login. Would you like to sign in now?',
};
