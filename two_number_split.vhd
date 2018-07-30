----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/30/2018 01:42:30 PM
-- Design Name: 
-- Module Name: two_number_split - Behavioral
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


entity two_number_split is
  Port (NUMBER: in STD_LOGIC_VECTOR (6 downto 0);
        LEFT_DIGIT: out STD_LOGIC_VECTOR (3 downto 0);
        RIGHT_DIGIT: out STD_LOGIC_VECTOR (3 downto 0));
end two_number_split;
--Binary to BCD converter for 0 to 99 
architecture Behavioral of two_number_split is
  begin
     process (NUMBER)
      variable z : STD_LOGIC_VECTOR(14 downto 0);
           begin
             for i in 0 to 14 loop
               z(i) := '0';
             end loop;
             z(9 downto 3) := NUMBER;
             for i in 0 to 3 loop
               if z(10 downto 7) > 4 then
                 z(10 downto 7) := z(10 downto 7) + 3;
               end if;
               if z(14 downto 11) > 4 then
                 z(14 downto 11) := z(14 downto 11) + 3;
               end if;
               z(14 downto 1) := z(13 downto 0);
             end loop;
             LEFT_DIGIT <= z(14 downto 11);
             RIGHT_DIGIT <= z(10 downto 7);
           end process;
end Behavioral;
