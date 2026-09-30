import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/analyze_result.dart';

/// Talks to the CribeIt FastAPI backend (hardcoded demo analyze + static edited image).
///
/// Override [baseUrl] at build time if needed:
///   flutter run --dart-define=API_BASE_URL=http://192.168.1.10:8000
class ApiService {
  ApiService({String? baseUrl}) : baseUrl = _normalizeBaseUrl(baseUrl ?? _defaultBaseUrl());

  final String baseUrl;

  static String _normalizeBaseUrl(String url) => url.replaceAll(RegExp(r'/+$'), '');

  static String _defaultBaseUrl() {
    const fromEnv = String.fromEnvironment('API_BASE_URL');
    if (fromEnv.isNotEmpty) return fromEnv;

    // Android emulator reaches the host machine via 10.0.2.2.
    if (!kIsWeb && Platform.isAndroid) {
      return 'http://10.0.2.2:8000';
    }
    return 'http://127.0.0.1:8000';
  }

  Future<AnalyzeResult> analyzeProduct({
    required File imageFile,
    required String languageCode,
  }) async {
    final uri = Uri.parse('$baseUrl/analyze');
    final request = http.MultipartRequest('POST', uri)
      ..fields['language'] = languageCode
      ..files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

    final streamed = await request.send().timeout(const Duration(seconds: 90));
    final body = await streamed.stream.bytesToString();

    if (streamed.statusCode < 200 || streamed.statusCode >= 300) {
      throw ApiException(
        'Analyze failed (${streamed.statusCode}): ${_shortError(body)}',
        statusCode: streamed.statusCode,
      );
    }

    final decoded = jsonDecode(body) as Map<String, dynamic>;
    return AnalyzeResult.fromJson(decoded);
  }

  String _shortError(String body) {
    try {
      final map = jsonDecode(body) as Map<String, dynamic>;
      return (map['detail'] ?? body).toString();
    } catch (_) {
      return body.length > 180 ? '${body.substring(0, 180)}…' : body;
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}
