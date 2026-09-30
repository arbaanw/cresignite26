/// Response from POST /analyze.
class AnalyzeResult {
  final String name;
  final String description;
  final double suggestedPrice;

  const AnalyzeResult({
    required this.name,
    required this.description,
    required this.suggestedPrice,
  });

  factory AnalyzeResult.fromJson(Map<String, dynamic> json) {
    return AnalyzeResult(
      name: (json['name'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      suggestedPrice: (json['suggested_price'] as num?)?.toDouble() ?? 0,
    );
  }
}
