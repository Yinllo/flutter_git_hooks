import 'dart:io';

import 'package:lint_plugin/install/hook_template.dart';

import '../utils/logging.dart';
import '../utils/type.dart';
import '../utils/utils.dart';

typedef _HooksCommandFile = Future<bool> Function(File file);

String _rootDir = Directory.current.path;

/// install hooks
class CreateHooks {
  /// Create files to `.git/hooks`
  static Future<bool> createFile({String? targetPath}) async {
    var logger = Logger.standard();
    try {
      var commonStr = commonHook();
      commonStr = createHeader() + commonStr;
      var progress = logger.progress('create files');
      await _hooksCommand((hookFile) async {
        if (!hookFile.existsSync()) {
          await hookFile.create(recursive: true);
        }
        await hookFile.writeAsString(commonStr);
        if (!Platform.isWindows) {
          try {
            await Process.run('chmod', ['777', hookFile.path]);
          } catch (e) {
            print(e);
          }
        }
        return true;
      });
      print('All files wrote successful!');
      progress.finish(showTiming: true);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  ///往项目.git/hook下写入hook脚本
  static Future<void> _hooksCommand(_HooksCommandFile callBack) async {
    var gitDir = Directory(Utils.uri(_rootDir + '/.git/'));
    var gitHookDir = Utils.gitHookFolder;
    if (!gitDir.existsSync()) {
      throw ArgumentError('.git is not exists in your project');
    }
    for (var hook in hookList.values) {
      var path = gitHookDir + hook;
      var hookFile = File(path);
      if (!await callBack(hookFile)) {
        return;
      }
    }
  }
}
