enum Git {
  preCommit,
  commitMsg,
  applypatchMsg,
  preApplypatch,
  postApplypatch,
  prepareCommitMsg,
  postCommit,
  preRebase,
  postCheckout,
  postMerge,
  prePush,
  preReceive,
  update,
  postReceive,
  postUpdate,
  pushToCheckout,
  preAutoGc,
  postRewrite,
  sendemailValidate
}

/// enum to git hooks types
final Map<String, String> hookList = {
  'preCommit': 'pre-commit',
  'commitMsg': 'commit-msg',
  'applypatchMsg': 'applypatch-msg',
  'preApplypatch': 'pre-applypatch',
  'postApplypatch': 'post-applypatch',
  'prepareCommitMsg': 'prepare-commit-msg',
  'postCommit': 'post-commit',
  'preRebase': 'pre-rebase',
  'postCheckout': 'post-checkout',
  'postMerge': 'post-merge',
  'prePush': 'pre-push',
  'preReceive': 'pre-receive',
  'update': 'update',
  'postReceive': 'post-receive',
  'postUpdate': 'post-update',
  'pushToCheckout': 'push-to-checkout',
  'preAutoGc': 'pre-auto-gc',
  'postRewrite': 'post-rewrite',
  'sendemailValidate': 'sendemail-validate'
};
