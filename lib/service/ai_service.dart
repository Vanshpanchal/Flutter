import 'dart:convert';
import 'package:http/http.dart' as http;

/// Simple AI service wrapper. You must provide your own backend endpoint
/// that proxies requests to an LLM provider (e.g. OpenAI, Gemini, Azure OpenAI)
/// to avoid exposing secrets in the mobile app.
class AIService {
  final String baseUrl;
  final String? apiKey; // Optional if your backend needs a key from client (not recommended)

  const AIService({required this.baseUrl, this.apiKey});

  Future<String> summarizeThread({required List<Map<String, dynamic>> qaPairs}) async {
    final prompt = _buildSummaryPrompt(qaPairs);
    final resp = await _postJson('/summarize', {'prompt': prompt});
    return resp['summary'] as String? ?? 'No summary';
  }

  Future<String> reviewCode({required String code, String? context}) async {
    final prompt = _buildCodeReviewPrompt(code: code, context: context);
    final resp = await _postJson('/code-review', {'prompt': prompt});
    return resp['review'] as String? ?? 'No review';
  }

  Future<Map<String, dynamic>> _postJson(String path, Map<String, dynamic> body) async {
    final uri = Uri.parse('$baseUrl$path');
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (apiKey != null) headers['x-api-key'] = apiKey!;
    final response = await http.post(uri, headers: headers, body: jsonEncode(body));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception('AIService error ${response.statusCode}: ${response.body}');
  }

  String _buildSummaryPrompt(List<Map<String, dynamic>> qaPairs) {
    final buffer = StringBuffer();
    buffer.writeln('You are an assistant that summarizes a Q&A interview prep thread.');
    buffer.writeln('Return concise bullet points capturing:');
    buffer.writeln('- Core concepts');
    buffer.writeln('- Key definitions');
    buffer.writeln('- Algorithms / complexities');
    buffer.writeln('- Any gotchas');
    buffer.writeln('Format: Markdown list.');
    for (final pair in qaPairs) {
      buffer.writeln('\nQ: ${pair['Question']}');
      buffer.writeln('A: ${pair['Answer']}');
    }
    return buffer.toString();
  }

  String _buildCodeReviewPrompt({required String code, String? context}) {
    return [
      'You are a senior Flutter engineer. Provide a structured code review.',
      if (context != null) 'Context: $context',
      'Code below between <code> tags.',
      '<code>',
      code,
      '</code>',
      'Respond sections: Summary, Correctness, Performance, Readability, BestPractices, SuggestedPatches (diff-like).'
    ].join('\n');
  }
}
