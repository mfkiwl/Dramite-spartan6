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

    Description: 386 bus simulation layer for cpu simulation

    Copyright (C) 2018 Wenting Zhang

*******************************************************************************/
#pragma once

#include <stdint.h>
#include <mutex>
#include <thread>
#include <condition_variable>
#include "cpucore.h"
#include "cpubus.h"

class CPUSIM {
private:
    typedef enum bus_state {
        BUS_IDLE,
        BUS_S1,
        BUS_S2,
        BUS_DONE
    } BusState;

    uint32_t _bus_req_addr;
    uint16_t _bus_req_data;
    bool _bus_req_wr;
    bool _bus_req_mio;
    BusState _bus_state;
    uint8_t _last_reset;

public:

    // For testbench run. Normally start at FFF0
    const uint32_t CPU_INIT_EIP = 10;
    // For testbench run
    const uint32_t CPU_INIT_ESP = 0;

    CPUCORE *m_cpucore;
    CPUBUS *m_cpubus;
    std::mutex m_mutex;
    std::condition_variable m_cond;
    bool m_bus_request;
    bool m_bus_completed; 
    uint32_t m_bus_req_addr;
    uint16_t m_bus_req_data;
    bool m_bus_req_wr;
    bool m_bus_req_mio;
    std::thread *cpu_thread;

    CPUSIM();
    ~CPUSIM();
    void start();
    void apply(uint32_t &cpu_a, uint16_t &cpu_d, uint8_t &cpu_ads_n, uint8_t &cpu_bhe_n, uint8_t &cpu_ble_n, const uint8_t cpu_busy_n, const uint8_t cpu_clk2, uint8_t &cpu_dc, const uint8_t cpu_error_n, uint8_t &cpu_hlda, uint8_t &cpu_lock_n, const uint8_t cpu_hold, const uint8_t cpu_intr, uint8_t &cpu_mio, const uint8_t cpu_na_n, const uint8_t cpu_nmi, const uint8_t cpu_pereq, const uint8_t cpu_ready_n, const uint8_t cpu_reset, uint8_t &cpu_wr, bool &done);
    void operator() (uint32_t &cpu_a, uint16_t &cpu_d, uint8_t &cpu_ads_n, uint8_t &cpu_bhe_n, uint8_t &cpu_ble_n, const uint8_t cpu_busy_n, const uint8_t cpu_clk2, uint8_t &cpu_dc, const uint8_t cpu_error_n, uint8_t &cpu_hlda, uint8_t &cpu_lock_n, const uint8_t cpu_hold, const uint8_t cpu_intr, uint8_t &cpu_mio, const uint8_t cpu_na_n, const uint8_t cpu_nmi, const uint8_t cpu_pereq, const uint8_t cpu_ready_n, const uint8_t cpu_reset, uint8_t &cpu_wr, bool &done) {
        apply(cpu_a, cpu_d, cpu_ads_n, cpu_bhe_n, cpu_ble_n, cpu_busy_n, cpu_clk2, cpu_dc, cpu_error_n, cpu_hlda, cpu_lock_n, cpu_hold, cpu_intr, cpu_mio, cpu_na_n, cpu_nmi, cpu_pereq, cpu_ready_n, cpu_reset, cpu_wr, done);
    }
};
