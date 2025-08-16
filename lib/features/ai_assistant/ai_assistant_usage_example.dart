// Example usage of AI Assistant feature
// This file demonstrates how to use the AI Assistant in your app

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/service_locator.dart';
import 'presentation/cubit/ai_assistant_cubit.dart';
import 'presentation/cubit/ai_assistant_state.dart';

class AiAssistantUsageExample extends StatelessWidget {
  const AiAssistantUsageExample({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AiAssistantCubit>(),
      child: const _AiAssistantView(),
    );
  }
}

class _AiAssistantView extends StatefulWidget {
  const _AiAssistantView();

  @override
  State<_AiAssistantView> createState() => _AiAssistantViewState();
}

class _AiAssistantViewState extends State<_AiAssistantView> {
  final _questionController = TextEditingController();

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  void _askQuestion() {
    final question = _questionController.text.trim();
    if (question.isNotEmpty) {
      context.read<AiAssistantCubit>().askQuestion(question);
      _questionController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Learning Assistant'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Question input
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(
                labelText: 'Ask a study-related question',
                hintText: 'e.g., Explain photosynthesis process',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onSubmitted: (_) => _askQuestion(),
            ),
            const SizedBox(height: 16),
            
            // Ask button
            ElevatedButton(
              onPressed: _askQuestion,
              child: const Text('Ask AI Assistant'),
            ),
            
            const SizedBox(height: 24),
            
            // Response area
            Expanded(
              child: BlocBuilder<AiAssistantCubit, AiAssistantState>(
                builder: (context, state) {
                  return switch (state) {
                    AiAssistantInitial() => const Center(
                        child: Text(
                          'Ask me any study-related question!\n\nI can help with:\n• Explaining concepts\n• Solving problems\n• Study tips\n• Technical topics',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    AiAssistantLoading() => const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('AI is thinking...'),
                          ],
                        ),
                      ),
                    AiAssistantSuccess(:final response) => Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.smart_toy, color: Colors.green.shade700),
                                const SizedBox(width: 8),
                                Text(
                                  'AI Assistant Response',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Text(
                                  response.response,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    AiAssistantError(:final message) => Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.error, color: Colors.red.shade700),
                                const SizedBox(width: 8),
                                Text(
                                  'Error',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red.shade700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(message),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () => context.read<AiAssistantCubit>().reset(),
                              child: const Text('Try Again'),
                            ),
                          ],
                        ),
                      ),
                    // TODO: Handle this case.
                    AiAssistantState() => throw UnimplementedError(),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
USAGE INSTRUCTIONS:

1. Import the necessary dependencies in your pubspec.yaml (already done)

2. Make sure your .env file contains the GEMINI_API_KEY (already done)

3. Initialize the dependencies in your main.dart:
   ```dart
   await dotenv.load(fileName: ".env");
   await init(); // This will initialize all dependencies including AI Assistant
   ```

4. Use the AI Assistant in your app:
   ```dart
   // Method 1: Use the example widget directly
   Navigator.push(
     context,
     MaterialPageRoute(builder: (context) => const AiAssistantUsageExample()),
   );

   // Method 2: Use the Cubit directly in your own widget
   BlocProvider(
     create: (context) => sl<AiAssistantCubit>(),
     child: YourCustomWidget(),
   );
   ```

5. Ask questions programmatically:
   ```dart
   final cubit = context.read<AiAssistantCubit>();
   cubit.askQuestion("Explain the water cycle");
   ```

FEATURES:
- Clean Architecture implementation
- Proper error handling and loading states
- Study-focused AI responses
- Network connectivity checks
- Configurable AI model parameters
- Professional tutor prompt engineering
*/
