// ignore_for_file: prefer_const_constructors
import 'package:network_repository/network_repository.dart';
import 'package:test/test.dart';

void main() {
  group('NetworkRepository', () {
    test('can be instantiated', () {
      expect(NetworkRepository(), isNotNull);
    });
  });
}
