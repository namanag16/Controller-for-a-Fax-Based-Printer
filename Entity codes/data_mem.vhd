----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:18:56 09/05/2014 
-- Design Name: 
-- Module Name:    data_mem - arch_data_mem 
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
use IEEE.std_logic_arith.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity data_mem is
    Port ( r_w : in  STD_LOGIC;
			  sys_clk : in STD_LOGIC;
			  sys_rst : in STD_LOGIC;
           data_in : in  STD_LOGIC_VECTOR(79 DOWNTO 0);
			  data_out : out STD_LOGIC_VECTOR(79 DOWNTO 0);
			  valid_bit : out STD_LOGIC
			);  
end data_mem;

architecture arch_data_mem of data_mem is
 --variable read_index : integer := 0;
 TYPE mem_array is array(0 to 8192) of std_logic_vector(79 downto 0);

 type mem_valid is array (0 to 8192) of std_logic;
 
begin

	process(sys_clk)
	variable read_index : integer := 0;
	--variable data_mem : mem_array := (others => "0");
	variable data_mem : mem_array;
	variable data_valid : mem_valid;  
	variable mem_index : integer := 0;
	
	BEGIN 
	for i in 8192 downto 0 loop
		data_valid(i) := '0';
	end loop;
	
		IF(sys_clk = '1' AND sys_clk'event) then
			IF (sys_rst='1') THEN
			
				read_index := 0;
				mem_index := 0;
				for i in 8192 downto 0 loop
					data_valid(i) := '0';
				end loop;  -- set all data valid bits to be zero
			
			ELSIF (r_w = '1') THEN
				-- this is write mode 
				if(mem_index = read_index -1 ) then 
					--send out an error .. memory is full
				else	
					data_mem(mem_index) := data_in;
					data_valid(mem_index) := '1';
					
					if(mem_index = 8192) then
						mem_index :=0;
					else 
						mem_index := mem_index +1;
					end if;
				end if;
			ELSIF (r_w = '0') THEN  -- this is read mode
				if(mem_index = read_index ) then
					-- send out an error .. memory has no elements to read
					report "memory has no elements to read";
					--elsif (read_index = 1) then
				   elsif (data_valid(read_index) = '1') then
					data_out <= 	data_mem(read_index);
					valid_bit <= data_valid(read_index);
					--data_valid(read_index) := '1';
					if(read_index = 8192) then
						read_index := 0;
					else
						read_index := read_index + 1;
					end if;
				end if;
			
			END IF;
		END IF;
	END process;

end arch_data_mem;

