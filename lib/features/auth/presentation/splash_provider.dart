import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider that tracks if the minimum splash screen duration has completed.
final splashFinishedProvider = StateProvider<bool>((ref) => false);
