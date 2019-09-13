----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:22:10 08/25/2014 
-- Design Name: 
-- Module Name:    data_processor - arch_data_processor 
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
--use IEEE.std_logic_arith.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity data_processor is
PORT( sys_clk : IN STD_LOGIC;
		sys_rst : IN STD_LOGIC;
		data_en : IN std_logic := '0';
		count : OUT std_logic;
		row_count : OUT std_logic;
--		data_in : in STD_LOGIC_VECTOR(79 DOWNTO 0);
		--valid_bit : in STD_LOGIC;
		print_data : OUT std_logic_vector(7 DOWNTO 0)
		);
end data_processor;

architecture arch_data_processor of data_processor is

signal r_w: STD_LOGIC :='Z';
signal valid_bit :STD_LOGIC;
signal data_in : STD_LOGIC_VECTOR(79 DOWNTO 0);
type rng is range -1 to 7;
--type state is (NO_DATA, STOPPED, SENDING);
--variable myState :state := NO_DATA;   
--variable j_bit_count_indx,j_send_data_indx :integer :=0;
--variable total_bit_count,uc_count,c_count :integer :=0;
--variable c_count_i,uc_count_i:integer :=0;
--variable x :integer :=7;
--variable c_bit_i :std_logic;
--type pre_data is array(0 to 7) of bit;
--variable prepare_data : std_logic_vector(7 downto 0);
--variable y :integer :=0;
--variable row_counter :integer :=0;
signal dummy : STD_LOGIC_VECTOR(79 downto 0) := (others =>'1');
component data_mem port(r_w : in  STD_LOGIC;
			  sys_clk : in STD_LOGIC;
			  sys_rst : in STD_LOGIC;
           data_in : in  STD_LOGIC_VECTOR(79 DOWNTO 0);
			  data_out : out  STD_LOGIC_VECTOR(79 DOWNTO 0);
			  valid_bit : out STD_LOGIC
			);  
end component;

FOR ALL: data_mem use ENTITY work.data_mem(arch_data_mem);

begin

U1: data_mem port map (r_w,sys_clk,sys_rst,dummy,data_in,valid_bit);
--U1: data_mem PORT MAP(
--			r_w => r_w,
--			sys_clk => sys_clk,
--			sys_rst => sys_rst,
--			data_out => data_in, 
--			valid_bit => valid_bit);
--			
		reset: PROCESS(sys_rst)
		variable total_bit_count,uc_count,c_count :integer :=0;
		variable j_bit_count_indx,j_send_data_indx :integer :=0;
		variable c_count_i,uc_count_i:integer :=0;
		variable x :integer :=7;
		variable y :integer :=0;
		variable row_counter :integer :=0;
		BEGIN
		
		
		
			IF (sys_rst = '1') THEN 
				j_bit_count_indx:=0;
				j_send_data_indx:=0; 
				total_bit_count:=0;
				uc_count:=0;
				c_count:=0;
				c_count_i:=0;
				uc_count_i:=0;
				x:=7;
				y:=0;
				count <= '0';
				row_count <= '0';
				row_counter := 0;
				r_w<='Z';
				valid_bit<='0';
				
			END IF;
		END PROCESS reset;
		
		count_bits: PROCESS(sys_clk)
		variable temp : std_logic_vector(79 downto 0);
		--type temp1 is array(79 downto 0) of std_logic;
		--variable temp : temp1;
		variable j_bit_count_indx: integer:=0;
		variable total_bit_count,uc_count,c_count :integer :=0;
		BEGIN

			IF (sys_clk='1' AND sys_clk'EVENT) THEN 
				--U1_1: 
				IF (valid_bit = '1') THEN
					temp := data_in;
					uc_count := to_integer(unsigned(temp(79 downto 74)));
					c_count := to_integer(unsigned(temp(72 downto 66)));
					total_bit_count := uc_count + c_count;
					
					j_bit_count_indx:= j_bit_count_indx +1;
					
					--if(j_bit_count_indx > 2**16-1) then
					--	j_bit_count_indx:=0;
					--end if;
					
					IF(total_bit_count > 2**19) then 
						count<='1';
	-- should i set total_bit_count to zero again after this.. 
	-- should i send data continuously after this position and keep count 1 or 
	-- should i wait for the whole next page to come i.e. reset count						
	-- and total_bit_count to zero 
						
					end if;
					
				END IF;
			END IF;
		END PROCESS count_bits;
		
		uncompress_nsend:  PROCESS(sys_clk,data_en)
		variable temp : std_logic_vector(79 downto 0);
		variable temp1 : std_logic_vector(79 downto 0);
		variable j_send_data_indx : integer:=0;
		variable total_bit_count,uc_count,c_count :integer :=0;
		variable c_count_i,uc_count_i:integer :=0;
		variable x : integer :=7;
		variable c_bit_i :std_logic;
		variable prepare_data : std_logic_vector(7 downto 0);
		variable y :integer :=0;
		variable row_counter :integer :=0;
		
		BEGIN 
			--if(sys_clk='1' AND sys_clk'EVENT ) then
			if(data_en = '1' and data_en'event) THEN 
				r_w<='0';
				temp :=data_in;
			
			else
				IF(sys_clk='1' AND sys_clk'EVENT AND data_en = '1') THEN 
				--r_w<='Z';
				L1: LOOP
					r_w<='0';
					temp1 := data_in;
					
					uc_count_i := to_integer(unsigned(temp(79 downto 74))); -- take length of uncompressed data in the record
					c_count_i := to_integer(unsigned(temp(72 downto 66)));  -- take length of compressed data in the record
					c_bit_i := temp(73);  -- 73rd bit of the record is the compressed bit
					y:=0;	
					IF(c_count_i>0) THEN
					for i in 0 to 7 
					loop
						if (x>=0 or c_count_i>0) then
							prepare_data(x):=c_bit_i;
							x:= x-1;
							c_count_i:=c_count_i - 1;
							
							exit when c_count_i = 0;
						end if;
						
						
					end loop;
						
						if(x<0) then
							print_data <= prepare_data; -- if all 7 bits are full then transfer to print port
							x:=7;
							row_counter := row_counter + 8;
							if(row_counter > 512 ) then
								row_count <= '1';
								row_counter := row_counter - 512;
							end if;
							exit L1;
						else 
							if(uc_count_i > 0 ) then
								while (x >=0) loop
									--prepare_data(x) := temp((65-y)); -- take (65-y)th bit and assign to prepare data
									prepare_data(x) := temp(16+y); 
									uc_count:=uc_count-1;
									y:=y+1;
									x:=x-1;
									exit when (y+16)=80;
									exit when uc_count = 0;
								end loop;
							end if;
							if(x<0) then
								print_data <= prepare_data; -- if all 7 bits are full then transfer to print port
								x:=7;
								row_counter := row_counter + 8;
								if(row_counter > 512 ) then
									row_count <= '1';
									row_counter := row_counter-512;
								end if;
								exit L1;
							else 
								--j_send_data_indx := j_send_data_indx +1;
								
							end if;
						end if;
						
						
						
					END IF;
				END LOOP;
			END IF;
			end if;
			r_w<='Z';
			temp := temp1;
		END PROCESS uncompress_nsend;

end architecture arch_data_processor;

