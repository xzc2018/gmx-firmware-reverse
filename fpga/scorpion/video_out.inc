FUNCTION video_out (MD[7..0], p14M, clk7, ras, pix_clk, graphic, brd[2..0], we, cpu_slot, h[8..0], hborder, hs_pulse, vborder, flash)
	RETURNS (o_at_d[4..1], o_out_g, o_out_r, o_out_b, o_out_i);
