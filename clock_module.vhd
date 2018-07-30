----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/30/2018 01:43:59 PM
-- Design Name: 
-- Module Name: clock_module - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clock_module is
    Port ( 
        clk: in STD_LOGIC;
        output: out STD_LOGIC
    );
end clock_module;

architecture Behavioral of clock_module is
    signal value: integer := 0;
    signal counter: STD_LOGIC := '0';
begin
    process(clk)
    begin
    if clk'event and clk = '1' then
        if counter = '0' then
            value <= value + 1;
            if value = 50000000 then
                counter <= '1';
            end if;
        else 
            value <= value - 1;
            if value = 0 then
                counter <= '0';
            end if;
        end if;
    end if;
    end process;
    
    process(counter)
    begin
    if counter = '1' then
        output <= '1';
      else 
        output <= '0';    
    end if;
    end process;

end Behavioral;

