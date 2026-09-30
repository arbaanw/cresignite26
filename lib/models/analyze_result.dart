/// Response from POST /analyze.
class AnalyzeResult {
  final String name;
  final String description;
  final double suggestedPrice;
  final String? editedImageUrl;

  const AnalyzeResult({
    required this.name,
    required this.description,
    required this.suggestedPrice,
    this.editedImageUrl,
  });

  factory AnalyzeResult.fromJson(Map<String, dynamic> json) {
    final url = json['edited_image_url']?.toString().trim();
    return AnalyzeResult(
      name: (json['name'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      suggestedPrice: (json['suggested_price'] as num?)?.toDouble() ?? 0,
      editedImageUrl: (url == null || url.isEmpty) ? null : url,
    );
  }
}
