import 'package:lint_plugin/lint_plugin.dart';

void main(List arguments) {
  print("获取到的参数1是：" + arguments[0]);
  FlutterGitHooksPlugin.gitHooks(arguments);
}
