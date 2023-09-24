IKEA® TRÅDFRI Shortcut Button (E1812)
=====================================

Overview
--------

Battery powered Zigbee push button with "single press", "double press"
and "long press" functionality.

Purpose
-------

Provide unofficial documentation of possible firmware/configuration
modifications.

The `firmware <firmware.rst>`_ can be modified to:

* Disable the "double press" feature, making "single press"
  instantaneous again.

Double press
~~~~~~~~~~~~

The original firmware (2020-11-20 v2.3.015) has an issue with flash
management under low battery conditions that means it becomes unable to
communicate, requiring re-pairing.

The later firmwares (2021-10-27 v2.3.080 and 2023-05-20 v24.4.6) fix
this issue and improve battery performance but they also add a "double
press" feature that wasn't previously present.

To implement "double press" functionality necessarily requires delaying
the "single press" action because on every button press it needs to wait
to determine if the button is going to be pressed again. The result is
that the "single press" is delayed by 400ms and this causes a very
noticeable delay in the action (like turning on lights) that doesn't
need to be there if "double press" isn't used.

To accommodate both modes without this delay requires either being able
to disable "double press" entirely or transmitting an extra message at
the start of the 400ms period (so that the Zigbee co-ordinator can
choose to react to "every press" or just "single press [that isn't a
double press]").

Contents
--------

* `Hardware <hardware.rst>`_
* `Firmware <firmware.rst>`_

Inspired by `basilfx/TRADFRI-Hacking <https://github.com/basilfx/TRADFRI-Hacking>`_.

"IKEA" is a trademark of `Inter IKEA Systems B.V. <https://www.ikea.com/>`_.
