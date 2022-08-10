import 'package:hive/hive.dart';
//part 'entry_items.g.dart';

@HiveType(typeId: 0)
class EntryItems{
  @HiveField(0)
  late String api;
  @HiveField(1)
  late String description;
  @HiveField(2)
  late String category;
  @HiveField(3)
  late String link;

}