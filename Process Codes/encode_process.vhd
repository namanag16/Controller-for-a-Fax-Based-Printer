library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;

encode: process(sys_clk)
variable nc_count : integer := 0;
variable c_count : integer := 0;
variable ch : std_logic := 'Z';
variable index: integer :=-1;
begin
   if sys_clk ='1' and sys_clk'event then
	  
	  for count in 0 to 63 
	  loop
		if(count=0) then   -- we will be compressing bits only if they occur before the uncompressed section
			if x[count] is all 0 or 1 then 
				ch :=1 or 0;
				c_count := c_count +1;
			else 
				nc_count :=nc_count+1;
				index:=count;
			end if;
		else
			if(x[count](0) = ch ) then
				c_count:= c_count+1;
			else 
				uc_count := uc_count +1;
				if(index = -1) then index := count; end if;
			end if;
			
		end if;
		
	  end loop; -- the loop calculates the compressed and uncompressed length.. also the compressed bit if present
	  
	  y(1 downto 0) := "00"; -- how to know if the record is the last record of the page 
	  y(7 downto 2) :=to_stdlogicvector(nc_count,6);    -- convert integer to std_logic_vector
	  y((8) := ch;
	  y(15 downto 9) := to_stdlogicvector(c_count,7);
	  
	  for count in index to x'length  -- should i run this till length or (length-1)
	  loop
		p:= count - index;
		q:= 16 + p*8;
		y(q to (q+7)):=x[count]; -- can i do this assignment
	  end loop;
   end if;
end process encode;