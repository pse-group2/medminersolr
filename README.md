medminer
========

Use git clone git@github.com:pse-group2/medminersolr.git to clone this project to your desired directory.

Also, please check out the README.rdoc.

Synchronizing the original repository with your fork
------------

1. Terminal > cd to local project directory on your computer, check with git status that you are in the right directory!
2. Make an alias of the original project `git remote add original https://github.com/pse-group2/medminersolr`
3. Get the files from the original repository to your local repository with `git fetch original`
4. Merge the original with the local repository `git merge original/master` (it will open vim, just hit ESC, then type :wq, the standard message is fine)
5. Push the changes to your own online repository/fork `git push origin master`

Normal GitHub commit workflow
------------

1. make the changes in the code
2. Terminal > cd to local repository if not there yet (you should probably have the most recent version synced before starting to work on it)
3. `git status` to see what's the current status of that repository
4. `git add file` or `git add *` (for all files) to add the changed files to a commit (seen via git status)
5. `git commit -m "commit message"` to commit the added changes and set the message that will appear on GitHub
6. `git push origin master` to upload the changes to the master branch of your online repository/fork on GitHub
7. go to your own online repository/fork and click the green `"review/compare"` button left to the branch dropdown
8. create a `pull request` against the original repository
9. you are taken to the original repository, if the change doesn't need approval of all team members you can merge your pull request on the presented page