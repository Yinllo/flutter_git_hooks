library lint_plugin;

import 'dart:io';

import 'package:lint_plugin/runtime/git_hooks.dart';
import 'package:lint_plugin/utils/type.dart';
import 'package:lint_plugin/utils/utils.dart';

class FlutterGitHooksPlugin {
  static Future<void> gitHooks(List arguments) async {
    Map<Git, UserBackFun> params = {
      // Git.commitMsg: commitMsg,
      Git.preCommit: preCommit
    };
    GitHooks.call(arguments as List<String>, params);
  }

  static void formatCode() {
    print('Running code formatting...');
    Process.runSync('flutter', ['format', '.'], runInShell: true);
  }

  static Future<bool> runStaticAnalysis(List<String> files) async {
    if (files.isEmpty) {
      print('No staged files for static analysis.');
      return false;
    }
    List<String> args = ['analyze', ...files];
    try {
      // ProcessResult result = await Process.run('dart analyzer', ['bin']);
      ProcessResult result = Process.runSync('dart', args, runInShell: true);
      print(result.stdout);
      return !(result.exitCode != 0);
    } catch (e) {
      return false;
    }
  }

  static Future<bool> preCommit() async {
    List<String> stagedFiles = getStagedFiles();
    if (stagedFiles.isEmpty) {
      print('No staged files for static analysis.');
      return false;
    }
    print("stagedFiles文件如下---" + stagedFiles.toString());
    // return await runStaticAnalysis(stagedFiles);
    List<String> args = ['analyze', ...stagedFiles];
    try {
      // ProcessResult result = await Process.run('dart analyzer', ['bin']);
      ProcessResult result = Process.runSync('dart', args, runInShell: true);
      print(result.stdout);
      return !(result.exitCode != 0);
    } catch (e) {
      return false;
    }
  }

  /// 获取本次提交的文件
  static List<String> getStagedFiles() {
    // Use git diff command with --diff-filter=d option to get the list of staged files
    var result = Process.runSync(
        'git', ['diff', '--name-only', '--cached', '--diff-filter=d'],
        runInShell: true);
    return result.stdout
        .toString()
        .split('\n')
        .where((file) => file.isNotEmpty)
        .toList();
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
