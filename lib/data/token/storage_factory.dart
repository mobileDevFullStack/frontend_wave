
import 'package:waveflutterapp/core/constants/api_constants.dart';

import '../services/interface/token_storage.dart';
import 'shared_preferences_token_storage.dart';
import 'hive_token_storage.dart';

TokenStorage createTokenStorage() {
  return useSharedPreferences
      ? SharedPreferencesTokenStorage()
      : HiveTokenStorage();
}