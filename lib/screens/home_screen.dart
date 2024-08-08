import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../constants/strings.dart';
import '../constants/styles.dart';
import '../utils/date_formatter.dart';
import '../models/weight_entry.dart';
import 'login_screen.dart';
import 'weight_entry_screen.dart';
import 'weight_history_screen.dart';

class HomeScreen extends StatefulWidget {
  final AuthService authService;

  const HomeScreen({Key? key, required this.authService}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService _databaseService = DatabaseService();
  WeightEntry? _latestEntry;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    _loadLatestEntry();
  }

  Future<void> _loadLatestEntry() async {
    final currentUser = widget.authService.currentUser;
    if (currentUser != null) {
      final entries = await _databaseService.getWeightEntries(currentUser.id);
      setState(() {
        _latestEntry = entries.isNotEmpty ? entries.first : null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = widget.authService.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await widget.authService.logout();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginScreen(authService: widget.authService)),
              );
            },
          ),
        ],
      ),
      body: currentUser == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${Strings.welcome}, ${currentUser.name}!',
              style: Styles.headlineStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildLatestWeightCard(),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: Styles.primaryButtonStyle,
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => WeightEntryScreen(authService: widget.authService)),
                );
                _loadLatestEntry();
              },
              icon: const Icon(Icons.add),
              label: Text(Strings.logTodaysWeight),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: Styles.primaryButtonStyle,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => WeightHistoryScreen(authService: widget.authService)),
                );
              },
              icon: const Icon(Icons.history),
              label: Text(Strings.viewWeightHistory),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLatestWeightCard() {
    return Card(
      elevation: 4,
      shape: Styles.cardTheme.shape,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              Strings.latestWeight,
              style: Styles.titleStyle,
            ),
            const SizedBox(height: 8),
            _latestEntry != null
                ? Column(
              children: [
                Text(
                  '${_latestEntry!.weight} kg',
                  style: Styles.headlineStyle.copyWith(
                    color: Styles.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'le ${DateFormatter.formatDate(_latestEntry!.date)}',
                  style: Styles.bodyStyle,
                ),
              ],
            )
                : Text(Strings.noWeightEntries, style: Styles.bodyStyle),
          ],
        ),
      ),
    );
  }
}
