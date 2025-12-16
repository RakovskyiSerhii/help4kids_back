import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:help4kids/config/app_config.dart';
import 'package:help4kids/routes/_handler.dart';

Future<void> main() async {
  final address = InternetAddress.anyIPv4;
  final port = AppConfig.serverPort;

  // Start the server using the global `handler`
  final server = await serve(handler, address, port);
  stdout.writeln(
    'Server listening on http://${server.address.address}:${server.port}',
  );
}