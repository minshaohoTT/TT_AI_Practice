package SRAM;
use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

use Exporter;
use FileHandle;
use Env; # Make environment variables available


use Genesis2::Manager 1.00;
use Genesis2::UniqueModule 1.00;

@ISA = qw(Exporter Genesis2::UniqueModule);
@EXPORT = qw();
@EXPORT_OK = qw();
$VERSION = '1.0';
sub get_SrcSuffix {Genesis2::UniqueModule::private_to_me(); return ".vp";};
sub get_OutfileSuffix {Genesis2::UniqueModule::private_to_me(); return ".v"};
############################### Module Starts Here ###########################


  sub to_verilog{ 
      # START PRE-GENERATED TO_VERILOG PREFIX CODE >>>
      my $self = shift;
      
      print STDERR "$self->{BaseModuleName}->to_verilog: Start user code\n" 
	  if $self->{Debug} & 8;
      # <<< END PRE-GENERATED TO_VERILOG PREFIX CODE
	$self->SUPER::to_verilog('/proj_soc/user_dev/minshaoho/tryrun/ale_smc/fftgen/rtl/SRAM.vp');
# START USER CODE FROM /proj_soc/user_dev/minshaoho/tryrun/ale_smc/fftgen/rtl/SRAM.vp PARSED INTO PACKAGE >>>
# line 1 "/proj_soc/user_dev/minshaoho/tryrun/ale_smc/fftgen/rtl/SRAM.vp"
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '// Copyright 2013, all rights reserved.';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '// See below (end of file) for extended copyright information.';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '//';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
# push (@INC, "./rtl"); # Now this happens in "Makefile.local"
 require fftgen;        # log2()

print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '// ---------------- Begin default Genesis2 parameter summary ----------------';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '//';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
 # parameter() calls send default Genesis output to top of .v file

 my $nwords = parameter
    (Name=>'nwords', Val=>16, Min=>1,
     Doc=>'Number of words in SRAM.');

 my $SRAM_NAME = parameter
    (Name=>'SRAM_NAME', Val=>"SRAM000",
     Doc=>'What is my name e.g. SRAM000, SRAM001...');

 my $SRAM_TYPE = parameter
    (Name=>'SRAM_TYPE', Val=>"1PORT_DBLPUMP",
     List=>["TRUE_1PORT", "TRUE_2PORT", "1PORT_DBLPUMP"],
     Doc=>'What kind of SRAM should the FFT use?');

 my $data_width = parameter
    (Name=>'data_width', Val=>32,
     Doc=>'E.g. 64 (bits) for 32b each complex real+imaginary');

 my $test_mode = parameter
    (Name=>'test_mode', Val=>"TEST0",
     List=>["TEST0", "TEST1", "TEST2", "TEST3", "TEST4", "TEST5"],
     Doc=>'TEST0: int add; TEST1: complex int add; TEST2: complex int mul; TEST3: complex fp mul');

print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '// ---------------- End default Genesis2 parameter summary ----------------';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '////////////////////////////////////////////////////////////////////////';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '// module '; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } mname; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '//';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '// Usage: SRAM(n_words), where';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '//';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '//   nwords is the number of (32-bit) words in the SRAM.';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '   ';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
# if ($nwords < 1) { $nwords = 1; }    # This can happen, never mind why.
 my $nrows = $nwords;                 # Number of rows (words) in the SRAM
 my $rwidth = fftgen::log2($nrows);   # Number of bits required to address all the rows.
 if ($rwidth < 1) { $rwidth = 1; }     # Need at least one bit!!!
 my $rbits = ($rwidth-1).":0";
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
# nwords  nrows rwidth   [rbits:0]  memrange
#   1       1     0        [0:0]     [0:0]
#   2       2     1        [0:0]     [0:1]
#   4       4     2        [1:0]     [0:3]
#  512     512    9        [8:0]    [0:511]
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 

 if ($test_mode eq "TEST0") {
    $data_width = 32;
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '// WARNING test_mode "'; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } $test_mode; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '" is setting data_width to '; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } $data_width; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
 }

 if ($test_mode =~ /^TEST[1-9]$/) {  # TEST1, TEST2, TEST3, TEST4, TEST5, ...
    $data_width = 64;
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '// WARNING test_mode "'; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } $test_mode; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '" is setting data_width to '; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } $data_width; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
 }
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } 'module '; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } mname; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '(clk_i, ez_i, wz_i, addr_i, rd_data_o, wr_data_i);';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '   input  logic clk_i;';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '   input  logic ez_i;             // Active low chip select';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '   input  logic wz_i;             // Active low write control';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '   input  logic ['; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } $rbits; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '] addr_i;     // Address bus';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '   output logic ['; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } $data_width-1; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } ':0] rd_data_o; // Read data OUT.';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '   input  logic ['; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } $data_width-1; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } ':0] wr_data_i; // Write data IN.';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '   reg ['; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } $data_width-1; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } ':0] mem[0:'; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } $nrows-1; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '];  // Memory cells';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '   reg ['; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } $data_width-1; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } ':0] wr_data_i_prev;     // Hack to make true-1port work I guess';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
    # For debugging
    my $real="63:32"; # Real
    my $imag="31: 0"; # Imaginary
    #
    # sub sr{ my $s = shift; return "\$bitstoshortreal(${s})"; }
    # 06/2019 oops cannot use bitstoshortreal any more b/c verilator
    sub sr{ my $s = shift; return "${s}"; }
    sub r { my $s = shift; return sr("${s}[$real]"); }
    sub i { my $s = shift; return sr("${s}[$imag]"); }
    sub ri{ my $s = shift; return r($s).", ".i($s); }
   
    # E.g. $myname="SRAM002"
    my $myname = $SRAM_NAME;
   
 if ($SRAM_TYPE eq "TRUE_1PORT") {
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '   // Only dpump uses clk_i; this may or may not be the best way to address that';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '   wire unused_ok; assign unused_ok = clk_i;';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '   //////////////////////////////////////////////////////////////////////////////';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '   // READ TRUE_1PORT';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '   assign rd_data_o = (~ez_i & wz_i) ? mem[addr_i] : \'x;  // READ TRUE_1PORT';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '   // READ DEBUG';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '   // READ INFO (historical) (also for analyze_reads_and_writes.pl -d9)';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '   always @(ez_i or wz_i or addr_i) if (~ez_i & wz_i) begin';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '      $display("%m %1d: ez_i=%1d and wz_i=%1d", $time, ez_i, wz_i);';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '      $display("%m %1d: Reading rd_data_o mem[%1d] <= %16x", $time, addr_i, rd_data_o);';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '      $display("'; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } $myname; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } ' t5 %5d: Read(f) wr_data_i mem[%1d] <= (bsr\'%08X,bsr\'%08X)", ';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '                       $time, addr_i, '; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } ri("rd_data_o"); print { $Genesis2::UniqueModule::myself->{OutfileHandle} } ');';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '      $display("");';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '   end';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '   //  sync sram see http://www.asic-world.com/examples/verilog/ram_sp_sr_sw.html';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '   // async sram see http://www.asic-world.com/examples/verilog/ram_sp_ar_aw.html';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '   //////////////////////////////////////////////////////////////////////////////';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '   // WRITE TRUE_1PORT';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '   // FIXME use a proper async SRAM (see above)!!! fiddle w/signals outside, in wrapper :(';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '   // Want to trigger writes on negedge wz_i';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '   always @(negedge clk_i) wr_data_i_prev = wr_data_i; // omg';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '   always @(wz_i) begin';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '      if (!ez_i && !wz_i) begin';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '         // WRITE TRUE_1PORT';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '         mem[addr_i] <= wr_data_i_prev;';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '         // WRITE DEBUG';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '         $display("%m %1d: ez_i=%1d and wz_i=%1d", $time, ez_i, wz_i);';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '         $display("%m %1d: Wrote   wr_data_i mem[%1d] <= %16x", $time, addr_i, wr_data_i_prev);';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '         $display("'; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } $myname; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } ' t5 %5d: Wrote(f) wr_data_i mem[%1d] <= (bsr\'%08X,bsr\'%08X)",';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '                       $time, addr_i, '; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } ri("wr_data_i_prev"); print { $Genesis2::UniqueModule::myself->{OutfileHandle} } ');';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '         $display("");';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '      end';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '   end';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '    ';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
 } elsif ($SRAM_TYPE eq "TRUE_2PORT") {                # TRUE_2PORT
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '   // Only dpump uses clk_i; this may or may not be the best way to address that';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '   wire unused_ok; assign unused_ok = clk_i;';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '   // True 2-port SRAM *can* read and write at the same time.';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
   #
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '   assign rd_data_o = (~ez_i) ? mem[addr_i] : \'x;            // READ TRUE_2PORT';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '   always @(ez_i or addr_i) if (~ez_i) begin';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '      // READ INFO (historical) (also for analyze_reads_and_writes.pl -d9)';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '      $display("%m %1d: ez_i=%1d and wz_i=%1d", $time, ez_i, wz_i);';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '      $display("%m %1d: Reading rd_data_o mem[%1d] <= %16x", $time, addr_i, rd_data_o);';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '      $display("'; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } $myname; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } ' t5 %5d: Read(f) wr_data_i mem[%1d] <= (bsr\'%08X,bsr\'%08X)", $time, addr_i, '; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } ri("rd_data_o"); print { $Genesis2::UniqueModule::myself->{OutfileHandle} } ');';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '      $display("");';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '   end';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
   # FIXME is 2port write same as 1port write????
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '   //always @(ez_i or wz_i) //does not work for verilator';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '   always @(negedge wz_i) // will it...? it did!!!';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '      if (~ez_i & ~wz_i) begin                               // WRITE TRUE_2PORT';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '         mem[addr_i] <= wr_data_i;';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '         $display("%m %1d: ez_i=%1d and wz_i=%1d", $time, ez_i, wz_i);';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '         $display("%m %1d: Wrote   wr_data_i mem[%1d] <= %16x", $time, addr_i, wr_data_i);';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '         $display("'; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } $myname; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } ' t5 %5d: Wrote(f) wr_data_i mem[%1d] <= (bsr\'%08X,bsr\'%08X)", $time, addr_i, '; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } ri("wr_data_i"); print { $Genesis2::UniqueModule::myself->{OutfileHandle} } ');';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '         $display("");';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '      end';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '//   // This might keep lint from complaining that clk_i is "unused." NOPE';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '//   always @(posedge clk_i) assert (0==0);';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
 } else { # SRAM_TYPE == 1PORT_DBLPUMP
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '   // READ on negedge';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '   always @(negedge clk_i) begin                             // READ 1PORT_DBLPUMP';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '      $display("'; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } $myname; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } ' FOO %1d: ez_i=%1d and wz_i=%1d", $time, ez_i, wz_i);';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '      if (~ez_i & wz_i) begin';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '         // Double-pump SRAM reads and writes on alternate clock edges.';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
          if ($SRAM_TYPE eq "1PORT_DBLPUMP") {
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '         rd_data_o <= mem[addr_i];                         ';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
          }
         
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '         // READ INFO (historical)';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '         $display("%m %1d: ez_i=%1d and wz_i=%1d", $time, ez_i, wz_i);';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '         $display("%m %1d: Reading rd_data_o mem[%1d] <= %16x", $time, addr_i, rd_data_o);';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '         $display("'; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } $myname; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } ' t5 %5d: Read(f) wr_data_i mem[%1d] <= (bsr\'%08X,bsr\'%08X)", $time, addr_i, '; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } ri("rd_data_o"); print { $Genesis2::UniqueModule::myself->{OutfileHandle} } ');';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '         $display("");';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '      end';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '   end';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '   // WRITE on negedge';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '   always @(posedge clk_i) begin                              // WRITE 1PORT_DBLPUMP';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '      if (~ez_i & ~wz_i) begin';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '         mem[addr_i] <= wr_data_i;';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '         $display("%m %1d: ez_i=%1d and wz_i=%1d", $time, ez_i, wz_i);';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '         $display("%m %1d: Wrote   wr_data_i mem[%1d] <= %16x", $time, addr_i, wr_data_i);';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '         $display("'; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } $myname; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } ' t5 %5d: Wrote(f) wr_data_i mem[%1d] <= (bsr\'%08X,bsr\'%08X)", $time, addr_i, '; print { $Genesis2::UniqueModule::myself->{OutfileHandle} } ri("wr_data_i"); print { $Genesis2::UniqueModule::myself->{OutfileHandle} } ');';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '         $display("");';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '      end';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '   end';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
 } # SRAM_TYPE == DPUMP
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } 'endmodule';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
########################################################################
#// RAM Model
#//
#// +-----------------------------+
#// |    Copyright 1996 DOULOS    |
#// |       Library: Memory       |
#// |   designer : John Aynsley   |
#// +-----------------------------+
#
#module RamChip (Address, Data, CS, WE, OE);
#
#parameter AddressSize = 1;
#parameter WordSize = 1;
#
#input [AddressSize-1:0] Address;
#inout [WordSize-1:0] Data;
#input CS, WE, OE;
#
#reg [WordSize-1:0] Mem [0:1<<AddressSize];
#
#assign Data = (!CS && !OE) ? Mem[Address] : {WordSize{1'bz}};
#
#always @(CS or WE)
#  if (!CS && !WE)
#    Mem[Address] = Data;
#
#always @(WE or OE)
#  if (!WE && !OE)
#    $display("Operational error in RamChip: OE and WE both active");
#
#endmodule // RamChip
#
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '/////////////////////////////////////////////////////////////////////////////////';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '// MIT License';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '// ';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '// Copyright (c) 2013 Stephen E. Richardson and Stanford University';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '// ';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '// Permission is hereby granted, free of charge, to any person obtaining a copy';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '// of this software and associated documentation files (the "Software"), to deal';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '// in the Software without restriction, including without limitation the rights';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '// copies of the Software, and to permit persons to whom the Software is';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '// furnished to do so, subject to the following conditions:';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '// ';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '// The above copyright notice and this permission notice shall be included in all';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '// copies or substantial portions of the Software.';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '// ';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IM-';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '// PLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNEC-';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '// TION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '// ';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '// For more information please contact';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '// Stephen E. Richardson  steveri@stanford.edu (Stanford University)';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '// Prof. Mark Horowitz   horowitz@stanford.edu (Stanford University)';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
print { $Genesis2::UniqueModule::myself->{OutfileHandle} } '/////////////////////////////////////////////////////////////////////////////////';print { $Genesis2::UniqueModule::myself->{OutfileHandle} } "\n"; 
# <<< END USER CODE FROM /proj_soc/user_dev/minshaoho/tryrun/ale_smc/fftgen/rtl/SRAM.vp PARSED INTO PACKAGE


      # START PRE-GENERATED TO_VERILOG SUFFIX CODE >>>
      print STDERR "$self->{BaseModuleName}->to_verilog: Done with user code\n" 
	  if $self->{Debug} & 8;

      #
      # clean up code comes here...
      #
      # <<< END PRE-GENERATED TO_VERILOG SUFFIX CODE
  }
