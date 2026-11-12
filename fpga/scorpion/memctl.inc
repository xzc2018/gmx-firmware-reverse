FUNCTION memctl (A[15..0], IORQ_n, M1, MREQ_n, RD_n, clk7, ras, ma_col, cpu_clk, turbo, a9_buf, a14_buf, sys[3..0], scr, blk1, sm[2..0], graphic, sw[6..0], magic_hold, h[8..0], hborder, v[7..0], vborder, at_d[4..1], ga[13..0])
	WITH (CBR)
	RETURNS (o_ram_sel, o_ram_rd, o_rom_rd_n, o_m1_ram, o_we, o_cpu_slot, o_cas0_drv, o_cas1_drv, o_rdlatch_clk, o_simm1_oe, o_wait_out, o_ma_out[9..0]);
