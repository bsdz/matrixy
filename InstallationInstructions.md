# Introduction #

Currently, matrixy is in active development and cannot be "installed" and "used" like a normal compiler. This will change as the compiler matures. These are instructions for getting started testing and developing matrixy.


# With an Installed Parrot #

If you have an installed Parrot, such as a parrot where you've downloaded the source and typed "make install", or a parrot that you've downloaded as some other kind of package, here is what you can do to get matrixy working:

# With a Development Parrot #

If you have a development Parrot, one that you have downloaded with SVN and compiled yourself, here is what you can do to get matrixy working:

From the parrot repository root, build parrot:

```
 perl Configure.pl
 make
```

Now, get matrixy:

```
 cd languages
 make co-matrixy
 cd matrixy
 perl Configure.pl
 make
 make disttest
```