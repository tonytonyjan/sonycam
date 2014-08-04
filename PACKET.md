Common Header
=============

Common Header is constructed of the following 8 Bytes.

- Start byte : 1 [B]
  - 0xFF, fixed
- Payload type : 1 [B]
  - indicates type of the Payload
  - 0x01 = For liveview images
- Sequence number : 2 [B]
  - Frame No, 2 bytes integer and increments every frame
  - This frame no will be repeated.
- Time stamp : 4 [B]
  - 4 bytes integer, the unit will be indicated by Payload type
  - In case Payload type = 0x01, the unit of the Time stamp of the Common Header is milliseconds. The start time may not start from zero and depends on the server.

Payload Header
==============

In case Payload type = 0x01, the header format will be as following 128 Bytes.

- Start code : 4[B]
  - fixed (0x24, 0x35, 0x68, 0x79)
  - This can be used for detection of the payload header.
- JPEG data size : 3[B]
  - Size of JPEG in Payload data, Bytes.
- Padding size : 1[B]
  - Padding size of the Payload data after the JPEG data, Bytes.
- Reserved : 4[B]
- Flag : 1[B]
  - 0x00, fixed.
- Reserved : 115[B]

Payload Data
============

In case Payload type = 0x01
- JPEG data(1 data)
  - This size is indicated as "JPEG data size" in Payload Header.
- Padding data
  - This size is indicated as "Padding size" in Payload Header (No padding if 0 bytes was indicated).