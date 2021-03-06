Feature: git-town sync: syncing the current perennial branch

  As a developer syncing a perennial branch
  I want to be able update my ongoing work to include the latest finished features from the rest of the team
  So that our collaboration remains effective.


  Background:
    Given I have perennial branches named "production" and "qa"
    And I am on the "qa" branch
    And the following commits exist in my repository
      | BRANCH | LOCATION         | MESSAGE       | FILE NAME   |
      | qa     | local            | local commit  | local_file  |
      |        | remote           | remote commit | remote_file |
      | main   | local and remote | main commit   | main_file   |
    And I have an uncommitted file
    When I run `git-town sync`


  Scenario: no conflict
    Then it runs the commands
      | BRANCH | COMMAND              |
      | qa     | git fetch --prune    |
      |        | git add -A           |
      |        | git stash            |
      |        | git rebase origin/qa |
      |        | git push             |
      |        | git push --tags      |
      |        | git stash pop        |
    And I am still on the "qa" branch
    And I still have my uncommitted file
    And all branches are now synchronized
    And I have the following commits
      | BRANCH | LOCATION         | MESSAGE       | FILE NAME   |
      | main   | local and remote | main commit   | main_file   |
      | qa     | local and remote | remote commit | remote_file |
      |        |                  | local commit  | local_file  |
