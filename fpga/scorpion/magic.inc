FUNCTION magic (A[15..0], M1, MG, MREQ_n, RESET, turbo, a9_buf, rd_ff, sys[3..0], scr, rom1, blkpk1, blk1, sm[2..0], mag_dis, graphic, ram_sel, rom_rd_n, m1_ram)
	RETURNS (o_magic_hold, o_dos_act, o_ml_sys[3..0], o_ml_sm[2..0], o_ml_blkpk1, o_ml_scr, o_ml_turbo, o_ml_gfx, o_ml_blk1);
