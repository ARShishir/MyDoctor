
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String url =
      'https://gxwnawkrdvewjtygtubj.supabase.co';

  static const String anonKey =
      'sb_publishable_DGBpU2Pil2o5holIKadjEQ_51rfFHCm';
}

/// ⚠️ DO NOT access Supabase.instance here
SupabaseClient getSupabaseClient() {
  return Supabase.instance.client;
}
