import 'dart:io';

String fixture(String fileName) =>
    File('test/features/fixtures/$fileName').readAsStringSync();
