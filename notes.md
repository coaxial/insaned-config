# parallel command on scanner:

`parallel --eta --workdir ... -j2 -S 2/user@scanner-helper --trc {.}_clean.pnm textcleaner -g {} {.}_clean.pnm ::: /tmp/scan_20161121_213922.pnm /tmp/scan_20161121_232056.pnm`

`parallel --eta --workdir ... -j2 -S 2/user@scanner-helper --trc {.}_clean.pnm.gz "zcat {} | textcleaner -g - pnm:- | gzip > {.}_clean.pnm.gz" ::: /tmp/scan_20161122_200227.pnm.gz /tmp/scan_20161122_200330.pnm.gz`

- mention distributed mode of operation in README
- investigate compression to offset slow wifi ~not practical, handling~
  ~compressed files makes the whole thing 50% slower :(~ wrong, it was slow
  because vm didn't have anough RAM and was swapping. Runs at 5sec/img now.
- investigate how to bundle textcleaner script into parallel command so it
  doesn't have to be installed on workers
- fallback to local processing if network down
- investigate FIFO queues to not block insaned



```time (\
gzip --keep /tmp/scan_20161123_171943.pnm && \
gzip --keep /tmp/scan_20161123_172010.pnm && \
parallel \
  --eta \
  --workdir ... \
  -j2 \
  -S 2/user@scanner-helper \
  --trc {.}_clean.pnm.gz \
  "zcat {} | textcleaner -g - pnm:- | gzip -c > {.}_clean.pnm.gz" \
  ::: /tmp/scan_20161123_171943.pnm.gz /tmp/scan_20161123_172010.pnm.gz && \
gunzip --keep /tmp/scan_20161123_171943.pnm_clean.pnm.gz && \
gunzip --keep /tmp/scan_20161123_172010.pnm_clean.pnm.gz && \
rm /tmp/scan_20161123_17{1943,2010}.pnm.gz\
)```
40 secs

```time(\
parallel \
  --eta \
  --workdir ... \
  -j2 \
  -S 2/user@scanner-helper \
  --trc {.}_clean.pnm \
  "textcleaner -g {} {.}_clean.pnm" \
  ::: /tmp/scan_20161123_171943.pnm /tmp/scan_20161123_172010.pnm\
)```
