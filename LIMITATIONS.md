# Limitations

## Package Availability

### APT (Debian/Ubuntu)

* Ubuntu 22.04 and 24.04 provide `lm-sensors` and `openipmi` packages for common server architectures including amd64 and arm64.
* Debian 12 provides `lm-sensors` for amd64, arm64, armhf, i386, ppc64el, s390x, and other Debian architectures. OpenIPMI packages are available from the Debian archive.

### DNF/YUM (RHEL family and Fedora)

* Fedora provides `lm_sensors` and `OpenIPMI` packages in current releases.
* RHEL-compatible distributions use `lm_sensors` for lm-sensors and `OpenIPMI` for IPMI tooling.

### Zypper (SUSE)

* SUSE/openSUSE support was not retained because this cookbook did not previously declare SUSE support in `metadata.rb`.

## Architecture Limitations

* This cookbook installs distribution packages and does not build lm-sensors or OpenIPMI from source.
* Hardware sensor discovery depends on real host hardware. The default test suite disables `sensors-detect` and verifies package/config management in containers.

## Source/Compiled Installation

No source install path is implemented.

## Known Issues

* The `sensors-detect` workflow is skipped automatically on EC2 and virtual guests by default.
* The `configure_collectd` integration assumes collectd resources and services are available in the consuming cookbook run list.
