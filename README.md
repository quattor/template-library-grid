template-library-grid
=====================

Template library for configuring EMI grid middleware services.

UMD services validated (04/05/2016): WN

Starting with this branch, the template layout has been slightly modified to be inline
with other template libraries. In particular the following namespaces (directories) have
been renamed:

- glite -> personality
- common -> feature
- machine-types -> machine-types/grid
- defaults/glite -> defaults/grid

Usually, only the machine-types change should have an impact on site templates.

__Note: this branch requires Quattor 14.2.1 or later (YUM-based deployment only) and sl6.x or el7.x OS templates. See http://quattor.org/documentation/2014/03/24/spma-yum-migration.html for
details__
