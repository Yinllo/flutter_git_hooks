import 'dart:io';

import 'package:lint_plugin/install/create_hooks.dart';
import 'package:lint_plugin/utils/utils.dart';
import 'package:yaml/yaml.dart';

void main(List<dynamic>? arguments) {
  if (arguments != null && arguments.isNotEmpty) {
    var str = arguments[0]!.toString();
    if (arguments.isNotEmpty) {
      if (str == 'create') {
        CreateHooks.createFile();
      } else if (str == '-h' || str == '-help') {
        help();
      }
    } else if (str == '-v' || str == '--version') {
      var f = File(Utils.uri((Utils.getOwnPath() ?? '') + '/pubspec.yaml'));
      var text = f.readAsStringSync();
      Map yaml = loadYaml(text);
      String? version = yaml['version'];
      print(version);
    } else {
      print('Too many positional arguments: 1 expected, but ${arguments.length} found');
      print('');
      help();
    }
  } else {
    print('please Enter the command');
    print('');
    help();
  }
}

void help() {
  print('Common commands:');
  print('');
  print(' git_hooks create {{targetPath}}');
  print('   Create hooks files in \'.git/hooks\'');
  print('');
}
