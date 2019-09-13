----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:16:55 08/24/2014 
-- Design Name: 
-- Module Name:    module_1 - arch_module_1 
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
--use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity data_rcvr is
PORT(	fax_line: in std_logic;
		sys_rst: in std_logic := '0';
		sys_clk_fax : in std_logic := '0';
		sys_clk: IN std_logic := '0'
		
		);
end data_rcvr;

architecture arch_data_rcvr of data_rcvr is

TYPE sysState IS (IDLE,START,RECEIVING);
signal LSR : std_logic_vector(79 DOWNTO 0);
--variable uc_length:integer :=1;
shared variable count_bits :integer :=0;
shared variable i:integer :=0;
shared variable mem_load : std_logic:='0';
--TYPE mem_array is array(0 to 2**16-1) of std_logic_vector(79 downto 0);
--variable data_mem : mem_array;
--type mem_valid is array (0 to 2**16-1) of std_logic; 
--variable data_valid : mem_valid := (others =>'0');
shared variable x: integer;
signal data_valid : std_logic ;
signal data_in : std_logic_vector(79 downto 0);
signal r_w: STD_LOGIC :='1';
shared variable stateNow: sysState :=IDLE;

component data_mem port(r_w : in  STD_LOGIC;
			  sys_clk : in STD_LOGIC;
			  sys_rst : in STD_LOGIC;
           data_in : in  STD_LOGIC_VECTOR(79 DOWNTO 0)
			 
			  --data_out : out  STD_LOGIC_VECTOR(79 DOWNTO 0);
			  --valid_bit : out STD_LOGIC
			);  
end component;

FOR ALL: data_mem use ENTITY work.data_mem(arch_data_mem);

begin


U1: data_mem port map (r_w,sys_clk,sys_rst,data_in);
	reset: PROCESS(sys_rst)
		--variable stateNow: sysState :=IDLE;
		variable count_bits :integer;
		variable i:integer :=0;
		variable mem_load : std_logic;
		variable x: integer;
		variable uc_length:integer;			--previous value 1 (default)
		

	BEGIN 
		IF (sys_rst ='1' ) THEN
			stateNow:= IDLE;
			uc_length:=1;
			count_bits:=0;
			mem_load:='0';
			
			--data_valid := (others =>'0');       -- change all the valid bits to zero 
			i:=0;
			
		END IF;
	END PROCESS reset;
	
	poll: PROCESS(sys_clk_fax)
	   variable count_bits :integer;
		variable i:integer :=0;
		variable mem_load : std_logic;
		variable x: integer;
	BEGIN
	
		IF sys_clk_fax = '1' AND sys_clk_fax'EVENT AND stateNow = IDLE THEN
			IF(fax_line='0') THEN   -- starting of a new record
				stateNow:=START;
			END IF;
		END IF;	
		
		IF sys_clk_fax = '1' AND sys_clk_fax'EVENT AND stateNow = START THEN
				IF(fax_line='0' OR fax_line= '1') THEN   -- just an indirection 
					stateNow:=RECEIVING;
				END IF;	
		END IF;	
		
	END PROCESS poll;
	
	receive: PROCESS (sys_clk_fax)
		variable count_bits :integer;
		variable i:integer :=0;
		variable mem_load : std_logic;
		variable x: integer;
		variable uc_length:integer;			--previous default value 1
	BEGIN 
		
		--L1: LOOP
			IF sys_clk_fax = '1' AND sys_clk_fax'EVENT AND stateNow = RECEIVING THEN
				count_bits:= count_bits +1;
				LSR <= LSR(78 DOWNTO 1) & fax_line;
				
				if (count_bits=6) then 
					uc_length := to_integer(unsigned(LSR(5 downto 0)));
				end if;
				
				if (count_bits>15) then
					uc_length:=uc_length-1;
				end if;
				
				if uc_length =0 then
					mem_load:='1';
				end if;
				
				IF(mem_load = '1' ) THEN 
					x := count_bits -1;
					data_in <= LSR(x downto 0) & (others=>'0') ;
					--data_mem(i):= (LSR(x downto 0),(others=>"0")) ;
					--data_valid(i):='1';
					i:=i+1;
					count_bits:=0;
					mem_load:='0';
					r_w <='1';
				END IF;
				
				IF (uc_length =0) then
					stateNow :=IDLE;
					uc_length:=1;
					count_bits:=0;
					mem_load:='0';
				END IF;
				
				
				 
				--EXIT L1 when uc_length = 0; 	
				
			END IF;
		
	END PROCESS receive;
	
	
end ARCHITECTURE arch_data_rcvr;

