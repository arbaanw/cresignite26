import '../models/models.dart';

/// All demo/seed data lives here so the app works fully offline.
class DemoData {
  static Artisan seedArtisan() => Artisan(
        name: 'Lakshmi Devi',
        craft: 'Handwoven Textiles',
        location: 'Madurai, Tamil Nadu',
        language: AppLanguage.tamil,
      );

  static List<Product> seedProducts() {
    return [
      Product(
        id: 'p1',
        name: 'Handwoven Cotton Saree',
        category: 'Traditional Textiles',
        material: '100% Cotton',
        craft: 'Handwoven',
        origin: 'Madurai, Tamil Nadu',
        descriptions: {
          'en':
              'Traditional handwoven cotton saree crafted by skilled artisans in Madurai, Tamil Nadu. Lightweight, breathable and inspired by timeless traditional patterns.',
          'hi':
              'मदुरै, तमिलनाडु के कुशल कारीगरों द्वारा हाथ से बुनी गई पारंपरिक सूती साड़ी। हल्की, सांस लेने योग्य और सदाबहार पारंपरिक डिज़ाइनों से प्रेरित।',
          'ta':
              'மதுரை, தமிழ்நாட்டைச் சேர்ந்த திறமையான கைவினைஞர்களால் கைத்தறியில் நெய்யப்பட்ட பாரம்பரிய பருத்தி புடவை. இலகுவானது, காற்றோட்டமானது, மற்றும் காலம் காலமான பாரம்பரிய வடிவமைப்புகளால் ஈர்க்கப்பட்டது.',
        },
        keywords: const ['handwoven', 'cotton', 'saree', 'madurai', 'traditional'],
        rawMaterialCost: 1200,
        craftingDays: 3,
        otherCosts: 300,
        price: 2850,
        recommendedPrice: 2850,
        rangeLow: 2500,
        rangeHigh: 3200,
        status: ProductStatus.draft,
        visual: 0,
      ),
      Product(
        id: 'p2',
        name: 'Palm Leaf Basket',
        category: 'Handicrafts',
        material: 'Palm Leaf',
        craft: 'Hand-woven basketry',
        origin: 'Thanjavur, Tamil Nadu',
        descriptions: {
          'en':
              'Eco-friendly palm leaf basket, hand-woven with fine detailing, perfect for everyday storage.',
          'hi':
              'बारीक बुनाई के साथ हाथ से बुनी गई पर्यावरण-अनुकूल ताड़ के पत्ते की टोकरी, रोज़मर्रा के भंडारण के लिए उपयुक्त।',
          'ta':
              'சுற்றுச்சூழலுக்கு உகந்த பனை ஓலைக் கூடை, நுட்பமான வேலைப்பாட்டுடன் கைத்தறியில் நெய்யப்பட்டது.',
        },
        keywords: const ['palm leaf', 'basket', 'eco-friendly'],
        rawMaterialCost: 250,
        craftingDays: 1,
        otherCosts: 50,
        price: 450,
        status: ProductStatus.published,
        visual: 1,
      ),
      Product(
        id: 'p3',
        name: 'Terracotta Pot',
        category: 'Pottery',
        material: 'Terracotta Clay',
        craft: 'Hand-thrown pottery',
        origin: 'Pondicherry',
        descriptions: {
          'en':
              'Hand-thrown terracotta pot, fired using traditional techniques for a rustic, earthy finish.',
          'hi':
              'हाथ से बनाया गया टेराकोटा का बर्तन, पारंपरिक तकनीकों से पकाया गया, देहाती और मिट्टी जैसी फिनिश के साथ।',
          'ta': 'பாரம்பரிய முறையில் சுட்டெடுக்கப்பட்ட, கையால் வடிவமைக்கப்பட்ட களிமண் பானை.',
        },
        keywords: const ['terracotta', 'pottery', 'clay'],
        rawMaterialCost: 150,
        craftingDays: 2,
        otherCosts: 40,
        price: 380,
        status: ProductStatus.aiOptimized,
        visual: 2,
      ),
      Product(
        id: 'p4',
        name: 'Handcrafted Jute Bag',
        category: 'Bags & Accessories',
        material: 'Jute',
        craft: 'Hand-stitched',
        origin: 'Kolkata, West Bengal',
        descriptions: {
          'en': 'Durable hand-stitched jute bag, a sustainable alternative for everyday use.',
          'hi': 'हाथ से सिली गई टिकाऊ जूट की थैली, रोज़मर्रा के उपयोग के लिए एक टिकाऊ विकल्प।',
          'ta': 'நீடித்த சணல் பையை கையால் தைத்து உருவாக்கப்பட்டது, தினசரி பயன்பாட்டிற்கு ஏற்றது.',
        },
        keywords: const ['jute', 'bag', 'sustainable'],
        rawMaterialCost: 180,
        craftingDays: 1,
        otherCosts: 30,
        price: 320,
        status: ProductStatus.draft,
        visual: 3,
      ),
      Product(
        id: 'p5',
        name: 'Traditional Cotton Shawl',
        category: 'Traditional Textiles',
        material: 'Cotton',
        craft: 'Handloom',
        origin: 'Kanchipuram, Tamil Nadu',
        descriptions: {
          'en':
              'Soft handloom cotton shawl with traditional border patterns, ideal for all seasons.',
          'hi':
              'पारंपरिक बॉर्डर डिज़ाइन वाली मुलायम हैंडलूम सूती शॉल, हर मौसम के लिए उपयुक्त।',
          'ta': 'பாரம்பரிய விளிம்பு வடிவமைப்புகளுடன் கூடிய மென்மையான கைத்தறி பருத்தி துப்பட்டா.',
        },
        keywords: const ['shawl', 'cotton', 'handloom'],
        rawMaterialCost: 400,
        craftingDays: 2,
        otherCosts: 60,
        price: 720,
        status: ProductStatus.published,
        visual: 4,
      ),
    ];
  }

  static List<Buyer> seedBuyers() => [
        Buyer(
          name: 'Chennai Handicraft Retailer',
          type: 'B2B Retailer',
          interest: 'Cotton Textiles',
          minOrder: 20,
        ),
        Buyer(
          name: 'Traditional Textile Buyer',
          type: 'Wholesale Buyer',
          interest: 'Handwoven Sarees & Shawls',
          minOrder: 15,
        ),
        Buyer(
          name: 'Bengaluru Boutique Collective',
          type: 'B2B Retailer',
          interest: 'Handicrafts & Bags',
          minOrder: 10,
        ),
      ];
}
