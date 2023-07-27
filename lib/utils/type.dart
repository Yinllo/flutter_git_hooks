enum Git {
  preCommit,
  commitMsg,
}

/// enum to git hooks types
final Map<String, String> hookList = {
  'preCommit': 'pre-commit',
  'commitMsg': 'commit-msg',
};
