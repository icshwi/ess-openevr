# ESS openEVR

ESS openEVR is a subset implementation of the MRF's Event Receiver. The project
is based in the mrf-openEVR firmware, released by MRF in GitHub.

The respository has been structured as an IP core which can be added from a
top project using VIVADO. The current development targets the picoZED carrier
board made by the Tallinn University of Technology as in-kind contribution to
the ESS.

**Still under heavy development.**

If you'd like to request a feature, contact any of the maintainers working for
the ESS.

## Documentation

The code is partitally commented using Doxygen syntax. In order to compile the
documentation, Doxygen must be installed in the system, Make is also needed.

To generate the docs, type:

    $ make

The script will try to open the generated files using Firefox.

## Maintainers

- Ross Elliot (ross.elliot@ess.eu)
- Felipe Torres González (felipe.torresgonzalez@ess.eu)

## Credits

This development is based on the [open EVR by MRF](https://github.com/jpietari/mrf-openevr)
