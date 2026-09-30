import 'package:flutter/material.dart';
import '../models/models.dart';
import '../data/demo_data.dart';
import 'storage_service.dart';

/// Single app-wide state holder. Keeps the MVP simple: no backend,
/// everything is seeded/simulated and persisted locally when possible.
class AppState extends ChangeNotifier {
  final StorageService _storage = StorageService();

  Artisan artisan = DemoData.seedArtisan();
  AppLanguage language = AppLanguage.tamil;
  List<Product> products = DemoData.seedProducts();
  List<Buyer> buyers = DemoData.seedBuyers();
  bool onboarded = false;
  bool loaded = false;

  /// The product currently moving through Add -> Image Studio -> Catalog
  /// -> Pricing -> Listing -> Publish.
  Product? activeProduct;

  Future<void> init() async {
    onboarded = await _storage.isOnboarded();
    final savedLang = await _storage.loadLanguage();
    if (savedLang != null) language = savedLang;
    final savedArtisan = await _storage.loadArtisan();
    if (savedArtisan != null) artisan = savedArtisan;
    final savedProducts = await _storage.loadProducts();
    if (savedProducts != null && savedProducts.isNotEmpty) products = savedProducts;
    loaded = true;
    notifyListeners();
  }

  Future<void> setLanguage(AppLanguage lang) async {
    language = lang;
    await _storage.saveLanguage(lang);
    notifyListeners();
  }

  Future<void> completeOnboarding(Artisan a) async {
    artisan = a;
    onboarded = true;
    await _storage.saveArtisan(a);
    await _storage.setOnboarded(true);
    notifyListeners();
  }

  /// Starts the demo add-product flow using the seeded saree.
  void startAddProduct() {
    final seedSaree = DemoData.seedProducts().first;
    activeProduct = seedSaree.copy();
    activeProduct!.status = ProductStatus.draft;
    activeProduct!.imageEnhanced = false;
    notifyListeners();
  }

  void markImageEnhanced() {
    activeProduct?.imageEnhanced = true;
    notifyListeners();
  }

  void updateActiveDescription(AppLanguage lang, String text) {
    activeProduct?.descriptions[lang.code] = text;
    notifyListeners();
  }

  /// Demo pricing "AI": a simple, explainable formula computed from the
  /// artisan's own entered costs — not a real external market lookup.
  PricingRecommendation calculatePricing({
    required double materialCost,
    required int craftingDays,
    required double otherCosts,
  }) {
    final craftsmanship = craftingDays * 267.0;
    final marketPattern = materialCost * 0.375;
    final margin = otherCosts + 100.0;
    final recommended = materialCost + craftsmanship + marketPattern + margin;
    return PricingRecommendation(
      materialCost: materialCost,
      craftsmanship: craftsmanship,
      marketPattern: marketPattern,
      margin: margin,
      recommended: recommended,
      rangeLow: recommended - 350,
      rangeHigh: recommended + 350,
    );
  }

  void applyPricing(
    PricingRecommendation rec, {
    required double materialCost,
    required int craftingDays,
    required double otherCosts,
  }) {
    final p = activeProduct;
    if (p == null) return;
    p.rawMaterialCost = materialCost;
    p.craftingDays = craftingDays;
    p.otherCosts = otherCosts;
    p.recommendedPrice = rec.recommended;
    p.price = rec.recommended;
    p.rangeLow = rec.rangeLow;
    p.rangeHigh = rec.rangeHigh;
    p.status = ProductStatus.aiOptimized;
    notifyListeners();
  }

  Future<void> publishActiveProduct() async {
    final p = activeProduct;
    if (p == null) return;
    p.status = ProductStatus.published;
    final index = products.indexWhere((existing) => existing.id == p.id);
    if (index >= 0) {
      products[index] = p;
    } else {
      products.insert(0, p);
    }
    await _storage.saveProducts(products);
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    products.removeWhere((p) => p.id == id);
    await _storage.saveProducts(products);
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    final index = products.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      products[index] = product;
    }
    await _storage.saveProducts(products);
    notifyListeners();
  }

  /// Persists a product created from the real photo → FastAPI analyze flow.
  Future<void> saveAnalyzedProduct({
    required String name,
    required String description,
    required AppLanguage language,
    required double suggestedPrice,
    String? imagePath,
    String? remoteImageUrl,
  }) async {
    final id = 'ai-${DateTime.now().millisecondsSinceEpoch}';
    final product = Product(
      id: id,
      name: name,
      category: 'AI Catalogued',
      material: '—',
      craft: artisan.craft,
      origin: artisan.location,
      descriptions: {language.code: description},
      keywords: const ['ai', 'analyzed'],
      rawMaterialCost: 0,
      craftingDays: 1,
      otherCosts: 0,
      recommendedPrice: suggestedPrice,
      rangeLow: (suggestedPrice * 0.88).clamp(0, double.infinity),
      rangeHigh: suggestedPrice * 1.12,
      price: suggestedPrice,
      status: ProductStatus.aiOptimized,
      imageEnhanced: true,
      visual: products.length % 5,
      localImagePath: imagePath,
      remoteImageUrl: remoteImageUrl,
    );
    products.insert(0, product);
    activeProduct = product;
    await _storage.saveProducts(products);
    notifyListeners();
  }

  Product? findProduct(String id) {
    for (final p in products) {
      if (p.id == id) return p;
    }
    return null;
  }

  int get publishedCount => products.where((p) => p.status == ProductStatus.published).length;
  double get inventoryValue => products.fold(0.0, (sum, p) => sum + p.price);
}
