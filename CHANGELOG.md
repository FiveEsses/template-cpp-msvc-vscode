# CHANGELOG (newest first)

## 2024.03.10 - MAR10 Day!
* Created template
* Known (likely) issues:
    * **ISSUE0001** includes targeting other-than-current folder likely to fail the tooling
    * **ISSUE0002** commandline `rebuild_all.bat` call to `clean_all.ps1` is redundant, since `build_all.ps1` cleans each project before building.
    * **ISSUE0003** I haven't tested this setup on anything non-trivial