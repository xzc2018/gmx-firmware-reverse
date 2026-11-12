// Scorpion GMX board model (Verilator). Sources: ref/GMX_sch_verify_ver2.pdf, sheets 1-2.
//   DD1 Z80 (tv80z), DD3 FLEX EPF8452A (flex_scorpion / flex_pentagon, selected by the configuration
//   controller in C++), DD13 CPLD EPM7064S (cpld_gmx), DD2 Flash 28F400 (byte mode, read via DPI),
//   SIMM bank 0 (data MD) and bank 1 (data SD), DD4/DD8 74ABT245 (D -> SD/MD while WE# = 0),
//   DD5 74HC373 (SD -> MD, LE = CAS1, OE# = EBUF), DD9 373 (MD -> D, LE = WRBUF, OE# = RAM/),
//   DD11 245 (A = DB, B = D, T = DIR, OE# = EO), diode ANDs: CSROM = RDR/ & CONF_DONE,
//   RESET = RESET_mb & CONF_DONE, DD10.3/DD10.6: RST_DLY = delayed RESET.
//   Motherboard (Scorpion ZS-256 side of the Z80 socket): keyboard on port #FE (A0 = 0) drives DB,
//   NMI from the Magic button.
module gmx_board (
  input         clk14,          // 14 MHz (ZQ1)
  input         mb_reset_n,     // motherboard RESET
  input         magic_n,        // Magic button (MG and NMI)
  input         turbo_n,        // TRBB button
  input  [1:0]  flex_sel,       // 0 = FLEX not configured, 1 = Scorpion, 2 = PentaGON
  input         flex_grst_n,    // 0 = FLEX registers held cleared (configuration)
  input  [39:0] keys,           // key matrix, 1 = pressed; bit = row*5 + column (row = A8..A15 line)
  // DRAM refresh check: rows refreshed by RAS (row address) and by CAS-before-RAS (internal counter)
  input         dram_r1024,     // 1 = 1024-row parts (1M x 4, 3-chip SIMM), 0 = 512-row parts (1M x 1, 9-chip)
  input  [31:0] dram_tref,      // refresh period in 14 MHz ticks (16 ms / 8 ms)
  input         dram_decay,     // 1 = an overdue row loses its data (inverted)
  output [31:0] dram_viol,      // overdue rows found (rows holding written data)
  output [31:0] dram_maxage,    // longest interval between refreshes of a row with data, ticks
  output [31:0] dram_cbr,       // CAS-before-RAS cycles (both banks)
  output [31:0] dram_wcbr,      // CAS-before-RAS cycles with WE# = 0 (test mode entry on real parts)
  // to the C++ side
  output        NCONF, CONFD_o, CS27, CS1, A13_cpld, A13_cpld_oe,
  output [2:0]  RA,
  output        R, G, B, I, SYNC, VS,
  output        CLKCPU, M1_n, MREQ_n, IORQ_n, RD_n, WR_n,
  output [15:0] ADDR,
  output [7:0]  DBUS,
  output [31:0] conflicts,
  output [3:0]  dbg_drv          // D bus drivers: {cpu, flash, DD9, DD11}
);
  wire confd = (flex_sel != 2'd0);
  assign CONFD_o = confd;

  // ------------------------------------------------------------ reset
  wire reset = mb_reset_n & confd;              // VD5: CONF_DONE = 0 holds RESET low
  reg  [3:0] rdly = 4'd0;
  reg  rst_dly = 1'b0;
  always @(posedge clk14) begin                 // DD10.3/DD10.6 + C1: short delay
    if (reset != rst_dly) begin
      rdly <= rdly + 4'd1;
      if (rdly == 4'd13) begin rst_dly <= reset; rdly <= 4'd0; end
    end else rdly <= 4'd0;
  end

  // ------------------------------------------------------------ nets used before their drivers
  wire [7:0]  md, sd, dbx, dbus;
  wire [15:0] abus;
  wire        trbb;
  wire        z_m1, z_mreq, z_iorq, z_rd, z_wr;
  `include "flex_wires.vh"

  // ------------------------------------------------------------ Z80
  wire [15:0] za;
  wire [7:0]  zdo;
  wire        zdo_en, z_rfsh, z_halt, z_busak;
  wire        cpuclk = f_CLKCPU_oe ? f_CLKCPU_o : 1'b0;
  wire        wait_n = !(f_WAIT_n_oe && !f_WAIT_n_o);   // VD6: FLEX can only pull WAIT/ low
  wire        int_n  = f_INT_oe ? f_INT_o : 1'b1;
  tv80z cpu (.reset_n(reset), .clk(cpuclk), .wait_n(wait_n), .int_n(int_n), .nmi_n(magic_n),
             .busrq_n(1'b1), .m1_n(z_m1), .mreq_n(z_mreq), .iorq_n(z_iorq), .rd_n(z_rd), .wr_n(z_wr),
             .rfsh_n(z_rfsh), .halt_n(z_halt), .busak_n(z_busak), .A(za), .di(dbus), .dout(zdo),
             .dout_en(zdo_en));

  // ------------------------------------------------------------ CPLD
  wire c_NCONF_o, c_NCONF_oe, c_EO_o, c_EO_oe, c_DIR_o, c_DIR_oe, c_A13_o, c_A13_oe;
  wire c_CS27_o, c_CS27_oe, c_CS1_o, c_CS1_oe, c_RA16_o, c_RA16_oe, c_RA17_o, c_RA17_oe;
  wire c_RA18_o, c_RA18_oe, c_WEFL_o, c_WEFL_oe, c_EVPP_o, c_EVPP_oe;
  wire a13 = c_A13_oe ? c_A13_o : za[13];
  assign abus = {za[15:14], a13, za[12:0]};
  // CPLD data inputs pass through the PIA and product terms and arrive later than the global clock
  // WR/ (pin 43): the inputs below are delayed by half a 14 MHz period, WR_n is not. Without this the
  // port registers clocked by the rising edge of WR/ would see IORQ/ already inactive.
  reg [15:0] cd_a = 16'hFFFF;
  reg [7:0]  cd_d = 8'hFF;
  reg        cd_iorq = 1'b1, cd_mreq = 1'b1, cd_rd = 1'b1, cd_m1 = 1'b1;
  always @(posedge clk14 or negedge clk14) begin
    cd_a <= abus; cd_d <= dbus; cd_iorq <= z_iorq; cd_mreq <= z_mreq; cd_rd <= z_rd; cd_m1 <= z_m1;
  end
  cpld_gmx cpld (
    .RST_DLY(rst_dly), .MG(magic_n), .NCONF_o(c_NCONF_o), .NCONF_oe(c_NCONF_oe),
    .EO_o(c_EO_o), .EO_oe(c_EO_oe), .DIR_o(c_DIR_o), .DIR_oe(c_DIR_oe),
    .A0(cd_a[0]), .A1(cd_a[1]), .A5(cd_a[5]), .A8(cd_a[8]), .A9(cd_a[9]), .A10(cd_a[10]),
    .A11(cd_a[11]), .A12(cd_a[12]), .A13_o(c_A13_o), .A13_oe(c_A13_oe), .A13_i(cd_a[13]),
    .A14(cd_a[14]), .A15(cd_a[15]), .CS27_o(c_CS27_o), .CS27_oe(c_CS27_oe), .CS1_o(c_CS1_o),
    .CS1_oe(c_CS1_oe), .RA16_o(c_RA16_o), .RA16_oe(c_RA16_oe), .RA17_o(c_RA17_o), .RA17_oe(c_RA17_oe),
    .RA18_o(c_RA18_o), .RA18_oe(c_RA18_oe), .WEFL_o(c_WEFL_o), .WEFL_oe(c_WEFL_oe),
    .EVPP_o(c_EVPP_o), .EVPP_oe(c_EVPP_oe), .MREQ_n(cd_mreq), .RD_n(cd_rd),
    .D6(cd_d[6]), .D5(cd_d[5]), .D4(cd_d[4]), .D3(cd_d[3]), .D2(cd_d[2]), .D1(cd_d[1]), .D0(cd_d[0]),
    .IORQ_n(cd_iorq), .M1(cd_m1), .WR_n(z_wr), .CONFD(confd));

  // ------------------------------------------------------------ Flash 28F400 (CE# = 0, OE# = CSROM)
  import "DPI-C" function int flash_rd(input int addr);
  wire rdr_n  = f_RDR_n_oe ? f_RDR_n_o : 1'b1;
  wire csrom  = rdr_n & confd;                   // VD1/VD2 + RN1
  wire [18:0] faddr = {c_RA18_o, c_RA17_o, c_RA16_o, c_CS1_o, c_CS27_o, abus[13:0]};
  wire flash_oe = !csrom && c_WEFL_o;
  reg  [7:0] flash_q;
  integer    flash_v;
  always @* begin flash_v = flash_rd({13'd0, faddr}); flash_q = flash_v[7:0]; end

  // ------------------------------------------------------------ DRAM (2 x 1M x 8 SIMM30)
  wire ras_n  = f_RAS_n_oe  ? f_RAS_n_o  : 1'b1;   // DD12.1 buffers
  wire cas0_n = f_CAS0_n_oe ? f_CAS0_n_o : 1'b1;
  wire cas1_n = !(f_CAS1_oe ? f_CAS1_o : 1'b0);    // DD10.1 inverter
  wire we_n   = f_WE_n_oe   ? f_WE_n_o   : 1'b1;
  wire [9:0] ma = {f_MA9_o, f_MA8_o, f_MA7_o, f_MA6_o, f_MA5_o, f_MA4_o, f_MA3_o, f_MA2_o, f_MA1_o, f_MA0_o};
  reg  [7:0] mem0 [0:1048575];
  reg  [7:0] mem1 [0:1048575];
  reg  [9:0] row = 10'd0, col0 = 10'd0, col1 = 10'd0;
  reg  [7:0] md_hold = 8'hFF, sd_hold = 8'hFF;
  always @(negedge ras_n) row <= ma;
  always @(negedge cas0_n) begin col0 <= ma; if (!we_n) mem0[{row, ma}] <= md; end
  always @(negedge cas1_n) begin col1 <= ma; if (!we_n) mem1[{row, ma}] <= sd; end
  always @(negedge we_n) begin
    if (!cas0_n) mem0[{row, col0}] <= md;
    if (!cas1_n) mem1[{row, col1}] <= sd;
  end
  // ---- refresh check. A RAS cycle with CAS# = 1 refreshes row MA in both banks (RAS is common);
  // RAS falling with CAS# = 0 is a CAS-before-RAS cycle of that bank: row = internal counter.
  // 512-row parts ignore MA9 for refresh. Every 1 ms all rows that hold written data are checked.
  reg  [63:0] tck = 64'd0;
  always @(posedge clk14) tck <= tck + 64'd1;
  reg  [63:0] last0 [0:1023];
  reg  [63:0] last1 [0:1023];
  reg         val0  [0:1023];
  reg         val1  [0:1023];
  reg  [9:0]  cbr0 = 10'd0, cbr1 = 10'd0;
  reg  [31:0] n_viol = 32'd0, n_maxage = 32'd0, n_cbr = 32'd0, n_wcbr = 32'd0;
  integer ri;
  initial for (ri = 0; ri < 1024; ri = ri + 1) begin last0[ri] = 64'd0; last1[ri] = 64'd0; val0[ri] = 1'b0; val1[ri] = 1'b0; end
  task automatic refr(input integer bank, input [9:0] r);
    integer k, rr;
    reg [63:0] age;
    for (k = 0; k < 2; k = k + 1) begin
      rr = dram_r1024 ? {22'd0, r} : (k == 0 ? {23'd0, r[8:0]} : {22'd0, 1'b1, r[8:0]});
      if (!(dram_r1024 && k == 1)) begin
        if (bank == 0) begin
          age = tck - last0[rr];
          if (val0[rr] && age[31:0] > n_maxage) n_maxage = age[31:0];
          last0[rr] = tck;
        end else begin
          age = tck - last1[rr];
          if (val1[rr] && age[31:0] > n_maxage) n_maxage = age[31:0];
          last1[rr] = tck;
        end
      end
    end
  endtask
  always @(negedge ras_n) begin
    if (!cas0_n) begin refr(0, cbr0); cbr0 <= cbr0 + 10'd1; end else refr(0, ma);
    if (!cas1_n) begin refr(1, cbr1); cbr1 <= cbr1 + 10'd1; end else refr(1, ma);
    n_cbr <= n_cbr + {31'd0, !cas0_n} + {31'd0, !cas1_n};
    if (!we_n && (!cas0_n || !cas1_n)) n_wcbr <= n_wcbr + 32'd1;
  end
  always @(negedge cas0_n) if (!we_n && !ras_n) val0[row] <= 1'b1;
  always @(negedge cas1_n) if (!we_n && !ras_n) val1[row] <= 1'b1;
  always @(negedge we_n) begin if (!cas0_n && !ras_n) val0[row] <= 1'b1; if (!cas1_n && !ras_n) val1[row] <= 1'b1; end
  reg  [15:0] scan_div = 16'd0;
  integer si, sc;
  always @(posedge clk14) begin
    scan_div <= (scan_div == 16'd13999) ? 16'd0 : scan_div + 16'd1;
    if (scan_div == 16'd0)
      for (si = 0; si < 1024; si = si + 1) begin
        if (val0[si] && tck - last0[si] > {32'd0, dram_tref}) begin
          n_viol = n_viol + 32'd1; last0[si] = tck;
          if (dram_decay) for (sc = 0; sc < 1024; sc = sc + 1) mem0[{si[9:0], sc[9:0]}] = ~mem0[{si[9:0], sc[9:0]}];
        end
        if (val1[si] && tck - last1[si] > {32'd0, dram_tref}) begin
          n_viol = n_viol + 32'd1; last1[si] = tck;
          if (dram_decay) for (sc = 0; sc < 1024; sc = sc + 1) mem1[{si[9:0], sc[9:0]}] = ~mem1[{si[9:0], sc[9:0]}];
        end
      end
  end
  assign dram_viol = n_viol;
  assign dram_maxage = n_maxage;
  assign dram_cbr = n_cbr;
  assign dram_wcbr = n_wcbr;
`ifdef DBG_RAM
  // debug: CPU accesses to DBG_LO..DBG_HI with the DRAM cell used
  wire dbg_hit = !z_mreq && z_rfsh && abus >= `DBG_LO && abus <= `DBG_HI;
  always @(negedge cas0_n) if (dbg_hit && !we_n) $display("RAM0 cpu %04X row %03X col %03X %s %02X", abus, row, ma, we_n ? "rd" : "WR", we_n ? mem0[{row, ma}] : md);
  always @(negedge cas1_n) if (dbg_hit && !we_n) $display("RAM1 cpu %04X row %03X col %03X %s %02X", abus, row, ma, we_n ? "rd" : "WR", we_n ? mem1[{row, ma}] : sd);
  always @(negedge z_wr) if (dbg_hit) $display("CPU  wr %04X data %02X", abus, dbus);
  final begin $writememh("mem0.hex", mem0); $writememh("mem1.hex", mem1); end
`endif
`ifdef DBG_PAGE
  // debug: FLEX page register after #7FFD writes, DRAM cell of CPU accesses to the #C000 window
  reg dbg_w7 = 1'b0;
  integer dbg_n = 400, dbg_k = 0;
  always @(negedge z_wr) if (!z_iorq && abus == 16'h7FFD) dbg_w7 <= 1'b1;
  always @(negedge z_m1) if (dbg_w7) begin
    dbg_w7 <= 1'b0;
    dbg_k = dbg_k + 1;
    if (dbg_k < 60) $display("7FFD d=%02X db=%02X sys=%b%b%b%b", zdo, dbx, u_scorpion.lc1_a20, u_scorpion.lc3_a18, u_scorpion.lc5_a3, u_scorpion.lc2_a18);
  end
  always @(negedge cas0_n) if (!z_mreq && z_rfsh && abus[15:14] == 2'b11 && dbg_n < 400) begin
    dbg_n = dbg_n + 1; $display("C000 %04X bank0 row %03X col %03X we %b", abus, row, ma, we_n);
  end
  always @(negedge cas1_n) if (!z_mreq && z_rfsh && abus[15:14] == 2'b11 && dbg_n < 400) begin
    dbg_n = dbg_n + 1; $display("C000 %04X bank1 row %03X col %03X we %b", abus, row, ma, we_n);
  end
`endif
  wire m0_oe = !cas0_n && we_n;
  wire m1_oe = !cas1_n && we_n;
  // DD5: transparent while CAS1 = 1
  reg [7:0] dd5 = 8'hFF;
  wire cas1 = f_CAS1_oe ? f_CAS1_o : 1'b0;
  always @* if (cas1) dd5 = sd;
  wire ebuf_n = f_EBUF_oe ? f_EBUF_o : 1'b1;
  // DD9: transparent while WRBUF = 1
  reg [7:0] dd9 = 8'hFF;
  wire wrbuf = f_WRBUF_oe ? f_WRBUF_o : 1'b0;
  always @* if (wrbuf) dd9 = md;
  wire ram_n = f_RAM_n_oe ? f_RAM_n_o : 1'b1;

  // ------------------------------------------------------------ DD11, motherboard
  wire eo_n = c_EO_o, dir = c_DIR_o;
  wire [7:0] f_db_o  = {f_DB7_o, f_DB6_o, f_DB5_o, f_DB4_o, f_DB3_o, f_DB2_o, f_DB1_o, f_DB0_o};
  wire [7:0] f_db_oe = {f_DB7_oe, f_DB6_oe, f_DB5_oe, f_DB4_oe, f_DB3_oe, f_DB2_oe, f_DB1_oe, f_DB0_oe};
  wire mb_rd_fe = !z_iorq && !z_rd && z_m1 && !abus[0];
  reg  [4:0] kcol;
  integer kr, kc;
  always @* begin
    kcol = 5'h1F;
    for (kr = 0; kr < 8; kr = kr + 1)
      if (!abus[8 + kr])
        for (kc = 0; kc < 5; kc = kc + 1)
          if (keys[kr * 5 + kc]) kcol[kc] = 1'b0;
  end
  wire [7:0] mb_q = {3'b111, kcol};

  // ------------------------------------------------------------ bus resolution (hold when undriven)
  reg [7:0] db_hold = 8'hFF;
  wire db_by_dd11 = !eo_n && !dir;
  wire d_by_dd11  = !eo_n && dir;
  wire [7:0] db_other = db_by_dd11 ? dbus : mb_rd_fe ? mb_q : db_hold;
  assign dbx = (f_db_oe & f_db_o) | (~f_db_oe & db_other);
  // D bus: after the last driver is released the value is held for 4 half-periods of 14 MHz
  // (output disable time of the drivers, bus capacitance), then RN2 pulls it to FF.
  wire       d_driven = zdo_en | flash_oe | !ram_n | d_by_dd11;
  wire [7:0] d_drv = zdo_en ? zdo : flash_oe ? flash_q : !ram_n ? dd9 : dbx;
  reg  [7:0] d_hold = 8'hFF;
  reg  [2:0] d_age = 3'd7;
  always @(posedge clk14 or negedge clk14) begin
    if (d_driven) begin d_hold <= d_drv; d_age <= 3'd0; end
    else if (d_age != 3'd7) d_age <= d_age + 3'd1;
  end
  assign dbus = d_driven ? d_drv : (d_age < 3'd4) ? d_hold : 8'hFF;
  assign md = !we_n ? dbus : m0_oe ? mem0[{row, col0}] : !ebuf_n ? dd5 : md_hold;
  assign sd = !we_n ? dbus : m1_oe ? mem1[{row, col1}] : sd_hold;
  always @(posedge clk14) begin md_hold <= md; sd_hold <= sd; db_hold <= dbx; end

  // FLEX inputs
  assign trbb = !turbo_n ? 1'b0 : f_TRBB_oe ? f_TRBB_o : 1'b1;

  // conflict counters (two drivers on one bus)
  reg [31:0] nconf = 32'd0;
  wire c_d  = (zdo_en + flash_oe + !ram_n + d_by_dd11) > 1;
  wire c_db = ((|f_db_oe) + db_by_dd11 + mb_rd_fe) > 1;
  wire c_md = (!we_n + m0_oe + !ebuf_n) > 1;
  always @(posedge clk14) if (c_d | c_db | c_md) nconf <= nconf + 32'd1;
  assign conflicts = nconf;

  // ------------------------------------------------------------ outputs
  assign NCONF = c_NCONF_o;
  assign CS27 = c_CS27_o;
  assign CS1 = c_CS1_o;
  assign A13_cpld = c_A13_o;
  assign A13_cpld_oe = c_A13_oe;
  assign RA = {c_RA18_o, c_RA17_o, c_RA16_o};
  assign R = f_R_oe & f_R_o;
  assign G = f_G_oe & f_G_o;
  assign B = f_B_oe & f_B_o;
  assign I = f_I_oe & f_I_o;
  assign SYNC = f_SYNC_oe ? f_SYNC_o : 1'b1;
  assign VS = f_VS_oe ? f_VS_o : 1'b1;
  assign CLKCPU = cpuclk;
  assign M1_n = z_m1;
  assign MREQ_n = z_mreq;
  assign IORQ_n = z_iorq;
  assign RD_n = z_rd;
  assign WR_n = z_wr;
  assign ADDR = abus;
  assign DBUS = dbus;
  assign dbg_drv = {zdo_en, flash_oe, !ram_n, d_by_dd11};

  `include "flex_inst.vh"
endmodule
