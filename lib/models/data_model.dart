import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class Notify {
  final AUser sender;
  final Timestamp time;
  final bool isRead;

  Notify({
    this.sender,
    this.time,
    this.isRead,
  });
}
