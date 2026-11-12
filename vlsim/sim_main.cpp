// Scorpion GMX board simulator (Verilator): Z80 + FLEX + CPLD + Flash + DRAM, video to PNG.
//
//   gmxsim --rom gmx12501.rom --scorpion scheme1.rbf --pentagon scheme4.rbf --script s.txt --out dir
//          [--scorpion-alt other.rbf]   a second bitstream that also selects the Scorpion model
//          [--dram 512|1024] [--tref ms] [--decay]   DRAM refresh check: rows per part (1024 = 1M x 4,
//                                       3-chip SIMM; 512 = 1M x 1, 9-chip), refresh period (16 / 8 ms),
//                                       overdue rows lose their data
//                                       (an image with blocks of two compilations of the same design)
//
// Script lines (time in ms of emulated time, '#' starts a comment):
//   <ms> key <KEY> [hold_ms]   press a key (default hold 60 ms); KEY: 0-9, A-Z, ENTER, SPACE, CS, SS
//   <ms> keys <TEXT> [hold_ms] type characters one after another (hold, then same release time)
//   <ms> magic [hold_ms]       Magic button (MG + NMI)
//   <ms> reset [hold_ms]       motherboard RESET button
//   <ms> turbo [hold_ms]       turbo button
//   <ms> shot <file.png>       save the next complete frame
//   <ms> end                   stop
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cstdint>
#include <string>
#include <vector>
#include <fstream>
#include <sstream>
#include <algorithm>
#include <memory>
#include <ctime>
#ifdef _WIN32
#include <fcntl.h>
#include <stdlib.h>
#endif
#include "Vgmx_board.h"
#include "Vgmx_board__Dpi.h"
#include "verilated.h"
#include "verilated_save.h"

static std::vector<uint8_t> g_rom;             // 512 KB image, logical page order (as gmx12501.rom)
static double g_time = 0;
double sc_time_stamp() { return g_time; }

// Flash address pins: bit 14 = CS27, bit 15 = CS1; logical page p: p0 = CS27, p1 = CS1 xor CS27
static uint32_t phys_to_file(uint32_t a) {
    uint32_t b14 = (a >> 14) & 1, b15 = (a >> 15) & 1;
    return (a & ~0xC000u) | (b14 << 14) | ((b15 ^ b14) << 15);
}

int flash_rd(int addr) {
    uint32_t off = phys_to_file((uint32_t)addr & 0x7FFFF);
    return off < g_rom.size() ? g_rom[off] : 0xFF;
}

static std::vector<uint8_t> read_file(const std::string& p) {
    std::ifstream f(p, std::ios::binary);
    if (!f) { fprintf(stderr, "cannot read %s\n", p.c_str()); exit(1); }
    return std::vector<uint8_t>((std::istreambuf_iterator<char>(f)), std::istreambuf_iterator<char>());
}

// ---------------------------------------------------------------- PNG writer (stored deflate)
static uint32_t crc_tab[256];
static void crc_init() {
    for (uint32_t n = 0; n < 256; n++) {
        uint32_t c = n;
        for (int k = 0; k < 8; k++) c = (c & 1) ? 0xEDB88320u ^ (c >> 1) : c >> 1;
        crc_tab[n] = c;
    }
}
static uint32_t crc32(const uint8_t* b, size_t n, uint32_t c = 0xFFFFFFFFu) {
    for (size_t i = 0; i < n; i++) c = crc_tab[(c ^ b[i]) & 0xFF] ^ (c >> 8);
    return c;
}
static void put32(std::vector<uint8_t>& v, uint32_t x) {
    v.push_back(x >> 24); v.push_back(x >> 16); v.push_back(x >> 8); v.push_back(x);
}
static void chunk(std::vector<uint8_t>& out, const char* type, const std::vector<uint8_t>& data) {
    put32(out, (uint32_t)data.size());
    std::vector<uint8_t> td(type, type + 4);
    td.insert(td.end(), data.begin(), data.end());
    out.insert(out.end(), td.begin(), td.end());
    put32(out, crc32(td.data(), td.size()) ^ 0xFFFFFFFFu);
}
static bool write_png(const std::string& path, int w, int h, const std::vector<uint8_t>& rgb) {
    std::vector<uint8_t> raw;
    for (int y = 0; y < h; y++) {
        raw.push_back(0);
        raw.insert(raw.end(), rgb.begin() + (size_t)y * w * 3, rgb.begin() + (size_t)(y + 1) * w * 3);
    }
    std::vector<uint8_t> z = {0x78, 0x01};
    uint32_t a = 1, b = 0;
    for (uint8_t c : raw) { a = (a + c) % 65521; b = (b + a) % 65521; }
    for (size_t pos = 0; pos < raw.size(); pos += 65535) {
        size_t n = std::min<size_t>(65535, raw.size() - pos);
        z.push_back(pos + n == raw.size() ? 1 : 0);
        z.push_back(n & 0xFF); z.push_back(n >> 8); z.push_back(~n & 0xFF); z.push_back((~n >> 8) & 0xFF);
        z.insert(z.end(), raw.begin() + pos, raw.begin() + pos + n);
    }
    put32(z, (b << 16) | a);
    std::vector<uint8_t> out = {0x89, 'P', 'N', 'G', 0x0D, 0x0A, 0x1A, 0x0A}, ihdr;
    put32(ihdr, w); put32(ihdr, h);
    ihdr.insert(ihdr.end(), {8, 2, 0, 0, 0});
    chunk(out, "IHDR", ihdr);
    const char mark[] = "GMXcolor\0zx";                  // colours in ZX order (screenshot marker)
    chunk(out, "tEXt", std::vector<uint8_t>(mark, mark + sizeof mark - 1));
    chunk(out, "IDAT", z);
    chunk(out, "IEND", {});
    std::ofstream f(path, std::ios::binary);
    f.write((const char*)out.data(), out.size());
    return (bool)f;
}

// ---------------------------------------------------------------- keyboard
static int key_bit(const std::string& k) {
    static const char* rows[8][5] = {
        {"CS", "Z", "X", "C", "V"}, {"A", "S", "D", "F", "G"}, {"Q", "W", "E", "R", "T"},
        {"1", "2", "3", "4", "5"}, {"0", "9", "8", "7", "6"}, {"P", "O", "I", "U", "Y"},
        {"ENTER", "L", "K", "J", "H"}, {"SPACE", "SS", "M", "N", "B"}};
    std::string u = k;
    for (auto& c : u) c = (char)toupper((unsigned char)c);
    for (int r = 0; r < 8; r++)
        for (int c = 0; c < 5; c++)
            if (u == rows[r][c]) return r * 5 + c;
    return -1;
}

struct Event { double ms; std::string cmd, arg; double hold; };

int main(int argc, char** argv) {
#ifdef _WIN32
    _set_fmode(_O_BINARY);   // VerilatedSave/Restore use ::open() without O_BINARY: default to binary mode
#endif
    Verilated::commandArgs(argc, argv);
    std::string rom = "gmx12501.rom", bs_s, bs_p, bs_s2, script, outdir = ".";
    double max_ms = 10000;
    uint64_t progress_ms = 100;
    double jfrom_ms = 0, jto_ms = 0;
    uint32_t watch_lo = 1, watch_hi = 0;
    double bfrom_ms = 0, bto_ms = 0, vd_ms = -1, save_ms = -1;
    std::string save_file, load_file, gallery, gallery_prefix;
    int dram_rows = 1024, dram_decay = 0;
    double dram_tref_ms = 0;
    int crop_x = 160;                              // samples before the visible part (line sync, back porch)
    uint32_t last_sig = 0;
    setvbuf(stdout, nullptr, _IONBF, 0);
    clock_t t0 = clock();
    for (int i = 1; i < argc; i++) if (std::string(argv[i]) == "--decay") dram_decay = 1;
    for (int i = 1; i + 1 < argc; i++) {
        std::string a = argv[i];
        if (a == "--rom") rom = argv[++i];
        else if (a == "--scorpion") bs_s = argv[++i];
        else if (a == "--pentagon") bs_p = argv[++i];
        else if (a == "--scorpion-alt") bs_s2 = argv[++i];
        else if (a == "--script") script = argv[++i];
        else if (a == "--out") outdir = argv[++i];
        else if (a == "--ms") max_ms = atof(argv[++i]);
        else if (a == "--progress") progress_ms = (uint64_t)atoi(argv[++i]);
        else if (a == "--jumps") { jfrom_ms = atof(argv[++i]); jto_ms = atof(argv[++i]); }
        else if (a == "--vdump") vd_ms = atof(argv[++i]);
        else if (a == "--save") { save_ms = atof(argv[++i]); save_file = argv[++i]; }
        else if (a == "--load") load_file = argv[++i];
        else if (a == "--crop") crop_x = atoi(argv[++i]);
        else if (a == "--dram") dram_rows = atoi(argv[++i]);
        else if (a == "--tref") dram_tref_ms = atof(argv[++i]);
        else if (a == "--gallery") { gallery = argv[++i]; gallery_prefix = argv[++i]; }
        else if (a == "--bus") { bfrom_ms = atof(argv[++i]); bto_ms = atof(argv[++i]); jfrom_ms = bfrom_ms; jto_ms = bto_ms; }
        else if (a == "--watch") { watch_lo = strtoul(argv[++i], nullptr, 16); watch_hi = strtoul(argv[++i], nullptr, 16); }
    }
    crc_init();
    g_rom = read_file(rom);
    std::vector<std::vector<uint8_t>> bits;
    bits.push_back(read_file(bs_s));
    bits.push_back(read_file(bs_p));
    if (!bs_s2.empty()) bits.push_back(read_file(bs_s2));   // index 2 -> Scorpion model

    std::vector<Event> ev;
    if (!script.empty()) {
        std::ifstream f(script);
        std::string line;
        while (std::getline(f, line)) {
            auto h = line.find('#');
            if (h != std::string::npos) line = line.substr(0, h);
            std::istringstream ss(line);
            Event e{0, "", "", 0};
            if (!(ss >> e.ms >> e.cmd)) continue;
            if (e.cmd == "key" || e.cmd == "keys" || e.cmd == "shot") ss >> e.arg;
            if (!(ss >> e.hold)) e.hold = (e.cmd == "reset") ? 20 : 60;
            ev.push_back(e);
        }
        std::sort(ev.begin(), ev.end(), [](const Event& a, const Event& b) { return a.ms < b.ms; });
    }

    auto top = std::make_unique<Vgmx_board>();
    const uint64_t TPM = 14000;                  // 14 MHz ticks per ms
    uint64_t tick = 0, end_tick = (uint64_t)(max_ms * TPM);
    uint64_t keys = 0;
    struct Hold { uint64_t until; int what; int bit; };  // what: 0 key, 1 magic, 2 reset, 3 turbo
    std::vector<Hold> holds;
    std::vector<std::pair<uint64_t, int>> typed;  // (tick, key bit) for "keys"
    bool mb_reset = true;                         // power-on reset for 30 ms
    uint64_t por_end = 30 * TPM;
    bool magic = false, turbo = false;

    // FLEX configuration controller
    int fsel = 0, cfg = 0;                        // cfg: 0 idle (unconfigured), 1 configuring, 2 user mode
    uint64_t cfg_done = 0;
    const uint64_t CFG_TICKS = 2 * TPM;

    // video
    const int FW = 1024, FH = 400;
    std::vector<uint8_t> fb((size_t)FW * FH, 0);
    int vx = 0, vy = 0, last_sync = 1, last_vs = 1, maxy = 0;
    std::vector<std::string> shots;
    int frames = 0;
    size_t ei = 0;

    // trace state
    struct Fetch { uint64_t t; uint32_t a; };
    const size_t RING = 4096;
    std::vector<Fetch> ring(RING, {0, 0});
    size_t ring_pos = 0;
    int last_m1 = 1, last_wr = 1, last_iorq = 1, same_pc = 0;
    uint32_t last_addr = 0, last_data = 0;
    int last_m1_lvl = 1;
    int last_rd = 1, last_mreq = 1, last_ra = 0, last_cs1 = 0, last_cs27 = 0;
    long romchk_n = 0, romchk_bad = 0;
    FILE* romchk_log = fopen((outdir + "/romcheck.log").c_str(), "w");
    uint32_t last_pc = 0xFFFFFFFF;
    bool halt_dumped = false;
    FILE* iolog = fopen((outdir + "/io.log").c_str(), "w");
    FILE* jlog = jto_ms > 0 ? fopen((outdir + "/jumps.log").c_str(), "w") : nullptr;
    uint64_t jfrom = (uint64_t)(jfrom_ms * 14000), jto = (uint64_t)(jto_ms * 14000);
    uint64_t bfrom = (uint64_t)(bfrom_ms * 14000), bto = (uint64_t)(bto_ms * 14000);
    FILE* vdump = vd_ms >= 0 ? fopen((outdir + "/video.raw").c_str(), "wb") : nullptr;
    uint64_t vd_from = (uint64_t)(vd_ms * 14000);
    long iolog_n = 0;
    auto dump = [&](const char* why) {
        FILE* f = fopen((outdir + "/m1trace_" + why + ".txt").c_str(), "w");
        if (!f) return;
        size_t n = std::min(ring_pos, RING);
        for (size_t i = ring_pos - n; i < ring_pos; i++)
            fprintf(f, "%10.4f ms  %04X\n", ring[i % RING].t / (double)TPM, ring[i % RING].a);
        fclose(f);
        printf("[%8.1f ms] trace dumped (%s)\n", tick / (double)TPM, why);
    };
    top->clk14 = 0; top->magic_n = 1; top->turbo_n = 1; top->mb_reset_n = 0;
    top->flex_sel = 0; top->flex_grst_n = 0; top->keys = 0;
    if (dram_tref_ms <= 0) dram_tref_ms = dram_rows == 512 ? 8 : 16;
    top->dram_r1024 = dram_rows != 512;
    top->dram_tref = (uint32_t)(dram_tref_ms * TPM);
    top->dram_decay = dram_decay;
    top->eval();

    // ---- state snapshot (Verilator --savable model + harness state)
    struct HState { uint64_t tick, cfg_done, keys; int fsel, cfg, mb_reset, magic, turbo, vx, vy, last_sync, last_vs; };
    auto save_state = [&](const std::string& path) {
        VerilatedSave os;
        os.open(path.c_str());
        os << *top;
        HState h{tick, cfg_done, keys, fsel, cfg, mb_reset, magic, turbo, vx, vy, last_sync, last_vs};
        os.write(&h, sizeof h);
        uint64_t n = holds.size();
        os.write(&n, sizeof n);
        for (auto& x : holds) os.write(&x, sizeof x);
        os.close();
        printf("[%8.1f ms] state saved to %s\n", tick / (double)TPM, path.c_str());
    };
    if (!load_file.empty()) {
        VerilatedRestore is;
        is.open(load_file.c_str());
        is >> *top;
        HState h;
        is.read(&h, sizeof h);
        tick = h.tick; cfg_done = h.cfg_done; keys = h.keys; fsel = h.fsel; cfg = h.cfg; mb_reset = h.mb_reset;
        magic = h.magic; turbo = h.turbo; vx = h.vx; vy = h.vy; last_sync = h.last_sync; last_vs = h.last_vs;
        uint64_t n = 0;
        is.read(&n, sizeof n);
        holds.resize(n);
        for (auto& x : holds) is.read(&x, sizeof x);
        is.close();
        por_end = 0;
        end_tick = (uint64_t)(max_ms * TPM);
        while (ei < ev.size() && (uint64_t)(ev[ei].ms * TPM) < tick) ei++;   // skip script events before the snapshot
        printf("[%8.1f ms] state loaded from %s\n", tick / (double)TPM, load_file.c_str());
    }
    uint64_t save_tick = save_ms >= 0 ? (uint64_t)(save_ms * TPM) : UINT64_MAX;

    while (tick < end_tick) {
        if (tick == save_tick) save_state(save_file);
        // ---- script
        while (ei < ev.size() && (uint64_t)(ev[ei].ms * TPM) <= tick) {
            Event& e = ev[ei++];
            uint64_t hold = (uint64_t)(e.hold * TPM);
            if (e.cmd == "key") {
                int b = key_bit(e.arg);
                if (b < 0) { fprintf(stderr, "unknown key %s\n", e.arg.c_str()); continue; }
                keys |= 1ull << b; holds.push_back({tick + hold, 0, b});
            } else if (e.cmd == "keys") {
                uint64_t t = tick;
                for (char c : e.arg) {
                    std::string k(1, c);
                    if (c == '_') k = "SPACE";
                    int b = key_bit(k);
                    if (b >= 0) typed.push_back({t, b});
                    t += 2 * hold;
                }
            } else if (e.cmd == "magic") { magic = true; holds.push_back({tick + hold, 1, 0}); }
            else if (e.cmd == "reset") { mb_reset = true; holds.push_back({tick + hold, 2, 0}); }
            else if (e.cmd == "turbo") { turbo = true; holds.push_back({tick + hold, 3, 0}); }
            else if (e.cmd == "shot") shots.push_back(outdir + "/" + e.arg);
            else if (e.cmd == "end") end_tick = tick;
            printf("[%8.1f ms] %s %s\n", tick / (double)TPM, e.cmd.c_str(), e.arg.c_str());
        }
        for (auto it = typed.begin(); it != typed.end();) {
            if (it->first <= tick) {
                keys |= 1ull << it->second;
                holds.push_back({tick + 60 * TPM, 0, it->second});
                it = typed.erase(it);
            } else ++it;
        }
        for (auto it = holds.begin(); it != holds.end();) {
            if (it->until <= tick) {
                if (it->what == 0) keys &= ~(1ull << it->bit);
                else if (it->what == 1) magic = false;
                else if (it->what == 2) mb_reset = false;
                else turbo = false;
                it = holds.erase(it);
            } else ++it;
        }
        if (tick == por_end) mb_reset = false;
        top->keys = keys;
        top->magic_n = !magic;
        top->turbo_n = !turbo;
        top->mb_reset_n = (!mb_reset && tick >= por_end) ? 1 : 0;

        // ---- FLEX configuration
        if (cfg == 2 && !top->NCONF) {
            cfg = 0; fsel = 0;
            printf("[%8.1f ms] FLEX: nCONFIG = 0, unconfigured\n", tick / (double)TPM);
        }
        if (cfg == 0 && top->NCONF) { cfg = 1; cfg_done = tick + CFG_TICKS; }
        if (cfg == 1 && !top->NCONF) cfg = 0;
        if (cfg == 1 && tick >= cfg_done) {
            uint32_t phys = ((uint32_t)top->RA << 16) | ((uint32_t)top->CS1 << 15) | ((uint32_t)top->CS27 << 14) |
                            ((uint32_t)(top->A13_cpld_oe ? top->A13_cpld : 0) << 13);
            uint32_t off = phys_to_file(phys);
            int found = 0;
            for (int k = 0; k < (int)bits.size(); k++) {
                const auto& b = bits[k];
                if (off + b.size() <= g_rom.size() && std::equal(b.begin(), b.end(), g_rom.begin() + off))
                    found = (k == 2) ? 1 : k + 1;
            }
            char name[11] = {0};
            if (off + 0x2000 <= g_rom.size()) memcpy(name, &g_rom[off + 0x1FF0], 10);
            printf("[%8.1f ms] FLEX: configured from file offset 0x%05X (\"%s\") -> %s\n", tick / (double)TPM, off,
                   name, found == 1 ? "Scorpion" : found == 2 ? "PentaGON" : "unknown bitstream, stays unconfigured");
            if (found) { fsel = found; cfg = 2; } else cfg = 3;
        }
        top->flex_sel = fsel;
        top->flex_grst_n = (cfg == 2);

        // ---- clock
        top->clk14 = 1;
        top->eval();
        // video sample
        int sync = top->SYNC, vs = top->VS;
        if (vdump && tick >= vd_from && tick < vd_from + 2 * 14000 * 20) {
            uint8_t b = (uint8_t)((top->R) | (top->G << 1) | (top->B << 2) | (top->I << 3) | (sync << 4) | (vs << 5));
            fputc(b, vdump);
        }
        if (!last_sync && sync && vx > 400) { vx = 0; vy++; }    // SYNC: positive line sync pulse
        if (last_vs && !vs) {
            frames++;
            if (!shots.empty() && vy > 200) {
                int h = std::min(vy, FH), w = 896 - crop_x;
                std::vector<uint8_t> rgb((size_t)w * h * 2 * 3);
                for (int y = 0; y < h; y++)
                    for (int x = 0; x < w; x++) {
                        uint8_t p = fb[(size_t)y * FW + x + crop_x];
                        uint8_t lv = (p & 8) ? 0xFF : 0xC0;
                        uint8_t r = (p & 1) ? lv : 0, g = (p & 2) ? lv : 0, bl = (p & 4) ? lv : 0;
                        for (int d = 0; d < 2; d++) {
                            uint8_t* q = &rgb[(((size_t)(2 * y + d)) * w + x) * 3];
                            q[0] = r; q[1] = g; q[2] = bl;
                        }
                    }
                write_png(shots.front(), w, 2 * h, rgb);
                if (!gallery.empty()) {
                    std::string base = shots.front().substr(shots.front().find_last_of("/\\") + 1);
                    write_png(gallery + "/" + gallery_prefix + base, w, 2 * h, rgb);
                }
                printf("[%8.1f ms] screenshot %s (%dx%d, frame %d)\n", tick / (double)TPM, shots.front().c_str(), w,
                       2 * h, frames);
                shots.erase(shots.begin());
            }
            maxy = std::max(maxy, vy);
            vy = 0;
            std::fill(fb.begin(), fb.end(), 0);
        }
        last_sync = sync; last_vs = vs;
        if (vx < FW && vy < FH)
            // FLEX pin "G" (pin 1) carries attribute bit 0 = blue, pin "B" (pin 84) bit 2 = green (ZX palette);
            // the frame buffer stores bit 0 = red, 1 = green, 2 = blue, 3 = bright
            fb[(size_t)vy * FW + vx] = (top->R ? 1 : 0) | (top->B ? 2 : 0) | (top->G ? 4 : 0) | (top->I ? 8 : 0);
        vx++;
        // ---- CPU trace: M1 fetch addresses, port writes
        {
            int m1 = top->M1_n, wr = top->WR_n;
            if (last_m1 && !m1 && top->IORQ_n) {
                ring[ring_pos++ % RING] = {tick, top->ADDR};
                if (jlog && tick >= jfrom && tick < jto && (top->ADDR < last_pc || top->ADDR > last_pc + 4))
                    fprintf(jlog, "%10.4f ms %04X -> %04X  bank %d cs %d%d\n", tick / (double)TPM, last_pc & 0xFFFF,
                            top->ADDR, top->RA, top->CS1, top->CS27);
                if (top->ADDR == last_pc) { if (++same_pc == 3000 && !halt_dumped) { halt_dumped = true; dump("halt"); } }
                else same_pc = 0;
                last_pc = top->ADDR;
            }
            if (!last_wr && wr && !last_iorq && iolog_n < 200000) {
                if (iolog) fprintf(iolog, "%10.3f ms OUT (%04X),%02X\n", tick / (double)TPM, last_addr, last_data);
                iolog_n++;
            }
            // ROM read check: data at the end of a memory read in 0000-3FFF vs the Flash content
            int rd = top->RD_n;
            if (last_iorq == 0 && top->IORQ_n && !last_m1_lvl && iolog && iolog_n < 200000) {
                fprintf(iolog, "%10.3f ms INTA data %02X\n", tick / (double)TPM, last_data);
                iolog_n++;
            }
            if (jlog && tick >= bfrom && tick < bto) {
                uint32_t sig = (top->M1_n << 4) | (top->MREQ_n << 3) | (top->IORQ_n << 2) | (top->RD_n << 1) | wr |
                               (top->DBUS << 8) | (top->dbg_drv << 16);
                if (sig != last_sig)
                    fprintf(jlog, "%10.4f ms BUS M1%d MREQ%d IORQ%d RD%d WR%d A=%04X D=%02X drv=%X\n", tick / (double)TPM,
                            top->M1_n, top->MREQ_n, top->IORQ_n, top->RD_n, wr, top->ADDR, top->DBUS, top->dbg_drv);
                last_sig = sig;
            }
            last_m1_lvl = top->M1_n;
            // watched memory range: CPU reads (end of RD) and writes (end of WR)
            if (iolog && !last_mreq && last_addr >= watch_lo && last_addr <= watch_hi &&
                ((!last_rd && top->RD_n) || (!last_wr && wr)))
                fprintf(iolog, "%10.4f ms MEM %s %04X %02X\n", tick / (double)TPM, !last_rd ? "rd" : "WR", last_addr,
                        last_data);
            if (!last_rd && rd && !last_iorq && iolog && iolog_n < 200000) {
                fprintf(iolog, "%10.3f ms IN  (%04X),%02X\n", tick / (double)TPM, last_addr, last_data);
                iolog_n++;
            }
            if (!last_rd && rd && !last_mreq && last_addr < 0x4000 && romchk_n < 400000) {
                uint32_t phys = ((uint32_t)last_ra << 16) | ((uint32_t)last_cs1 << 15) | ((uint32_t)last_cs27 << 14) |
                                (last_addr & 0x3FFF);
                int exp = flash_rd((int)phys);
                romchk_n++;
                if (exp != (int)last_data) {
                    romchk_bad++;
                    if (romchk_log && romchk_bad <= 300)
                        fprintf(romchk_log, "%10.4f ms %04X read %02X flash %02X (phys %05X)\n", tick / (double)TPM,
                                last_addr, last_data, exp, phys);
                }
            }
            last_rd = rd; last_mreq = top->MREQ_n; last_ra = top->RA; last_cs1 = top->CS1; last_cs27 = top->CS27;
            last_m1 = m1; last_wr = wr; last_iorq = top->IORQ_n; last_addr = top->ADDR; last_data = top->DBUS;
        }
        top->clk14 = 0;
        top->eval();
        tick++;
        if (tick % (progress_ms * TPM) == 0) {
            double wall = (double)(clock() - t0) / CLOCKS_PER_SEC;
            printf("[%8.1f ms] frames %d, addr 0x%04X, conflicts %u, wall %.1f s (%.2f ms/s)\n", tick / (double)TPM,
                   frames, top->ADDR, top->conflicts, wall, wall > 0 ? tick / (double)TPM / wall : 0.0);
            printf("[%8.1f ms] DRAM: max refresh interval %.2f ms, overdue rows %u, CBR %u, WCBR %u\n",
                   tick / (double)TPM, top->dram_maxage / (double)TPM, top->dram_viol, top->dram_cbr, top->dram_wcbr);
        }
    }
    dump("end");
    printf("ROM reads checked %ld, mismatches %ld\n", romchk_n, romchk_bad);
    if (romchk_log) fclose(romchk_log);
    if (iolog) fclose(iolog);
    top->final();
    printf("DRAM: %d-row parts, tref %.1f ms%s: max refresh interval %.2f ms, overdue rows %u, CBR %u, WCBR %u\n",
           dram_rows == 512 ? 512 : 1024, dram_tref_ms, dram_decay ? ", decay" : "", top->dram_maxage / (double)TPM,
           top->dram_viol, top->dram_cbr, top->dram_wcbr);
    printf("done: %.1f ms emulated, %d frames, bus conflicts %u\n", tick / (double)TPM, frames, top->conflicts);
    return 0;
}
