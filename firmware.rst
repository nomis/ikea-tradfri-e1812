Firmware
========

The microcontroller in the push button is an EFR32MG1P132F256 with 256KB
of integrated flash. The CPU is a little-endian 32-bit ARM® Cortex®-M4
that uses the Arm®v7-M Thumb instruction set.

The 16KB bootloader is located at ``0x00000`` and the application is
located at ``0x04000``. The application uses the last 8KB at ``0x3E000``
to store configuration.

There's also 2KB of static configuration in a separate flash area at
``0x0FE00000`` and 10KB of read-only memory at ``0x0FE10000`` that
should not be modified. The MAC address is fixed in the hardware.

After `reading <hardware.rst>`_ the firmware, save a copy of
``flash0.bin`` as ``firmware.bin`` and truncate it to the first 248KB so
that the configuration is not overwritten when writing it back.

To convert the modified firmware to an ELF file (that gdb will accept
for writing to flash) use the following command:

.. code-block:: shell

    arm-none-eabi-objcopy -I binary -O elf32-littlearm -S firmware.bin firmware.elf

Modifications to v24.4.6
~~~~~~~~~~~~~~~~~~~~~~~~

Disable double press
^^^^^^^^^^^^^^^^^^^^

There is a timeout set for multiple button presses. The default timeout
is 400ms but it can be modified for each button. The pairing button on
the back uses the same timing but will not be affected by these changes.

All offsets are from the start of the flash.

Modify the instruction at ``0x1C01C``:

.. code-block:: none

   -1C010  F0 B5 DF F8 F4 37 DF F8  F4 47 18 60 00 20 00 23
   +1C010  F0 B5 DF F8 F4 37 DF F8  F4 47 18 60 01 20 00 23
                                                ↑↑ ↑↑

This is the counter for a loop that writes a specific multiple press
timeout for all of the buttons. By starting at index 1 instead of 0, the
back button will not be modified.

Modify the instruction at ``0x1C7FA``:

.. code-block:: none

   -1C7F0  43 F8 24 50 05 2A F4 DB  40 1C 10 28 F0 DB 31 BD
   +1C7F0  43 F8 24 50 05 2A F4 DB  40 1C 01 28 F0 DB 31 BD
                                          ↑↑ ↑↑

This is the end condition for a loop that sets the multiple press
timeout to 400ms for all of the buttons. By ending after 1 button
instead of 16 buttons, only the back button will be modified.

Modify the instruction at ``0x28A9A``:

.. code-block:: none

   -28A90  01 BD 10 B5 F3 F7 91 FE  0A 22 4F F4 C8 71 4F F4
   +28A90  01 BD 10 B5 F3 F7 91 FE  0A 22 4F F0 00 01 4F F4
                                          ↑↑ ↑↑ ↑↑ ↑↑

This is the parameter to the function that writes a specific multiple
press timeout for all of the buttons (see ``0x1C01C`` above). By passing
0 to this function instead of 400 the timeout will be set to 0 and the
"double press" handling will be skipped.

Modify the data at ``0x2FE94``:

.. code-block:: none

   -2FE90  00 00 00 00 06 32 34 2E  34 2E 36 00 00 00 00 00
   -2FEA0  00 00 00 00 00 FF FF FF  FF FF FF FF FF FF FF FF
                       ↓↓                    ↓↓ ↓↓ ↓↓ ↓↓ ↓↓
   +2FE90  00 00 00 00 0D 32 34 2E  34 2E 36 2D 6E 6F 2D 64
   +2FEA0  62 6C 00 00 00 FF FF FF  FF FF FF FF FF FF FF FF
           ↑↑ ↑↑

This changes the Zigbee "SWBuildID" from ``24.4.6`` to ``24.4.6-no-dbl``
so that the custom firmware can be identified. This field is limited to
16 bytes.
