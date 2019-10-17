import 'package:flutter_test/flutter_test.dart';
import 'package:pointy_flutter/data-types/member.dart';

void main() {
  final Member member = Member(uid: "12345", name: "John Doe", vote: 345);

  group(
    'Test Member object',
    () {
      test(
        'Member attributes set',
        () {
          expect(member.uid, "12345");
          expect(member.name, "John Doe");
          expect(member.vote, 345);
        },
      );

      test('Member tostring method', () {
        expect(member.toString(), "Member<id:null>");
      });
    },
  );
}
