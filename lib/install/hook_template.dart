import 'dart:io';

import 'package:yaml/yaml.dart';

/// hooks template
String commonHook() {
  var temp = '';
  if (Platform.isMacOS) {
    temp += '''
if [ -f ~/.bash_profile ]
then
  source ~/.bash_profile
fi
if [ -f ~/.zsh_profile ]
then
  source ~/.zsh_profile
fi
''';
  }
  temp += '''
  
hookName=`basename "\$0"`
flutter pub run lint_plugin:preCommit \$hookName
  if [ "\$?" -ne "0" ];then
    exit 1
  fi
else
  echo "git_hooks > \$hookName"
fi
''';
  return temp;
}

/// hooks header
String createHeader() {
  var rootDir = Directory.current;
  var f = File(rootDir.path + '/pubspec.yaml');
  var text = f.readAsStringSync();
  Map yaml = loadYaml(text);
  String name = yaml['name'] ?? '';
  String author = yaml['author'] ?? '';
  String version = yaml['version'] ?? '';
  String homepage = yaml['homepage'] ?? '';
  return '''
#!/bin/sh
# !!!don"t edit this file
# ${name}
# Hook created by ${author}
#   Version: ${version}
#   At: ${DateTime.now()}
#   See: ${homepage}#readme

# From
#   Homepage: ${homepage}#readme

''';
}
