[![CircleCI](https://circleci.com/gh/toreriklinnerud/clean-files/tree/master.svg?style=svg)](https://circleci.com/gh/toreriklinnerud/clean-files/tree/master)

## Synopsis

Executable to delete files fitting certain criteria.

The intended purpose is to delete backups older than a certain date,
whilst keeping hourly, daily or weekly and so on backups.

Specifying an option like --hourly will keep the first file of the hour
and delete the rest of the files created within the same hour,
provided that the those files were created before the threshold date.

The executable does not itself create any backups, it is only
intended for cleaning up existing ones.

## Usage

```
  clean_files file_paths [options]
```

For help use: `clean_files -h`

## Options

```bash
  -v, --verbose     Print name of files deleted
  -p, --pretend     Implies -v, only prints what files would have been deleted
  -r, --recursive   Delete directories as well as files
  -t, --threshold   Time ago in days for when to start deleting files
                    File newer than this date are never deleted.
                    The default is 30 days.

                    For example:

                   -t 10 or --threshold=30

  -H, --hourly      Keep hourly files
  -D, --daily       Keep daily files
  -W, --weekly      Keep weekly files
  -M, --monthly     Keep monthly files
  -Y, --yearly      Keep yearly files
```

## Examples

```bash
  clean_files /backups/sql/*.sql --threshold 60 --daily
  clean_files /Users/me/Downloads/* --pretend --verbose --recursive -t 10
```

## Copyright

Copyright (c) 2009 AlphaSights Ltd. See LICENSE for details.
