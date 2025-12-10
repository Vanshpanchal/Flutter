import 'package:flutter/material.dart';
import 'service/ai_service.dart';

class CodeReviewPage extends StatefulWidget {
  const CodeReviewPage({super.key});

  @override
  State<CodeReviewPage> createState() => _CodeReviewPageState();
}

class _CodeReviewPageState extends State<CodeReviewPage> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _contextController = TextEditingController();
  final AIService _ai = const AIService(baseUrl: 'https://YOUR_BACKEND_URL');
  bool _loading = false;
  String? _review;
  String? _error;

  Future<void> _runReview() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      setState(() { _error = 'Enter code first'; });
      return; 
    }
    setState(() { _loading = true; _error = null; _review = null; });
    try {
      final res = await _ai.reviewCode(code: code, context: _contextController.text.trim().isEmpty ? null : _contextController.text.trim());
      setState(() { _review = res; });
    } catch (e) {
      setState(() { _error = e.toString(); });
    } finally {
      setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Code Review')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _contextController,
              decoration: const InputDecoration(
                labelText: 'Optional Context (feature, constraints, goals)',
                border: OutlineInputBorder(),
              ),
              minLines: 1,
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Paste Flutter/Dart/other code here',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
                maxLines: null,
                expands: true,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _loading ? null : _runReview,
                  icon: const Icon(Icons.play_circle_fill),
                  label: const Text('Run Review'),
                ),
                const SizedBox(width: 12),
                if (_loading) const CircularProgressIndicator(),
              ],
            ),
            const SizedBox(height: 12),
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
            if (_review != null)
              SizedBox(
                height: 200,
                child: SingleChildScrollView(
                  child: SelectableText(_review!),
                ),
              ),
            Text('NOTE: Backend URL must be set in ai_service.dart', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
