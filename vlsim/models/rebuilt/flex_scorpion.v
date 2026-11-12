// flex_scorpion: EPF8452A design "Scorpion", one LUT and register per logic cell, from the firmware built from this repository (gmx.rom, gmx_cpld.pof).
// 328 logic cells; names lcK_<row><col> = LCK_<ROW><col>.
`timescale 1ns/1ps
module flex_scorpion (
  output G_o,
  output G_oe,
  output DB7_o,
  output DB7_oe,
  input DB7_i,
  output R_o,
  output R_oe,
  output DB6_o,
  output DB6_oe,
  input DB6_i,
  output DB5_o,
  output DB5_oe,
  input DB5_i,
  output DB4_o,
  output DB4_oe,
  input DB4_i,
  output DB3_o,
  output DB3_oe,
  input DB3_i,
  output DB2_o,
  output DB2_oe,
  input DB2_i,
  input p14M,
  output DB1_o,
  output DB1_oe,
  input DB1_i,
  output DB0_o,
  output DB0_oe,
  input DB0_i,
  output MA0_o,
  output MA0_oe,
  output MA1_o,
  output MA1_oe,
  output MA2_o,
  output MA2_oe,
  output MA3_o,
  output MA3_oe,
  output MA4_o,
  output MA4_oe,
  output MA5_o,
  output MA5_oe,
  output MA6_o,
  output MA6_oe,
  output MA7_o,
  output MA7_oe,
  output MA8_o,
  output MA8_oe,
  output MA9_o,
  output MA9_oe,
  output RAS_n_o,
  output RAS_n_oe,
  output CAS0_n_o,
  output CAS0_n_oe,
  output CAS1_o,
  output CAS1_oe,
  output WE_n_o,
  output WE_n_oe,
  input MD1,
  input MD2,
  input MD3,
  input MD4,
  input MD5,
  input MD6,
  input MD0,
  output WAIT_n_o,
  output WAIT_n_oe,
  input RD_n,
  input IORQ_n,
  input M1,
  input MG,
  input MREQ_n,
  output RAM_n_o,
  output RAM_n_oe,
  output CLKCPU_o,
  output CLKCPU_oe,
  output EBUF_o,
  output EBUF_oe,
  output INT_o,
  output INT_oe,
  input MD7,
  output TRBB_o,
  output TRBB_oe,
  input TRBB_i,
  input A15,
  input A14,
  output WRBUF_o,
  output WRBUF_oe,
  input A12,
  input A11,
  input A10,
  input A9,
  input A8,
  input A7,
  input A6,
  input A5,
  input A4,
  input A3,
  input A2,
  input A1,
  input RESET,
  input A0,
  input A13,
  output RDR_n_o,
  output RDR_n_oe,
  output WROUT_n_o,
  output WROUT_n_oe,
  output VS_o,
  output VS_oe,
  output SYNC_o,
  output SYNC_oe,
  output I_o,
  output I_oe,
  output B_o,
  output B_oe,
  input grst_n
);
  function lut16(input [15:0] m, input [3:0] i); lut16 = m[i]; endfunction
  wire DB7 = DB7_i;
  wire DB6 = DB6_i;
  wire DB5 = DB5_i;
  wire DB4 = DB4_i;
  wire DB3 = DB3_i;
  wire DB2 = DB2_i;
  wire DB1 = DB1_i;
  wire DB0 = DB0_i;
  wire TRBB = TRBB_i;
  wire lc1_a1;
  wire lc2_a1 = lut16(16'hCFC0, {lc8_a1, lc2_a8, lc1_a1, 1'b1});  // LC2_A1
  wire lc3_a1;
  wire lc4_a1;
  wire lc5_a1;
  wire lc6_a1;
  wire lc7_a1;
  wire lc8_a1 = lut16(16'hF0CC, {lc4_a4, lc8_a1, lc5_a3, 1'b1});  // LC8_A1
  wire lc1_a2 = lut16(16'hBFFF, {lc4_a13, lc5_a11, lc8_a21, lc6_a11});  // LC1_A2
  wire lc2_a2 = lut16(16'hCFC0, {lc5_a2, lc5_b14, lc4_b9, 1'b1});  // LC2_A2
  wire lc3_a2 = lut16(16'hCFC0, {lc6_a2, lc5_b14, A7, 1'b1});  // LC3_A2
  wire lc4_a2 = lut16(16'hFF7F, {lc1_a2, lc8_a2, lc8_a9, lc3_a8});  // LC4_A2
  wire lc5_a2 = lut16(16'hFC0C, {lc5_a11, lc6_a10, lc5_b13, 1'b1});  // LC5_A2
  wire lc6_a2 = lut16(16'hFC0C, {lc8_a21, lc6_a10, lc5_b16, 1'b1});  // LC6_A2
  wire lc7_a2 = lut16(16'h3033, {lc1_b16, lc6_a18, lc4_a12, 1'b1});  // LC7_A2
  wire lc8_a2;
  wire lc1_a3;
  wire lc3_a3;
  wire lc4_a3;
  wire lc5_a3;
  wire lc6_a3;
  wire lc7_a3;
  wire lc8_a3;
  wire lc1_a4 = lut16(16'hCDC8, {lc7_a4, lc7_b9, lc8_a4, lc2_b9});  // LC1_A4
  wire lc2_a4;
  wire lc3_a4 = lut16(16'hB888, {lc8_a17, lc6_a10, lc5_b14, A13});  // LC3_A4
  wire lc4_a4;
  wire lc5_a4 = lut16(16'h00F0, {lc2_a8, RESET, 1'b1, 1'b1});  // LC5_A4
  wire lc6_a4 = lut16(16'hF0CC, {lc4_a4, lc6_a4, lc5_a18, 1'b1});  // LC6_A4
  wire lc7_a4 = lut16(16'hCFC0, {lc6_a4, lc2_a8, lc7_a1, 1'b1});  // LC7_A4
  wire lc8_a4 = lut16(16'hCCF0, {lc7_b9, lc8_a12, lc8_a20, 1'b1});  // LC8_A4
  wire lc1_a5 = lut16(16'hCFFF, {lc1_b16, lc8_a19, lc4_a12, 1'b1});  // LC1_A5
  wire lc2_a5;
  wire lc3_a5 = lut16(16'h3033, {lc1_b16, lc8_a19, lc4_a12, 1'b1});  // LC3_A5
  wire lc4_a5 = lut16(16'hBFFF, {lc3_a16, lc5_a7, lc3_a7, lc2_b11});  // LC4_A5
  wire lc5_a5 = lut16(16'hFC30, {lc7_b14, lc7_a5, lc3_b5, 1'b1});  // LC5_A5
  wire lc6_a5 = lut16(16'hFC0C, {lc2_a5, lc6_a10, lc8_b6, 1'b1});  // LC6_A5
  wire lc7_a5 = lut16(16'hCFC0, {lc6_a5, lc5_b14, A4, 1'b1});  // LC7_A5
  wire lc8_a5 = lut16(16'hBFFF, {lc2_a15, lc2_a5, lc2_a16, lc4_a5});  // LC8_A5
  wire lc1_a6 = lut16(16'hCDC8, {lc4_a6, lc7_b9, lc7_a6, lc2_b9});  // LC1_A6
  wire lc2_a6;
  wire lc3_a6 = lut16(16'hF0CC, {lc4_a4, lc3_a6, lc4_a18, 1'b1});  // LC3_A6
  wire lc4_a6 = lut16(16'hCFC0, {lc3_a6, lc2_a8, lc5_a1, 1'b1});  // LC4_A6
  wire lc5_a6;
  wire lc6_a6 = lut16(16'h3000, {M1, A0, IORQ_n, 1'b1});  // LC6_A6
  wire lc7_a6 = lut16(16'hFFC0, {lc6_a12, lc7_b9, lc6_a3, 1'b1});  // LC7_A6
  wire lc1_a7 = lut16(16'hCFC0, {lc6_a7, lc5_b14, A1, 1'b1});  // LC1_A7
  wire lc2_a7 = lut16(16'hFC30, {lc2_a2, lc1_a7, lc3_b5, 1'b1});  // LC2_A7
  wire lc3_a7;
  wire lc4_a7 = lut16(16'hF0FF, {lc3_a7, lc2_b11, 1'b1, 1'b1});  // LC4_A7
  wire lc5_a7;
  wire lc6_a7 = lut16(16'hFC0C, {lc5_a7, lc6_a10, lc4_b6, 1'b1});  // LC6_A7
  wire lc7_a7 = lut16(16'hBFFF, {lc2_a16, lc3_a16, lc5_a7, lc4_a7});  // LC7_A7
  wire lc8_a7 = lut16(16'hBFFF, {lc4_a13, lc8_a21, lc3_b17, lc8_a5});  // LC8_A7
  wire lc1_a8 = lut16(16'hC000, {lc5_a11, lc8_a2, lc8_a21, 1'b1});  // LC1_A8
  wire lc2_a8 = lut16(16'h8000, {lc5_a20, lc6_a6, lc5_a8, A6});  // LC2_A8
  wire lc3_a8;
  wire lc4_a8 = lut16(16'hFF7F, {lc8_a7, lc5_a11, lc8_a2, lc8_a9});  // LC4_A8
  wire lc5_a8 = lut16(16'h8000, {A4, A7, A3, A2});  // LC5_A8
  wire lc6_a8 = lut16(16'h3033, {lc1_b16, lc3_a10, lc4_a12, 1'b1});  // LC6_A8
  wire lc7_a8 = lut16(16'hCFFF, {lc1_b16, lc3_a10, lc4_a12, 1'b1});  // LC7_A8
  wire lc1_a9 = lut16(16'hFC30, {lc8_a20, lc6_a3, lc3_b5, 1'b1});  // LC1_A9
  wire lc2_a9 = lut16(16'hF3C0, {lc5_a18, lc4_a18, lc3_b5, 1'b1});  // LC2_A9
  wire lc3_a9 = lut16(16'h3033, {lc1_b16, lc4_a10, lc4_a12, 1'b1});  // LC3_A9
  wire lc4_a9 = lut16(16'hFC30, {lc2_a9, lc1_a9, lc4_b16, 1'b1});  // LC4_A9
  wire lc5_a9 = lut16(16'h0040, {lc6_a12, lc7_b17, lc4_b16, A8});  // LC5_A9
  wire lc6_a9 = lut16(16'hCFFF, {lc1_b16, lc4_a10, lc4_a12, 1'b1});  // LC6_A9
  wire lc8_a9;
  wire lc1_a10 = lut16(16'hCDC8, {lc8_a10, lc7_b9, lc2_a14, lc2_b9});  // LC1_A10
  wire lc2_a10;
  wire lc3_a10;
  wire lc4_a10;
  wire lc5_a10 = lut16(16'hFFDF, {lc5_a12, lc7_b17, lc4_b16, A8});  // LC5_A10
  wire lc6_a10;
  wire lc7_a10;
  wire lc8_a10 = lut16(16'hCCF0, {lc2_a8, lc5_a19, lc7_a10, 1'b1});  // LC8_A10
  wire lc1_a11 = lut16(16'hCFFF, {lc1_b16, lc7_a18, lc4_a12, 1'b1});  // LC1_A11
  wire lc2_a11 = lut16(16'hCFFF, {lc1_b16, lc4_a1, lc4_a12, 1'b1});  // LC2_A11
  wire lc3_a11 = lut16(16'hCFFF, {lc1_b16, lc6_a18, lc4_a12, 1'b1});  // LC3_A11
  wire lc4_a11 = lut16(16'h3033, {lc1_b16, lc4_a1, lc4_a12, 1'b1});  // LC4_A11
  wire lc5_a11;
  wire lc6_a11 = lut16(16'hBFFF, {lc3_b17, lc2_a15, lc2_a5, lc7_a7});  // LC6_A11
  wire lc7_a11 = lut16(16'h3033, {lc1_b16, lc7_a18, lc4_a12, 1'b1});  // LC7_A11
  wire lc8_a11 = lut16(16'h000F, {lc1_b16, lc4_a12, 1'b1, 1'b1});  // LC8_A11
  wire lc1_a12;
  wire lc2_a12;
  wire lc3_a12;
  wire lc4_a12;
  wire lc5_a12;
  wire lc6_a12;
  wire lc7_a12 = lut16(16'hFFF0, {lc2_a12, RESET, 1'b1, 1'b1});  // LC7_A12
  wire lc8_a12;
  wire lc1_a13 = lut16(16'hCFFF, {lc1_b16, lc8_a18, lc4_a12, 1'b1});  // LC1_A13
  wire lc2_a13 = lut16(16'hCFC0, {lc8_a13, lc5_b14, A8, 1'b1});  // LC2_A13
  wire lc3_a13 = lut16(16'hBFFF, {lc8_a21, lc3_b17, lc2_a15, lc3_a15});  // LC3_A13
  wire lc4_a13;
  wire lc5_a13 = lut16(16'hE4AA, {lc5_b14, lc1_b5, A6, lc3_b5});  // LC5_A13
  wire lc6_a13 = lut16(16'hBFFF, {lc4_a13, lc5_a11, lc8_a2, lc3_a13});  // LC6_A13
  wire lc7_a13 = lut16(16'h3033, {lc1_b16, lc8_a18, lc4_a12, 1'b1});  // LC7_A13
  wire lc8_a13 = lut16(16'hFC0C, {lc4_a13, lc6_a10, lc2_b13, 1'b1});  // LC8_A13
  wire lc1_a14;
  wire lc2_a14 = lut16(16'hCCF0, {lc7_b9, lc1_a12, lc3_a12, 1'b1});  // LC2_A14
  wire lc3_a14 = lut16(16'hCFFF, {lc5_a7, lc3_a7, lc2_b11, 1'b1});  // LC3_A14
  wire lc4_a14 = lut16(16'hFE50, {lc6_a14, lc5_a14, lc4_b17, lc3_b5});  // LC4_A14
  wire lc5_a14 = lut16(16'hB888, {lc3_a7, lc6_a10, lc5_b14, A0});  // LC5_A14
  wire lc6_a14 = lut16(16'hC0CF, {lc6_a10, lc5_b14, lc1_b9, 1'b1});  // LC6_A14
  wire lc7_a14;
  wire lc8_a14 = lut16(16'hFC30, {lc3_a4, lc4_a15, lc3_b5, 1'b1});  // LC8_A14
  wire lc1_a15 = lut16(16'hFC0C, {lc2_a15, lc6_a10, lc3_b13, 1'b1});  // LC1_A15
  wire lc2_a15;
  wire lc3_a15 = lut16(16'hBFFF, {lc2_a5, lc2_a16, lc3_a16, lc3_a14});  // LC3_A15
  wire lc4_a15 = lut16(16'hCFC0, {lc1_a15, lc5_b14, A5, 1'b1});  // LC4_A15
  wire lc5_a15 = lut16(16'h3000, {lc6_a6, A5, A1, 1'b1});  // LC5_A15
  wire lc6_a15 = lut16(16'h0C00, {M1, IORQ_n, RD_n, 1'b1});  // LC6_A15
  wire lc7_a15 = lut16(16'h3033, {lc1_b16, lc7_a3, lc4_a12, 1'b1});  // LC7_A15
  wire lc8_a15 = lut16(16'hCFFF, {lc1_b16, lc7_a3, lc4_a12, 1'b1});  // LC8_A15
  wire lc1_a16 = lut16(16'hCFC0, {lc5_a16, lc5_b14, A3, 1'b1});  // LC1_A16
  wire lc2_a16;
  wire lc3_a16;
  wire lc4_a16 = lut16(16'hCFC0, {lc7_a16, lc5_b14, A2, 1'b1});  // LC4_A16
  wire lc5_a16 = lut16(16'hFC0C, {lc2_a16, lc6_a10, lc3_b6, 1'b1});  // LC5_A16
  wire lc6_a16 = lut16(16'hFC30, {lc7_b15, lc1_a16, lc3_b5, 1'b1});  // LC6_A16
  wire lc7_a16 = lut16(16'hFC0C, {lc3_a16, lc6_a10, lc2_b6, 1'b1});  // LC7_A16
  wire lc8_a16 = lut16(16'hFC30, {lc8_b13, lc4_a16, lc3_b5, 1'b1});  // LC8_A16
  wire lc1_a17 = lut16(16'hF0CC, {lc4_a4, lc1_a17, lc4_a3, 1'b1});  // LC1_A17
  wire lc2_a17 = lut16(16'hFE10, {lc7_a17, lc6_a17, lc7_b9, lc2_b9});  // LC2_A17
  wire lc3_a17 = lut16(16'hF0CC, {lc4_a4, lc3_a17, lc2_a18, 1'b1});  // LC3_A17
  wire lc4_a17 = lut16(16'h3033, {lc1_b16, lc2_a10, lc4_a12, 1'b1});  // LC4_A17
  wire lc5_a17 = lut16(16'hCFFF, {lc1_b16, lc2_a10, lc4_a12, 1'b1});  // LC5_A17
  wire lc6_a17 = lut16(16'hCFC0, {lc3_a17, lc2_a8, lc6_a1, 1'b1});  // LC6_A17
  wire lc7_a17 = lut16(16'hCFC0, {lc1_a17, lc7_b9, lc4_a20, 1'b1});  // LC7_A17
  wire lc8_a17;
  wire lc1_a18 = lut16(16'hFFD0, {lc5_a9, lc2_b12, A6, lc6_a15});  // LC1_A18
  wire lc2_a18;
  wire lc3_a18;
  wire lc4_a18;
  wire lc5_a18;
  wire lc6_a18;
  wire lc7_a18;
  wire lc8_a18;
  wire lc1_a19 = lut16(16'h0F00, {lc1_b17, M1, 1'b1, 1'b1});  // LC1_A19
  wire lc2_a19 = lut16(16'hFFFC, {lc5_b17, MREQ_n, RD_n, 1'b1});  // LC2_A19
  wire lc3_a19;
  wire lc4_a19 = lut16(16'hFFCF, {M1, A8, lc4_b9, 1'b1});  // LC4_A19
  wire lc5_a19;
  wire lc6_a19;
  wire lc7_a19;
  wire lc8_a19;
  wire lc1_a20;
  wire lc2_a20 = lut16(16'hEFFE, {lc3_a20, lc7_a20, A5, A1});  // LC2_A20
  wire lc3_a20;
  wire lc4_a20;
  wire lc5_a20 = lut16(16'h8008, {lc3_a20, lc7_a20, A5, A1});  // LC5_A20
  wire lc6_a20;
  wire lc7_a20;
  wire lc8_a20;
  wire lc1_a21 = lut16(16'hFE10, {lc7_a21, lc2_a1, lc7_b9, lc2_b9});  // LC1_A21
  wire lc2_a21 = lut16(16'h3033, {lc1_b16, lc3_a1, lc4_a12, 1'b1});  // LC2_A21
  wire lc3_a21 = lut16(16'hF0CC, {lc4_a4, lc3_a21, lc8_a3, 1'b1});  // LC3_A21
  wire lc4_a21 = lut16(16'h0307, {lc6_a12, lc5_a12, lc4_b16, A8});  // LC4_A21
  wire lc5_a21 = lut16(16'hF7F5, {lc4_a3, lc4_a21, lc7_a19, lc7_b17});  // LC5_A21
  wire lc6_a21 = lut16(16'hCFFF, {lc1_b16, lc3_a1, lc4_a12, 1'b1});  // LC6_A21
  wire lc7_a21 = lut16(16'hCFC0, {lc3_a21, lc7_b9, lc3_a3, 1'b1});  // LC7_A21
  wire lc8_a21;
  wire lc1_b1;
  wire lc2_b1 = lut16(16'h8F80, {lc6_a10, lc5_b14, lc4_a9, A15});  // LC2_B1
  wire lc3_b1 = lut16(16'hCFC0, {lc8_b1, lc2_a8, lc7_b1, 1'b1});  // LC3_B1
  wire lc4_b1 = lut16(16'hF3C0, {lc2_a13, lc6_b1, lc3_b5, 1'b1});  // LC4_B1
  wire lc5_b1 = lut16(16'hA820, {lc1_a20, lc4_b3, lc4_b16, A15});  // LC5_B1
  wire lc6_b1 = lut16(16'hCFC0, {lc6_a10, lc5_b14, lc5_b1, 1'b1});  // LC6_B1
  wire lc7_b1;
  wire lc8_b1 = lut16(16'hF0CC, {lc4_a4, lc8_b1, lc1_a20, 1'b1});  // LC8_B1
  wire lc1_b2 = lut16(16'h5554, {lc2_a8, lc4_b2, lc3_b9, RD_n});  // LC1_B2
  wire lc2_b2 = lut16(16'hF0CC, {lc4_a4, lc2_b2, lc8_b19, 1'b1});  // LC2_B2
  wire lc3_b2 = lut16(16'hFE10, {lc8_b2, lc7_b2, lc7_b9, lc2_b9});  // LC3_B2
  wire lc4_b2 = lut16(16'hFFF0, {lc7_b9, lc2_b9, 1'b1, 1'b1});  // LC4_B2
  wire lc5_b2;
  wire lc6_b2 = lut16(16'hF0CC, {lc4_a4, lc6_b2, lc3_a18, 1'b1});  // LC6_B2
  wire lc7_b2 = lut16(16'hCFC0, {lc6_b2, lc2_a8, lc5_b2, 1'b1});  // LC7_B2
  wire lc8_b2 = lut16(16'hCFC0, {lc2_b2, lc7_b9, lc1_b1, 1'b1});  // LC8_B2
  wire lc1_b3 = lut16(16'hFE10, {lc8_b3, lc3_b1, lc7_b9, lc2_b9});  // LC1_B3
  wire lc2_b3;
  wire lc3_b3;
  wire lc4_b3;
  wire lc5_b3;
  wire lc6_b3;
  wire lc7_b3;
  wire lc8_b3 = lut16(16'hCFC0, {lc4_b15, lc7_b9, lc4_b3, 1'b1});  // LC8_B3
  wire lc1_b4;
  wire lc2_b4;
  wire lc3_b4;
  wire lc4_b4 = lut16(16'h0A8A, {lc1_b4, lc6_a10, lc3_b13, lc5_b4});  // LC4_B4
  wire lc5_b4 = lut16(16'hCCF0, {lc1_b4, lc6_b16, lc8_a12, 1'b1});  // LC5_B4
  wire lc6_b4 = lut16(16'hA0C0, {lc6_a10, lc1_b19, lc3_b15, lc2_b4});  // LC6_B4
  wire lc7_b4 = lut16(16'hCC40, {lc6_a10, lc3_b13, lc8_b4, lc8_a12});  // LC7_B4
  wire lc8_b4 = lut16(16'hC000, {lc6_b16, lc5_b16, lc7_b16, 1'b1});  // LC8_B4
  wire lc1_b5 = lut16(16'hEC64, {lc2_a18, lc4_a20, lc4_b16, A15});  // LC1_B5
  wire lc2_b5 = lut16(16'hF3C0, {lc3_a2, lc8_b5, lc3_b5, 1'b1});  // LC2_B5
  wire lc3_b5;
  wire lc4_b5 = lut16(16'h28A0, {lc1_a3, lc6_b3, lc3_b11, lc6_b14});  // LC4_B5
  wire lc5_b5 = lut16(16'h820A, {lc1_a3, lc6_b3, lc3_b11, lc6_b14});  // LC5_B5
  wire lc6_b5;
  wire lc7_b5 = lut16(16'h8A02, {lc5_a3, lc3_a3, lc4_b16, A15});  // LC7_B5
  wire lc8_b5 = lut16(16'hCCF0, {lc5_b14, lc8_a3, lc7_b5, 1'b1});  // LC8_B5
  wire lc1_b6 = lut16(16'hC000, {lc4_b6, lc6_b6, lc2_b6, 1'b1});  // LC1_B6
  wire lc2_b6;
  wire lc3_b6;
  wire lc4_b6;
  wire lc5_b6;
  wire lc6_b6 = lut16(16'h8000, {lc7_b20, lc3_b20, lc5_b11, lc6_b11});  // LC6_B6
  wire lc8_b6;
  wire lc1_b7 = lut16(16'hFE10, {lc3_b21, lc8_b7, lc7_b9, lc2_b9});  // LC1_B7
  wire lc2_b7;
  wire lc3_b7 = lut16(16'hFF0F, {lc2_b12, lc2_b9, 1'b1, 1'b1});  // LC3_B7
  wire lc4_b7;
  wire lc5_b7 = lut16(16'h57DF, {lc4_b7, lc2_b7, lc4_b16, A15});  // LC5_B7
  wire lc6_b7 = lut16(16'hF0CC, {lc4_a4, lc6_b7, lc4_b7, 1'b1});  // LC6_B7
  wire lc7_b7;
  wire lc8_b7 = lut16(16'hCFC0, {lc6_b7, lc2_a8, lc7_b7, 1'b1});  // LC8_B7
  wire lc1_b8 = lut16(16'hECA0, {lc5_b5, lc4_b5, lc8_b8, lc7_b8});  // LC1_B8
  wire lc2_b8;
  wire lc3_b8;
  wire lc4_b8;
  wire lc5_b8;
  wire lc6_b8;
  wire lc7_b8;
  wire lc8_b8;
  wire lc1_b9 = lut16(16'hEC64, {lc3_a18, lc1_b1, lc4_b16, A15});  // LC1_B9
  wire lc2_b9 = lut16(16'hC000, {lc5_a9, lc4_b9, A10, 1'b1});  // LC2_B9
  wire lc3_b9 = lut16(16'h3000, {lc5_a9, lc4_b9, A10, 1'b1});  // LC3_B9
  wire lc4_b9 = lut16(16'hFF00, {A9, 1'b1, 1'b1, 1'b1});  // LC4_B9
  wire lc5_b9;
  wire lc6_b9 = lut16(16'hF3FF, {lc5_a9, lc4_b9, A10, 1'b1});  // LC6_B9
  wire lc7_b9 = lut16(16'h0300, {lc5_a9, lc4_b9, A10, 1'b1});  // LC7_B9
  wire lc8_b9 = lut16(16'h3F0F, {lc7_b10, lc8_b19, lc5_b9, 1'b1});  // LC8_B9
  wire lc1_b10 = lut16(16'hCFFF, {lc2_b14, lc6_b19, lc5_b11, 1'b1});  // LC1_B10
  wire lc2_b10 = lut16(16'hCCF0, {lc6_a10, lc2_b14, p14M, 1'b1});  // LC2_B10
  wire lc3_b10;
  wire lc4_b10;
  wire lc5_b10 = lut16(16'h3F33, {lc5_b14, lc5_b7, lc5_b11, 1'b1});  // LC5_B10
  wire lc6_b10 = lut16(16'h0800, {lc5_b17, MREQ_n, RD_n, lc3_b10});  // LC6_B10
  wire lc7_b10 = lut16(16'h444F, {lc1_b17, lc6_b10, lc3_b16, lc6_b19});  // LC7_B10
  wire lc8_b10;
  wire lc1_b11 = lut16(16'hECA0, {lc5_b5, lc4_b5, lc7_b11, lc4_b11});  // LC1_B11
  wire lc2_b11 = lut16(16'hFFF3, {lc1_b4, lc1_b19, lc7_b20, 1'b1});  // LC2_B11
  wire lc3_b11;
  wire lc4_b11;
  wire lc5_b11;
  wire lc6_b11;
  wire lc7_b11;
  wire lc8_b11;
  wire lc1_b12 = lut16(16'hECA0, {lc5_b5, lc4_b5, lc8_b11, lc3_b12});  // LC1_B12
  wire lc2_b12 = lut16(16'hFF03, {lc7_b12, lc4_b12, lc5_b12, 1'b1});  // LC2_B12
  wire lc3_b12;
  wire lc4_b12;
  wire lc5_b12;
  wire lc6_b12;
  wire lc7_b12 = lut16(16'hF3C0, {lc6_b12, lc8_b12, lc8_b19, 1'b1});  // LC7_B12
  wire lc8_b12;
  wire lc1_b13;
  wire lc2_b13 = lut16(16'hFC30, {lc6_b16, lc1_b13, lc3_b20, 1'b1});  // LC2_B13
  wire lc3_b13;
  wire lc4_b13;
  wire lc5_b13 = lut16(16'hFC30, {lc2_b16, lc4_b13, lc3_b20, 1'b1});  // LC5_B13
  wire lc6_b13;
  wire lc7_b13 = lut16(16'hF404, {lc8_a2, lc6_a10, lc6_b13, lc3_b20});  // LC7_B13
  wire lc8_b13 = lut16(16'hCFC0, {lc7_b13, lc5_b14, A10, 1'b1});  // LC8_B13
  wire lc1_b14 = lut16(16'hCCC0, {lc5_b5, lc4_b5, lc6_b8, 1'b1});  // LC1_B14
  wire lc2_b14;
  wire lc3_b14 = lut16(16'h00FD, {lc6_a10, lc5_b14, lc3_b20, lc5_b11});  // LC3_B14
  wire lc4_b14 = lut16(16'hCC0F, {lc6_a10, lc3_b20, lc5_b8, 1'b1});  // LC4_B14
  wire lc5_b14 = lut16(16'hCF00, {lc3_b16, lc7_b20, lc8_b19, 1'b1});  // LC5_B14
  wire lc6_b14;
  wire lc7_b14 = lut16(16'hCFC0, {lc8_b14, lc5_b14, A12, 1'b1});  // LC7_B14
  wire lc8_b14 = lut16(16'hFE0E, {lc3_a8, lc6_a10, lc2_b16, lc3_b20});  // LC8_B14
  wire lc1_b15 = lut16(16'hFFF0, {lc1_b16, lc5_b15, 1'b1, 1'b1});  // LC1_B15
  wire lc2_b15 = lut16(16'hCFCC, {lc8_b15, lc5_b14, lc5_a13, 1'b1});  // LC2_B15
  wire lc3_b15 = lut16(16'h0300, {lc3_b6, lc8_b6, lc3_b19, 1'b1});  // LC3_B15
  wire lc4_b15 = lut16(16'hF0CC, {lc4_a4, lc4_b15, lc6_a10, 1'b1});  // LC4_B15
  wire lc5_b15;
  wire lc6_b15 = lut16(16'hFE0E, {lc8_a9, lc6_a10, lc6_b16, lc3_b20});  // LC6_B15
  wire lc7_b15 = lut16(16'hCFC0, {lc6_b15, lc5_b14, A11, 1'b1});  // LC7_B15
  wire lc8_b15 = lut16(16'hFC0C, {lc3_b17, lc6_a10, lc7_b16, 1'b1});  // LC8_B15
  wire lc1_b16;
  wire lc2_b16;
  wire lc3_b16 = lut16(16'hFFF7, {lc1_b4, lc1_b19, lc7_b20, lc8_b19});  // LC3_B16
  wire lc4_b16 = lut16(16'hFF00, {A14, 1'b1, 1'b1, 1'b1});  // LC4_B16
  wire lc5_b16;
  wire lc6_b16;
  wire lc7_b16;
  wire lc8_b16 = lut16(16'h0FF0, {lc3_b13, lc8_a12, 1'b1, 1'b1});  // LC8_B16
  wire lc1_b17 = lut16(16'h0300, {lc5_b17, MREQ_n, RD_n, 1'b1});  // LC1_B17
  wire lc2_b17 = lut16(16'hFCFF, {lc4_a4, MREQ_n, RD_n, 1'b1});  // LC2_B17
  wire lc3_b17;
  wire lc4_b17 = lut16(16'h20AA, {lc3_b16, lc7_b20, lc8_b19, lc6_b11});  // LC4_B17
  wire lc5_b17 = lut16(16'hFEEE, {lc2_b17, lc6_a20, lc4_b16, A15});  // LC5_B17
  wire lc6_b17 = lut16(16'hFFBF, {lc6_a12, lc5_a15, A15, A13});  // LC6_B17
  wire lc7_b17 = lut16(16'h0F00, {lc5_a15, A15, 1'b1, 1'b1});  // LC7_B17
  wire lc1_b18;
  wire lc2_b18;
  wire lc3_b18;
  wire lc4_b18 = lut16(16'hBF00, {lc6_a10, lc7_b20, lc2_b14, lc6_b19});  // LC4_B18
  wire lc5_b18;
  wire lc6_b18;
  wire lc7_b18;
  wire lc8_b18;
  wire lc1_b19;
  wire lc2_b19 = lut16(16'hCCC0, {lc6_a10, lc3_b6, lc8_b6, 1'b1});  // LC2_B19
  wire lc3_b19;
  wire lc4_b19 = lut16(16'hF033, {lc8_b19, lc2_b14, lc6_b19, 1'b1});  // LC4_B19
  wire lc5_b19 = lut16(16'hF0FF, {lc6_a10, lc3_b6, 1'b1, 1'b1});  // LC5_B19
  wire lc6_b19;
  wire lc8_b19;
  wire lc1_b20;
  wire lc2_b20 = lut16(16'hC8CC, {lc1_b17, lc8_b20, lc4_b20, lc5_b7});  // LC2_B20
  wire lc3_b20;
  wire lc4_b20 = lut16(16'hCFFF, {lc5_b14, lc1_b20, lc5_b8, 1'b1});  // LC4_B20
  wire lc5_b20 = lut16(16'h2A20, {lc6_a10, lc5_b14, lc5_b7, lc5_b11});  // LC5_B20
  wire lc6_b20 = lut16(16'h7FFF, {A10, A13, A12, A11});  // LC6_B20
  wire lc7_b20;
  wire lc8_b20 = lut16(16'h0FFF, {lc5_b14, lc5_b11, 1'b1, 1'b1});  // LC8_B20
  wire lc1_b21 = lut16(16'hF000, {TRBB, lc8_b19, 1'b1, 1'b1});  // LC1_B21
  wire lc2_b21;
  wire lc3_b21 = lut16(16'hCFC0, {lc5_b21, lc7_b9, lc2_b7, 1'b1});  // LC3_B21
  wire lc4_b21;
  wire lc5_b21 = lut16(16'hF0CC, {lc4_a4, lc5_b21, lc6_a20, 1'b1});  // LC5_B21
  wire lc6_b21 = lut16(16'hA75C, {lc6_a10, lc8_b19, lc3_b6, lc2_b6});  // LC6_B21
  wire lc7_b21 = lut16(16'hF00F, {lc1_b16, lc8_a12, 1'b1, 1'b1});  // LC7_B21
  assign G_o = lc1_b11;  // pin 1
  assign G_oe = 1'b1;
  assign DB7_o = lc1_a10;  // pin 2
  assign DB7_oe = lc1_b2;
  assign R_o = lc1_b8;  // pin 3
  assign R_oe = 1'b1;
  assign DB6_o = lc1_b7;  // pin 4
  assign DB6_oe = lc1_b2;
  assign DB5_o = lc1_a6;  // pin 6
  assign DB5_oe = lc1_b2;
  assign DB4_o = lc1_a4;  // pin 7
  assign DB4_oe = lc1_b2;
  assign DB3_o = lc1_b3;  // pin 8
  assign DB3_oe = lc1_b2;
  assign DB2_o = lc3_b2;  // pin 9
  assign DB2_oe = lc1_b2;
  assign DB1_o = lc1_a21;  // pin 13
  assign DB1_oe = lc1_b2;
  assign DB0_o = lc2_a17;  // pin 14
  assign DB0_oe = lc1_b2;
  assign MA0_o = lc4_a14;  // pin 15
  assign MA0_oe = 1'b1;
  assign MA1_o = lc2_a7;  // pin 16
  assign MA1_oe = 1'b1;
  assign MA2_o = lc8_a16;  // pin 18
  assign MA2_oe = 1'b1;
  assign MA3_o = lc6_a16;  // pin 19
  assign MA3_oe = 1'b1;
  assign MA4_o = lc5_a5;  // pin 20
  assign MA4_oe = 1'b1;
  assign MA5_o = lc8_a14;  // pin 21
  assign MA5_oe = 1'b1;
  assign MA6_o = lc2_b15;  // pin 22
  assign MA6_oe = 1'b1;
  assign MA7_o = lc2_b5;  // pin 23
  assign MA7_oe = 1'b1;
  assign MA8_o = lc4_b1;  // pin 24
  assign MA8_oe = 1'b1;
  assign MA9_o = lc2_b1;  // pin 25
  assign MA9_oe = 1'b1;
  assign RAS_n_o = lc6_b19;  // pin 27
  assign RAS_n_oe = 1'b1;
  assign CAS0_n_o = lc5_b10;  // pin 28
  assign CAS0_n_oe = 1'b1;
  assign CAS1_o = lc5_b20;  // pin 29
  assign CAS1_oe = 1'b1;
  assign WE_n_o = !lc8_b10;  // pin 30
  assign WE_n_oe = 1'b1;
  assign WAIT_n_o = lc8_b9;  // pin 41
  assign WAIT_n_oe = 1'b1;
  assign RAM_n_o = !lc1_b17;  // pin 48
  assign RAM_n_oe = 1'b1;
  assign CLKCPU_o = !lc4_b19;  // pin 49
  assign CLKCPU_oe = 1'b1;
  assign EBUF_o = lc2_b20;  // pin 50
  assign EBUF_oe = 1'b1;
  assign INT_o = !lc2_b21;  // pin 51
  assign INT_oe = 1'b1;
  assign TRBB_o = lc8_b19;  // pin 55
  assign TRBB_oe = lc1_b21;
  assign WRBUF_o = !lc8_b20;  // pin 58
  assign WRBUF_oe = 1'b1;
  assign RDR_n_o = lc2_a19;  // pin 78
  assign RDR_n_oe = 1'b1;
  assign WROUT_n_o = lc1_a18;  // pin 79
  assign WROUT_n_oe = 1'b1;
  assign VS_o = !lc1_b16;  // pin 81
  assign VS_oe = 1'b1;
  assign SYNC_o = lc1_b15;  // pin 82
  assign SYNC_oe = 1'b1;
  assign I_o = lc1_b14;  // pin 83
  assign I_oe = 1'b1;
  assign B_o = lc1_b12;  // pin 84
  assign B_oe = 1'b1;
  gmx_dffs r_lc1_a1 (.d(lut16(16'hAAAA, {1'b1, 1'b1, 1'b1, MD1})), .clk(!lc3_b20), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc1_a1));  // LC1_A1
  gmx_dffs r_lc3_a1 (.d(lut16(16'hFC0C, {DB7, lc3_b9, lc3_a1, 1'b1})), .clk(lc2_b12), .clrn((RESET)), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc3_a1));  // LC3_A1
  gmx_dffs r_lc4_a1 (.d(lut16(16'hFC0C, {DB6, lc3_b9, lc4_a1, 1'b1})), .clk(lc2_b12), .clrn((RESET)), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc4_a1));  // LC4_A1
  gmx_dffs r_lc5_a1 (.d(lut16(16'hAAAA, {1'b1, 1'b1, 1'b1, MD5})), .clk(!lc3_b20), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc5_a1));  // LC5_A1
  gmx_dffs r_lc6_a1 (.d(lut16(16'hAAAA, {1'b1, 1'b1, 1'b1, MD0})), .clk(!lc3_b20), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc6_a1));  // LC6_A1
  gmx_dffs r_lc7_a1 (.d(lut16(16'hAAAA, {1'b1, 1'b1, 1'b1, MD4})), .clk(!lc3_b20), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc7_a1));  // LC7_A1
  gmx_dffs r_lc8_a2 (.d(lut16(16'h00FF, {lc8_a2, 1'b1, 1'b1, 1'b1})), .clk(lc1_a2), .clrn(lc7_a2), .prn(lc3_a11), .grst_n(grst_n), .ts(p14M), .q(lc8_a2));  // LC8_A2
  gmx_dffs r_lc1_a3 (.d(lut16(16'h00FF, {lc1_a3, 1'b1, 1'b1, 1'b1})), .clk(lc5_a6), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc1_a3));  // LC1_A3
  gmx_dffs r_lc3_a3 (.d(lut16(16'hFC0C, {DB1, lc7_b9, lc3_a3, 1'b1})), .clk(lc2_b12), .clrn((RESET)), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc3_a3));  // LC3_A3
  gmx_dffs r_lc4_a3 (.d(lut16(16'hF3C0, {DB5, lc4_a3, lc5_a21, 1'b1})), .clk(lc2_b12), .clrn((RESET)), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc4_a3));  // LC4_A3
  gmx_dffs r_lc5_a3 (.d(lut16(16'hF3C0, {DB1, lc5_a3, lc5_a21, 1'b1})), .clk(lc2_b12), .clrn((RESET)), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc5_a3));  // LC5_A3
  gmx_dffs r_lc6_a3 (.d(lut16(16'hFC0C, {DB5, lc7_b9, lc6_a3, 1'b1})), .clk(lc2_b12), .clrn((RESET)), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc6_a3));  // LC6_A3
  gmx_dffs r_lc7_a3 (.d(lut16(16'hFC0C, {DB5, lc3_b9, lc7_a3, 1'b1})), .clk(lc2_b12), .clrn((RESET)), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc7_a3));  // LC7_A3
  gmx_dffs r_lc8_a3 (.d(lut16(16'hF3C0, {DB3, lc8_a3, lc5_a21, 1'b1})), .clk(lc2_b12), .clrn((RESET)), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc8_a3));  // LC8_A3
  gmx_dffs r_lc2_a4 (.d(lut16(16'hF303, {lc2_a4, lc7_a19, MG, 1'b1})), .clk(lc1_a19), .clrn(lc2_a19), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc2_a4));  // LC2_A4
  gmx_dffs r_lc4_a4 (.d(lut16(16'hFFFF, {1'b1, 1'b1, 1'b1, 1'b1})), .clk(lc2_a4), .clrn(lc5_a4), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc4_a4));  // LC4_A4
  gmx_dffs r_lc2_a5 (.d(lut16(16'h00FF, {lc2_a5, 1'b1, 1'b1, 1'b1})), .clk(lc7_a7), .clrn(lc3_a5), .prn(lc1_a5), .grst_n(grst_n), .ts(p14M), .q(lc2_a5));  // LC2_A5
  gmx_dffs r_lc2_a6 (.d(lut16(16'h00FF, {lc2_a6, 1'b1, 1'b1, 1'b1})), .clk(lc1_a14), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc2_a6));  // LC2_A6
  gmx_dffs r_lc5_a6 (.d(lut16(16'h00FF, {lc5_a6, 1'b1, 1'b1, 1'b1})), .clk(lc2_a6), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc5_a6));  // LC5_A6
  gmx_dffs r_lc3_a7 (.d(lut16(16'h00FF, {lc3_a7, 1'b1, 1'b1, 1'b1})), .clk(lc2_b11), .clrn(lc8_a11), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc3_a7));  // LC3_A7
  gmx_dffs r_lc5_a7 (.d(lut16(16'h00FF, {lc5_a7, 1'b1, 1'b1, 1'b1})), .clk(lc4_a7), .clrn(lc8_a11), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc5_a7));  // LC5_A7
  gmx_dffs r_lc3_a8 (.d(lut16(16'h00FF, {lc3_a8, 1'b1, 1'b1, 1'b1})), .clk(lc4_a8), .clrn(lc6_a8), .prn(lc7_a8), .grst_n(grst_n), .ts(p14M), .q(lc3_a8));  // LC3_A8
  gmx_dffs r_lc8_a9 (.d(lut16(16'h00FF, {lc8_a9, 1'b1, 1'b1, 1'b1})), .clk(lc6_a13), .clrn(lc3_a9), .prn(lc6_a9), .grst_n(grst_n), .ts(p14M), .q(lc8_a9));  // LC8_A9
  gmx_dffs r_lc2_a10 (.d(lut16(16'hCFC0, {DB5, lc6_b9, lc2_a10, 1'b1})), .clk(lc2_b12), .clrn((RESET)), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc2_a10));  // LC2_A10
  gmx_dffs r_lc3_a10 (.d(lut16(16'hCFC0, {DB4, lc6_b9, lc3_a10, 1'b1})), .clk(lc2_b12), .clrn((RESET)), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc3_a10));  // LC3_A10
  gmx_dffs r_lc4_a10 (.d(lut16(16'hCFC0, {DB3, lc6_b9, lc4_a10, 1'b1})), .clk(lc2_b12), .clrn((RESET)), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc4_a10));  // LC4_A10
  gmx_dffs r_lc6_a10 (.d(lut16(16'hFC30, {DB3, lc6_a10, lc2_b9, 1'b1})), .clk(lc2_b12), .clrn((RESET)), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc6_a10));  // LC6_A10
  gmx_dffs r_lc7_a10 (.d(lut16(16'hAAAA, {1'b1, 1'b1, 1'b1, MD7})), .clk(!lc3_b20), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc7_a10));  // LC7_A10
  gmx_dffs r_lc5_a11 (.d(lut16(16'h00FF, {lc5_a11, 1'b1, 1'b1, 1'b1})), .clk(lc8_a7), .clrn(lc7_a11), .prn(lc1_a11), .grst_n(grst_n), .ts(p14M), .q(lc5_a11));  // LC5_A11
  gmx_dffs r_lc1_a12 (.d(lut16(16'hDC8C, {DB2, lc5_a20, lc1_a12, A0})), .clk(lc2_b12), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc1_a12));  // LC1_A12
  gmx_dffs r_lc2_a12 (.d(lut16(16'hCDC8, {DB4, lc2_a20, lc2_a12, A0})), .clk(lc2_b12), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc2_a12));  // LC2_A12
  gmx_dffs r_lc3_a12 (.d(lut16(16'hD8CC, {lc5_a20, DB1, lc3_a12, A0})), .clk(lc2_b12), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc3_a12));  // LC3_A12
  gmx_dffs r_lc4_a12 (.d(lut16(16'h8000, {lc8_a9, lc3_a8, lc8_a17, lc1_a8})), .clk(lc7_b20), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc4_a12));  // LC4_A12
  gmx_dffs r_lc5_a12 (.d(lut16(16'hCDC8, {DB6, lc2_a20, lc5_a12, A0})), .clk(lc2_b12), .clrn(lc7_a12), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc5_a12));  // LC5_A12
  gmx_dffs r_lc6_a12 (.d(lut16(16'hCDC8, {DB5, lc2_a20, lc6_a12, A0})), .clk(lc2_b12), .clrn(lc7_a12), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc6_a12));  // LC6_A12
  gmx_dffs r_lc8_a12 (.d(lut16(16'hCDC8, {DB7, lc2_a20, lc8_a12, A0})), .clk(lc2_b12), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc8_a12));  // LC8_A12
  gmx_dffs r_lc4_a13 (.d(lut16(16'h00FF, {lc4_a13, 1'b1, 1'b1, 1'b1})), .clk(lc3_a13), .clrn(lc7_a13), .prn(lc1_a13), .grst_n(grst_n), .ts(p14M), .q(lc4_a13));  // LC4_A13
  gmx_dffs r_lc1_a14 (.d(lut16(16'h00FF, {lc1_a14, 1'b1, 1'b1, 1'b1})), .clk(lc7_a14), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc1_a14));  // LC1_A14
  gmx_dffs r_lc7_a14 (.d(lut16(16'h00FF, {lc7_a14, 1'b1, 1'b1, 1'b1})), .clk(!lc1_b16), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc7_a14));  // LC7_A14
  gmx_dffs r_lc2_a15 (.d(lut16(16'h00FF, {lc2_a15, 1'b1, 1'b1, 1'b1})), .clk(lc3_a15), .clrn(lc7_a15), .prn(lc8_a15), .grst_n(grst_n), .ts(p14M), .q(lc2_a15));  // LC2_A15
  gmx_dffs r_lc2_a16 (.d(lut16(16'h00FF, {lc2_a16, 1'b1, 1'b1, 1'b1})), .clk(lc4_a5), .clrn(lc8_a11), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc2_a16));  // LC2_A16
  gmx_dffs r_lc3_a16 (.d(lut16(16'h00FF, {lc3_a16, 1'b1, 1'b1, 1'b1})), .clk(lc3_a14), .clrn(lc8_a11), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc3_a16));  // LC3_A16
  gmx_dffs r_lc8_a17 (.d(lut16(16'h00FF, {lc8_a17, 1'b1, 1'b1, 1'b1})), .clk(lc4_a2), .clrn(lc4_a17), .prn(lc5_a17), .grst_n(grst_n), .ts(p14M), .q(lc8_a17));  // LC8_A17
  gmx_dffs r_lc2_a18 (.d(lut16(16'hF3C0, {DB0, lc2_a18, lc5_a21, 1'b1})), .clk(lc2_b12), .clrn((RESET)), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc2_a18));  // LC2_A18
  gmx_dffs r_lc3_a18 (.d(lut16(16'hF3C0, {DB2, lc3_a18, lc5_a21, 1'b1})), .clk(lc2_b12), .clrn((RESET)), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc3_a18));  // LC3_A18
  gmx_dffs r_lc4_a18 (.d(lut16(16'hF3C0, {DB1, lc4_a18, lc6_b17, 1'b1})), .clk(lc2_b12), .clrn((RESET)), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc4_a18));  // LC4_A18
  gmx_dffs r_lc5_a18 (.d(lut16(16'hF3C0, {DB0, lc5_a18, lc6_b17, 1'b1})), .clk(lc2_b12), .clrn((RESET)), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc5_a18));  // LC5_A18
  gmx_dffs r_lc6_a18 (.d(lut16(16'hCFC0, {DB2, lc6_b9, lc6_a18, 1'b1})), .clk(lc2_b12), .clrn((RESET)), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc6_a18));  // LC6_A18
  gmx_dffs r_lc7_a18 (.d(lut16(16'hCFC0, {DB1, lc6_b9, lc7_a18, 1'b1})), .clk(lc2_b12), .clrn((RESET)), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc7_a18));  // LC7_A18
  gmx_dffs r_lc8_a18 (.d(lut16(16'hCFC0, {DB0, lc6_b9, lc8_a18, 1'b1})), .clk(lc2_b12), .clrn((RESET)), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc8_a18));  // LC8_A18
  gmx_dffs r_lc3_a19 (.d(lut16(16'hFFEF, {lc5_b17, lc6_a19, lc4_a19, lc6_b20})), .clk(!MREQ_n), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc3_a19));  // LC3_A19
  gmx_dffs r_lc5_a19 (.d(lut16(16'hDC8C, {DB0, lc5_a20, lc5_a19, A0})), .clk(lc2_b12), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc5_a19));  // LC5_A19
  gmx_dffs r_lc6_a19 (.d(lut16(16'hCFC0, {DB4, lc5_a21, lc6_a19, 1'b1})), .clk(lc2_b12), .clrn((RESET)), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc6_a19));  // LC6_A19
  gmx_dffs r_lc7_a19 (.d(lut16(16'hFC0C, {DB2, lc2_b9, lc7_a19, 1'b1})), .clk(lc2_b12), .clrn((RESET)), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc7_a19));  // LC7_A19
  gmx_dffs r_lc8_a19 (.d(lut16(16'hFC0C, {DB4, lc3_b9, lc8_a19, 1'b1})), .clk(lc2_b12), .clrn((RESET)), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc8_a19));  // LC8_A19
  gmx_dffs r_lc1_a20 (.d(lut16(16'hF3C0, {DB4, lc1_a20, lc5_a10, 1'b1})), .clk(lc2_b12), .clrn((RESET)), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc1_a20));  // LC1_A20
  gmx_dffs r_lc3_a20 (.d(lut16(16'hFF00, {lc2_a4, 1'b1, 1'b1, 1'b1})), .clk(lc1_a19), .clrn((RESET)), .prn(lc3_a19), .grst_n(grst_n), .ts(p14M), .q(lc3_a20));  // LC3_A20
  gmx_dffs r_lc4_a20 (.d(lut16(16'hFC0C, {DB0, lc7_b9, lc4_a20, 1'b1})), .clk(lc2_b12), .clrn((RESET)), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc4_a20));  // LC4_A20
  gmx_dffs r_lc6_a20 (.d(lut16(16'hF3C0, {DB0, lc6_a20, lc5_a10, 1'b1})), .clk(lc2_b12), .clrn((RESET)), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc6_a20));  // LC6_A20
  gmx_dffs r_lc7_a20 (.d(lut16(16'hF3C0, {DB2, lc7_a20, lc5_a10, 1'b1})), .clk(lc2_b12), .clrn((RESET)), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc7_a20));  // LC7_A20
  gmx_dffs r_lc8_a20 (.d(lut16(16'hFC0C, {DB4, lc7_b9, lc8_a20, 1'b1})), .clk(lc2_b12), .clrn((RESET)), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc8_a20));  // LC8_A20
  gmx_dffs r_lc8_a21 (.d(lut16(16'h00FF, {lc8_a21, 1'b1, 1'b1, 1'b1})), .clk(lc6_a11), .clrn(lc2_a21), .prn(lc6_a21), .grst_n(grst_n), .ts(p14M), .q(lc8_a21));  // LC8_A21
  gmx_dffs r_lc1_b1 (.d(lut16(16'hFC0C, {DB2, lc7_b9, lc1_b1, 1'b1})), .clk(lc2_b12), .clrn((RESET)), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc1_b1));  // LC1_B1
  gmx_dffs r_lc7_b1 (.d(lut16(16'hAAAA, {1'b1, 1'b1, 1'b1, MD3})), .clk(!lc3_b20), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc7_b1));  // LC7_B1
  gmx_dffs r_lc5_b2 (.d(lut16(16'hAAAA, {1'b1, 1'b1, 1'b1, MD2})), .clk(!lc3_b20), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc5_b2));  // LC5_B2
  gmx_dffs r_lc2_b3 (.d(lut16(16'hFF00, {lc7_b3, 1'b1, 1'b1, 1'b1})), .clk(lc2_b10), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc2_b3));  // LC2_B3
  gmx_dffs r_lc3_b3 (.d(lut16(16'hF0E2, {lc3_b14, lc1_b18, lc4_b18, MD7})), .clk(lc2_b10), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc3_b3));  // LC3_B3
  gmx_dffs r_lc4_b3 (.d(lut16(16'hFC0C, {DB3, lc7_b9, lc4_b3, 1'b1})), .clk(lc2_b12), .clrn((RESET)), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc4_b3));  // LC4_B3
  gmx_dffs r_lc5_b3 (.d(lut16(16'hFF00, {lc3_b3, 1'b1, 1'b1, 1'b1})), .clk(lc2_b10), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc5_b3));  // LC5_B3
  gmx_dffs r_lc6_b3 (.d(lut16(16'hFF00, {lc2_b3, 1'b1, 1'b1, 1'b1})), .clk(lc2_b10), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc6_b3));  // LC6_B3
  gmx_dffs r_lc7_b3 (.d(lut16(16'hFF00, {lc5_b3, 1'b1, 1'b1, 1'b1})), .clk(lc2_b10), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc7_b3));  // LC7_B3
  gmx_dffs r_lc1_b4 (.d(lut16(16'h15C0, {lc1_b4, lc2_b16, lc4_b4, lc7_b4})), .clk(!lc6_b4), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc1_b4));  // LC1_B4
  gmx_dffs r_lc2_b4 (.d(lut16(16'h00FF, {lc3_b6, 1'b1, 1'b1, 1'b1})), .clk(lc2_b6), .clrn(lc1_b19), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc2_b4));  // LC2_B4
  gmx_dffs r_lc3_b4 (.d(lut16(16'hEAC0, {lc1_b4, lc2_b16, lc4_b4, lc7_b4})), .clk(!lc6_b4), .clrn(lc1_b19), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc3_b4));  // LC3_B4
  gmx_dff r_lc3_b5 (.d(lut16(16'h00FF, {lc6_b19, 1'b1, 1'b1, 1'b1})), .clk(!(p14M)), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .q(lc3_b5));  // LC3_B5
  gmx_dffs r_lc6_b5 (.d(lut16(16'h00FF, {lc6_b5, 1'b1, 1'b1, 1'b1})), .clk(!lc4_b21), .clrn(!(!lc3_b7 & !DB7)), .prn(!(!lc3_b7 & DB7)), .grst_n(grst_n), .ts(p14M), .q(lc6_b5));  // LC6_B5
  gmx_dffs r_lc2_b6 (.d(lut16(16'h3CCC, {lc4_b6, lc6_b6, lc2_b6, 1'b1})), .clk(lc2_b14), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc2_b6));  // LC2_B6
  gmx_dffs r_lc3_b6 (.d(lut16(16'h7F80, {lc3_b6, lc4_b6, lc6_b6, lc2_b6})), .clk(lc2_b14), .clrn(!lc3_b19), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc3_b6));  // LC3_B6
  gmx_dffs r_lc4_b6 (.d(lut16(16'h0FF0, {lc4_b6, lc6_b6, 1'b1, 1'b1})), .clk(lc2_b14), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc4_b6));  // LC4_B6
  gmx_dffs r_lc5_b6 (.d(lut16(16'h6AAA, {lc3_b6, lc8_b6, lc1_b6, lc5_b6})), .clk(lc2_b14), .clrn(!lc3_b19), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc5_b6));  // LC5_B6
  gmx_dffs r_lc8_b6 (.d(lut16(16'h3CF0, {lc3_b6, lc8_b6, lc1_b6, 1'b1})), .clk(lc2_b14), .clrn(!lc3_b19), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc8_b6));  // LC8_B6
  gmx_dffs r_lc2_b7 (.d(lut16(16'hFC0C, {DB6, lc7_b9, lc2_b7, 1'b1})), .clk(lc2_b12), .clrn((RESET)), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc2_b7));  // LC2_B7
  gmx_dffs r_lc4_b7 (.d(lut16(16'hF3C0, {DB2, lc4_b7, lc6_b17, 1'b1})), .clk(lc2_b12), .clrn((RESET)), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc4_b7));  // LC4_B7
  gmx_dffs r_lc7_b7 (.d(lut16(16'hAAAA, {1'b1, 1'b1, 1'b1, MD6})), .clk(!lc3_b20), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc7_b7));  // LC7_B7
  gmx_dff r_lc2_b8 (.d(lut16(16'hFF00, {lc4_b8, 1'b1, 1'b1, 1'b1})), .clk((p14M)), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .q(lc2_b8));  // LC2_B8
  gmx_dff r_lc3_b8 (.d(lut16(16'hFFF0, {lc3_b14, lc4_b18, 1'b1, 1'b1})), .clk((p14M)), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .q(lc3_b8));  // LC3_B8
  gmx_dff r_lc4_b8 (.d(lut16(16'hFF00, {lc3_b8, 1'b1, 1'b1, 1'b1})), .clk((p14M)), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .q(lc4_b8));  // LC4_B8
  gmx_dff r_lc5_b8 (.d(lut16(16'h00FF, {lc2_b8, 1'b1, 1'b1, 1'b1})), .clk((p14M)), .clrn(!lc8_b10), .prn(1'b1), .grst_n(grst_n), .q(lc5_b8));  // LC5_B8
  gmx_dffs r_lc6_b8 (.d(lut16(16'h000C, {lc1_b4, lc1_b19, MD6, 1'b1})), .clk(lc4_b14), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc6_b8));  // LC6_B8
  gmx_dffs r_lc7_b8 (.d(lut16(16'hCCCA, {lc1_b4, lc1_b19, lc3_a12, MD1})), .clk(lc4_b14), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc7_b8));  // LC7_B8
  gmx_dffs r_lc8_b8 (.d(lut16(16'hCCCA, {lc1_b4, lc1_b19, lc3_a12, MD4})), .clk(lc4_b14), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc8_b8));  // LC8_B8
  gmx_dffs r_lc5_b9 (.d(lut16(16'h00FF, {lc5_b9, 1'b1, 1'b1, 1'b1})), .clk(!lc4_b19), .clrn(!IORQ_n), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc5_b9));  // LC5_B9
  gmx_dffs r_lc3_b10 (.d(lut16(16'hFF00, {lc4_b10, 1'b1, 1'b1, 1'b1})), .clk(!MREQ_n), .clrn(M1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc3_b10));  // LC3_B10
  gmx_dffs r_lc4_b10 (.d(lut16(16'hFFFF, {1'b1, 1'b1, 1'b1, 1'b1})), .clk(!MREQ_n), .clrn(M1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc4_b10));  // LC4_B10
  gmx_dffs r_lc8_b10 (.d(lut16(16'hFC0C, {lc6_b10, lc5_b14, lc8_b10, 1'b1})), .clk(lc3_b5), .clrn(lc1_b10), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc8_b10));  // LC8_B10
  gmx_dffs r_lc3_b11 (.d(lut16(16'h000C, {lc1_b4, lc1_b19, MD7, 1'b1})), .clk(lc4_b14), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc3_b11));  // LC3_B11
  gmx_dffs r_lc4_b11 (.d(lut16(16'hCCCA, {lc1_b4, lc1_b19, lc5_a19, MD0})), .clk(lc4_b14), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc4_b11));  // LC4_B11
  gmx_dffs r_lc5_b11 (.d(lut16(16'h00FF, {lc5_b11, 1'b1, 1'b1, 1'b1})), .clk(lc2_b14), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc5_b11));  // LC5_B11
  gmx_dffs r_lc6_b11 (.d(lut16(16'h6AAA, {lc7_b20, lc3_b20, lc5_b11, lc6_b11})), .clk(lc2_b14), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc6_b11));  // LC6_B11
  gmx_dffs r_lc7_b11 (.d(lut16(16'hCCCA, {lc1_b4, lc1_b19, lc5_a19, MD3})), .clk(lc4_b14), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc7_b11));  // LC7_B11
  gmx_dffs r_lc8_b11 (.d(lut16(16'hCCCA, {lc1_b4, lc1_b19, lc1_a12, MD5})), .clk(lc4_b14), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc8_b11));  // LC8_B11
  gmx_dffs r_lc3_b12 (.d(lut16(16'hCCCA, {lc1_b4, lc1_b19, lc1_a12, MD2})), .clk(lc4_b14), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc3_b12));  // LC3_B12
  gmx_dffs r_lc4_b12 (.d(lut16(16'hFFFF, {1'b1, 1'b1, 1'b1, 1'b1})), .clk(lc4_b19), .clrn(lc6_a15), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc4_b12));  // LC4_B12
  gmx_dffs r_lc5_b12 (.d(lut16(16'hFF00, {lc4_b12, 1'b1, 1'b1, 1'b1})), .clk(lc4_b19), .clrn(lc6_a15), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc5_b12));  // LC5_B12
  gmx_dffs r_lc6_b12 (.d(lut16(16'hFF00, {lc5_b12, 1'b1, 1'b1, 1'b1})), .clk(lc4_b19), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc6_b12));  // LC6_B12
  gmx_dffs r_lc8_b12 (.d(lut16(16'hFF00, {lc6_b12, 1'b1, 1'b1, 1'b1})), .clk(lc4_b19), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc8_b12));  // LC8_B12
  gmx_dffs r_lc1_b13 (.d(lut16(16'h00FF, {lc1_b13, 1'b1, 1'b1, 1'b1})), .clk(lc6_b4), .clrn(!lc3_b4), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc1_b13));  // LC1_B13
  gmx_dffs r_lc3_b13 (.d(lut16(16'h7F80, {lc3_b13, lc1_b13, lc4_b13, lc6_b13})), .clk(lc6_b4), .clrn(!lc3_b4), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc3_b13));  // LC3_B13
  gmx_dffs r_lc4_b13 (.d(lut16(16'h0FF0, {lc1_b13, lc4_b13, 1'b1, 1'b1})), .clk(lc6_b4), .clrn(!lc3_b4), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc4_b13));  // LC4_B13
  gmx_dffs r_lc6_b13 (.d(lut16(16'h3CCC, {lc1_b13, lc4_b13, lc6_b13, 1'b1})), .clk(lc6_b4), .clrn(!lc3_b4), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc6_b13));  // LC6_B13
  gmx_dff r_lc2_b14 (.d(lut16(16'h00FF, {lc2_b14, 1'b1, 1'b1, 1'b1})), .clk((p14M)), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .q(lc2_b14));  // LC2_B14
  gmx_dffs r_lc6_b14 (.d(lut16(16'h00FF, {lc1_b16, 1'b1, 1'b1, 1'b1})), .clk(lc4_b6), .clrn(!lc6_b4), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc6_b14));  // LC6_B14
  gmx_dffs r_lc5_b15 (.d(lut16(16'hFFFF, {1'b1, 1'b1, 1'b1, 1'b1})), .clk(!lc6_b14), .clrn(!lc4_b6), .prn(!lc1_b16), .grst_n(grst_n), .ts(p14M), .q(lc5_b15));  // LC5_B15
  gmx_dffs r_lc1_b16 (.d(lut16(16'hF30C, {lc1_b16, lc6_b16, lc5_b16, 1'b1})), .clk(lc8_b16), .clrn(lc1_b4), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc1_b16));  // LC1_B16
  gmx_dffs r_lc2_b16 (.d(lut16(16'h78F0, {lc6_b16, lc2_b16, lc5_b16, lc7_b16})), .clk(!lc3_b13), .clrn(!lc3_b4), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc2_b16));  // LC2_B16
  gmx_dffs r_lc5_b16 (.d(lut16(16'h0FF0, {lc5_b16, lc7_b16, 1'b1, 1'b1})), .clk(!lc3_b13), .clrn(!lc3_b4), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc5_b16));  // LC5_B16
  gmx_dffs r_lc6_b16 (.d(lut16(16'h3FC0, {lc6_b16, lc5_b16, lc7_b16, 1'b1})), .clk(!lc3_b13), .clrn(!lc3_b4), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc6_b16));  // LC6_B16
  gmx_dffs r_lc7_b16 (.d(lut16(16'h00FF, {lc7_b16, 1'b1, 1'b1, 1'b1})), .clk(!lc3_b13), .clrn(!lc3_b4), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc7_b16));  // LC7_B16
  gmx_dffs r_lc3_b17 (.d(lut16(16'h00FF, {lc3_b17, 1'b1, 1'b1, 1'b1})), .clk(lc8_a5), .clrn(lc4_a11), .prn(lc2_a11), .grst_n(grst_n), .ts(p14M), .q(lc3_b17));  // LC3_B17
  gmx_dffs r_lc1_b18 (.d(lut16(16'hF0E2, {lc3_b14, lc8_b18, lc4_b18, MD6})), .clk(lc2_b10), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc1_b18));  // LC1_B18
  gmx_dffs r_lc2_b18 (.d(lut16(16'h000C, {lc3_b14, lc4_b18, MD0, 1'b1})), .clk(lc2_b10), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc2_b18));  // LC2_B18
  gmx_dffs r_lc3_b18 (.d(lut16(16'hF0E2, {lc3_b14, lc2_b18, lc4_b18, MD1})), .clk(lc2_b10), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc3_b18));  // LC3_B18
  gmx_dffs r_lc5_b18 (.d(lut16(16'hF0E2, {lc3_b14, lc3_b18, lc4_b18, MD2})), .clk(lc2_b10), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc5_b18));  // LC5_B18
  gmx_dffs r_lc6_b18 (.d(lut16(16'hF0E2, {lc3_b14, lc5_b18, lc4_b18, MD3})), .clk(lc2_b10), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc6_b18));  // LC6_B18
  gmx_dffs r_lc7_b18 (.d(lut16(16'hF0E2, {lc3_b14, lc6_b18, lc4_b18, MD4})), .clk(lc2_b10), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc7_b18));  // LC7_B18
  gmx_dffs r_lc8_b18 (.d(lut16(16'hF0E2, {lc3_b14, lc7_b18, lc4_b18, MD5})), .clk(lc2_b10), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc8_b18));  // LC8_B18
  gmx_dffs r_lc1_b19 (.d(lut16(16'h0F88, {lc1_b19, lc2_b19, lc5_b19, lc5_b6})), .clk(lc2_b14), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc1_b19));  // LC1_B19
  gmx_dffs r_lc3_b19 (.d(lut16(16'hCCA0, {lc1_b19, lc5_b19, lc2_b19, lc5_b6})), .clk(lc2_b14), .clrn(!lc7_b20), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc3_b19));  // LC3_B19
  gmx_dffs r_lc6_b19 (.d(lut16(16'hFF00, {lc5_b11, 1'b1, 1'b1, 1'b1})), .clk(!lc2_b14), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc6_b19));  // LC6_B19
  gmx_dffs r_lc8_b19 (.d(lut16(16'hF1E0, {lc6_b5, lc8_b19, IORQ_n, lc6_b19})), .clk(lc2_b14), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc8_b19));  // LC8_B19
  gmx_dffs r_lc1_b20 (.d(lut16(16'h00FF, {lc5_b14, 1'b1, 1'b1, 1'b1})), .clk(lc5_b11), .clrn(lc6_a10), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc1_b20));  // LC1_B20
  gmx_dffs r_lc3_b20 (.d(lut16(16'h3CF0, {lc7_b20, lc3_b20, lc5_b11, 1'b1})), .clk(lc2_b14), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc3_b20));  // LC3_B20
  gmx_dffs r_lc7_b20 (.d(lut16(16'h0FF0, {lc7_b20, lc5_b11, 1'b1, 1'b1})), .clk(lc2_b14), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc7_b20));  // LC7_B20
  gmx_dffs r_lc2_b21 (.d(lut16(16'hFFFF, {1'b1, 1'b1, 1'b1, 1'b1})), .clk(lc7_b21), .clrn(lc6_b21), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc2_b21));  // LC2_B21
  gmx_dffs r_lc4_b21 (.d(lut16(16'hAAAA, {1'b1, 1'b1, 1'b1, TRBB})), .clk(lc2_b21), .clrn(1'b1), .prn(1'b1), .grst_n(grst_n), .ts(p14M), .q(lc4_b21));  // LC4_B21
endmodule
