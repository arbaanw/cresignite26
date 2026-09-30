enum ProductStatus { draft, aiOptimized, published }

enum AppLanguage { english, hindi, tamil }

extension AppLanguageX on AppLanguage {
  String get code {
    switch (this) {
      case AppLanguage.english:
        return 'en';
      case AppLanguage.hindi:
        return 'hi';
      case AppLanguage.tamil:
        return 'ta';
    }
  }

  String get label {
    switch (this) {
      case AppLanguage.english:
        return 'English';
      case AppLanguage.hindi:
        return 'हिन्दी';
      case AppLanguage.tamil:
        return 'தமிழ்';
    }
  }

  static AppLanguage fromCode(String code) {
    switch (code) {
      case 'hi':
        return AppLanguage.hindi;
      case 'ta':
        return AppLanguage.tamil;
      default:
        return AppLanguage.english;
    }
  }
}

class Artisan {
  String name;
  String craft;
  String location;
  AppLanguage language;

  Artisan({
    required this.name,
    required this.craft,
    required this.location,
    required this.language,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'craft': craft,
        'location': location,
        'language': language.code,
      };

  factory Artisan.fromJson(Map<String, dynamic> json) => Artisan(
        name: json['name'] ?? 'Lakshmi Devi',
        craft: json['craft'] ?? 'Handwoven Textiles',
        location: json['location'] ?? 'Madurai, Tamil Nadu',
        language: AppLanguageX.fromCode(json['language'] ?? 'ta'),
      );
}

class PricingRecommendation {
  final double materialCost;
  final double craftsmanship;
  final double marketPattern;
  final double margin;
  final double recommended;
  final double rangeLow;
  final double rangeHigh;

  PricingRecommendation({
    required this.materialCost,
    required this.craftsmanship,
    required this.marketPattern,
    required this.margin,
    required this.recommended,
    required this.rangeLow,
    required this.rangeHigh,
  });
}

class Buyer {
  final String name;
  final String type;
  final String interest;
  final int minOrder;

  Buyer({
    required this.name,
    required this.type,
    required this.interest,
    required this.minOrder,
  });
}

class Product {
  final String id;
  String name;
  String category;
  String material;
  String craft;
  String origin;
  Map<String, String> descriptions; // keyed by language code: en / hi / ta
  List<String> keywords;
  double rawMaterialCost;
  int craftingDays;
  double otherCosts;
  double? recommendedPrice;
  double rangeLow;
  double rangeHigh;
  double price;
  ProductStatus status;
  bool imageEnhanced;
  int visual; // selects a placeholder illustration style
  String? localImagePath; // on-device photo from camera/gallery analyze flow
  String? remoteImageUrl; // edited demo image URL from /analyze

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.material,
    required this.craft,
    required this.origin,
    required this.descriptions,
    required this.keywords,
    required this.rawMaterialCost,
    required this.craftingDays,
    required this.otherCosts,
    this.recommendedPrice,
    this.rangeLow = 0,
    this.rangeHigh = 0,
    required this.price,
    this.status = ProductStatus.draft,
    this.imageEnhanced = false,
    this.visual = 0,
    this.localImagePath,
    this.remoteImageUrl,
  });

  String descriptionFor(AppLanguage lang) =>
      descriptions[lang.code] ?? descriptions['en'] ?? '';

  Product copy() => Product(
        id: id,
        name: name,
        category: category,
        material: material,
        craft: craft,
        origin: origin,
        descriptions: Map<String, String>.of(descriptions),
        keywords: List<String>.of(keywords),
        rawMaterialCost: rawMaterialCost,
        craftingDays: craftingDays,
        otherCosts: otherCosts,
        recommendedPrice: recommendedPrice,
        rangeLow: rangeLow,
        rangeHigh: rangeHigh,
        price: price,
        status: status,
        imageEnhanced: imageEnhanced,
        visual: visual,
        localImagePath: localImagePath,
        remoteImageUrl: remoteImageUrl,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'material': material,
        'craft': craft,
        'origin': origin,
        'descriptions': descriptions,
        'keywords': keywords,
        'rawMaterialCost': rawMaterialCost,
        'craftingDays': craftingDays,
        'otherCosts': otherCosts,
        'recommendedPrice': recommendedPrice,
        'rangeLow': rangeLow,
        'rangeHigh': rangeHigh,
        'price': price,
        'status': status.index,
        'imageEnhanced': imageEnhanced,
        'visual': visual,
        'localImagePath': localImagePath,
        'remoteImageUrl': remoteImageUrl,
      };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as String,
        name: json['name'] as String,
        category: json['category'] as String,
        material: json['material'] as String,
        craft: json['craft'] as String,
        origin: json['origin'] as String,
        descriptions: Map<String, String>.from(json['descriptions'] ?? {}),
        keywords: List<String>.from(json['keywords'] ?? []),
        rawMaterialCost: (json['rawMaterialCost'] ?? 0).toDouble(),
        craftingDays: json['craftingDays'] ?? 1,
        otherCosts: (json['otherCosts'] ?? 0).toDouble(),
        recommendedPrice: (json['recommendedPrice'] as num?)?.toDouble(),
        rangeLow: (json['rangeLow'] ?? 0).toDouble(),
        rangeHigh: (json['rangeHigh'] ?? 0).toDouble(),
        price: (json['price'] ?? 0).toDouble(),
        status: ProductStatus.values[json['status'] ?? 0],
        imageEnhanced: json['imageEnhanced'] ?? false,
        visual: json['visual'] ?? 0,
        localImagePath: json['localImagePath'] as String?,
        remoteImageUrl: json['remoteImageUrl'] as String?,
      );
}
