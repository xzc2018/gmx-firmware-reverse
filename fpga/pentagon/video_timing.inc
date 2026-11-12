FUNCTION video_timing (clk7, turbo, graphic, st_pent)
	RETURNS (o_h[8..0], o_hborder, o_blank_n, o_csync, o_v[7..0], o_vborder, o_vsync, o_int_ff, o_flash);
