// cpld_gmx: EPM7064S design of the GMX CPLD, one sum of products per macrocell, from the firmware built from this repository (gmx.rom, gmx_cpld.pof).
// 40 macrocells; lcN = macrocell N output (register Q or combinational value).
`timescale 1ns/1ps
module cpld_gmx (
  input RST_DLY,
  input MG,
  output NCONF_o,
  output NCONF_oe,
  output EO_o,
  output EO_oe,
  output DIR_o,
  output DIR_oe,
  input A0,
  input A1,
  input A5,
  input A8,
  input A9,
  input A10,
  input A11,
  input A12,
  output A13_o,
  output A13_oe,
  input A13_i,
  input A14,
  input A15,
  output CS27_o,
  output CS27_oe,
  output CS1_o,
  output CS1_oe,
  output RA16_o,
  output RA16_oe,
  output RA17_o,
  output RA17_oe,
  output RA18_o,
  output RA18_oe,
  output WEFL_o,
  output WEFL_oe,
  output EVPP_o,
  output EVPP_oe,
  input MREQ_n,
  input RD_n,
  input D6,
  input D5,
  input D4,
  input D3,
  input D2,
  input D1,
  input D0,
  input IORQ_n,
  input M1,
  input WR_n,
  input CONFD
);
  wire A13 = A13_i;
  wire lc1;
  wire lc2;
  wire lc3;
  wire lc4;
  wire lc5;
  wire lc6;
  wire lc7;
  wire lc8;
  wire lc9;
  wire lc11 = (1'b0 ^ (CONFD & WR_n));  // LC11 comb
  wire lc13;
  wire lc14 = (((!M1 & CONFD) | (!A10 & !RD_n & !lc39 & M1 & !IORQ_n & !A9 & A14 & A5 & !A8 & lc48 & !A1 & !lc13 & A0 & !A15) | (IORQ_n & CONFD)) ^ 1'b0);  // LC14 comb
  wire lc16;
  wire lc17 = (((lc49 & !CONFD) | (CONFD & !lc59 & lc58 & !lc26 & !lc64) | (CONFD & !lc59 & !lc58 & lc64) | (CONFD & !lc59 & lc26)) ^ 1'b0);  // LC17 comb
  wire lc18;
  wire lc19 = (((CONFD & lc59) | (lc38 & lc49 & !CONFD & lc42) | (CONFD & lc58 & !lc26) | (lc38 & !CONFD & !lc42)) ^ 1'b0);  // LC19 comb
  wire lc24 = (((lc42) | (!lc38 & !lc49)) ^ 1'b0);  // LC24 comb
  wire lc25;
  wire lc26;
  wire lc33;
  wire lc34;
  wire lc35;
  wire lc36;
  wire lc37 = (((!MREQ_n & !A14 & lc47 & !WR_n & !A15)) ^ 1'b1);  // LC37 comb
  wire lc38;
  wire lc39;
  wire lc40;
  wire lc41;
  wire lc42;
  wire lc43;
  wire lc47;
  wire lc48;
  wire lc49;
  wire lc50;
  wire lc53;
  wire lc57;
  wire lc58;
  wire lc59;
  wire lc61;
  wire lc64;
  gmx_dff r_lc1 (.d((1'b0 ^ 1'b0)), .clk((!(!A10 & !RD_n & !lc39 & M1 & !IORQ_n & !A9 & A14 & A5 & !A8 & !A1 & !lc13 & A0 & !A15))), .clrn(!((!RST_DLY & !lc7 & !lc43))), .prn(!(!RST_DLY & lc7 & !lc43)), .grst_n(1'b1), .q(lc1));  // LC1 cfg 1111110100001
  gmx_dff r_lc2 (.d((1'b0 ^ (lc34))), .clk((!(!A10 & !RD_n & !lc39 & M1 & !IORQ_n & !A9 & A14 & A5 & !A8 & !A1 & !lc13 & A0 & !A15))), .clrn(!((!RST_DLY & !lc43))), .prn(!1'b0), .grst_n(1'b1), .q(lc2));  // LC2 cfg 1111110100001
  gmx_dff r_lc3 (.d((1'b0 ^ (lc2))), .clk((!(!A10 & !RD_n & !lc39 & M1 & !IORQ_n & !A9 & A14 & A5 & !A8 & !A1 & !lc13 & A0 & !A15))), .clrn(!((!lc8 & !RST_DLY & !lc43))), .prn(!(lc8 & !RST_DLY & !lc43)), .grst_n(1'b1), .q(lc3));  // LC3 cfg 1111110100001
  gmx_dff r_lc4 (.d((1'b0 ^ (lc5))), .clk((!(!A10 & !RD_n & !lc39 & M1 & !IORQ_n & !A9 & A14 & A5 & !A8 & !A1 & !lc13 & A0 & !A15))), .clrn(!((!lc38 & !RST_DLY & !lc43))), .prn(!(lc38 & !RST_DLY & !lc43)), .grst_n(1'b1), .q(lc4));  // LC4 cfg 1111110100001
  gmx_dff r_lc5 (.d((1'b0 ^ (lc3))), .clk((!(!A10 & !RD_n & !lc39 & M1 & !IORQ_n & !A9 & A14 & A5 & !A8 & !A1 & !lc13 & A0 & !A15))), .clrn(!((!lc49 & !RST_DLY & !lc43))), .prn(!(lc49 & !RST_DLY & !lc43)), .grst_n(1'b1), .q(lc5));  // LC5 cfg 1111110100001
  gmx_tff r_lc6 (.t((((!D6 & M1 & !IORQ_n & lc6 & !A5 & !A1 & !A0) | (D6 & M1 & !IORQ_n & !lc6 & !A5 & !A1 & !A0)) ^ 1'b0)), .clk((WR_n)), .clrn(1'b1), .prn(!1'b0), .q(lc6));  // LC6 cfg 1001110010001
  gmx_tff r_lc7 (.t((1'b0 ^ 1'b0)), .clk(1'b0), .clrn(!(1'b0)), .prn(!(!A10 & !RD_n & !lc39 & M1 & !IORQ_n & A9 & A14 & A5 & !A8 & !A1 & !lc13 & A0 & !A15)), .q(lc7));  // LC7 cfg 1011110010001
  gmx_tff r_lc8 (.t((((M1 & lc8 & !IORQ_n & !D3 & !A5 & !A1 & !A0) | (M1 & !lc8 & !IORQ_n & D3 & !A5 & !A1 & !A0)) ^ 1'b0)), .clk((WR_n)), .clrn(!((!A10 & !RD_n & !lc39 & M1 & !IORQ_n & A9 & A14 & A5 & !A8 & !A1 & !lc13 & A0 & !A15))), .prn(1'b1), .q(lc8));  // LC8 cfg 1011010010001
  gmx_dff r_lc9 (.d((1'b0 ^ (lc1))), .clk((!(!A10 & !RD_n & !lc39 & M1 & !IORQ_n & !A9 & A14 & A5 & !A8 & !A1 & !lc13 & A0 & !A15))), .clrn(!((!RST_DLY & !lc6 & !lc43))), .prn(!(!RST_DLY & lc6 & !lc43)), .grst_n(1'b1), .q(lc9));  // LC9 cfg 1111110100001
  assign DIR_o = lc11;  // pin 6
  assign DIR_oe = 1'b1;
  gmx_tff r_lc13 (.t((((!D6 & M1 & !IORQ_n & !A5 & !A1 & lc13 & !A0) | (D6 & M1 & !IORQ_n & !A5 & !A1 & !lc13 & !A0)) ^ 1'b0)), .clk((WR_n)), .clrn(!((!RST_DLY & !lc43))), .prn(1'b1), .q(lc13));  // LC13 cfg 1011010010001
  assign EO_o = lc14;  // pin 5
  assign EO_oe = 1'b1;
  gmx_tff r_lc16 (.t((((M1 & !IORQ_n & !D3 & !A5 & !A1 & !A0 & !lc16) | (M1 & !IORQ_n & D3 & !A5 & !A1 & !A0 & lc16)) ^ 1'b0)), .clk((WR_n)), .clrn(1'b1), .prn(!(!RST_DLY)), .q(lc16));  // LC16 cfg 1001110010001
  assign NCONF_o = lc16;  // pin 4
  assign NCONF_oe = 1'b1;
  assign CS1_o = lc17;  // pin 21
  assign CS1_oe = 1'b1;
  gmx_tff r_lc18 (.t((((!(M1 & !lc18 & !IORQ_n & A14 & A8 & A5 & D5 & !A1 & !A15 & A0) & !(M1 & lc18 & !IORQ_n & lc57 & A5 & !D5 & !A1 & lc13 & !A15 & A0) & !(lc39 & M1 & !lc18 & !IORQ_n & A14 & A5 & D5 & !A1 & !A15 & A0) & !(M1 & lc18 & !IORQ_n & A14 & lc57 & A8 & A5 & !D5 & !A1 & !A15 & A0) & !(lc39 & M1 & lc18 & !IORQ_n & A14 & lc57 & A5 & !D5 & !A1 & !A15 & A0) & !(M1 & !lc18 & !IORQ_n & A5 & D5 & !A1 & lc13 & !A15 & A0))) ^ 1'b1)), .clk((WR_n)), .clrn(!((!RST_DLY))), .prn(!1'b0), .q(lc18));  // LC18 cfg 1011110011001
  assign CS27_o = lc19;  // pin 20
  assign CS27_oe = 1'b1;
  assign A13_o = lc24;  // pin 17
  assign A13_oe = !CONFD;
  gmx_dff r_lc25 (.d((1'b0 ^ 1'b0)), .clk((!lc53)), .clrn(!(1'b0)), .prn(!(!(RST_DLY & !A5) & !(!M1 & RST_DLY) & !(RST_DLY & !A1) & !(RST_DLY & !A0) & !(RST_DLY & lc64) & !(IORQ_n & RST_DLY))), .grst_n(1'b1), .q(lc25));  // LC25 cfg 1111110100001
  gmx_tff r_lc26 (.t((((M1 & !IORQ_n & !A14 & A8 & A5 & !D1 & !A1 & !lc13 & lc26 & !A15 & A0) | (M1 & !IORQ_n & !A14 & A8 & A5 & D1 & !A1 & !lc13 & !lc26 & !A15 & A0)) ^ 1'b0)), .clk((WR_n)), .clrn(!((!RST_DLY))), .prn(1'b1), .q(lc26));  // LC26 cfg 1011010010001
  gmx_tff r_lc33 (.t((((!lc39 & A10 & M1 & lc33 & !IORQ_n & A9 & A14 & A5 & !A8 & !D4 & !A1 & !lc13 & !lc43 & A0 & !A15) | (!lc39 & A10 & M1 & !lc33 & !IORQ_n & A9 & A14 & A5 & !A8 & D4 & !A1 & !lc13 & !lc43 & A0 & !A15)) ^ 1'b0)), .clk((WR_n)), .clrn(!((!RST_DLY & !lc43))), .prn(1'b1), .q(lc33));  // LC33 cfg 1011010010001
  assign RA16_o = lc33;  // pin 24
  assign RA16_oe = 1'b1;
  gmx_dff r_lc34 (.d((1'b0 ^ (lc9))), .clk((!(!lc39 & !RD_n & !A10 & M1 & !IORQ_n & !A9 & A14 & A5 & !A8 & !A1 & !lc13 & A0 & !A15))), .clrn(!((!RST_DLY & !lc43 & !lc41))), .prn(!(!RST_DLY & !lc43 & lc41)), .grst_n(1'b1), .q(lc34));  // LC34 cfg 1111110100001
  gmx_tff r_lc35 (.t((((!lc39 & A10 & M1 & !IORQ_n & lc35 & A9 & A14 & A5 & !A8 & !D5 & !A1 & !lc13 & !lc43 & A0 & !A15) | (!lc39 & A10 & M1 & !IORQ_n & !lc35 & A9 & A14 & A5 & !A8 & D5 & !A1 & !lc13 & !lc43 & A0 & !A15)) ^ 1'b0)), .clk((WR_n)), .clrn(!((!RST_DLY & !lc43))), .prn(1'b1), .q(lc35));  // LC35 cfg 1011010010001
  assign RA17_o = lc35;  // pin 25
  assign RA17_oe = 1'b1;
  gmx_tff r_lc36 (.t((((!D6 & !lc39 & A10 & M1 & !IORQ_n & lc36 & A9 & A14 & A5 & !A8 & !A1 & !lc13 & !lc43 & A0 & !A15) | (D6 & !lc39 & A10 & M1 & !IORQ_n & !lc36 & A9 & A14 & A5 & !A8 & !A1 & !lc13 & !lc43 & A0 & !A15)) ^ 1'b0)), .clk((WR_n)), .clrn(!((!RST_DLY & !lc43))), .prn(1'b1), .q(lc36));  // LC36 cfg 1011010010001
  assign RA18_o = lc36;  // pin 26
  assign RA18_oe = 1'b1;
  assign WEFL_o = lc37;  // pin 27
  assign WEFL_oe = 1'b1;
  gmx_tff r_lc38 (.t((((lc38 & M1 & !IORQ_n & !A5 & !D1 & !A1 & !A0) | (!lc38 & M1 & !IORQ_n & !A5 & D1 & !A1 & !A0)) ^ 1'b0)), .clk((WR_n)), .clrn(1'b1), .prn(!1'b0), .q(lc38));  // LC38 cfg 1001110010001
  gmx_tff r_lc39 (.t((((lc39 & M1 & !IORQ_n & !A5 & !D5 & !A1 & !A0) | (!lc39 & M1 & !IORQ_n & !A5 & D5 & !A1 & !A0)) ^ 1'b0)), .clk((WR_n)), .clrn(!((!RST_DLY & !lc43))), .prn(1'b1), .q(lc39));  // LC39 cfg 1011010010001
  gmx_tff r_lc40 (.t((((lc40 & !lc39 & A10 & M1 & !IORQ_n & A9 & A14 & A5 & !A8 & !D1 & !A1 & !lc13 & A0 & !A15) | (!lc40 & !lc39 & A10 & M1 & !IORQ_n & A9 & A14 & A5 & !A8 & D1 & !A1 & !lc13 & A0 & !A15)) ^ 1'b0)), .clk((WR_n)), .clrn(!((!RST_DLY))), .prn(1'b1), .q(lc40));  // LC40 cfg 1011010010001
  assign EVPP_o = lc40;  // pin 28
  assign EVPP_oe = 1'b1;
  gmx_tff r_lc41 (.t((((M1 & !IORQ_n & !A5 & !D5 & !A1 & !A0 & lc41) | (M1 & !IORQ_n & !A5 & D5 & !A1 & !A0 & !lc41)) ^ 1'b0)), .clk((WR_n)), .clrn(1'b1), .prn(!1'b0), .q(lc41));  // LC41 cfg 1001110010001
  gmx_tff r_lc42 (.t((((!D0 & M1 & !IORQ_n & !A5 & !A1 & !A0 & lc42) | (D0 & M1 & !IORQ_n & !A5 & !A1 & !A0 & !lc42)) ^ 1'b0)), .clk((WR_n)), .clrn(1'b1), .prn(!1'b0), .q(lc42));  // LC42 cfg 1001110010001
  gmx_tff r_lc43 (.t((((M1 & !IORQ_n & !A5 & !D4 & !A1 & lc43 & !A0) | (M1 & !IORQ_n & !A5 & D4 & !A1 & !lc43 & !A0)) ^ 1'b0)), .clk((WR_n)), .clrn(1'b1), .prn(!1'b0), .q(lc43));  // LC43 cfg 1001110010001
  gmx_tff r_lc47 (.t((((!lc39 & !D0 & A10 & M1 & !IORQ_n & A9 & A14 & lc47 & A5 & !A8 & !A1 & !lc13 & A0 & !A15) | (!lc39 & D0 & A10 & M1 & !IORQ_n & A9 & A14 & !lc47 & A5 & !A8 & !A1 & !lc13 & A0 & !A15)) ^ 1'b0)), .clk((WR_n)), .clrn(!((!RST_DLY))), .prn(1'b1), .q(lc47));  // LC47 cfg 1011010010001
  gmx_dff r_lc48 (.d((1'b0 ^ (lc4))), .clk((!(!lc39 & !RD_n & !A10 & M1 & !IORQ_n & !A9 & A14 & A5 & !A8 & !A1 & !lc13 & A0 & !A15))), .clrn(!((!RST_DLY & !lc43 & !lc42))), .prn(!(!RST_DLY & !lc43 & lc42)), .grst_n(1'b1), .q(lc48));  // LC48 cfg 1111110100001
  gmx_tff r_lc49 (.t((((lc49 & M1 & !IORQ_n & !A5 & !A1 & !A0 & !D2) | (!lc49 & M1 & !IORQ_n & !A5 & !A1 & !A0 & D2)) ^ 1'b0)), .clk((WR_n)), .clrn(1'b1), .prn(!1'b0), .q(lc49));  // LC49 cfg 1001110010001
  gmx_dff r_lc50 (.d((((A11 & A10 & !M1 & A12 & !A14 & !A9 & lc58 & A8 & A13 & !lc61 & !A15) | (!RD_n & A11 & A10 & !M1 & A12 & !MREQ_n & !A14 & !A9 & lc58 & A8 & A13 & !lc25 & !A15)) ^ 1'b1)), .clk((!MREQ_n)), .clrn(1'b1), .prn(!1'b0), .grst_n(1'b1), .q(lc50));  // LC50 cfg 1001110001001
  gmx_dff r_lc53 (.d((((MG & !lc57) | (lc53 & lc57)) ^ 1'b0)), .clk((!RD_n & !M1 & !MREQ_n & !(!A14 & !lc61 & !A15) & !(!A14 & !lc25 & !A15))), .clrn(1'b1), .prn(!(!RD_n & !MREQ_n & !A14 & !A15 & !(lc25 & lc61))), .grst_n(1'b1), .q(lc53));  // LC53 cfg 1001110000001
  gmx_tff r_lc57 (.t((((!lc39 & A10 & M1 & !IORQ_n & A14 & A9 & lc57 & !A8 & A5 & !A1 & !lc13 & A0 & !D2 & !A15) | (!lc39 & A10 & M1 & !IORQ_n & A14 & A9 & !lc57 & !A8 & A5 & !A1 & !lc13 & A0 & D2 & !A15)) ^ 1'b0)), .clk((WR_n)), .clrn(!((!RST_DLY))), .prn(1'b1), .q(lc57));  // LC57 cfg 1011010010001
  gmx_tff r_lc58 (.t((((!(M1 & !IORQ_n & A14 & lc57 & !lc58 & D4 & A8 & A5 & !A1 & A0 & !A15) & !(M1 & !lc18 & !IORQ_n & A14 & !lc58 & D4 & A8 & A5 & !A1 & A0 & !A15) & !(M1 & !IORQ_n & lc57 & !lc58 & D4 & A5 & !A1 & lc13 & A0 & !A15) & !(M1 & !IORQ_n & lc57 & lc58 & !D4 & A5 & !A1 & lc13 & A0 & !A15) & !(lc39 & M1 & !IORQ_n & A14 & lc57 & !lc58 & D4 & A5 & !A1 & A0 & !A15) & !(M1 & !lc18 & !IORQ_n & !lc58 & D4 & A5 & !A1 & lc13 & A0 & !A15) & !(lc39 & M1 & !IORQ_n & A14 & lc57 & lc58 & !D4 & A5 & !A1 & A0 & !A15) & !(lc39 & M1 & !lc18 & !IORQ_n & A14 & !lc58 & D4 & A5 & !A1 & A0 & !A15) & !(lc39 & M1 & !lc18 & !IORQ_n & A14 & lc58 & !D4 & A5 & !A1 & A0 & !A15) & !(M1 & !lc18 & !IORQ_n & A14 & lc58 & !D4 & A8 & A5 & !A1 & A0 & !A15) & !(M1 & !lc18 & !IORQ_n & lc58 & !D4 & A5 & !A1 & lc13 & A0 & !A15) & !(M1 & !IORQ_n & A14 & lc57 & lc58 & !D4 & A8 & A5 & !A1 & A0 & !A15))) ^ 1'b1)), .clk((WR_n)), .clrn(!((!RST_DLY))), .prn(!1'b0), .q(lc58));  // LC58 cfg 1011110011001
  gmx_tff r_lc59 (.t((((M1 & !IORQ_n & !A14 & A8 & lc59 & A5 & !A1 & !lc13 & A0 & !D2 & !A15) | (M1 & !IORQ_n & !A14 & A8 & !lc59 & A5 & !A1 & !lc13 & A0 & D2 & !A15)) ^ 1'b0)), .clk((WR_n)), .clrn(!((!RST_DLY))), .prn(1'b1), .q(lc59));  // LC59 cfg 1011010010001
  gmx_tff r_lc61 (.t((((!D0 & M1 & !IORQ_n & !A14 & A8 & A5 & !A1 & !lc13 & A0 & lc61 & !A15) | (D0 & M1 & !IORQ_n & !A14 & A8 & A5 & !A1 & !lc13 & A0 & !lc61 & !A15)) ^ 1'b0)), .clk((WR_n)), .clrn(!((!RST_DLY))), .prn(1'b1), .q(lc61));  // LC61 cfg 1011010010001
  gmx_dff r_lc64 (.d((1'b0 ^ (!lc53))), .clk((!RD_n & !M1 & !MREQ_n & !(!A14 & !lc61 & !A15) & !(!A14 & !lc25 & !A15))), .clrn(!((!RST_DLY))), .prn(!(!lc50)), .grst_n(1'b1), .q(lc64));  // LC64 cfg 1111110100001
endmodule
