Feature: git-hack on a feature branch with open changes

  Background:
    Given I have a feature branch named "feature"
    And the following commits exist in my repository
      | BRANCH  | LOCATION | MESSAGE        | FILE NAME    |
      | main    | remote   | main commit    | main_file    |
      | feature | local    | feature commit | feature_file |
    And I am on the "feature" branch
    And I have an uncommitted file with name: "uncommitted" and content: "stuff"
    When I run `git hack other_feature`


  Scenario: result
    Then it runs the Git commands
      | BRANCH        | COMMAND                            |
      | feature       | git stash -u                       |
      | feature       | git checkout main                  |
      | main          | git fetch --prune                  |
      | main          | git rebase origin/main             |
      | main          | git checkout -b other_feature main |
      | other_feature | git stash pop                      |
    And I end up on the "other_feature" branch
    And I still have an uncommitted file with name: "uncommitted" and content: "stuff"
    And I have the following commits
      | BRANCH        | LOCATION         | MESSAGE        | FILES        |
      | main          | local and remote | main commit    | main_file    |
      | feature       | local            | feature commit | feature_file |
      | other_feature | local            | main commit    | main_file    |