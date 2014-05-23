REMIX
=====

Eclipse-based tooling for creating presentations from re-usable modules.
This solves the usual problem of clone-and-own of slide sets, which leads
to inconsistencies, redundancies and a lot of wasted time.

After organizing your presentation library based on REMIX's features,
you will be able to create a new presentation in the order of minutes
(not in the order of hours and days as before).


## Installation

You can install remix using an [Eclipse Update site](https://drive.google.com/folderview?id=0B7JseVbR6jvhOXFnRXYyM0k3Qmc&usp=sharing)
which is available on Google Drive. Just download the archive, start from an
existing or fresh Eclipse installation and install remix via
<em>Help > Install new software... > Add... > Archive...</em>.
If an additional product needed by remix is missing in your Eclipse installation,
Eclipse will either install it automatically or point you towards the missing products.

The installable product (update site) is also built by travis-ci.
However, currently this product build is not publicly available. 
Build status: [![Build Status](https://travis-ci.org/kbirken/remix.png?branch=master)](https://travis-ci.org/kbirken/remix).

If you want to, the project can be built with maven.
You then need an Eclipse development environment and the sources of remix
(cloned from this github repository).
Then just use the parent pom.xml in folder releng/org.nanosite.remix.parent
and start a maven build from there. After a successful build, the ready-to-use
product for your OS platform will be available in releng/org.nanosite.remix.product.


## General idea

REMIX combines re-usable presentation parts (i.e., sets of slides, aka modules)
to build complete presentations. It can be used for creating any type of presentation
(even any kind of textual document), but it works best with [reveal.js](http://lab.hakim.se/reveal-js/).

REMIX handles two kinds of files:
- the actual presentation content (e.g., html-files for reveal.js)
- REMIX-files (suffix rmx) for controlling the content and providing metadata

REMIX comes with a nice editor for working with REMIX-files (*.rmx).
The REMIX language is described below.


## REMIX language

The most important concepts of the REMIX language are
<code>module</code>, <code>collection</code> and <code>presentation</code>.

### Modules in REMIX

A <code>module</code> is the content atom in REMIX. It represents
one file with presentation content (typically a html-file). A module
has a name and specifies the file name of the content file it represents.


### Collections in REMIX

A <code>collection</code> is a set of REMIX modules. It has a name and
(optionally) a path specification for the folder where the modules are located.
If the path specification is omitted, the modules are located in the same
folder as the rmx-file which contains the <code>collection</code> section.

A <code>collection</code> can also be regarded as a common namespace for 
modules. All collections available in the Eclipse workspace constitute
the library of available presentation modules. Some collections may be shared
among groups of users (e.g., using a git infrastructure), other may be private.


### Presentations in REMIX

A <code>presentation</code> represents an ordered combination of modules
(stored in collections) together with some additional information.
From a <code>presentation</code>, the REMIX generator will create the actual
presentation in a target folder (see below).

REMIX offers a variety of features which are controlled using the 
<code>presentation</code> section:
- structure your presentation with <code>part</code> sections
  (parts may get a title and an optional image)
- create a summary with the <code>overview</code> keyword
- change the look-and-feel of the presentation with the <code>theme</code> keyword
- and some more (to be documented)

Hint: If your <code>presentation</code> is stored in one Eclipse project
and it refers to a <code>collection</code> in another Eclipse project,
don't forget to set a 'Project Reference' from the former to the latter in 
the project's properties.


## REMIX generator

The REMIX generator is triggered when saving an rmx-file which contains
a <code>presentation</code> section. The target folder for the 
generated presentation will be determined from the <code>=></code> attribute
at the end of the <code>presentation</code> section. This might be a relative path
(which is resolved relatively to the rmx-file's location) or an absolute path.
At this target path, a further subfolder will be created which will be named
like the presentation name.

The generator will collect the content files of
all the presentation's modules into one resulting <code>index.html</code>.
Additionally, it will collect the contents of the <code>resources</code>
folder of each module into a common <code>resources</code> folder which is
located beneath the <code>index.html</code> file. This mechanism can be used
to handle images, additional javascript files, and many more.


## Using REMIX with [reveal.js](http://lab.hakim.se/reveal-js/)

The example project <code>org.nanosite.remix.revealjs</code> shows how
REMIX can be used to build [reveal.js](http://lab.hakim.se/reveal-js/)
presentations.
See the two examples in the <code>models</code> folder.
Triggered by a save-action, a folder <code>presentation-gen</code>
will be created in the root of the project which contains the presentation.
In order to show the result as a reveal-HTML5-presentation, copy the
content of a typical reveal.js-presentation into the same folder
(without overwriting <code>index.html</code>) and open
the <code>index.html</code> (generated by REMIX) in your browser
([reveal.js](http://lab.hakim.se/reveal-js/) works best with Google Chrome).

