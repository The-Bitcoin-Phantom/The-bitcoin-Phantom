P2P and network changes
-----------------------

#### Removal of reject network messages from bitphantom Core (BIP61)

The command line option to enable BIP61 (`-enablebip61`) has been removed.

This feature has been disabled by default since bitphantom Core version 0.18.0.
Nodes on the network can not generally be trusted to send valid ("reject")
messages, so this should only ever be used when connected to a trusted node.
Please use the recommended alternatives if you rely on this deprecated feature:

* Testing or debugging of implementations of the bitphantom P2P network protocol
  should be done by inspecting the log messages that are produced by a recent
  version of bitphantom Core. bitphantom Core logs debug messages
  (`-debug=<category>`) to a stream (`-printtoconsole`) or to a file
  (`-debuglogfile=<debug.log>`).

* Testing the validity of a block can be achieved by specific RPCs:
  - `submitblock`
  - `getblocktemplate` with `'mode'` set to `'proposal'` for blocks with
    potentially invalid POW

* Testing the validity of a transaction can be achieved by specific RPCs:
  - `sendrawtransaction`
  - `testmempoolaccept`

* Wallets should not use the absence of "reject" messages to indicate a
  transaction has propagated the network, nor should wallets use "reject"
  messages to set transaction fees. Wallets should rather use fee estimation
  to determine transaction fees and set replace-by-fee if desired. Thus, they
  could wait until the transaction has confirmed (taking into account the fee
  target they set (compare the RPC `estimatesmartfee`)) or listen for the
  transaction announcement by other network peers to check for propagation.
