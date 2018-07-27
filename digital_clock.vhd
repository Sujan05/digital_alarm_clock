----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/27/2018 01:20:52 PM
-- Design Name: 
-- Module Name: digital_clock - Behavioral
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

entity controller is port (
  S: in STD_LOGIC_VECTOR (4 downto 0);
  DISPLAY0, DISPLAY1, DISPLAY2, DISPLAY3: out integer range 0 to 9 ;
  alarm: out STD_LOGIC;
  clk: in std_logic;
  reset: in std_logic );
end controller;

architecture Behavioral of controller is

  component Display60 is Port (
    number : in integer range 0 to 59;
    position1, position0: out integer range 0 to 9);
  end component;

  component Display24 is Port (
    number : in integer range 0 to 23;
    position1, position0: out integer range 0 to 9);
  end component;

  signal timer: std_logic_vector (13 downto 0);
  signal sectrigger : std_logic;
  signal DISPLAY10, DISPLAY11, DISPLAY20, DISPLAY21: integer range 0 to 9;
  signal DISPLAY30, DISPLAY31, DISPLAY40, DISPLAY41: integer range 0 to 9;
  signal hours, whours: integer range 0 to 23;
  signal secs, mins, wmins: integer range 0 to 59;
  type state_type is (ntime, set_time, set_alarm);
  signal current_state: state_type;

  begin

    SECTIMER: process(clk,reset)
      variable timer_msb_to_zero : std_logic_vector(timer’RANGE);
    begin
      if reset=’1’ then
        timer <= (others => ’0’);
      elsif clk’EVENT and clk=’1’ then
        timer_msb_to_zero := timer;
        -- set msb to zero, the msb will be our overflow bit
        timer_msb_to_zero(timer’LENGTH-1) := ’0’;
        timer <= timer_msb_to_zero + 1;
      end if;
    end process SECTIMER;

    sectrigger <= timer(timer’LENGTH-1);

    FSM: process (clk,reset,current_state,secs,mins,hours,wmins,whours, S)
      variable next_state: state_type;
    begin
      if reset = ’1’ then
        hours <= 0; mins <= 0; secs <= 0;
        whours <= 0; wmins <= 0; alarm <= ’0’;
        current_state <= ntime;
      elsif (clk’event and clk=’1’) then
        if (not (current_state = set_time) and (sectrigger=’1’)) then
          -- Zhle Uhr hoch
          if secs = 59 then
            secs <= 0;
            if mins = 59 then
              mins <= 0;
              if hours = 23 then
                hours <= 0;
              else
                hours <= hours+1;
              end if;
            else
              mins <= mins+1;
            end if;
          else
            secs <= secs+1;
          end if;
        end if;

        case current_state is
when ntime =>
-- check if alarm is set
-- set next state
-- State Set_time
-- set minutes and hours with S(3) or S(4)
-- set next state
-- state set_alarm
-- set WMinute and WStunde with S(3) bzw. S(4)
-- set next state
.......;
    end process FSM;

    -- MINUTE-DISPLAY (TIME)
    MIN_CONVERT: Display60
      PORT MAP (number => ...., position1 => DISPLAY11, position0 => DISPLAY10);
    -- HOURS-DISPLAY (TIME)
    HR_CONVERT: Display24
      PORT MAP (number => ....., position1 => DISPLAY21, position0 => DISPLAY20);
    -- MINUTE-DISPLAY (ALARM-TIME)
    WMIN_CONVERT: Display60
      PORT MAP (number => ...., position1 => DISPLAY31, position0 => DISPLAY30);
    -- HOURS-DISPLAY (ALARM-TIME)
    WHR_CONVERT: Display24
      PORT MAP (number => ..... , position1 => DISPLAY41, position0 => DISPLAY40);

    -- Describes how to set the DISPLAY-Variables
    Switch_Display: process (S, DISPLAY10, DISPLAY11, DISPLAY20, DISPLAY21, DISPLAY30,
        DISPLAY31, DISPLAY40, DISPLAY41 ) is
        begin
          if current_state /= set_alarm then
            DISPLAY0 <= DISPLAY10 ;
            DISPLAY1 <= DISPLAY11;
            DISPLAY2 <= DISPLAY20 ;
            DISPLAY3 <= DISPLAY21 ;
          else
            DISPLAY0 <= DISPLAY30;
            DISPLAY1 <= DISPLAY31;
            DISPLAY2 <= DISPLAY40;
            DISPLAY3 <= DISPLAY41;
          end if;
    end process Switch_Display;

end Behavioral;



