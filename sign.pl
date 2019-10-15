#!/usr/bin/perl

open(SIG, $ARGV[0]) || die "open $ARGV[0]: $!";

$n = sysread(SIG, $buf, 1000);

if($n > 510){ # 最后两个字节要留给boot sector做标记
  print STDERR "boot block too large: $n bytes (max 510)\n";
  exit 1;
}

print STDERR "boot block is $n bytes (max 510)\n";

$buf .= "\0" x (510-$n); # 如果不够510字节，用0补全
$buf .= "\x55\xAA"; # 最后两个字节是0x55和0xAA，bios通过这个标志来判断，该sector是boot sector

open(SIG, ">$ARGV[0]") || die "open >$ARGV[0]: $!";
print SIG $buf;
close SIG;
