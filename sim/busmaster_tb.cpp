/*******************************************************************************

    This program is free software (firmware): you can redistribute it and/or
    modify it under the terms of  the GNU General Public License as published
    by the Free Software Foundation, either version 3 of the License, or (at
    your option) any later version.
   
    This program is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTIBILITY or
    FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
    for more details.
   
    You should have received a copy of the GNU General Public License along
    with this program.  (It's in the $(ROOT)/doc directory.  Run make with no
    target there if the PDF file isn't present.)  If not, see
    <http://www.gnu.org/licenses/> for a copy.

    Description: Dramite simulation top level

    Copyright (C) 2018 Wenting Zhang

*******************************************************************************/
#include <signal.h>
#include <time.h>
#include <ctype.h>

#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vbusmaster.h"

#include "memsim.h"
#include "cpusim.h"

#define VVAR(A) busmaster__DOT_ ## A

class TESTBENCH {
    Vbusmaster *m_core;
    VerilatedVcdC* m_trace;
    unsigned long  m_tickcount;
public:
    bool m_done;
    CPUSIM *m_cpu;
    MEMSIM *m_bios;
    MEMSIM *m_ram;
    unsigned char fake_rom_wr_ack;

    TESTBENCH() {
        m_core = new Vbusmaster;
        Verilated::traceEverOn(true);

        m_done = false;
        m_cpu = new CPUSIM();
        m_bios = new MEMSIM(32 * 1024 / 4, 0);
        m_ram = new MEMSIM(640 * 1024 / 4, 2);
    }

    ~TESTBENCH() {
        if (m_trace) m_trace->close();
        delete m_core;
        m_core = NULL;
    }

    void opentrace(const char *vcdname) {
        if (!m_trace) {
            m_trace = new VerilatedVcdC;
            m_core->trace(m_trace, 99);
            m_trace->open(vcdname);
        }
    }

    void closetrace(void) {
        if (m_trace) {
            m_trace->close();
            m_trace = NULL;
        }
    }

    void eval(void) {
        m_core->eval();
    }

    void load_bios(const char *fname) {
        m_bios->load(fname);
    }

    void close(void) {
        m_done = true;
    }

    bool done(void) {
        return m_done;
    }

    virtual void tick(void) {
        // Why I have to do this ?
        m_cpu->operator()(
            m_core->cpu_a, 
            m_core->cpu_d, 
            m_core->cpu_ads_n, 
            m_core->cpu_bhe_n, 
            m_core->cpu_ble_n, 
            m_core->cpu_busy_n, 
            m_core->cpu_clk2, 
            m_core->cpu_dc, 
            m_core->cpu_error_n, 
            m_core->cpu_hlda,
            m_core->cpu_lock_n, 
            m_core->cpu_hold, 
            m_core->cpu_intr, 
            m_core->cpu_mio, 
            m_core->cpu_na_n, 
            m_core->cpu_nmi, 
            m_core->cpu_pereq, 
            m_core->cpu_ready_n, 
            m_core->cpu_reset, 
            m_core->cpu_wr,
            m_done);

        m_bios->operator()(
            0, 
            m_core->rom_address, 
            0, 
            0, 
            m_core->rom_rd_enable, 
            fake_rom_wr_ack, 
            m_core->rom_rd_data, 
            m_core->rom_rd_valid);

        m_ram->operator()(
            m_core->ram_wr_data, 
            m_core->ram_address, 
            m_core->ram_wr_enable, 
            m_core->ram_wr_mask,
            m_core->ram_rd_enable, 
            m_core->ram_wr_ack,
            m_core->ram_rd_data, 
            m_core->ram_rd_valid);
        
        m_tickcount++;

        // Make sure we have our evaluations straight before the top
        // of the clock.  This is necessary since some of the 
        // connection modules may have made changes, for which some
        // logic depends.  This forces that logic to be recalculated
        // before the top of the clock.
        eval();
        if (m_trace) m_trace->dump(10*m_tickcount-2);
        m_core->clk = 1;
        eval();
        if (m_trace) m_trace->dump(10*m_tickcount);
        m_core->clk = 0;
        eval();
        if (m_trace) m_trace->dump(10*m_tickcount+5);
    }

    void reset(void) {
        m_core->rst = 1;
        tick();
        m_core->rst = 0;
        // printf("RESET\n");
        m_cpu->start();
    }
};

TESTBENCH *tb;

void busmaster_kill(int v) {
    tb->close();
    fprintf(stderr, "KILLED!!\n");
    exit(EXIT_SUCCESS);
}

void usage(void) {
    puts("USAGE: busmaster_tb ?");
}

int main(int argc, char **argv) {
    const char *trace_file = "trace.vcd";
    const char *bios_file = "../bios/bios.bin";
    
    printf("Dramite Simulator\n");

    Verilated::commandArgs(argc, argv);

    tb = new TESTBENCH();
    tb->load_bios(bios_file);
    tb->opentrace(trace_file);
    tb->reset();

    printf("Initialized.\n");

    while(!tb->done()) {
        tb->tick();
    }

    exit(0);
}

