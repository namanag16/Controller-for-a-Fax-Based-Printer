----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:00:59 09/10/2014 
-- Design Name: 
-- Module Name:    fax - Behavioral 
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

entity fax is
port (fax_line : in std_logic;
		sys_clk : in std_logic;
		p_ready : in std_logic;
		motor_control: out std_logic;
		print_data: out std_logic_vector(7 downto 0);
		d_ready: out std_logic;
		sys_rst : in std_logic := '0'
		);
end fax;

architecture Behavioral of fax is
component data_processor port (sys_clk : IN STD_LOGIC;
		sys_rst : IN STD_LOGIC;
		--data_en : IN std_logic;
		--count : OUT std_logic;
		--row_count : OUT std_logic;
--		data_in : in STD_LOGIC_VECTOR(79 DOWNTO 0);
		--valid_bit : in STD_LOGIC;
		print_data : OUT std_logic_vector(7 DOWNTO 0)
		);
end component;

component controller port (d_ready: OUT std_logic;
	  p_ready: IN std_logic:='1';
	  motor_control: OUT std_logic
	  --count,row_count,sys_clk_fax: IN std_logic;
	 -- data_en: OUT std_logic
		);
end component;

component clock_div
		generic (n : integer);
		port (sys_rst : in  STD_LOGIC;
           sys_clk : in  STD_LOGIC
           --sys_clk_fax : out  STD_LOGIC
			  );
		
end component;

component data_rcvr port (fax_line, sys_rst, sys_clk: IN std_logic		--check; no outputs
		);
end component;
		
FOR ALL: data_processor use ENTITY work.data_processor(arch_data_processor);
FOR ALL: controller use ENTITY work.controller(Behavioral);
FOR ALL: clock_div use ENTITY work.clock_div(Behavioral);
FOR ALL: data_rcvr use ENTITY work.data_rcvr(arch_data_rcvr);


begin
A1 : data_processor port map (sys_clk, sys_rst, print_data);		--change ports
A2 : controller port map (d_ready, p_ready, motor_control);		--declare variables
A3 : clock_div generic map (n => 2) port map (sys_rst, sys_clk);
A4 : data_rcvr port map (fax_line, sys_rst, sys_clk);

end Behavioral;

