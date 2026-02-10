import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/program_model.dart';

class ProgramService {
  final CollectionReference _programsCollection =
      FirebaseFirestore.instance.collection('programs');

  Stream<List<Program>> getPrograms() {
    return _programsCollection
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Program.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}
