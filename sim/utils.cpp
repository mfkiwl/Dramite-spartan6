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
#include "utils.h"

uint32_t swap_endian32(uint32_t data){
  uint32_t swapped = 0x00;

  swapped += (data & 0xff000000) >> 24;
  swapped += (data & 0x00ff0000) >>  8;
  swapped += (data & 0x0000ff00) <<  8;
  swapped += (data & 0x000000ff) << 24;

  return swapped;
}
