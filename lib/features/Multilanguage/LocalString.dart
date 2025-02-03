import 'package:get/get.dart';

class Localstring extends Translations{
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'hello': 'Hello',
      'welcome': 'Welcome Back',
      'dabbawalas': 'Dabbawalas Around You',
      'settings':'Settings',
      'language':'Languages',
    },
    'hi_IN': {
      'hello': 'नमस्ते',
      'welcome': 'वापस स्वागत है',
      'dabbawalas': 'आपके आस-पास डबवालस',
      'settings':'सेटिंग्ज',
      'language':'भाषा',
    },
    'mr_IN': {
      'hello': 'नमस्ते',
      'welcome': 'परत स्वागत आहे',
      'dabbawalas': 'दब्बावलस आपल्या सभोवताल',
      'settings':'सेटिंग्ज',
      'language':'भाषा',
    }
  };
}