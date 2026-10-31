import 'package:flutter/material.dart';

void main() {
  runApp(const ElectionApp());
}

class Candidate {
  Candidate(this.name);
  final String name;
  int votes = 0;
}

String cleanName(String raw) {
  final words = raw.trim().split(' ').where((w) => w.isNotEmpty);
  final fixed = words.map(
        (w) => w[0].toUpperCase() + w.substring(1).toLowerCase(),
  );
  return fixed.join(' ');
}

class ElectionApp extends StatelessWidget {
  const ElectionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Class Election',
      theme: ThemeData(colorSchemeSeed: Colors.deepOrange),
      home: const VoteScreen(),
    );
  }
}

class VoteScreen extends StatefulWidget {
  const VoteScreen({super.key});

  @override
  State<VoteScreen> createState() => _VoteScreenState();
}

class _VoteScreenState extends State<VoteScreen> {
  final candidates = [Candidate('Keza'), Candidate('Mutoni'), Candidate('Gisa')];
  final voters = <String>[];
  final nameController = TextEditingController();
  Candidate? selected;

  void showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  void vote(Candidate candidate) {
    final voter = cleanName(nameController.text);
    if (voter.isEmpty) {
      showMessage('Type your name first');
      return;
    }
    if (voters.contains(voter)) {
      showMessage('$voter has already voted');
      return;
    }
    setState(() {
      candidate.votes++;
      voters.add(voter);
      selected = null;
    });
    nameController.clear();
    showMessage('$voter voted for ${candidate.name}');
  }

  void submit() {
    final choice = selected;
    if (choice == null) {
      showMessage('Tap a candidate first, then press Enter');
      return;
    }
    vote(choice);
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Election'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: nameController,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => submit(),
              decoration: const InputDecoration(
                labelText: 'Your name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Text('Votes so far: ${voters.length}'),
          Expanded(
            child: ListView.builder(
              itemCount: candidates.length,
              itemBuilder: (context, index) {
                final candidate = candidates[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(candidate.name),
                    selected: candidate == selected,
                    onTap: () {
                      setState(() {
                        selected = candidate;
                      });
                    },
                    trailing: FilledButton(
                      onPressed: () => vote(candidate),
                      child: const Text('Vote'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}