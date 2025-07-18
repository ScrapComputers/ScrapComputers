SCRAPCOMPUTERS EXTERNAL SOFTWARE NETWORK SYSTEM
============================================================================

ScrapComputers would have a comminucation system for external software. The
name would be "ScrapComputers External Software Network System" or
"ScrapComputers ESNS".

There are 2 ways of comminucating with the game and external software.
- Global Channel
- Software Channel.

They are called channels. The global channel is only used for creating
software channels for example. Software channels lets you control the entire
mod. It is designed like this to prevent collisions with other instances.

Each channel has 2 variables.
- Mod Packets : Packets sended from the mod and read by the software
- Soft Packets: Packets sended from the software and read by the mod

This is also to prevent collisions.

FILE STRUCTURE
============================================================================

PACKET CHEATSHEET
============================================================================

The ESNS has a lot of packet kinds, This is the cheatsheat for all of them.
They are catagorized like this:

GLOBAL CHANNEL:
    SEND:
        NEWCHANNEL (ID: 1): Creates a new channel
            Data: None (Ingored)
    
    RECEIVE:
        CREATEDCHAN (ID: 2): Receiving this means theres a new channel made.
            Data: SHA256 Channel id Identifier (String)

SOFTWARE CHANNEL:
    SEND:
        PING (ID: 3): Ping, used to check if it can comminucate with the receiver.
            Data: None (Ingored)

        GETCOMPS (ID: 6): Gets all computers in the world
            Data: None (Ingored)

    RECEIVE:
        PONG (ID: 4): Pong, used to check if it can comminucate with the receiver.
                      Receiving this means that theres comminucation with the mod.
            Data: None (Ingored)
        
        DISCONNECT (ID: 5): Destroy's the channel.
            Data: Reason why it had to disconnect (String)

        GETCOMPS (ID: 6): Gets all computers
            Data: A array of all computers (containing displayName and identifer)
                  It would look like this

                  [
                      [ComputerInteractableId] = {
                          "identifer": "SHA256",
                          "displayName": "Visual Name"
                      },
                      ...
                  ]