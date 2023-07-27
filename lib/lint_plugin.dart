library lint_plugin;

import 'dart:io';

import 'package:lint_plugin/runtime/git_hooks.dart';
import 'package:lint_plugin/utils/type.dart';
import 'package:lint_plugin/utils/utils.dart';

class FlutterGitHooksPlugin {
  static Future<void> gitHooks(List arguments) async {
    Map<Git, UserBackFun> params = {Git.commitMsg: commitMsg, Git.preCommit: preCommit};
    GitHooks.call(arguments as List<String>, params);
  }

  static void formatCode() {
    print('Running code formatting...');
    Process.runSync('flutter', ['format', '.'], runInShell: true);
  }

  static Future<bool> runStaticAnalysis() async {
    print('Running static analysis...');
    try {
      // ProcessResult result = await Process.run('dart analyzer', ['bin']);
      ProcessResult result = Process.runSync('dart', ['analyze'], runInShell: true);
      print(result.stdout);
      return !(result.exitCode != 0);
    } catch (e) {
      return false;
    }
  }

  static Future<bool> preCommit() async {
    return await runStaticAnalysis();
  }

  static Future<bool> commitMsg() async {
    var commitMsg = Utils.getCommitEditMsg();
    if (commitMsg.startsWith('fix:')) {
      return true; // you can return true let commit go
    } else {
      print('you should add `fix` in the commit message');
      return false;
    }
    return true;
  }
}
