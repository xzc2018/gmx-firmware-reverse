// Z80 bus interface around tv80_core (third_party/tv80) with Z80 pin timing:
//   M1 cycle : MREQ/RD fall at T1 falling edge, rise at T3 rising edge; refresh MREQ from T3 falling
//              to T4 falling edge, A7..A0 = R; opcode sampled at T3 rising edge.
//   memory   : MREQ (and RD) fall at T1 falling edge, rise at T3 falling edge;
//              WR falls at T2 falling edge, rises at T3 falling edge; read data sampled at T3 falling edge.
//   INTA     : IORQ low from the falling edge of the last T2; the IM 2 vector is read from the data bus.
//   I/O      : IORQ and RD/WR fall at T2 rising edge, rise at T3 falling edge (automatic wait state).
//   WAIT is sampled at falling edges of T2/TW.
// Requires `define TV80_REFRESH (refresh address output).
module tv80z (
  input         reset_n,
  input         clk,
  input         wait_n,
  input         int_n,
  input         nmi_n,
  input         busrq_n,
  output        m1_n,
  output        mreq_n,
  output        iorq_n,
  output        rd_n,
  output        wr_n,
  output        rfsh_n,
  output        halt_n,
  output        busak_n,
  output [15:0] A,
  input  [7:0]  di,
  output [7:0]  dout,
  output        dout_en
);
  wire       intcycle_n, no_read, write, iorq;
  wire [6:0] mc, ts;
  wire [7:0] core_dout;
  reg  [7:0] di_reg = 8'hFF;
  reg        wait_s = 1'b1;

  tv80_core #(.Mode(0), .IOWait(1)) core (
    .cen(1'b1), .m1_n(m1_n), .iorq(iorq), .no_read(no_read), .write(write), .rfsh_n(rfsh_n),
    .halt_n(halt_n), .wait_n(wait_s), .int_n(int_n), .nmi_n(nmi_n), .reset_n(reset_n),
    .busrq_n(busrq_n), .busak_n(busak_n), .clk(clk), .IntE(), .stop(), .A(A), .dinst(di),
    .di(di_reg), .dout(core_dout), .mc(mc), .ts(ts), .intcycle_n(intcycle_n));

  // phase within the current T state: late = 1 after its falling edge
  reg tp = 1'b0, tn = 1'b0;
  always @(posedge clk) tp <= ~tp;
  always @(negedge clk) tn <= tp;
  wire late = (tp == tn);

  wire M1 = mc[0];
  wire T1 = ts[1], T2 = ts[2], T3 = ts[3];
  wire inta = M1 & !intcycle_n;
  wire memrd = !M1 & !iorq & !no_read & !write;
  wire memwr = !M1 & !iorq & write;
  wire iocyc = !M1 & iorq & (write | !no_read);

  // strobes changing at falling edges
  reg mreq_r = 1'b1, rd_r = 1'b1, wr_r = 1'b1, iack_r = 1'b1;
  always @(negedge clk or negedge reset_n)
    if (!reset_n) begin
      mreq_r <= 1'b1; rd_r <= 1'b1; wr_r <= 1'b1; iack_r <= 1'b1;
    end else begin
      if (M1) begin
        mreq_r <= inta ? !T3 : !(T1 | T2 | T3);
        rd_r   <= inta ? 1'b1 : !(T1 | T2);
        wr_r   <= 1'b1;
        iack_r <= !(inta & T2);
      end else begin
        mreq_r <= !((memrd | memwr) & (T1 | T2));
        rd_r   <= !(memrd & (T1 | T2));
        wr_r   <= !(memwr & T2);
        iack_r <= 1'b1;
      end
      if (T2) wait_s <= wait_n;
      // DI_Reg: read data at T3 falling edge; in M1 cycles (incl. the IM 2 vector of INTA) at T2 falling edge
      if ((!M1 & T3) | (M1 & T2)) di_reg <= di;
    end

  wire io_act = iocyc & (T2 | (T3 & !late));
  assign mreq_n = mreq_r | (M1 & T3 & !late);
  assign rd_n   = (rd_r | (M1 & T3)) & !(io_act & !write);
  assign wr_n   = wr_r & !(io_act & write);
  assign iorq_n = !io_act & (iack_r | (M1 & T3));
  assign dout_en = (memwr & ((T1 & late) | T2 | T3)) | (iocyc & write & (T1 | T2 | T3));

  // The core loads its data output at the rising edge that ends T1; a Z80 drives write data from the
  // falling edge of T1. During T1 the value the core is about to load is put on the bus.
  wire [7:0] nd_bus = core.I_RLD ? {core.BusB[3:0], core.BusA[3:0]} :
                      core.I_RRD ? {core.BusA[3:0], core.BusB[7:4]} : core.BusB;
  wire       nd_c1  = T1 && !core.Auto_Wait_t1;
  wire       nd_c2  = (T1 && !core.Save_ALU_r && !core.Auto_Wait_t1) || (core.Save_ALU_r && core.ALU_Op_r != 4'b0111);
  wire [7:0] nd     = (nd_c2 && core.Read_To_Reg_r == 5'b10110) ? core.Save_Mux : nd_c1 ? nd_bus : core_dout;
  assign dout = ((memwr | (iocyc & write)) & T1) ? nd : core_dout;
endmodule
