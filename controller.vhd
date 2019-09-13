----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:48:44 08/25/2014 
-- Design Name: 
-- Module Name:    controller - Behavioral 
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

entity controller is
port(d_ready: OUT std_logic;
	  p_ready: IN std_logic:='1';
	  motor_control: OUT std_logic;
	  count,row_count: IN std_logic := '0';
	  sys_clk: IN std_logic := '0';
	  data_en: OUT std_logic
	  );
end controller;

architecture Behavioral of controller is

begin

process
begin
wait until count = '1';
d_ready <= '1';

if (p_ready = '1') then
data_en<='1';
else
data_en<='0';
end if;
--end if;

if (row_count = '1') then

	if (rising_edge(sys_clk)) then
		motor_control<= '1';
		motor_control <= transport '0' after 15ns;
		--if (falling_edge(sys_clk_fax)) then
		--wait until rising_edge(sys_clk_fax);
		--motor_control <= '0';
		
	end if;
	 --end if;
	
else
motor_control <='0';

--end if;
end if;
end process;

end Behavioral;