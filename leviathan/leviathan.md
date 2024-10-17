# OverTheWire - Leviathan

## Leviathan 0
As always, the first step is to connect to the server with `ssh leviathan0@leviathan.labs.overthewire.org -p 2223`.
Now let's look around:
[Execute ls command](imgs/leviathan0_ls.png)
as we can see there is an interesting directory named .backup, looking inside we find a bookmark.html folder containing 1299 lines of html syntax... but a simple `grep leviathan bookmarks.html` lifts the obscurity and shows us a bookmark with the password contained:
[Execute grep command](imgs/leviathan0_grep.png)
