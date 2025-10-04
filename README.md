```markdown
# 🍳 عربية الفيومي - El Fayoumi Cart

<div align="center">
  
![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-2.19+-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-green?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)

**تطبيق عربية الفيومي - تجربة طلب الفطار المصري الأصيل بتصميم عصري وسهولة في الاستخدام**

[Features](#-features) • [Screenshots](#-screenshots) • [Installation](#-installation) • [Usage](#-usage) • [Architecture](#-architecture)

</div>

---

## 📱 نظرة عامة | Overview

تطبيق **عربية الفيومي** هو تطبيق موبايل متكامل لطلب وتوصيل الفطار المصري التقليدي. يوفر التطبيق تجربة مستخدم سلسة وممتعة مع تصميم عصري يحافظ على الهوية المصرية الأصيلة.

### 🎯 الهدف من التطبيق
- توفير منصة سهلة وسريعة لطلب الفطار المصري
- دعم اللغة العربية بشكل كامل مع واجهة RTL
- تجربة مستخدم سلسة مع تصميم Material Design محسّن

## ✨ Features

### 🛒 نظام التسوق
- ✅ عرض قائمة متنوعة من الأصناف المصرية (فول، طعمية، بيض، جبن، مشروبات)
- ✅ نظام سلة تسوق ذكي مع إمكانية التعديل على الكميات
- ✅ إضافات مخصصة لكل صنف
- ✅ عرض الأسعار والخصومات بشكل واضح

### 🎨 التصميم والواجهة
- ✅ تصميم عصري مع الحفاظ على الهوية المصرية
- ✅ دعم كامل للغة العربية واتجاه RTL
- ✅ رسوم متحركة سلسة وتفاعلية
- ✅ ألوان دافئة تعكس الطابع الشعبي

### 📦 المميزات التقنية
- ✅ State Management باستخدام Provider
- ✅ Cached Network Images للأداء الأمثل
- ✅ Shimmer Loading Effects
- ✅ Carousel Slider للعروض
- ✅ Bottom Sheets تفاعلية
- ✅ Custom Painters للتصاميم المخصصة

## 🛠️ Technologies Used

| التقنية | الإصدار | الوصف |
|---------|---------|-------|
| **Flutter** | 3.0+ | Framework الأساسي |
| **Dart** | 2.19+ | لغة البرمجة |
| **Provider** | ^6.0.0 | State Management |
| **Google Fonts** | Latest | خطوط Cairo العربية |
| **Cached Network Image** | Latest | تحميل وتخزين الصور |
| **Shimmer** | Latest | Loading Effects |
| **Carousel Slider** | Latest | عرض البانرات |
| **Font Awesome** | Latest | الأيقونات |
| **Badges** | Latest | عدادات السلة |

## 📂 Project Structure

```
lib/
├── main.dart                 # نقطة البداية والإعدادات الأساسية
├── theme/
│   └── app_theme.dart       # إعدادات الألوان والثيم
├── providers/
│   └── cart_provider.dart   # إدارة حالة السلة
├── models/
│   ├── menu_item.dart      # نموذج الصنف
│   └── cart_item.dart      # نموذج عنصر السلة
├── screens/
│   ├── home_screen.dart    # الشاشة الرئيسية
│   └── cart_screen.dart    # شاشة السلة
├── widgets/
│   ├── banner_section.dart # قسم البانرات
│   ├── categories.dart     # قسم الفئات
│   ├── menu_item_card.dart # بطاقة الصنف
│   └── item_details.dart   # تفاصيل الصنف
└── data/
    └── app_data.dart       # البيانات الثابتة
```

## 🚀 Installation

### المتطلبات الأساسية
- Flutter SDK (3.0 أو أحدث)
- Dart SDK (2.19 أو أحدث)
- Android Studio / VS Code
- محاكي Android أو iOS

### خطوات التثبيت

```bash
# 1. استنساخ المشروع
git clone https://github.com/yourusername/el-fayoumi-cart.git

# 2. الانتقال لمجلد المشروع
cd el-fayoumi-cart

# 3. تثبيت الحزم المطلوبة
flutter pub get

# 4. تشغيل التطبيق
flutter run
```

## 📦 Dependencies

أضف هذه التبعيات في ملف `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.5
  google_fonts: ^5.1.0
  cached_network_image: ^3.2.3
  shimmer: ^3.0.0
  font_awesome_flutter: ^10.5.0
  carousel_slider: ^4.2.1
  smooth_page_indicator: ^1.1.0
  badges: ^3.1.1
```

## 🎨 Theme Configuration

التطبيق يستخدم نظام ألوان مخصص:

| اللون | الكود | الاستخدام |
|------|------|----------|
| **Primary Green** | `#2E7D32` | اللون الأساسي |
| **Secondary Red** | `#D32F2F` | الأزرار والتنبيهات |
| **Accent Yellow** | `#FFC107` | التمييز والنجوم |
| **Light Green** | `#81C784` | الخلفيات الفاتحة |
| **Background** | `#FFF8E1` | خلفية التطبيق |

## 🏗️ Architecture

التطبيق يتبع بنية **MVVM** مع **Provider** لإدارة الحالة:

```
┌─────────────────┐
│      View       │  ← واجهة المستخدم (Screens & Widgets)
└────────┬────────┘
         │
┌────────▼────────┐
│   ViewModel     │  ← Provider (Business Logic)
└────────┬────────┘
         │
┌────────▼────────┐
│     Model       │  ← Data Models & Services
└─────────────────┘
```

## 📱 Screens

### 1. الشاشة الرئيسية (HomeScreen)
- عرض ترحيبي ديناميكي حسب الوقت
- بانرات دعائية متحركة
- فئات الأصناف
- قسم الأكثر طلباً
- قائمة كاملة بالأصناف

### 2. تفاصيل الصنف (ItemDetailsSheet)
- صورة كبيرة للصنف
- الوصف الكامل
- اختيار الإضافات
- التحكم في الكمية
- حساب السعر الإجمالي

### 3. السلة (CartScreen)
- عرض الأصناف المضافة
- تعديل الكميات
- حذف الأصناف
- عرض الإجمالي
- تأكيد الطلب

## 🔧 Key Features Implementation

### State Management مع Provider

```dart
// إضافة صنف للسلة
context.read<CartProvider>().addItem(item, quantity, additions);

// قراءة عدد الأصناف
final itemCount = context.watch<CartProvider>().itemCount;
```

### التحميل الذكي للصور

```dart
CachedNetworkImage(
  imageUrl: item.imageUrl,
  placeholder: (context, url) => Shimmer.fromColors(...),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

## 🌟 Best Practices

1. **Performance**
   - استخدام `const` constructors حيثما أمكن
   - Lazy loading للصور
   - تخزين مؤقت للبيانات

2. **UX/UI**
   - رسوم متحركة سلسة
   - تغذية راجعة فورية
   - رسائل واضحة للمستخدم

3. **Code Quality**
   - فصل المنطق عن الواجهة
   - استخدام نماذج بيانات واضحة
   - تعليقات وتوثيق الكود

## 🐛 Known Issues

- قد تحتاج بعض الصور لوقت أطول للتحميل في المرة الأولى
- التطبيق حالياً يدعم الوضع العمودي فقط

## 🚧 Roadmap

- [ ] إضافة نظام تسجيل دخول
- [ ] دمج بوابة دفع إلكتروني
- [ ] إضافة نظام تتبع الطلبات
- [ ] دعم الوضع الليلي
- [ ] إضافة نظام التقييمات والمراجعات
- [ ] دعم اللغة الإنجليزية
- [ ] إضافة خرائط للتوصيل

## 🤝 Contributing

نرحب بالمساهمات! الرجاء اتباع الخطوات التالية:

1. Fork المشروع
2. إنشاء branch جديد (`git checkout -b feature/AmazingFeature`)
3. Commit التغييرات (`git commit -m 'Add some AmazingFeature'`)
4. Push للـ Branch (`git push origin feature/AmazingFeature`)
5. فتح Pull Request

## 📄 License

هذا المشروع مرخص تحت رخصة MIT - انظر ملف [LICENSE](LICENSE) للتفاصيل.

## 👨‍💻 Developer

تم التطوير بواسطة فريق عربية الفيومي

## 📞 Contact

- **Email**: support@elfayoumi.com
- **Phone**: +20 123 456 7890
- **Website**: [www.elfayoumi.com](https://www.elfayoumi.com)

## 🙏 Acknowledgments

- شكر خاص لمجتمع Flutter العربي
- Google Fonts لتوفير خط Cairo
- جميع المساهمين في المكتبات المستخدمة

---

<div align="center">
  
**صنع بـ ❤️ في مصر**

⭐ لا تنسى عمل Star للمشروع إذا أعجبك!

</div>
```
