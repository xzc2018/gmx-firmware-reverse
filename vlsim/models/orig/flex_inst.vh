  wire scorpion_G_o;
  wire scorpion_G_oe;
  wire scorpion_DB7_o;
  wire scorpion_DB7_oe;
  wire scorpion_R_o;
  wire scorpion_R_oe;
  wire scorpion_DB6_o;
  wire scorpion_DB6_oe;
  wire scorpion_DB5_o;
  wire scorpion_DB5_oe;
  wire scorpion_DB4_o;
  wire scorpion_DB4_oe;
  wire scorpion_DB3_o;
  wire scorpion_DB3_oe;
  wire scorpion_DB2_o;
  wire scorpion_DB2_oe;
  wire scorpion_DB1_o;
  wire scorpion_DB1_oe;
  wire scorpion_DB0_o;
  wire scorpion_DB0_oe;
  wire scorpion_MA0_o;
  wire scorpion_MA0_oe;
  wire scorpion_MA1_o;
  wire scorpion_MA1_oe;
  wire scorpion_MA2_o;
  wire scorpion_MA2_oe;
  wire scorpion_MA3_o;
  wire scorpion_MA3_oe;
  wire scorpion_MA4_o;
  wire scorpion_MA4_oe;
  wire scorpion_MA5_o;
  wire scorpion_MA5_oe;
  wire scorpion_MA6_o;
  wire scorpion_MA6_oe;
  wire scorpion_MA7_o;
  wire scorpion_MA7_oe;
  wire scorpion_MA8_o;
  wire scorpion_MA8_oe;
  wire scorpion_MA9_o;
  wire scorpion_MA9_oe;
  wire scorpion_RAS_n_o;
  wire scorpion_RAS_n_oe;
  wire scorpion_CAS0_n_o;
  wire scorpion_CAS0_n_oe;
  wire scorpion_CAS1_o;
  wire scorpion_CAS1_oe;
  wire scorpion_WE_n_o;
  wire scorpion_WE_n_oe;
  wire scorpion_WAIT_n_o;
  wire scorpion_WAIT_n_oe;
  wire scorpion_RAM_n_o;
  wire scorpion_RAM_n_oe;
  wire scorpion_CLKCPU_o;
  wire scorpion_CLKCPU_oe;
  wire scorpion_EBUF_o;
  wire scorpion_EBUF_oe;
  wire scorpion_INT_o;
  wire scorpion_INT_oe;
  wire scorpion_TRBB_o;
  wire scorpion_TRBB_oe;
  wire scorpion_WRBUF_o;
  wire scorpion_WRBUF_oe;
  wire scorpion_RDR_n_o;
  wire scorpion_RDR_n_oe;
  wire scorpion_WROUT_n_o;
  wire scorpion_WROUT_n_oe;
  wire scorpion_VS_o;
  wire scorpion_VS_oe;
  wire scorpion_SYNC_o;
  wire scorpion_SYNC_oe;
  wire scorpion_I_o;
  wire scorpion_I_oe;
  wire scorpion_B_o;
  wire scorpion_B_oe;
  flex_scorpion u_scorpion (
    .DB7_i(dbx[7]),
    .DB6_i(dbx[6]),
    .DB5_i(dbx[5]),
    .DB4_i(dbx[4]),
    .DB3_i(dbx[3]),
    .DB2_i(dbx[2]),
    .p14M(clk14),
    .DB1_i(dbx[1]),
    .DB0_i(dbx[0]),
    .MD1(md[1]),
    .MD2(md[2]),
    .MD3(md[3]),
    .MD4(md[4]),
    .MD5(md[5]),
    .MD6(md[6]),
    .MD0(md[0]),
    .RD_n(z_rd),
    .IORQ_n(z_iorq),
    .M1(z_m1),
    .MG(magic_n),
    .MREQ_n(z_mreq),
    .MD7(md[7]),
    .TRBB_i(trbb),
    .A15(abus[15]),
    .A14(abus[14]),
    .A12(abus[12]),
    .A11(abus[11]),
    .A10(abus[10]),
    .A9(abus[9]),
    .A8(abus[8]),
    .A7(abus[7]),
    .A6(abus[6]),
    .A5(abus[5]),
    .A4(abus[4]),
    .A3(abus[3]),
    .A2(abus[2]),
    .A1(abus[1]),
    .RESET(reset),
    .A0(abus[0]),
    .A13(abus[13]),
    .G_o(scorpion_G_o),
    .G_oe(scorpion_G_oe),
    .DB7_o(scorpion_DB7_o),
    .DB7_oe(scorpion_DB7_oe),
    .R_o(scorpion_R_o),
    .R_oe(scorpion_R_oe),
    .DB6_o(scorpion_DB6_o),
    .DB6_oe(scorpion_DB6_oe),
    .DB5_o(scorpion_DB5_o),
    .DB5_oe(scorpion_DB5_oe),
    .DB4_o(scorpion_DB4_o),
    .DB4_oe(scorpion_DB4_oe),
    .DB3_o(scorpion_DB3_o),
    .DB3_oe(scorpion_DB3_oe),
    .DB2_o(scorpion_DB2_o),
    .DB2_oe(scorpion_DB2_oe),
    .DB1_o(scorpion_DB1_o),
    .DB1_oe(scorpion_DB1_oe),
    .DB0_o(scorpion_DB0_o),
    .DB0_oe(scorpion_DB0_oe),
    .MA0_o(scorpion_MA0_o),
    .MA0_oe(scorpion_MA0_oe),
    .MA1_o(scorpion_MA1_o),
    .MA1_oe(scorpion_MA1_oe),
    .MA2_o(scorpion_MA2_o),
    .MA2_oe(scorpion_MA2_oe),
    .MA3_o(scorpion_MA3_o),
    .MA3_oe(scorpion_MA3_oe),
    .MA4_o(scorpion_MA4_o),
    .MA4_oe(scorpion_MA4_oe),
    .MA5_o(scorpion_MA5_o),
    .MA5_oe(scorpion_MA5_oe),
    .MA6_o(scorpion_MA6_o),
    .MA6_oe(scorpion_MA6_oe),
    .MA7_o(scorpion_MA7_o),
    .MA7_oe(scorpion_MA7_oe),
    .MA8_o(scorpion_MA8_o),
    .MA8_oe(scorpion_MA8_oe),
    .MA9_o(scorpion_MA9_o),
    .MA9_oe(scorpion_MA9_oe),
    .RAS_n_o(scorpion_RAS_n_o),
    .RAS_n_oe(scorpion_RAS_n_oe),
    .CAS0_n_o(scorpion_CAS0_n_o),
    .CAS0_n_oe(scorpion_CAS0_n_oe),
    .CAS1_o(scorpion_CAS1_o),
    .CAS1_oe(scorpion_CAS1_oe),
    .WE_n_o(scorpion_WE_n_o),
    .WE_n_oe(scorpion_WE_n_oe),
    .WAIT_n_o(scorpion_WAIT_n_o),
    .WAIT_n_oe(scorpion_WAIT_n_oe),
    .RAM_n_o(scorpion_RAM_n_o),
    .RAM_n_oe(scorpion_RAM_n_oe),
    .CLKCPU_o(scorpion_CLKCPU_o),
    .CLKCPU_oe(scorpion_CLKCPU_oe),
    .EBUF_o(scorpion_EBUF_o),
    .EBUF_oe(scorpion_EBUF_oe),
    .INT_o(scorpion_INT_o),
    .INT_oe(scorpion_INT_oe),
    .TRBB_o(scorpion_TRBB_o),
    .TRBB_oe(scorpion_TRBB_oe),
    .WRBUF_o(scorpion_WRBUF_o),
    .WRBUF_oe(scorpion_WRBUF_oe),
    .RDR_n_o(scorpion_RDR_n_o),
    .RDR_n_oe(scorpion_RDR_n_oe),
    .WROUT_n_o(scorpion_WROUT_n_o),
    .WROUT_n_oe(scorpion_WROUT_n_oe),
    .VS_o(scorpion_VS_o),
    .VS_oe(scorpion_VS_oe),
    .SYNC_o(scorpion_SYNC_o),
    .SYNC_oe(scorpion_SYNC_oe),
    .I_o(scorpion_I_o),
    .I_oe(scorpion_I_oe),
    .B_o(scorpion_B_o),
    .B_oe(scorpion_B_oe),
    .grst_n(flex_grst_n && flex_sel == 2'd1));
  wire pentagon_G_o;
  wire pentagon_G_oe;
  wire pentagon_DB7_o;
  wire pentagon_DB7_oe;
  wire pentagon_R_o;
  wire pentagon_R_oe;
  wire pentagon_DB6_o;
  wire pentagon_DB6_oe;
  wire pentagon_DB5_o;
  wire pentagon_DB5_oe;
  wire pentagon_DB4_o;
  wire pentagon_DB4_oe;
  wire pentagon_DB3_o;
  wire pentagon_DB3_oe;
  wire pentagon_DB2_o;
  wire pentagon_DB2_oe;
  wire pentagon_DB1_o;
  wire pentagon_DB1_oe;
  wire pentagon_DB0_o;
  wire pentagon_DB0_oe;
  wire pentagon_MA0_o;
  wire pentagon_MA0_oe;
  wire pentagon_MA1_o;
  wire pentagon_MA1_oe;
  wire pentagon_MA2_o;
  wire pentagon_MA2_oe;
  wire pentagon_MA3_o;
  wire pentagon_MA3_oe;
  wire pentagon_MA4_o;
  wire pentagon_MA4_oe;
  wire pentagon_MA5_o;
  wire pentagon_MA5_oe;
  wire pentagon_MA6_o;
  wire pentagon_MA6_oe;
  wire pentagon_MA7_o;
  wire pentagon_MA7_oe;
  wire pentagon_MA8_o;
  wire pentagon_MA8_oe;
  wire pentagon_MA9_o;
  wire pentagon_MA9_oe;
  wire pentagon_RAS_n_o;
  wire pentagon_RAS_n_oe;
  wire pentagon_CAS0_n_o;
  wire pentagon_CAS0_n_oe;
  wire pentagon_CAS1_o;
  wire pentagon_CAS1_oe;
  wire pentagon_WE_n_o;
  wire pentagon_WE_n_oe;
  wire pentagon_WAIT_n_o;
  wire pentagon_WAIT_n_oe;
  wire pentagon_RAM_n_o;
  wire pentagon_RAM_n_oe;
  wire pentagon_CLKCPU_o;
  wire pentagon_CLKCPU_oe;
  wire pentagon_EBUF_o;
  wire pentagon_EBUF_oe;
  wire pentagon_INT_o;
  wire pentagon_INT_oe;
  wire pentagon_TRBB_o;
  wire pentagon_TRBB_oe;
  wire pentagon_WRBUF_o;
  wire pentagon_WRBUF_oe;
  wire pentagon_RDR_n_o;
  wire pentagon_RDR_n_oe;
  wire pentagon_WROUT_n_o;
  wire pentagon_WROUT_n_oe;
  wire pentagon_VS_o;
  wire pentagon_VS_oe;
  wire pentagon_SYNC_o;
  wire pentagon_SYNC_oe;
  wire pentagon_I_o;
  wire pentagon_I_oe;
  wire pentagon_B_o;
  wire pentagon_B_oe;
  flex_pentagon u_pentagon (
    .DB7_i(dbx[7]),
    .DB6_i(dbx[6]),
    .DB5_i(dbx[5]),
    .DB4_i(dbx[4]),
    .DB3_i(dbx[3]),
    .DB2_i(dbx[2]),
    .p14M(clk14),
    .DB1_i(dbx[1]),
    .DB0_i(dbx[0]),
    .MD1(md[1]),
    .MD2(md[2]),
    .MD3(md[3]),
    .MD4(md[4]),
    .MD5(md[5]),
    .MD6(md[6]),
    .MD0(md[0]),
    .RD_n(z_rd),
    .IORQ_n(z_iorq),
    .M1(z_m1),
    .MG(magic_n),
    .MREQ_n(z_mreq),
    .MD7(md[7]),
    .TRBB_i(trbb),
    .A15(abus[15]),
    .A14(abus[14]),
    .A12(abus[12]),
    .A11(abus[11]),
    .A10(abus[10]),
    .A9(abus[9]),
    .A8(abus[8]),
    .A7(abus[7]),
    .A6(abus[6]),
    .A5(abus[5]),
    .A4(abus[4]),
    .A3(abus[3]),
    .A2(abus[2]),
    .A1(abus[1]),
    .RESET(reset),
    .A0(abus[0]),
    .A13(abus[13]),
    .G_o(pentagon_G_o),
    .G_oe(pentagon_G_oe),
    .DB7_o(pentagon_DB7_o),
    .DB7_oe(pentagon_DB7_oe),
    .R_o(pentagon_R_o),
    .R_oe(pentagon_R_oe),
    .DB6_o(pentagon_DB6_o),
    .DB6_oe(pentagon_DB6_oe),
    .DB5_o(pentagon_DB5_o),
    .DB5_oe(pentagon_DB5_oe),
    .DB4_o(pentagon_DB4_o),
    .DB4_oe(pentagon_DB4_oe),
    .DB3_o(pentagon_DB3_o),
    .DB3_oe(pentagon_DB3_oe),
    .DB2_o(pentagon_DB2_o),
    .DB2_oe(pentagon_DB2_oe),
    .DB1_o(pentagon_DB1_o),
    .DB1_oe(pentagon_DB1_oe),
    .DB0_o(pentagon_DB0_o),
    .DB0_oe(pentagon_DB0_oe),
    .MA0_o(pentagon_MA0_o),
    .MA0_oe(pentagon_MA0_oe),
    .MA1_o(pentagon_MA1_o),
    .MA1_oe(pentagon_MA1_oe),
    .MA2_o(pentagon_MA2_o),
    .MA2_oe(pentagon_MA2_oe),
    .MA3_o(pentagon_MA3_o),
    .MA3_oe(pentagon_MA3_oe),
    .MA4_o(pentagon_MA4_o),
    .MA4_oe(pentagon_MA4_oe),
    .MA5_o(pentagon_MA5_o),
    .MA5_oe(pentagon_MA5_oe),
    .MA6_o(pentagon_MA6_o),
    .MA6_oe(pentagon_MA6_oe),
    .MA7_o(pentagon_MA7_o),
    .MA7_oe(pentagon_MA7_oe),
    .MA8_o(pentagon_MA8_o),
    .MA8_oe(pentagon_MA8_oe),
    .MA9_o(pentagon_MA9_o),
    .MA9_oe(pentagon_MA9_oe),
    .RAS_n_o(pentagon_RAS_n_o),
    .RAS_n_oe(pentagon_RAS_n_oe),
    .CAS0_n_o(pentagon_CAS0_n_o),
    .CAS0_n_oe(pentagon_CAS0_n_oe),
    .CAS1_o(pentagon_CAS1_o),
    .CAS1_oe(pentagon_CAS1_oe),
    .WE_n_o(pentagon_WE_n_o),
    .WE_n_oe(pentagon_WE_n_oe),
    .WAIT_n_o(pentagon_WAIT_n_o),
    .WAIT_n_oe(pentagon_WAIT_n_oe),
    .RAM_n_o(pentagon_RAM_n_o),
    .RAM_n_oe(pentagon_RAM_n_oe),
    .CLKCPU_o(pentagon_CLKCPU_o),
    .CLKCPU_oe(pentagon_CLKCPU_oe),
    .EBUF_o(pentagon_EBUF_o),
    .EBUF_oe(pentagon_EBUF_oe),
    .INT_o(pentagon_INT_o),
    .INT_oe(pentagon_INT_oe),
    .TRBB_o(pentagon_TRBB_o),
    .TRBB_oe(pentagon_TRBB_oe),
    .WRBUF_o(pentagon_WRBUF_o),
    .WRBUF_oe(pentagon_WRBUF_oe),
    .RDR_n_o(pentagon_RDR_n_o),
    .RDR_n_oe(pentagon_RDR_n_oe),
    .WROUT_n_o(pentagon_WROUT_n_o),
    .WROUT_n_oe(pentagon_WROUT_n_oe),
    .VS_o(pentagon_VS_o),
    .VS_oe(pentagon_VS_oe),
    .SYNC_o(pentagon_SYNC_o),
    .SYNC_oe(pentagon_SYNC_oe),
    .I_o(pentagon_I_o),
    .I_oe(pentagon_I_oe),
    .B_o(pentagon_B_o),
    .B_oe(pentagon_B_oe),
    .grst_n(flex_grst_n && flex_sel == 2'd2));
  assign f_G_o = (flex_sel == 2'd1) ? scorpion_G_o : (flex_sel == 2'd2) ? pentagon_G_o : 1'b0;
  assign f_G_oe = (flex_sel == 2'd1) ? scorpion_G_oe : (flex_sel == 2'd2) ? pentagon_G_oe : 1'b0;
  assign f_DB7_o = (flex_sel == 2'd1) ? scorpion_DB7_o : (flex_sel == 2'd2) ? pentagon_DB7_o : 1'b0;
  assign f_DB7_oe = (flex_sel == 2'd1) ? scorpion_DB7_oe : (flex_sel == 2'd2) ? pentagon_DB7_oe : 1'b0;
  assign f_R_o = (flex_sel == 2'd1) ? scorpion_R_o : (flex_sel == 2'd2) ? pentagon_R_o : 1'b0;
  assign f_R_oe = (flex_sel == 2'd1) ? scorpion_R_oe : (flex_sel == 2'd2) ? pentagon_R_oe : 1'b0;
  assign f_DB6_o = (flex_sel == 2'd1) ? scorpion_DB6_o : (flex_sel == 2'd2) ? pentagon_DB6_o : 1'b0;
  assign f_DB6_oe = (flex_sel == 2'd1) ? scorpion_DB6_oe : (flex_sel == 2'd2) ? pentagon_DB6_oe : 1'b0;
  assign f_DB5_o = (flex_sel == 2'd1) ? scorpion_DB5_o : (flex_sel == 2'd2) ? pentagon_DB5_o : 1'b0;
  assign f_DB5_oe = (flex_sel == 2'd1) ? scorpion_DB5_oe : (flex_sel == 2'd2) ? pentagon_DB5_oe : 1'b0;
  assign f_DB4_o = (flex_sel == 2'd1) ? scorpion_DB4_o : (flex_sel == 2'd2) ? pentagon_DB4_o : 1'b0;
  assign f_DB4_oe = (flex_sel == 2'd1) ? scorpion_DB4_oe : (flex_sel == 2'd2) ? pentagon_DB4_oe : 1'b0;
  assign f_DB3_o = (flex_sel == 2'd1) ? scorpion_DB3_o : (flex_sel == 2'd2) ? pentagon_DB3_o : 1'b0;
  assign f_DB3_oe = (flex_sel == 2'd1) ? scorpion_DB3_oe : (flex_sel == 2'd2) ? pentagon_DB3_oe : 1'b0;
  assign f_DB2_o = (flex_sel == 2'd1) ? scorpion_DB2_o : (flex_sel == 2'd2) ? pentagon_DB2_o : 1'b0;
  assign f_DB2_oe = (flex_sel == 2'd1) ? scorpion_DB2_oe : (flex_sel == 2'd2) ? pentagon_DB2_oe : 1'b0;
  assign f_DB1_o = (flex_sel == 2'd1) ? scorpion_DB1_o : (flex_sel == 2'd2) ? pentagon_DB1_o : 1'b0;
  assign f_DB1_oe = (flex_sel == 2'd1) ? scorpion_DB1_oe : (flex_sel == 2'd2) ? pentagon_DB1_oe : 1'b0;
  assign f_DB0_o = (flex_sel == 2'd1) ? scorpion_DB0_o : (flex_sel == 2'd2) ? pentagon_DB0_o : 1'b0;
  assign f_DB0_oe = (flex_sel == 2'd1) ? scorpion_DB0_oe : (flex_sel == 2'd2) ? pentagon_DB0_oe : 1'b0;
  assign f_MA0_o = (flex_sel == 2'd1) ? scorpion_MA0_o : (flex_sel == 2'd2) ? pentagon_MA0_o : 1'b0;
  assign f_MA0_oe = (flex_sel == 2'd1) ? scorpion_MA0_oe : (flex_sel == 2'd2) ? pentagon_MA0_oe : 1'b0;
  assign f_MA1_o = (flex_sel == 2'd1) ? scorpion_MA1_o : (flex_sel == 2'd2) ? pentagon_MA1_o : 1'b0;
  assign f_MA1_oe = (flex_sel == 2'd1) ? scorpion_MA1_oe : (flex_sel == 2'd2) ? pentagon_MA1_oe : 1'b0;
  assign f_MA2_o = (flex_sel == 2'd1) ? scorpion_MA2_o : (flex_sel == 2'd2) ? pentagon_MA2_o : 1'b0;
  assign f_MA2_oe = (flex_sel == 2'd1) ? scorpion_MA2_oe : (flex_sel == 2'd2) ? pentagon_MA2_oe : 1'b0;
  assign f_MA3_o = (flex_sel == 2'd1) ? scorpion_MA3_o : (flex_sel == 2'd2) ? pentagon_MA3_o : 1'b0;
  assign f_MA3_oe = (flex_sel == 2'd1) ? scorpion_MA3_oe : (flex_sel == 2'd2) ? pentagon_MA3_oe : 1'b0;
  assign f_MA4_o = (flex_sel == 2'd1) ? scorpion_MA4_o : (flex_sel == 2'd2) ? pentagon_MA4_o : 1'b0;
  assign f_MA4_oe = (flex_sel == 2'd1) ? scorpion_MA4_oe : (flex_sel == 2'd2) ? pentagon_MA4_oe : 1'b0;
  assign f_MA5_o = (flex_sel == 2'd1) ? scorpion_MA5_o : (flex_sel == 2'd2) ? pentagon_MA5_o : 1'b0;
  assign f_MA5_oe = (flex_sel == 2'd1) ? scorpion_MA5_oe : (flex_sel == 2'd2) ? pentagon_MA5_oe : 1'b0;
  assign f_MA6_o = (flex_sel == 2'd1) ? scorpion_MA6_o : (flex_sel == 2'd2) ? pentagon_MA6_o : 1'b0;
  assign f_MA6_oe = (flex_sel == 2'd1) ? scorpion_MA6_oe : (flex_sel == 2'd2) ? pentagon_MA6_oe : 1'b0;
  assign f_MA7_o = (flex_sel == 2'd1) ? scorpion_MA7_o : (flex_sel == 2'd2) ? pentagon_MA7_o : 1'b0;
  assign f_MA7_oe = (flex_sel == 2'd1) ? scorpion_MA7_oe : (flex_sel == 2'd2) ? pentagon_MA7_oe : 1'b0;
  assign f_MA8_o = (flex_sel == 2'd1) ? scorpion_MA8_o : (flex_sel == 2'd2) ? pentagon_MA8_o : 1'b0;
  assign f_MA8_oe = (flex_sel == 2'd1) ? scorpion_MA8_oe : (flex_sel == 2'd2) ? pentagon_MA8_oe : 1'b0;
  assign f_MA9_o = (flex_sel == 2'd1) ? scorpion_MA9_o : (flex_sel == 2'd2) ? pentagon_MA9_o : 1'b0;
  assign f_MA9_oe = (flex_sel == 2'd1) ? scorpion_MA9_oe : (flex_sel == 2'd2) ? pentagon_MA9_oe : 1'b0;
  assign f_RAS_n_o = (flex_sel == 2'd1) ? scorpion_RAS_n_o : (flex_sel == 2'd2) ? pentagon_RAS_n_o : 1'b0;
  assign f_RAS_n_oe = (flex_sel == 2'd1) ? scorpion_RAS_n_oe : (flex_sel == 2'd2) ? pentagon_RAS_n_oe : 1'b0;
  assign f_CAS0_n_o = (flex_sel == 2'd1) ? scorpion_CAS0_n_o : (flex_sel == 2'd2) ? pentagon_CAS0_n_o : 1'b0;
  assign f_CAS0_n_oe = (flex_sel == 2'd1) ? scorpion_CAS0_n_oe : (flex_sel == 2'd2) ? pentagon_CAS0_n_oe : 1'b0;
  assign f_CAS1_o = (flex_sel == 2'd1) ? scorpion_CAS1_o : (flex_sel == 2'd2) ? pentagon_CAS1_o : 1'b0;
  assign f_CAS1_oe = (flex_sel == 2'd1) ? scorpion_CAS1_oe : (flex_sel == 2'd2) ? pentagon_CAS1_oe : 1'b0;
  assign f_WE_n_o = (flex_sel == 2'd1) ? scorpion_WE_n_o : (flex_sel == 2'd2) ? pentagon_WE_n_o : 1'b0;
  assign f_WE_n_oe = (flex_sel == 2'd1) ? scorpion_WE_n_oe : (flex_sel == 2'd2) ? pentagon_WE_n_oe : 1'b0;
  assign f_WAIT_n_o = (flex_sel == 2'd1) ? scorpion_WAIT_n_o : (flex_sel == 2'd2) ? pentagon_WAIT_n_o : 1'b0;
  assign f_WAIT_n_oe = (flex_sel == 2'd1) ? scorpion_WAIT_n_oe : (flex_sel == 2'd2) ? pentagon_WAIT_n_oe : 1'b0;
  assign f_RAM_n_o = (flex_sel == 2'd1) ? scorpion_RAM_n_o : (flex_sel == 2'd2) ? pentagon_RAM_n_o : 1'b0;
  assign f_RAM_n_oe = (flex_sel == 2'd1) ? scorpion_RAM_n_oe : (flex_sel == 2'd2) ? pentagon_RAM_n_oe : 1'b0;
  assign f_CLKCPU_o = (flex_sel == 2'd1) ? scorpion_CLKCPU_o : (flex_sel == 2'd2) ? pentagon_CLKCPU_o : 1'b0;
  assign f_CLKCPU_oe = (flex_sel == 2'd1) ? scorpion_CLKCPU_oe : (flex_sel == 2'd2) ? pentagon_CLKCPU_oe : 1'b0;
  assign f_EBUF_o = (flex_sel == 2'd1) ? scorpion_EBUF_o : (flex_sel == 2'd2) ? pentagon_EBUF_o : 1'b0;
  assign f_EBUF_oe = (flex_sel == 2'd1) ? scorpion_EBUF_oe : (flex_sel == 2'd2) ? pentagon_EBUF_oe : 1'b0;
  assign f_INT_o = (flex_sel == 2'd1) ? scorpion_INT_o : (flex_sel == 2'd2) ? pentagon_INT_o : 1'b0;
  assign f_INT_oe = (flex_sel == 2'd1) ? scorpion_INT_oe : (flex_sel == 2'd2) ? pentagon_INT_oe : 1'b0;
  assign f_TRBB_o = (flex_sel == 2'd1) ? scorpion_TRBB_o : (flex_sel == 2'd2) ? pentagon_TRBB_o : 1'b0;
  assign f_TRBB_oe = (flex_sel == 2'd1) ? scorpion_TRBB_oe : (flex_sel == 2'd2) ? pentagon_TRBB_oe : 1'b0;
  assign f_WRBUF_o = (flex_sel == 2'd1) ? scorpion_WRBUF_o : (flex_sel == 2'd2) ? pentagon_WRBUF_o : 1'b0;
  assign f_WRBUF_oe = (flex_sel == 2'd1) ? scorpion_WRBUF_oe : (flex_sel == 2'd2) ? pentagon_WRBUF_oe : 1'b0;
  assign f_RDR_n_o = (flex_sel == 2'd1) ? scorpion_RDR_n_o : (flex_sel == 2'd2) ? pentagon_RDR_n_o : 1'b0;
  assign f_RDR_n_oe = (flex_sel == 2'd1) ? scorpion_RDR_n_oe : (flex_sel == 2'd2) ? pentagon_RDR_n_oe : 1'b0;
  assign f_WROUT_n_o = (flex_sel == 2'd1) ? scorpion_WROUT_n_o : (flex_sel == 2'd2) ? pentagon_WROUT_n_o : 1'b0;
  assign f_WROUT_n_oe = (flex_sel == 2'd1) ? scorpion_WROUT_n_oe : (flex_sel == 2'd2) ? pentagon_WROUT_n_oe : 1'b0;
  assign f_VS_o = (flex_sel == 2'd1) ? scorpion_VS_o : (flex_sel == 2'd2) ? pentagon_VS_o : 1'b0;
  assign f_VS_oe = (flex_sel == 2'd1) ? scorpion_VS_oe : (flex_sel == 2'd2) ? pentagon_VS_oe : 1'b0;
  assign f_SYNC_o = (flex_sel == 2'd1) ? scorpion_SYNC_o : (flex_sel == 2'd2) ? pentagon_SYNC_o : 1'b0;
  assign f_SYNC_oe = (flex_sel == 2'd1) ? scorpion_SYNC_oe : (flex_sel == 2'd2) ? pentagon_SYNC_oe : 1'b0;
  assign f_I_o = (flex_sel == 2'd1) ? scorpion_I_o : (flex_sel == 2'd2) ? pentagon_I_o : 1'b0;
  assign f_I_oe = (flex_sel == 2'd1) ? scorpion_I_oe : (flex_sel == 2'd2) ? pentagon_I_oe : 1'b0;
  assign f_B_o = (flex_sel == 2'd1) ? scorpion_B_o : (flex_sel == 2'd2) ? pentagon_B_o : 1'b0;
  assign f_B_oe = (flex_sel == 2'd1) ? scorpion_B_oe : (flex_sel == 2'd2) ? pentagon_B_oe : 1'b0;
