import 'package:lint_plugin/lint_plugin.dart';

void main(List arguments) {
  print("开始获取到的参数是：" + arguments[0]);
  FlutterGitHooksPlugin.preCommit();
}
