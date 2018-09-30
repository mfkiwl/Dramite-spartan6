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
#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <assert.h>
#include <thread>
#include <mutex>
#include <condition_variable>
#include "cpusim.h"
#include "cpucore.h"
#include "cpubus.h"

CPUSIM::CPUSIM() {
    _bus_state = BUS_IDLE;
    _last_reset = 0;
    m_bus_request = false;
    m_bus_req_wr = false;
    m_bus_req_mio = false;
    m_bus_completed = false;
    m_bus_req_addr = 0;
    m_bus_req_data = 0;

    m_cpubus = new CPUBUS(std::ref(m_mutex), std::ref(m_cond), m_bus_request, m_bus_completed, m_bus_req_addr, m_bus_req_data, m_bus_req_wr, m_bus_req_mio);
    m_cpucore = new CPUCORE(m_cpubus);
}

CPUSIM::~CPUSIM() {
    //delete m_cpucore;
    //delete m_cpubus;
}

void CPUSIM::start() {
    cpu_thread = new std::thread(&CPUCORE::run, m_cpucore);
}

void CPUSIM::apply(
    uint32_t &cpu_a, 
    uint16_t &cpu_d, 
    uint8_t &cpu_ads_n, 
    uint8_t &cpu_bhe_n, 
    uint8_t &cpu_ble_n, 
    const uint8_t cpu_busy_n, 
    const uint8_t cpu_clk2, 
    uint8_t &cpu_dc, 
    const uint8_t cpu_error_n, 
    uint8_t &cpu_hlda,
    uint8_t &cpu_lock_n, 
    const uint8_t cpu_hold, 
    const uint8_t cpu_intr, 
    uint8_t &cpu_mio, 
    const uint8_t cpu_na_n, 
    const uint8_t cpu_nmi, 
    const uint8_t cpu_pereq, 
    const uint8_t cpu_ready_n, 
    const uint8_t cpu_reset, 
    uint8_t &cpu_wr,
    bool &done) {
        
        size_t r_eip;
        //  while(emulator.get_eip() < MEMORY_SIZE) {
        //  uint8_t opcode = emulator.read_next_opcode();
        //  emulator.exec(opcode);
        //  if (emulator.get_eip() == 0x00) break;
        //  }
        //  emulator.dump_registers();
        
        if ((!_last_reset)&&(cpu_reset)) {
            m_cpucore -> init(CPU_INIT_EIP, CPU_INIT_ESP);
        }
        else {
            switch (_bus_state) {
                case BUS_IDLE: {
                    // Currently Idle, check if there is new request pending
                    std::lock_guard<std::mutex> lock(m_mutex);
                    if (m_bus_request) {
                        m_bus_request = false; // Clear the request
                        _bus_req_addr = m_bus_req_addr;
                        _bus_req_data = m_bus_req_data;
                        _bus_req_wr = m_bus_req_wr;
                        _bus_req_mio = m_bus_req_mio;
                        printf("cpusim: bus io %c %04x %02x\n", _bus_req_wr ? 'W':'R', _bus_req_addr, _bus_req_data);
                        _bus_state = BUS_DONE;
                    }
                    break;
                }
                case BUS_DONE: {
                    // next state will be idle
                    _bus_state = BUS_IDLE;
                    // Lock the data stuructiure
                    std::lock_guard<std::mutex> lock(m_mutex);
                    m_bus_completed = true;
                    // Notify the CPU bus
                    m_cond.notify_one();
                    break;
                }
            }

        }

        _last_reset = cpu_reset;

}