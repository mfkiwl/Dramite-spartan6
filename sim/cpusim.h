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
#ifndef CPUSIM_H
#define CPUSIM_H

class CPUSIM {
public:
    typedef unsigned short BUSW;
    typedef unsigned long ulong;
    typedef unsigned char uchar;

    CPUSIM();
    ~CPUSIM();
    void apply(ulong &cpu_a, BUSW &cpu_d, uchar &cpu_ads_n, uchar &cpu_bhe_n, uchar &cpu_ble_n, const uchar cpu_busy_n, const uchar cpu_clk2, uchar &cpu_dc, const uchar cpu_error_n, uchar &cpu_hlda, uchar &cpu_lock_n, const uchar cpu_hold, const uchar cpu_intr, uchar &cpu_mio, const uchar cpu_na_n, const uchar cpu_nmi, const uchar cpu_pereq, const uchar cpu_ready_n, const uchar cpu_reset, uchar &cpu_wr);
    void operator() (ulong &cpu_a, BUSW &cpu_d, uchar &cpu_ads_n, uchar &cpu_bhe_n, uchar &cpu_ble_n, const uchar cpu_busy_n, const uchar cpu_clk2, uchar &cpu_dc, const uchar cpu_error_n, uchar &cpu_hlda, uchar &cpu_lock_n, const uchar cpu_hold, const uchar cpu_intr, uchar &cpu_mio, const uchar cpu_na_n, const uchar cpu_nmi, const uchar cpu_pereq, const uchar cpu_ready_n, const uchar cpu_reset, uchar &cpu_wr) {
        apply(cpu_a, cpu_d, cpu_ads_n, cpu_bhe_n, cpu_ble_n, cpu_busy_n, cpu_clk2, cpu_dc, cpu_error_n, cpu_hlda, cpu_lock_n, cpu_hold, cpu_intr, cpu_mio, cpu_na_n, cpu_nmi, cpu_pereq, cpu_ready_n, cpu_reset, cpu_wr);
    }
}