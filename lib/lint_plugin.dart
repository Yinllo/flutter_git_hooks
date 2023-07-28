library lint_plugin;

import 'dart:io';

import 'package:lint_plugin/runtime/git_hooks.dart';
import 'package:lint_plugin/utils/type.dart';
import 'package:lint_plugin/utils/utils.dart';

class FlutterGitHooksPlugin {
  static void gitHooks(List arguments) {
    Map<Git, UserBackFun> params = {
      Git.commitMsg: commitMsg,
      Git.preCommit: preCommit
    };
    GitHooks.call(arguments as List<String>, params);
  }

  static void formatCode(List<String> files) {
    print('Running code formatting...');
    if (files.isEmpty) {
      print('No staged files for code formatting.');
      return;
    }
    ProcessResult formatResult =
        Process.runSync('dart', ['format', ...files], runInShell: true);
    if (formatResult.exitCode != 0) {
      print('Error occurred during code formatting:');
      print(formatResult.stderr);
    }
  }

  static Future<bool> runStaticAnalysis(List<String> files) async {
    print("分析的文件是--${files.toString()} \n");
    if (files.isEmpty) {
      print('No staged files for static analysis.');
      return false;
    }
    List<String> args = ['analyze', ...files];
    try {
      ProcessResult result = Process.runSync('dart', args, runInShell: true);
      print("代码分析结果---${result.stdout}");
      if (result.stdout.toString().contains("No")) return true;
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> preCommit() async {
    List<String> stagedFiles = getStagedFiles();
    return await runStaticAnalysis(stagedFiles);
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
    // var commitMsg = Utils.getCommitEditMsg();
    // if (commitMsg.startsWith('fix:')) {
    //   return true; // you can return true let commit go
    // } else {
    //   print('you should add `fix` in the commit message');
    //   return false;
    // }
    return true;
  }
}
