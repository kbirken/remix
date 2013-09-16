REMIX
=====

Eclipse-based tooling for creating presentations from re-usable modules.

## Installation

Currently, no update site is available for REMIX.
Thus, users have to install a proper Eclipse version
(e.g., Eclipse Kepler for DSL developers) first.
After that, clone this repository and build the projects
in your Eclipse environment.

Unfortunately, there is no ANT or Maven build available, too.
You have to run the mwe2 file in org.nanosite.remix to generate
the infrastructure for the REMIX DSL.


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

TBD

