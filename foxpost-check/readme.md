# readme of foxpost-check 

- Challenge:
  Usually when I'm sending package with foxpost, not getting updates of each steps like when I'm the receiver.

- Solution:
  I've created this script which you can place under a cronjob and will notify you about changes.
  1, will write into logs with logger
  2, you can create a slack webhook and it will notify about it

- How it works:
  The script will download the website from foxpost for each package number, and will use grep for the necessary information. It will be stored as a state file and will compare it with a later version. If there is a difference, it will notify you.
