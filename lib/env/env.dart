// lib/env/env.dart
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env', useConstantCase: true)
final class Env {
  @EnviedField(obfuscate: true)
  static final String googleMapsApiKey = _Env.googleMapsApiKey;
}
