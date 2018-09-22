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

    Description: A memory simulation model with simple delay control

    Copyright (C) 2018 Wenting Zhang
    Copyright (C) 2018 Kanta Mori

*******************************************************************************/
#define KB 1024
#define MB 1024*KB

#include <stdio.h>
#include <stdint.h>
#include "instructions.h"
#include "memory.h"

class Emulator{
public:
  Instructions instructions;
  Memory memory;

  void init(size_t memorysize, FILE *bin);
  void free();
  void exec(uint8_t opcode);
  void dump_registers();
  uint8_t read_next_opcode();
  uint8_t read_uint8(uint32_t addr);
  uint32_t get_eip();
};
