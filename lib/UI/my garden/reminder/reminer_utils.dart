import '../../../models/plant.dart';

class Reminder {
  final Plant plant;
  final String type; // "water" or "fertilize"
  final DateTime dateTime;
  final List<bool> repeatDays; // [Mon, Tue, Wed, Thu, Fri, Sat, Sun]

  Reminder({
    required this.plant,
    required this.type,
    required this.dateTime,
    required this.repeatDays,
  });
}

List<Reminder> reminders = [];