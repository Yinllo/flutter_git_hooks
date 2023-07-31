library lint_plugin;

import 'dart:io';

import 'package:lint_plugin/runtime/git_hooks.dart';
import 'package:lint_plugin/utils/type.dart';
import 'package:lint_plugin/utils/utils.dart';

class FlutterGitHooksPlugin {
  static void gitHooks(List arguments) {
    Map<Git, UserBackFun> params = {Git.commitMsg: commitMsg, Git.preCommit: preCommit};
    GitHooks.call(arguments as List<String>, params);
  }

  /// 获取本次提交的dart文件
  static List<String> getStagedFiles() {
    // Use git diff command with --diff-filter=d option to get the list of staged files
    var result = Process.runSync('git', ['diff', '--name-only', '--cached', '--diff-filter=d'], runInShell: true);
    return result.stdout.toString().split('\n').where((file) => file.isNotEmpty && file.endsWith('.dart')).toList();
  }

  ///commit hook
  static Future<bool> preCommit() async {
    try {
      // Filter out any files that are not Dart files
      var dartFiles = getStagedFiles();
      if (dartFiles.isEmpty) {
        return true;
      }
      ProcessResult result;
      // Run the pre-commit checks on each Dart file
      for (var dartFile in dartFiles) {
        print('开始代码格式化...');
        result = await Process.run('dart', ['format', dartFile]);
        // 获取格式化后的日志输出
        String formattedCode = result.stdout.toString().trim();
        if (result.exitCode != 0 || (formattedCode.isNotEmpty && !formattedCode.contains('0 changed'))) {
          print('文件: $dartFile 已经重新格式化，请重新提交');
          if (formattedCode.isNotEmpty) {
            print(formattedCode);
          }
          return false;
        }

        print('代码格式化通过');
        print('代码格式化通过。开始代码分析...');
        result = await Process.run('dart', ['analyze', dartFile]);
        // 获取格式化后的日志输出
        String analysisCode = result.stdout.toString().trim();
        if (result.exitCode != 0 || (analysisCode.isNotEmpty && !analysisCode.contains('No issues found'))) {
          print("代码不符合lint规则，需要修复");
          print("具体问题代码如下：${result.stdout}");
          return false;
        }
        print("代码分析结果为---${result.stdout}");
      }
      return true;
    } catch (e) {
      return false;
    }
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
