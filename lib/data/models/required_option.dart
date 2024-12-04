import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splitz/data/models/choice.dart';

class RequiredOption {
  String? id;
  final String name;
  final List<Choice> choices;

  RequiredOption({
    this.id,
    required this.name,
    required this.choices,
  });

  factory RequiredOption.fromFirestore(DocumentSnapshot doc) {
    final firestore = doc.data() as Map<String, dynamic>;
    return RequiredOption(
      id: doc.id,
      name: firestore['name'],
      choices: [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'choices': choices.map((e) => e.toMap()).toList(),
    };
  }

  RequiredOption copyWith({List<Choice>? choices}) {
    return RequiredOption(
      id: this.id,
      name: this.name,
      choices: choices ?? this.choices,
    );
  }
}
