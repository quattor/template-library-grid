template-library-grid
=====================

Template library for configuring EMI grid middleware services

EMI services validated (27/3/2014): ARGUS, BDII, CREAM CE, DPM, LFC, UI, WN (others coming soon)

Starting with this branch, the template layout has been slightly modified to be inline
with other template libraries. In particular the following namespaces (directories) have
been renamed:

- glite -> personality
- common -> feature
- machine-types -> machine-types/grid
- defaults/glite -> defaults/grid

Usually, only the machine-types change should have an impact on site templates.

__Note: this branch requires Quattor 14.2.1 (YUM-based deployment only) and sl5.x or sl6.x OS templates. See http://quattor.org/documentation/2014/03/24/spma-yum-migration.html for
details__
