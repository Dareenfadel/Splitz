import 'package:splitz/data/models/choice.dart';

class RequiredOption {
  final String id;
  final String name;
  final List<Choice> choices;

  RequiredOption({
    required this.id,
    required this.name,
    required this.choices,
  });

  factory RequiredOption.fromFirestore(Map<String, dynamic> firestore) {
    return RequiredOption(
      id: firestore['id'],
      name: firestore['name'],
      choices: (firestore['choices'] as List)
          .map((e) => Choice.fromFirestore(e))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'choices': choices.map((e) => e.toMap()).toList(),
    };
  }
}
