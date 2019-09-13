----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:57:39 08/25/2014 
-- Design Name: 
-- Module Name:    printer - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

--type state is (full,notfull);
--subtype count is integer range 0 to 2**19-1;

entity printer is
generic(
			mem:integer:=0;					--mem start point
			max:integer:=2**19-1);			--max memory
			
			--type space is array(7 downto 0) of std_logic;
			--type mem_arr is array(2**16-1 downto 0) of space;

port( sys_clk: IN std_logic;
		print_data: IN std_logic_vector(7 downto 0);
		d_ready: IN std_logic:='0';
		p_ready: OUT std_logic;
		motor_control: IN std_logic:='0'
		);
end printer;

architecture Behavioral of printer is
type state is (full,notfull);
--type space is array(7 downto 0) of std_logic;
type mem_arr is array(0 to 2**16-1) of std_logic_vector(7 downto 0);
signal memory_pr:mem_arr;
--variable temp:space;
begin

process

variable printer_state:state;
variable count_in:integer;

begin
wait until rising_edge(sys_clk);
if (d_ready = '1') then
	if (mem = max) then
		printer_state:= full;
		p_ready<='0';
	else
		printer_state:= notfull;
		p_ready<='1';
	

		for count_in in 0 to 2**16-1 loop
			if (rising_edge(sys_clk)) then
			exit when printer_state = full;
			--temp:= print_data;
			memory_pr(count_in) <= print_data;
			end if;
		end loop;
	end if;
end if;


end process;
end Behavioral;



