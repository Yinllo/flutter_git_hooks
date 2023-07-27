enum Git {
  commitMsg,
  preCommit,
}

/// enum to git hooks types
final Map<String, String> hookList = {
  'commitMsg': 'commit-msg',
  'preCommit': 'pre-commit',
};
