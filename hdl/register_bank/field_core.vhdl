--------------------------------------------------------------------------------
-- Project     : ESS FPGA Framework
--------------------------------------------------------------------------------
-- File        : field_core.vhdl
-- Authors     : Christian Amstutz
-- Created     : 2018-05-24
-- Last update : 2018-05-24
-- Platform    : Xilinx Ultrascale
-- Standard    : VHDL'93
--------------------------------------------------------------------------------
-- Description : Collection of the register fields belonging to the register
--               bank.
-- Problems    :
--------------------------------------------------------------------------------
-- Copyright (c) 2018 European Spallation Source ERIC
--------------------------------------------------------------------------------
-- Revisions   :
--
-- 0.1 : 2018-05-24  Christian Amstutz
--       Created
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

--------------------------------------------------------------------------------
--!
--------------------------------------------------------------------------------
entity field_core  is
  generic (
    RESET_VALUE      : std_logic_vector;
    WIDTH            : integer
  );
  port (
    clock_i          : in  std_logic;                                           --! System clock
    reset_n_i        : in  std_logic;                                           --! Reset signal, low-active

    write_en_i       : in  std_logic;                                           --! Record of write enable signals, one for each register
    bus_write_data_i : in  std_logic_vector(WIDTH-1 downto 0);                  --! Write data from the data bus
    field_value_o    : out std_logic_vector(WIDTH-1 downto 0);                  --! Output of register values towards the data bus
    logic_to_bus_o   : out std_logic_vector(WIDTH-1 downto 0);                  --! Value returned from the logic towards the data bus

    logic_data_o     : out std_logic_vector(WIDTH-1 downto 0);                  --! Output value towards the logic
    logic_return_i   : in  std_logic_vector(WIDTH-1 downto 0)                   --! Return value from the logic
  );
end entity field_core;

--------------------------------------------------------------------------------
--!
--------------------------------------------------------------------------------
architecture rtl of field_core is
  signal field_value : std_logic_vector(WIDTH-1 downto 0);
begin

  hw_fields : process (clock_i)
  begin

    if rising_edge(clock_i) then
      if reset_n_i = '0' then
        field_value <= RESET_VALUE;
      else
        if write_en_i = '1' then
          field_value <= bus_write_data_i;
        end if;
      end if;
      logic_to_bus_o <= logic_return_i;
    end if;

  end process hw_fields;

  field_value_o <= field_value;
  logic_data_o  <= field_value;

end architecture rtl;
