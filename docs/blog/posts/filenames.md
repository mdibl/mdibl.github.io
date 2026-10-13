---
date: 2022-06-23
authors: [joel]
tags:
  - best practices
  - tips
categories:
  - Tips
---

# Spaces, commas, and other things that go bump in filenames (at the command-line)

Today’s tip for those of you who are trying to learn to work from the command-line (or who might ever send a file to me).

When it comes to filenames, spaces, commas, and pretty much anything that isn’t either a letter (a-z, A-Z), number (0-9), dash (-), underscore (_), or period (.) are ***EVIL and SHOULD BE AVOIDED.***

<!-- more -->

## tl;dr (i.e., here’s the explanation)

Command-lines are generally interpreted by breaking the line as entered (when you hit return or enter) by white space, which, while it can include some punctuation marks, is generally present in the form of spaces or tabs. As such, when a filename includes spaces, it will not be properly recognized without “special attention”

So, for example, if you have files with names “my_file_1.txt” and “my file 2.txt” and you want to show their entire contents, you can use the “cat” function, for example

```
cat my_file_1.txt
```

This will successfully print out all of my_file_1.txt to the screen. It would also work for any other action. (e.g.

```
cp my_file_1.txt my_file_1_copy.txt 
```

which would duplicate "my_file_1.txt" into the second file "my_file_1_copy.txt").

In contrast, if you try that with the second file, you would see the following

```
cat my file 2.txt
cat: my: No such file or directory 
cat: file: No such file or directory 
cat: 2.txt: No such file or directory
```

This can be worked around, for example, by typing either

```
cat my\ file\ 2.txt
```

or

```
cat "my file 2.txt"
```

But, honestly, do you need that kind of extra work (and frustration) in your life?

With regard to other punctuation, such as [ or { or # or : and so on, the result is likely to be uncertain- it might work in some cases, but not others. It’s not really worth the guessing in my opinion

So as a general rule, when naming files, if you stick to alphanumerics, underscores, dashes, and periods, you’ll rarely go wrong.
