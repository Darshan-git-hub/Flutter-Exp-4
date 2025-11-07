import 'package:flutter/material.dart';

void main() {
  runApp(const TopicApp());
}

class TopicApp extends StatelessWidget {
  const TopicApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Topics - Coding Practice',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        scaffoldBackgroundColor: const Color(0xFFF3F2E1),
      ),
      home: const TopicsListScreen(),
    );
  }
}

class Topic {
  final String id;
  final String title;
  final String description;
  final List<Problem> problems;

  Topic({required this.id, required this.title, required this.description, required this.problems});
}

class Problem {
  final String id;
  final String title;
  final String difficulty;
  final String statement;
  final String sampleInput;
  final String sampleOutput;

  Problem({
    required this.id,
    required this.title,
    required this.difficulty,
    required this.statement,
    required this.sampleInput,
    required this.sampleOutput,
  });
}

final List<Topic> sampleTopics = [
  Topic(
    id: 'arrays',
    title: 'Arrays',
    description: 'Basic array problems, traversal and manipulation.',
    problems: [
      Problem(
        id: 'arr1',
        title: 'Find Maximum',
        difficulty: 'Easy',
        statement: 'Find the maximum element in an integer array.',
        sampleInput: '5\n1 5 3 2 4',
        sampleOutput: '5',
      ),
      Problem(
        id: 'arr2',
        title: 'Prefix Sum',
        difficulty: 'Medium',
        statement: 'Compute prefix sums of an array.',
        sampleInput: '4\n1 2 3 4',
        sampleOutput: '1 3 6 10',
      ),
    ],
  ),
  Topic(
    id: 'strings',
    title: 'Strings',
    description: 'String handling, searching, and basic algorithms.',
    problems: [
      Problem(
        id: 'str1',
        title: 'Palindrome Check',
        difficulty: 'Easy',
        statement: 'Check if a given string is a palindrome.',
        sampleInput: 'racecar',
        sampleOutput: 'YES',
      ),
      Problem(
        id: 'str2',
        title: 'Anagram Groups',
        difficulty: 'Medium',
        statement: 'Group anagrams together from a list of words.',
        sampleInput: 'eat tea tan ate nat bat',
        sampleOutput: '[eat, tea, ate] [tan, nat] [bat]',
      ),
    ],
  ),
  Topic(
    id: 'dp',
    title: 'Dynamic Programming',
    description: 'Classic DP problems and patterns.',
    problems: [
      Problem(
        id: 'dp1',
        title: 'Fibonacci (Top-down)',
        difficulty: 'Easy',
        statement: 'Compute nth Fibonacci number using DP.',
        sampleInput: '6',
        sampleOutput: '8',
      ),
      Problem(
        id: 'dp2',
        title: 'Knapsack (0/1)',
        difficulty: 'Hard',
        statement: '01 Knapsack problem: maximize value under weight limit.',
        sampleInput: '4 2\n1 2 3 2\n10 20 30 40',
        sampleOutput: '60',
      ),
    ],
  ),
];

class TopicsListScreen extends StatefulWidget {
  const TopicsListScreen({Key? key}) : super(key: key);

  @override
  _TopicsListScreenState createState() => _TopicsListScreenState();
}

class _TopicsListScreenState extends State<TopicsListScreen> {
  String _query = '';
  final Set<String> _solved = <String>{}; // problem ids marked solved (in-memory)

  List<Topic> get _filteredTopics {
    if (_query.trim().isEmpty) return sampleTopics;
    final q = _query.toLowerCase();
    return sampleTopics.where((t) => t.title.toLowerCase().contains(q) || t.description.toLowerCase().contains(q) || t.problems.any((p) => p.title.toLowerCase().contains(q))).toList();
  }

  void _toggleSolved(String problemId) {
    setState(() {
      if (_solved.contains(problemId)) _solved.remove(problemId);
      else _solved.add(problemId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coding Topics'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => showAboutDialog(
              context: context,
              applicationName: 'Topics - Coding Practice',
              applicationVersion: '1.0.0',
              children: const [Text('Simple topic/problem browser for practice.')],
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search topics or problems',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredTopics.length,
                itemBuilder: (context, idx) {
                  final t = _filteredTopics[idx];
                  final solvedCount = t.problems.where((p) => _solved.contains(p.id)).length;
                  return Card(
                    child: ListTile(
                      title: Text(t.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(t.description),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('$solvedCount/${t.problems.length} solved'),
                          const SizedBox(height: 4),
                          const Icon(Icons.chevron_right)
                        ],
                      ),
                      onTap: () async {
                        await Navigator.of(context).push(MaterialPageRoute(builder: (_) => TopicDetailScreen(topic: t, solved: _solved, onToggleSolved: _toggleSolved)));
                        setState(() {});
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopicDetailScreen extends StatelessWidget {
  final Topic topic;
  final Set<String> solved;
  final void Function(String) onToggleSolved;

  const TopicDetailScreen({Key? key, required this.topic, required this.solved, required this.onToggleSolved}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(topic.title)),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(topic.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            const Text('Problems', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: topic.problems.length,
                itemBuilder: (context, i) {
                  final p = topic.problems[i];
                  final isSolved = solved.contains(p.id);
                  return Card(
                    child: ListTile(
                      title: Text(p.title),
                      subtitle: Text('${p.difficulty} • ${p.statement.substring(0, (p.statement.length > 60) ? 60 : p.statement.length)}${p.statement.length > 60 ? '...' : ''}'),
                      leading: Icon(isSolved ? Icons.check_circle : Icons.radio_button_unchecked, color: isSolved ? Colors.green : null),
                      trailing: ElevatedButton(
                        onPressed: () {
                          onToggleSolved(p.id);
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: isSolved ? Colors.grey : Colors.deepOrange),
                        child: Text(isSolved ? 'Solved' : 'Mark'),
                      ),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProblemDetailScreen(problem: p, isSolved: isSolved, onToggleSolved: onToggleSolved))),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProblemDetailScreen extends StatelessWidget {
  final Problem problem;
  final bool isSolved;
  final void Function(String) onToggleSolved;

  const ProblemDetailScreen({Key? key, required this.problem, required this.isSolved, required this.onToggleSolved}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(problem.title)),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(problem.difficulty, style: const TextStyle(fontWeight: FontWeight.bold)),
                ElevatedButton(
                  onPressed: () => onToggleSolved(problem.id),
                  style: ElevatedButton.styleFrom(backgroundColor: isSolved ? Colors.grey : Colors.deepOrange),
                  child: Text(isSolved ? 'Solved' : 'Mark as Solved'),
                )
              ],
            ),
            const SizedBox(height: 12),
            const Text('Problem', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(problem.statement),
            const SizedBox(height: 12),
            const Text('Sample Input', style: TextStyle(fontWeight: FontWeight.bold)),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 6, bottom: 12),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: Text(problem.sampleInput),
            ),
            const Text('Sample Output', style: TextStyle(fontWeight: FontWeight.bold)),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 6),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: Text(problem.sampleOutput),
            ),
          ],
        ),
      ),
    );
  }
}
