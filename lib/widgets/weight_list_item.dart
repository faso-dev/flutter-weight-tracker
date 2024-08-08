import 'package:flutter/material.dart';
import '../models/weight_entry.dart';
import '../utils/date_formatter.dart';
import '../constants/styles.dart';

class WeightListItem extends StatelessWidget {
  final WeightEntry entry;
  final VoidCallback? onDelete;

  const WeightListItem({
    Key? key,
    required this.entry,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: Styles.cardTheme.shape,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Styles.primaryColor,
          child: Text(
            '${entry.weight.toStringAsFixed(1)}',
            style: Styles.bodyStyle.copyWith(color: Colors.white, fontSize: 12),
          ),
        ),
        title: Text(
          '${entry.weight} kg',
          style: Styles.titleStyle,
        ),
        subtitle: Text(DateFormatter.formatDate(entry.date), style: Styles.bodyStyle),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
