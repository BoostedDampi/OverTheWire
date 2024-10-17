# OverTheWire - Leviathan

## Leviathan 0
As always, the first step is to connect to the server with `ssh leviathan0@leviathan.labs.overthewire.org -p 2223`.

Now let's look around:
<img src="imgs/leviathan0_ls.png" align="left" width="750" >
as we can see there is an interesting directory named .backup, looking inside we find a bookmark.html folder containing 1299 lines of html syntax... but a simple `grep leviathan bookmarks.html` lifts the obscurity and shows us a bookmark with the password contained:
<img src="imgs/leviathan0_grep.png" align="left" width="750" >
## Leviathan 1
After connecting to the server and checking the contents of the home folder we can see a  `check` executable with execution rights:

<img src="imgs/leviathan1_ls.png" align="left" width="750" >

Let's try to execute the program:

<img src="imgs/leviathan1_check.webp" align="left" width="750" >

It seems that the crux of this CTF is to find the password inside the executable, so let's see if `ltrace` gives us some useful information:

>[!note]
>`ltrace executable` executes a program intercepting concurrently all external library calls, like `printf()` or more interestingly `strcmp()`

<img src="imgs/leviathan1_ltrace.webp" align="left" width="750" >

the first three characters of the input strings are being read and compared with _sex_.

> [!note]
This let me on a sidequest to comprehend what the arguments of `getchar()` in the `ltrace` output mean. I think that the first number rapresents `stdin`, the second one is maybe a buffer where the read values are saved but the third and forth arguments are a big question.

Now let's use our newly found password:

<img src=imgs/leviathan1_check2.webp align=left width="750">

And we are in, being logged as leviathan2, gives us access to the pass file for this user:

<img src="imgs/leviathan1_cat.webp" align="left" width="750" >

## Leviathan2

<img src="imgs/Pasted%20image%2020241017172128.webp" align="left" width="750" >

Do you see the `s` instead of the `x` in the permissions for `printfile`? I needed at least 20 minutes to notice that...

>[!note]
The **Real User Id** (UID) represents you, in this case _leviathan2_, the **Effective User Id** (EUID) instead is the one that the Operating Systems uses to check if you are permitted to do something, generally they are the same, but in this case members of the group leviathan2 can execute printfile with the EUID of leviathan3.

Let's create a tmp folder and a file for experimentation, after that we can try to execute `printfile`.

<img src="imgs/Pasted%20image%2020241017172424.webp" align="left" width="750" >

The first part uses `access()` on _belin_, let's read the manual...

> [!note]
> **access**() checks whether the calling process (real user id) can access the file _pathname_.  If _pathname_ is a symbolic link, it is dereferenced.
> The check is done using the **calling process's _real_ UID** and GID, rather than the effective IDs as is done when actually attempting an operation

Oh, this is interesting, even if our effective user ID is that of _leviathan3_, `access()` checks using our real user ID, so we can't access files owned by _leviathan3_ without circumventing this first part.

Here I couldn't go further, I knew what had to be done but not how it had to be done, so after a bit more frustration I got the tip to see what `cat` does with spaces in files.

And that was the solution, `cat` separates spaces into multiple files, this means that `cat belin pizza pasta` would be three different files, but `access("belin pizza pasta")` would see the string as a single file. Let's try it out:

<img src="imgs/Pasted%20image%2020241017182159.webp" align="left" width="750" >

As expected _tunnel belin_ is owned by us so access() return true and cat couldn't read the file `tunnel` as it doesn't exist! Now I only have to create a symlink...

<img src="imgs/Pasted%20image%2020241017182338.webp" align="left" width="750" >




