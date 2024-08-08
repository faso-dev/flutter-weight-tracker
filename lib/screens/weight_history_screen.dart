import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';
import '../models/weight_entry.dart';
import '../widgets/weight_chart.dart';
import '../widgets/weight_list_item.dart';
import '../constants/strings.dart';
import '../constants/styles.dart';

class WeightHistoryScreen extends StatefulWidget {
  final AuthService authService;

  const WeightHistoryScreen({Key? key, required this.authService}) : super(key: key);

  @override
  _WeightHistoryScreenState createState() => _WeightHistoryScreenState();
}

class _WeightHistoryScreenState extends State<WeightHistoryScreen> {
  final DatabaseService _databaseService = DatabaseService();
  List<WeightEntry> _weightEntries = [];

  @override
  void initState() {
    super.initState();
    _loadWeightEntries();
  }

  Future<void> _loadWeightEntries() async {
    final currentUser = widget.authService.currentUser;
    if (currentUser != null) {
      final entries = await _databaseService.getWeightEntries(currentUser.id);
      setState(() {
        _weightEntries = entries;
      });
    }
  }

  Future<void> _deleteWeightEntry(WeightEntry entry) async {
    await _databaseService.deleteWeightEntry(entry.id!);
    _loadWeightEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.weightHistory),
      ),
      body: _weightEntries.isEmpty
          ? Center(child: Text(Strings.noEntriesYet, style: Styles.bodyStyle))
          : Column(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: WeightChart(entries: _weightEntries),
            ),
          ),
          Expanded(
            flex: 3,
            child: ListView.builder(
              itemCount: _weightEntries.length,
              itemBuilder: (context, index) {
                return WeightListItem(
                  entry: _weightEntries[index],
                  onDelete: () => _deleteWeightEntry(_weightEntries[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
