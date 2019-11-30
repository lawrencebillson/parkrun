Parkrun Scripts
===============

These are modified versions of the existing data processing scripts to be run standalone.

Running
-------

* `barcodes` will look for a scanner and drop a file
* `timer` will look for a stopwatch and drop a file

Both scripts will drop a file in:

```
$HOME/parkrun/data/$DATE
```

This can be overridden by setting environment variable: `$PARKRUN_DATA`
