Configuration files for
[abusenius/insaned](https://github.com/abusenius/insaned) to enable custom
actions when pressing scanner's buttons.

Part of a project involving NTC's [CHIP
compputer](https://getchip.com/pages/chip) to turn my Canon LiDE 210 into a
standalone, networked scanner in an effort to go paperless.

> Note that the `insaned` executable has been compiled for ARM, it won't run on
> any other platform. If you need to build it for yourself, see the [insaned
> project repo](https://github.com/abusenius/insaned) for instructions.

# Installation

- Depends on `libsane` and `imagemagick`
- Copy or symlink the files in their respective directories (paths relative to
  `/`)
- Tweak the default settings in `etc/default/insaned`
- Register `insaned` as a systemd service: `systemctl daemon-reload &&
  systemctl enable insaned`
- Check it's running: `systemctl status insaned`

# Usage

Once the scanner is detected by `libsane` (`sane-find-scanner; scanimage -L`),
it will execute the script from `/etc/insaned/events/` that matches the button
pressed.

For reference, on the LiDE 210, these are the buttons mappings:

Label on scanner | `insaned` label
--- | ---
PDF | file
PDF ▶︎\| | extra
Autoscan | scan
Copy | copy
Email | email

## Scanning documents

Load the page in the scanner, press the PDF button. When done scanning, place
the next page and press PDF again. After the document's last page is scanned,
press the PDF ▶︎\| button to assemble every page into a single PDF document.

The resulting PDF file will be saved at `/scans/` and named
`YYYYMMDD_HHMMSS.pdf`. Documents are scanned at 300 dpi grayscale.

## Scanning pictures/color documents

Use the Autoscan button. The document will be saved as a 600 dpi TIFF file in
`/scans/` under `YYYYMMDD_HHMMSS.tif`.

## Photocopying documents

Scan the page with the Copy button. It will make a black and white 300 dpi scan
of the page, resample it to fit on a single page, and send it to the printer.

> Note that a printer must be configured for this to work.
> If your printer doesn't have ARM drivers (cough cough, Brother), or doesn't
> offer Linux drivers, try Generic PCL 6/PCL XL.

## Email

Not implemented yet.

# Logs

Kept at `/var/log/insaned.log`, can be overridden in each script.

## Format

Eahch log entry follows the following format:
`<timestamp> | <insaned button name>: <log message>`

# Acknowledgements

- `textcleaner` by Fred Weinhaus, free for non-commercial use only. More
  details and a ton of other useful ImageMagick scripts at
http://www.fmwconcepts.com/imagemagick

# TODO

- A cron job to reap documents older than X days in `/scans/` to avoid clutter
- Another cron job to git pull periodically to update the code
- Export `/scans/` as a NFS share
- Figure out how the email function will be implemented
