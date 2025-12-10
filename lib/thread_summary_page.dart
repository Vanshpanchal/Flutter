import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'service/ai_service.dart';

class ThreadSummaryPage extends StatefulWidget {
  const ThreadSummaryPage({super.key});

  @override
  State<ThreadSummaryPage> createState() => _ThreadSummaryPageState();
}

class _ThreadSummaryPageState extends State<ThreadSummaryPage> {
  final AIService _ai = const AIService(baseUrl: 'https://YOUR_BACKEND_URL');
  bool _loading = false;
  String? _summary;
  String? _error;

  Future<void> _generateSummary() async {
    setState(() { _loading = true; _error = null; });
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Question-Answer')
          .orderBy('Timestamp', descending: true)
          .limit(25)
          .get();
      final qaPairs = snapshot.docs.map((d) => d.data()).toList();
      final summary = await _ai.summarizeThread(qaPairs: qaPairs);
      setState(() { _summary = summary; });
    } catch (e) {
      setState(() { _error = e.toString(); });
    } finally {
      setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Thread Summary')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _loading ? null : _generateSummary,
              icon: const Icon(Icons.summarize),
              label: const Text('Summarize Latest Q&A'),
            ),
            const SizedBox(height: 16),
            if (_loading) const LinearProgressIndicator(),
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
            Expanded(
              child: _summary == null
                  ? const Center(child: Text('No summary yet'))
                  : SingleChildScrollView(
                      child: SelectableText(
                        _summary!,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
            ),
            const SizedBox(height: 8),
            Text('NOTE: Configure backend URL in ai_service.dart', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
