----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:38:22 08/25/2014 
-- Design Name: 
-- Module Name:    clock_div - Behavioral 
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

entity clock_div is
	 generic (n : integer := 2);
    Port ( sys_rst : in  STD_LOGIC;
           sys_clk : in  STD_LOGIC;
           sys_clk_fax : out  STD_LOGIC);
end clock_div;

architecture Behavioral of clock_div is

signal temp_clk : std_logic;
signal counter : integer;

begin

freq_div : process (sys_rst, sys_clk)
				begin
				
				if (sys_rst = '1') then
				temp_clk <= '0';
				counter <= 0;
				
				elsif (sys_clk = '1' and sys_clk'event) then
					if (counter = n/2) then
					temp_clk <= not(temp_clk);
					counter <= 0;
					
					else
					
					counter <= counter +1;
					end if;
				end if;
				end process freq_div;
		sys_clk_fax <=temp_clk;
		

end Behavioral;

