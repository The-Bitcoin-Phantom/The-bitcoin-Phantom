#!/usr/bin/env bash

export LC_ALL=C
TOPDIR=${TOPDIR:-$(git rev-parse --show-toplevel)}
BUILDDIR=${BUILDDIR:-$TOPDIR}

BINDIR=${BINDIR:-$BUILDDIR/src}
MANDIR=${MANDIR:-$TOPDIR/doc/man}

bitphantomD=${bitphantomD:-$BINDIR/bitphantomd}
bitphantomCLI=${bitphantomCLI:-$BINDIR/bitphantom-cli}
bitphantomTX=${bitphantomTX:-$BINDIR/bitphantom-tx}
WALLET_TOOL=${WALLET_TOOL:-$BINDIR/bitphantom-wallet}
bitphantomQT=${bitphantomQT:-$BINDIR/qt/bitphantom-qt}

[ ! -x $bitphantomD ] && echo "$bitphantomD not found or not executable." && exit 1

# The autodetected version git tag can screw up manpage output a little bit
read -r -a BTCVER <<< "$($bitphantomCLI --version | head -n1 | awk -F'[ -]' '{ print $6, $7 }')"

# Create a footer file with copyright content.
# This gets autodetected fine for bitphantomd if --version-string is not set,
# but has different outcomes for bitphantom-qt and bitphantom-cli.
echo "[COPYRIGHT]" > footer.h2m
$bitphantomD --version | sed -n '1!p' >> footer.h2m

for cmd in $bitphantomD $bitphantomCLI $bitphantomTX $WALLET_TOOL $bitphantomQT; do
  cmdname="${cmd##*/}"
  help2man -N --version-string=${BTCVER[0]} --include=footer.h2m -o ${MANDIR}/${cmdname}.1 ${cmd}
  sed -i "s/\\\-${BTCVER[1]}//g" ${MANDIR}/${cmdname}.1
done

rm -f footer.h2m
