FUNCTION magic (A[15..0], M1, MG, MREQ_n, RESET, turbo, rd_ff, a8_buf, a9_buf, a10_buf, a11_buf, a12_buf, sys[2..0], scr, rom1, blkpk1, sm[2..0], mag_dis, graphic, ram_sel, rom_rd_n, m1_ram)
	RETURNS (o_dos_act, o_ml_sys[2..0], o_ml_sm[2..0], o_ml_blkpk1, o_ml_scr, o_ml_turbo, o_ml_gfx, o_ml_zero);
