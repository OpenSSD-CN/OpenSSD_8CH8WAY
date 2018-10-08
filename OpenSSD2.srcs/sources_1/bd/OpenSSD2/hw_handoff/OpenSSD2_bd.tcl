
################################################################
# This is a generated script based on design: OpenSSD2
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2016.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source OpenSSD2_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z045ffg900-3
}


# CHANGE DESIGN NAME HERE
set design_name OpenSSD2

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]

  # Create ports
  set IO_NAND_CH0_DQ [ create_bd_port -dir IO -from 7 -to 0 IO_NAND_CH0_DQ ]
  set IO_NAND_CH0_DQS_N [ create_bd_port -dir IO IO_NAND_CH0_DQS_N ]
  set IO_NAND_CH0_DQS_P [ create_bd_port -dir IO IO_NAND_CH0_DQS_P ]
  set IO_NAND_CH1_DQ [ create_bd_port -dir IO -from 7 -to 0 IO_NAND_CH1_DQ ]
  set IO_NAND_CH1_DQS_N [ create_bd_port -dir IO IO_NAND_CH1_DQS_N ]
  set IO_NAND_CH1_DQS_P [ create_bd_port -dir IO IO_NAND_CH1_DQS_P ]
  set IO_NAND_CH2_DQ [ create_bd_port -dir IO -from 7 -to 0 IO_NAND_CH2_DQ ]
  set IO_NAND_CH2_DQS_N [ create_bd_port -dir IO IO_NAND_CH2_DQS_N ]
  set IO_NAND_CH2_DQS_P [ create_bd_port -dir IO IO_NAND_CH2_DQS_P ]
  set IO_NAND_CH3_DQ [ create_bd_port -dir IO -from 7 -to 0 IO_NAND_CH3_DQ ]
  set IO_NAND_CH3_DQS_N [ create_bd_port -dir IO IO_NAND_CH3_DQS_N ]
  set IO_NAND_CH3_DQS_P [ create_bd_port -dir IO IO_NAND_CH3_DQS_P ]
  set IO_NAND_CH4_DQ [ create_bd_port -dir IO -from 7 -to 0 IO_NAND_CH4_DQ ]
  set IO_NAND_CH4_DQS_N [ create_bd_port -dir IO IO_NAND_CH4_DQS_N ]
  set IO_NAND_CH4_DQS_P [ create_bd_port -dir IO IO_NAND_CH4_DQS_P ]
  set IO_NAND_CH5_DQ [ create_bd_port -dir IO -from 7 -to 0 IO_NAND_CH5_DQ ]
  set IO_NAND_CH5_DQS_N [ create_bd_port -dir IO IO_NAND_CH5_DQS_N ]
  set IO_NAND_CH5_DQS_P [ create_bd_port -dir IO IO_NAND_CH5_DQS_P ]
  set IO_NAND_CH6_DQ [ create_bd_port -dir IO -from 7 -to 0 IO_NAND_CH6_DQ ]
  set IO_NAND_CH6_DQS_N [ create_bd_port -dir IO IO_NAND_CH6_DQS_N ]
  set IO_NAND_CH6_DQS_P [ create_bd_port -dir IO IO_NAND_CH6_DQS_P ]
  set IO_NAND_CH7_DQ [ create_bd_port -dir IO -from 7 -to 0 IO_NAND_CH7_DQ ]
  set IO_NAND_CH7_DQS_N [ create_bd_port -dir IO IO_NAND_CH7_DQS_N ]
  set IO_NAND_CH7_DQS_P [ create_bd_port -dir IO IO_NAND_CH7_DQS_P ]
  set I_NAND_CH0_RB [ create_bd_port -dir I -from 7 -to 0 I_NAND_CH0_RB ]
  set I_NAND_CH1_RB [ create_bd_port -dir I -from 7 -to 0 I_NAND_CH1_RB ]
  set I_NAND_CH2_RB [ create_bd_port -dir I -from 7 -to 0 I_NAND_CH2_RB ]
  set I_NAND_CH3_RB [ create_bd_port -dir I -from 7 -to 0 I_NAND_CH3_RB ]
  set I_NAND_CH4_RB [ create_bd_port -dir I -from 7 -to 0 I_NAND_CH4_RB ]
  set I_NAND_CH5_RB [ create_bd_port -dir I -from 7 -to 0 I_NAND_CH5_RB ]
  set I_NAND_CH6_RB [ create_bd_port -dir I -from 7 -to 0 I_NAND_CH6_RB ]
  set I_NAND_CH7_RB [ create_bd_port -dir I -from 7 -to 0 I_NAND_CH7_RB ]
  set O_DEBUG [ create_bd_port -dir O -from 31 -to 0 O_DEBUG ]
  set O_NAND_CH0_ALE [ create_bd_port -dir O O_NAND_CH0_ALE ]
  set O_NAND_CH0_CE [ create_bd_port -dir O -from 7 -to 0 O_NAND_CH0_CE ]
  set O_NAND_CH0_CLE [ create_bd_port -dir O O_NAND_CH0_CLE ]
  set O_NAND_CH0_RE_N [ create_bd_port -dir O O_NAND_CH0_RE_N ]
  set O_NAND_CH0_RE_P [ create_bd_port -dir O O_NAND_CH0_RE_P ]
  set O_NAND_CH0_WE [ create_bd_port -dir O O_NAND_CH0_WE ]
  set O_NAND_CH0_WP [ create_bd_port -dir O O_NAND_CH0_WP ]
  set O_NAND_CH1_ALE [ create_bd_port -dir O O_NAND_CH1_ALE ]
  set O_NAND_CH1_CE [ create_bd_port -dir O -from 7 -to 0 O_NAND_CH1_CE ]
  set O_NAND_CH1_CLE [ create_bd_port -dir O O_NAND_CH1_CLE ]
  set O_NAND_CH1_RE_N [ create_bd_port -dir O O_NAND_CH1_RE_N ]
  set O_NAND_CH1_RE_P [ create_bd_port -dir O O_NAND_CH1_RE_P ]
  set O_NAND_CH1_WE [ create_bd_port -dir O O_NAND_CH1_WE ]
  set O_NAND_CH1_WP [ create_bd_port -dir O O_NAND_CH1_WP ]
  set O_NAND_CH2_ALE [ create_bd_port -dir O O_NAND_CH2_ALE ]
  set O_NAND_CH2_CE [ create_bd_port -dir O -from 7 -to 0 O_NAND_CH2_CE ]
  set O_NAND_CH2_CLE [ create_bd_port -dir O O_NAND_CH2_CLE ]
  set O_NAND_CH2_RE_N [ create_bd_port -dir O O_NAND_CH2_RE_N ]
  set O_NAND_CH2_RE_P [ create_bd_port -dir O O_NAND_CH2_RE_P ]
  set O_NAND_CH2_WE [ create_bd_port -dir O O_NAND_CH2_WE ]
  set O_NAND_CH2_WP [ create_bd_port -dir O O_NAND_CH2_WP ]
  set O_NAND_CH3_ALE [ create_bd_port -dir O O_NAND_CH3_ALE ]
  set O_NAND_CH3_CE [ create_bd_port -dir O -from 7 -to 0 O_NAND_CH3_CE ]
  set O_NAND_CH3_CLE [ create_bd_port -dir O O_NAND_CH3_CLE ]
  set O_NAND_CH3_RE_N [ create_bd_port -dir O O_NAND_CH3_RE_N ]
  set O_NAND_CH3_RE_P [ create_bd_port -dir O O_NAND_CH3_RE_P ]
  set O_NAND_CH3_WE [ create_bd_port -dir O O_NAND_CH3_WE ]
  set O_NAND_CH3_WP [ create_bd_port -dir O O_NAND_CH3_WP ]
  set O_NAND_CH4_ALE [ create_bd_port -dir O O_NAND_CH4_ALE ]
  set O_NAND_CH4_CE [ create_bd_port -dir O -from 7 -to 0 O_NAND_CH4_CE ]
  set O_NAND_CH4_CLE [ create_bd_port -dir O O_NAND_CH4_CLE ]
  set O_NAND_CH4_RE_N [ create_bd_port -dir O O_NAND_CH4_RE_N ]
  set O_NAND_CH4_RE_P [ create_bd_port -dir O O_NAND_CH4_RE_P ]
  set O_NAND_CH4_WE [ create_bd_port -dir O O_NAND_CH4_WE ]
  set O_NAND_CH4_WP [ create_bd_port -dir O O_NAND_CH4_WP ]
  set O_NAND_CH5_ALE [ create_bd_port -dir O O_NAND_CH5_ALE ]
  set O_NAND_CH5_CE [ create_bd_port -dir O -from 7 -to 0 O_NAND_CH5_CE ]
  set O_NAND_CH5_CLE [ create_bd_port -dir O O_NAND_CH5_CLE ]
  set O_NAND_CH5_E_N [ create_bd_port -dir O O_NAND_CH5_E_N ]
  set O_NAND_CH5_RE_P [ create_bd_port -dir O O_NAND_CH5_RE_P ]
  set O_NAND_CH5_WE [ create_bd_port -dir O O_NAND_CH5_WE ]
  set O_NAND_CH5_WP [ create_bd_port -dir O O_NAND_CH5_WP ]
  set O_NAND_CH6_ALE [ create_bd_port -dir O O_NAND_CH6_ALE ]
  set O_NAND_CH6_CE [ create_bd_port -dir O -from 7 -to 0 O_NAND_CH6_CE ]
  set O_NAND_CH6_CLE [ create_bd_port -dir O O_NAND_CH6_CLE ]
  set O_NAND_CH6_RE_N [ create_bd_port -dir O O_NAND_CH6_RE_N ]
  set O_NAND_CH6_RE_P [ create_bd_port -dir O O_NAND_CH6_RE_P ]
  set O_NAND_CH6_WE [ create_bd_port -dir O O_NAND_CH6_WE ]
  set O_NAND_CH6_WP [ create_bd_port -dir O O_NAND_CH6_WP ]
  set O_NAND_CH7_ALE [ create_bd_port -dir O O_NAND_CH7_ALE ]
  set O_NAND_CH7_CE [ create_bd_port -dir O -from 7 -to 0 O_NAND_CH7_CE ]
  set O_NAND_CH7_CLE [ create_bd_port -dir O O_NAND_CH7_CLE ]
  set O_NAND_CH7_RE_N [ create_bd_port -dir O O_NAND_CH7_RE_N ]
  set O_NAND_CH7_RE_P [ create_bd_port -dir O O_NAND_CH7_RE_P ]
  set O_NAND_CH7_WE [ create_bd_port -dir O O_NAND_CH7_WE ]
  set O_NAND_CH7_WP [ create_bd_port -dir O O_NAND_CH7_WP ]
  set pcie_perst_n [ create_bd_port -dir I pcie_perst_n ]
  set pcie_ref_clk_n [ create_bd_port -dir I pcie_ref_clk_n ]
  set pcie_ref_clk_p [ create_bd_port -dir I pcie_ref_clk_p ]
  set pcie_rx_n [ create_bd_port -dir I -from 7 -to 0 pcie_rx_n ]
  set pcie_rx_p [ create_bd_port -dir I -from 7 -to 0 pcie_rx_p ]
  set pcie_tx_n [ create_bd_port -dir O -from 7 -to 0 pcie_tx_n ]
  set pcie_tx_p [ create_bd_port -dir O -from 7 -to 0 pcie_tx_p ]

  # Create instance: CH0MMCMC1H200, and set properties
  set CH0MMCMC1H200 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.3 CH0MMCMC1H200 ]
  set_property -dict [ list \
CONFIG.CLKOUT1_JITTER {81.410} \
CONFIG.CLKOUT1_PHASE_ERROR {74.126} \
CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {200} \
CONFIG.JITTER_SEL {Min_O_Jitter} \
CONFIG.MMCM_BANDWIDTH {HIGH} \
CONFIG.MMCM_CLKFBOUT_MULT_F {15.750} \
CONFIG.MMCM_CLKIN1_PERIOD {10.0} \
CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
CONFIG.MMCM_CLKOUT0_DIVIDE_F {7.875} \
CONFIG.MMCM_COMPENSATION {ZHOLD} \
CONFIG.PRIM_SOURCE {Global_buffer} \
CONFIG.USE_LOCKED {false} \
 ] $CH0MMCMC1H200

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.MMCM_BANDWIDTH.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_CLKFBOUT_MULT_F.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_CLKIN1_PERIOD.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_CLKIN2_PERIOD.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_CLKOUT0_DIVIDE_F.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_COMPENSATION.VALUE_SRC {DEFAULT} \
 ] $CH0MMCMC1H200

  # Create instance: CH2MMCMC1H200, and set properties
  set CH2MMCMC1H200 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.3 CH2MMCMC1H200 ]
  set_property -dict [ list \
CONFIG.CLKOUT1_JITTER {81.410} \
CONFIG.CLKOUT1_PHASE_ERROR {74.126} \
CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {200} \
CONFIG.JITTER_SEL {Min_O_Jitter} \
CONFIG.MMCM_BANDWIDTH {HIGH} \
CONFIG.MMCM_CLKFBOUT_MULT_F {15.750} \
CONFIG.MMCM_CLKIN1_PERIOD {10.0} \
CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
CONFIG.MMCM_CLKOUT0_DIVIDE_F {7.875} \
CONFIG.MMCM_COMPENSATION {ZHOLD} \
CONFIG.PRIM_SOURCE {Global_buffer} \
CONFIG.USE_LOCKED {false} \
 ] $CH2MMCMC1H200

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.MMCM_BANDWIDTH.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_CLKFBOUT_MULT_F.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_CLKIN1_PERIOD.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_CLKIN2_PERIOD.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_CLKOUT0_DIVIDE_F.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_COMPENSATION.VALUE_SRC {DEFAULT} \
 ] $CH2MMCMC1H200

  # Create instance: CH3MMCMC1H200, and set properties
  set CH3MMCMC1H200 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.3 CH3MMCMC1H200 ]
  set_property -dict [ list \
CONFIG.CLKOUT1_JITTER {81.410} \
CONFIG.CLKOUT1_PHASE_ERROR {74.126} \
CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {200} \
CONFIG.JITTER_SEL {Min_O_Jitter} \
CONFIG.MMCM_BANDWIDTH {HIGH} \
CONFIG.MMCM_CLKFBOUT_MULT_F {15.750} \
CONFIG.MMCM_CLKIN1_PERIOD {10.0} \
CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
CONFIG.MMCM_CLKOUT0_DIVIDE_F {7.875} \
CONFIG.MMCM_COMPENSATION {ZHOLD} \
CONFIG.PRIM_SOURCE {Global_buffer} \
CONFIG.USE_LOCKED {false} \
 ] $CH3MMCMC1H200

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.MMCM_BANDWIDTH.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_CLKFBOUT_MULT_F.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_CLKIN1_PERIOD.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_CLKIN2_PERIOD.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_CLKOUT0_DIVIDE_F.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_COMPENSATION.VALUE_SRC {DEFAULT} \
 ] $CH3MMCMC1H200

  # Create instance: CH4MMCMC1H200, and set properties
  set CH4MMCMC1H200 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.3 CH4MMCMC1H200 ]
  set_property -dict [ list \
CONFIG.CLKOUT1_JITTER {81.410} \
CONFIG.CLKOUT1_PHASE_ERROR {74.126} \
CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {200} \
CONFIG.JITTER_SEL {Min_O_Jitter} \
CONFIG.MMCM_BANDWIDTH {HIGH} \
CONFIG.MMCM_CLKFBOUT_MULT_F {15.750} \
CONFIG.MMCM_CLKIN1_PERIOD {10.0} \
CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
CONFIG.MMCM_CLKOUT0_DIVIDE_F {7.875} \
CONFIG.MMCM_COMPENSATION {ZHOLD} \
CONFIG.PRIM_SOURCE {Global_buffer} \
CONFIG.USE_LOCKED {false} \
 ] $CH4MMCMC1H200

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.MMCM_BANDWIDTH.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_CLKFBOUT_MULT_F.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_CLKIN1_PERIOD.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_CLKIN2_PERIOD.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_CLKOUT0_DIVIDE_F.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_COMPENSATION.VALUE_SRC {DEFAULT} \
 ] $CH4MMCMC1H200

  # Create instance: CH6MMCMC1H200, and set properties
  set CH6MMCMC1H200 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.3 CH6MMCMC1H200 ]
  set_property -dict [ list \
CONFIG.CLKOUT1_JITTER {81.410} \
CONFIG.CLKOUT1_PHASE_ERROR {74.126} \
CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {200} \
CONFIG.JITTER_SEL {Min_O_Jitter} \
CONFIG.MMCM_BANDWIDTH {HIGH} \
CONFIG.MMCM_CLKFBOUT_MULT_F {15.750} \
CONFIG.MMCM_CLKIN1_PERIOD {10.0} \
CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
CONFIG.MMCM_CLKOUT0_DIVIDE_F {7.875} \
CONFIG.MMCM_COMPENSATION {ZHOLD} \
CONFIG.PRIM_SOURCE {Global_buffer} \
CONFIG.USE_LOCKED {false} \
 ] $CH6MMCMC1H200

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.MMCM_BANDWIDTH.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_CLKFBOUT_MULT_F.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_CLKIN1_PERIOD.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_CLKIN2_PERIOD.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_CLKOUT0_DIVIDE_F.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_COMPENSATION.VALUE_SRC {DEFAULT} \
 ] $CH6MMCMC1H200

  # Create instance: CH7MMCMC1H200, and set properties
  set CH7MMCMC1H200 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.3 CH7MMCMC1H200 ]
  set_property -dict [ list \
CONFIG.CLKOUT1_JITTER {81.410} \
CONFIG.CLKOUT1_PHASE_ERROR {74.126} \
CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {200} \
CONFIG.JITTER_SEL {Min_O_Jitter} \
CONFIG.MMCM_BANDWIDTH {HIGH} \
CONFIG.MMCM_CLKFBOUT_MULT_F {15.750} \
CONFIG.MMCM_CLKIN1_PERIOD {10.0} \
CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
CONFIG.MMCM_CLKOUT0_DIVIDE_F {7.875} \
CONFIG.MMCM_COMPENSATION {ZHOLD} \
CONFIG.PRIM_SOURCE {Global_buffer} \
CONFIG.USE_LOCKED {false} \
 ] $CH7MMCMC1H200

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.MMCM_BANDWIDTH.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_CLKFBOUT_MULT_F.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_CLKIN1_PERIOD.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_CLKIN2_PERIOD.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_CLKOUT0_DIVIDE_F.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_COMPENSATION.VALUE_SRC {DEFAULT} \
 ] $CH7MMCMC1H200

  # Create instance: Dispatcher_uCode_0, and set properties
  set Dispatcher_uCode_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 Dispatcher_uCode_0 ]
  set_property -dict [ list \
CONFIG.Coe_File {../../../../uProgROM_v2.0.coe} \
CONFIG.Enable_32bit_Address {false} \
CONFIG.Load_Init_File {true} \
CONFIG.Read_Width_A {64} \
CONFIG.Register_PortA_Output_of_Memory_Primitives {true} \
CONFIG.Use_Byte_Write_Enable {false} \
CONFIG.Use_RSTA_Pin {true} \
CONFIG.Write_Depth_A {256} \
CONFIG.Write_Width_A {64} \
CONFIG.use_bram_block {Stand_Alone} \
 ] $Dispatcher_uCode_0

  # Create instance: Dispatcher_uCode_1, and set properties
  set Dispatcher_uCode_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 Dispatcher_uCode_1 ]
  set_property -dict [ list \
CONFIG.Coe_File {../../../../uProgROM_v2.0.coe} \
CONFIG.Enable_32bit_Address {false} \
CONFIG.Load_Init_File {true} \
CONFIG.Read_Width_A {64} \
CONFIG.Register_PortA_Output_of_Memory_Primitives {true} \
CONFIG.Use_Byte_Write_Enable {false} \
CONFIG.Use_RSTA_Pin {true} \
CONFIG.Write_Depth_A {256} \
CONFIG.Write_Width_A {64} \
CONFIG.use_bram_block {Stand_Alone} \
 ] $Dispatcher_uCode_1

  # Create instance: Dispatcher_uCode_2, and set properties
  set Dispatcher_uCode_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 Dispatcher_uCode_2 ]
  set_property -dict [ list \
CONFIG.Coe_File {../../../../uProgROM_v2.0.coe} \
CONFIG.Enable_32bit_Address {false} \
CONFIG.Load_Init_File {true} \
CONFIG.Read_Width_A {64} \
CONFIG.Register_PortA_Output_of_Memory_Primitives {true} \
CONFIG.Use_Byte_Write_Enable {false} \
CONFIG.Use_RSTA_Pin {true} \
CONFIG.Write_Depth_A {256} \
CONFIG.Write_Width_A {64} \
CONFIG.use_bram_block {Stand_Alone} \
 ] $Dispatcher_uCode_2

  # Create instance: Dispatcher_uCode_3, and set properties
  set Dispatcher_uCode_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 Dispatcher_uCode_3 ]
  set_property -dict [ list \
CONFIG.Coe_File {../../../../uProgROM_v2.0.coe} \
CONFIG.Enable_32bit_Address {false} \
CONFIG.Load_Init_File {true} \
CONFIG.Read_Width_A {64} \
CONFIG.Register_PortA_Output_of_Memory_Primitives {true} \
CONFIG.Use_Byte_Write_Enable {false} \
CONFIG.Use_RSTA_Pin {true} \
CONFIG.Write_Depth_A {256} \
CONFIG.Write_Width_A {64} \
CONFIG.use_bram_block {Stand_Alone} \
 ] $Dispatcher_uCode_3

  # Create instance: Dispatcher_uCode_4, and set properties
  set Dispatcher_uCode_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 Dispatcher_uCode_4 ]
  set_property -dict [ list \
CONFIG.Coe_File {../../../../uProgROM_v2.0.coe} \
CONFIG.Enable_32bit_Address {false} \
CONFIG.Load_Init_File {true} \
CONFIG.Read_Width_A {64} \
CONFIG.Register_PortA_Output_of_Memory_Primitives {true} \
CONFIG.Use_Byte_Write_Enable {false} \
CONFIG.Use_RSTA_Pin {true} \
CONFIG.Write_Depth_A {256} \
CONFIG.Write_Width_A {64} \
CONFIG.use_bram_block {Stand_Alone} \
 ] $Dispatcher_uCode_4

  # Create instance: Dispatcher_uCode_5, and set properties
  set Dispatcher_uCode_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 Dispatcher_uCode_5 ]
  set_property -dict [ list \
CONFIG.Coe_File {../../../../uProgROM_v2.0.coe} \
CONFIG.Enable_32bit_Address {false} \
CONFIG.Load_Init_File {true} \
CONFIG.Read_Width_A {64} \
CONFIG.Register_PortA_Output_of_Memory_Primitives {true} \
CONFIG.Use_Byte_Write_Enable {false} \
CONFIG.Use_RSTA_Pin {true} \
CONFIG.Write_Depth_A {256} \
CONFIG.Write_Width_A {64} \
CONFIG.use_bram_block {Stand_Alone} \
 ] $Dispatcher_uCode_5

  # Create instance: Dispatcher_uCode_6, and set properties
  set Dispatcher_uCode_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 Dispatcher_uCode_6 ]
  set_property -dict [ list \
CONFIG.Coe_File {../../../../uProgROM_v2.0.coe} \
CONFIG.Enable_32bit_Address {false} \
CONFIG.Load_Init_File {true} \
CONFIG.Read_Width_A {64} \
CONFIG.Register_PortA_Output_of_Memory_Primitives {true} \
CONFIG.Use_Byte_Write_Enable {false} \
CONFIG.Use_RSTA_Pin {true} \
CONFIG.Write_Depth_A {256} \
CONFIG.Write_Width_A {64} \
CONFIG.use_bram_block {Stand_Alone} \
 ] $Dispatcher_uCode_6

  # Create instance: Dispatcher_uCode_7, and set properties
  set Dispatcher_uCode_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 Dispatcher_uCode_7 ]
  set_property -dict [ list \
CONFIG.Coe_File {../../../../uProgROM_v2.0.coe} \
CONFIG.Enable_32bit_Address {false} \
CONFIG.Load_Init_File {true} \
CONFIG.Read_Width_A {64} \
CONFIG.Register_PortA_Output_of_Memory_Primitives {true} \
CONFIG.Use_Byte_Write_Enable {false} \
CONFIG.Use_RSTA_Pin {true} \
CONFIG.Write_Depth_A {256} \
CONFIG.Write_Width_A {64} \
CONFIG.use_bram_block {Stand_Alone} \
 ] $Dispatcher_uCode_7

  # Create instance: GPIC0, and set properties
  set GPIC0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 GPIC0 ]
  set_property -dict [ list \
CONFIG.ENABLE_ADVANCED_OPTIONS {1} \
CONFIG.NUM_MI {5} \
CONFIG.S00_HAS_DATA_FIFO {0} \
 ] $GPIC0

  # Create instance: GPIC1, and set properties
  set GPIC1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 GPIC1 ]
  set_property -dict [ list \
CONFIG.NUM_MI {1} \
 ] $GPIC1

  # Create instance: GPIC2, and set properties
  set GPIC2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 GPIC2 ]
  set_property -dict [ list \
CONFIG.ENABLE_ADVANCED_OPTIONS {1} \
CONFIG.NUM_MI {4} \
CONFIG.S00_HAS_DATA_FIFO {0} \
 ] $GPIC2

  # Create instance: HPIC3, and set properties
  set HPIC3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 HPIC3 ]
  set_property -dict [ list \
CONFIG.NUM_MI {1} \
 ] $HPIC3

  # Create instance: NVMeHostController_0, and set properties
  set NVMeHostController_0 [ create_bd_cell -type ip -vlnv ENCLab:ip:NVMeHostController:2.0.0 NVMeHostController_0 ]

  # Create instance: PS, and set properties
  set PS [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 PS ]
  set_property -dict [ list \
CONFIG.PCW_ACT_APU_PERIPHERAL_FREQMHZ {1000.000000} \
CONFIG.PCW_ACT_CAN_PERIPHERAL_FREQMHZ {10.000000} \
CONFIG.PCW_ACT_DCI_PERIPHERAL_FREQMHZ {10.158730} \
CONFIG.PCW_ACT_ENET0_PERIPHERAL_FREQMHZ {25.000000} \
CONFIG.PCW_ACT_ENET1_PERIPHERAL_FREQMHZ {10.000000} \
CONFIG.PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ {100.000000} \
CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ {100.000000} \
CONFIG.PCW_ACT_FPGA2_PERIPHERAL_FREQMHZ {200.000000} \
CONFIG.PCW_ACT_FPGA3_PERIPHERAL_FREQMHZ {250.000000} \
CONFIG.PCW_ACT_PCAP_PERIPHERAL_FREQMHZ {200.000000} \
CONFIG.PCW_ACT_QSPI_PERIPHERAL_FREQMHZ {200.000000} \
CONFIG.PCW_ACT_SDIO_PERIPHERAL_FREQMHZ {50.000000} \
CONFIG.PCW_ACT_SMC_PERIPHERAL_FREQMHZ {10.000000} \
CONFIG.PCW_ACT_SPI_PERIPHERAL_FREQMHZ {10.000000} \
CONFIG.PCW_ACT_TPIU_PERIPHERAL_FREQMHZ {200.000000} \
CONFIG.PCW_ACT_TTC0_CLK0_PERIPHERAL_FREQMHZ {166.666672} \
CONFIG.PCW_ACT_TTC0_CLK1_PERIPHERAL_FREQMHZ {166.666672} \
CONFIG.PCW_ACT_TTC0_CLK2_PERIPHERAL_FREQMHZ {166.666672} \
CONFIG.PCW_ACT_TTC1_CLK0_PERIPHERAL_FREQMHZ {166.666672} \
CONFIG.PCW_ACT_TTC1_CLK1_PERIPHERAL_FREQMHZ {166.666672} \
CONFIG.PCW_ACT_TTC1_CLK2_PERIPHERAL_FREQMHZ {166.666672} \
CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ {100.000000} \
CONFIG.PCW_ACT_WDT_PERIPHERAL_FREQMHZ {166.666672} \
CONFIG.PCW_APU_CLK_RATIO_ENABLE {6:2:1} \
CONFIG.PCW_APU_PERIPHERAL_FREQMHZ {1000} \
CONFIG.PCW_ARMPLL_CTRL_FBDIV {60} \
CONFIG.PCW_CAN0_CAN0_IO {<Select>} \
CONFIG.PCW_CAN0_GRP_CLK_ENABLE {0} \
CONFIG.PCW_CAN0_GRP_CLK_IO {<Select>} \
CONFIG.PCW_CAN0_PERIPHERAL_CLKSRC {External} \
CONFIG.PCW_CAN0_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_CAN1_CAN1_IO {<Select>} \
CONFIG.PCW_CAN1_GRP_CLK_ENABLE {0} \
CONFIG.PCW_CAN1_GRP_CLK_IO {<Select>} \
CONFIG.PCW_CAN1_PERIPHERAL_CLKSRC {External} \
CONFIG.PCW_CAN1_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_CAN_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_CAN_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_CAN_PERIPHERAL_DIVISOR1 {1} \
CONFIG.PCW_CAN_PERIPHERAL_FREQMHZ {100} \
CONFIG.PCW_CLK0_FREQ {100000000} \
CONFIG.PCW_CLK1_FREQ {100000000} \
CONFIG.PCW_CLK2_FREQ {200000000} \
CONFIG.PCW_CLK3_FREQ {250000000} \
CONFIG.PCW_CPU_CPU_6X4X_MAX_RANGE {1000} \
CONFIG.PCW_CPU_CPU_PLL_FREQMHZ {2000.000} \
CONFIG.PCW_CPU_PERIPHERAL_CLKSRC {ARM PLL} \
CONFIG.PCW_CPU_PERIPHERAL_DIVISOR0 {2} \
CONFIG.PCW_CRYSTAL_PERIPHERAL_FREQMHZ {33.333333} \
CONFIG.PCW_DCI_PERIPHERAL_CLKSRC {DDR PLL} \
CONFIG.PCW_DCI_PERIPHERAL_DIVISOR0 {15} \
CONFIG.PCW_DCI_PERIPHERAL_DIVISOR1 {7} \
CONFIG.PCW_DCI_PERIPHERAL_FREQMHZ {10.159} \
CONFIG.PCW_DDRPLL_CTRL_FBDIV {32} \
CONFIG.PCW_DDR_DDR_PLL_FREQMHZ {1066.667} \
CONFIG.PCW_DDR_HPRLPR_QUEUE_PARTITION {HPR(0)/LPR(32)} \
CONFIG.PCW_DDR_HPR_TO_CRITICAL_PRIORITY_LEVEL {15} \
CONFIG.PCW_DDR_LPR_TO_CRITICAL_PRIORITY_LEVEL {2} \
CONFIG.PCW_DDR_PERIPHERAL_CLKSRC {DDR PLL} \
CONFIG.PCW_DDR_PERIPHERAL_DIVISOR0 {2} \
CONFIG.PCW_DDR_PORT0_HPR_ENABLE {0} \
CONFIG.PCW_DDR_PORT1_HPR_ENABLE {0} \
CONFIG.PCW_DDR_PORT2_HPR_ENABLE {0} \
CONFIG.PCW_DDR_PORT3_HPR_ENABLE {0} \
CONFIG.PCW_DDR_PRIORITY_READPORT_0 {High} \
CONFIG.PCW_DDR_PRIORITY_READPORT_1 {Low} \
CONFIG.PCW_DDR_PRIORITY_READPORT_2 {Low} \
CONFIG.PCW_DDR_PRIORITY_READPORT_3 {Low} \
CONFIG.PCW_DDR_PRIORITY_WRITEPORT_0 {High} \
CONFIG.PCW_DDR_PRIORITY_WRITEPORT_1 {Low} \
CONFIG.PCW_DDR_PRIORITY_WRITEPORT_2 {Low} \
CONFIG.PCW_DDR_PRIORITY_WRITEPORT_3 {Low} \
CONFIG.PCW_DDR_WRITE_TO_CRITICAL_PRIORITY_LEVEL {2} \
CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} \
CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
CONFIG.PCW_ENET0_GRP_MDIO_IO {MIO 52 .. 53} \
CONFIG.PCW_ENET0_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR0 {16} \
CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR1 {5} \
CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ {100 Mbps} \
CONFIG.PCW_ENET0_RESET_ENABLE {1} \
CONFIG.PCW_ENET0_RESET_IO {MIO 47} \
CONFIG.PCW_ENET1_ENET1_IO {<Select>} \
CONFIG.PCW_ENET1_GRP_MDIO_ENABLE {0} \
CONFIG.PCW_ENET1_GRP_MDIO_IO {<Select>} \
CONFIG.PCW_ENET1_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR1 {1} \
CONFIG.PCW_ENET1_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_ENET1_PERIPHERAL_FREQMHZ {1000 Mbps} \
CONFIG.PCW_ENET1_RESET_ENABLE {0} \
CONFIG.PCW_ENET1_RESET_IO {<Select>} \
CONFIG.PCW_ENET_RESET_ENABLE {1} \
CONFIG.PCW_ENET_RESET_POLARITY {Active Low} \
CONFIG.PCW_ENET_RESET_SELECT {Share reset pin} \
CONFIG.PCW_EN_4K_TIMER {0} \
CONFIG.PCW_EN_CLK1_PORT {1} \
CONFIG.PCW_EN_CLK2_PORT {1} \
CONFIG.PCW_EN_CLK3_PORT {1} \
CONFIG.PCW_EN_ENET0 {1} \
CONFIG.PCW_EN_I2C0 {1} \
CONFIG.PCW_EN_PTP_ENET0 {1} \
CONFIG.PCW_EN_QSPI {1} \
CONFIG.PCW_EN_RST1_PORT {1} \
CONFIG.PCW_EN_RST2_PORT {1} \
CONFIG.PCW_EN_RST3_PORT {1} \
CONFIG.PCW_EN_SDIO0 {1} \
CONFIG.PCW_EN_UART1 {1} \
CONFIG.PCW_EN_USB0 {1} \
CONFIG.PCW_FCLK0_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR0 {5} \
CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR1 {4} \
CONFIG.PCW_FCLK1_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR0 {5} \
CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR1 {4} \
CONFIG.PCW_FCLK2_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR0 {5} \
CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR1 {2} \
CONFIG.PCW_FCLK3_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR0 {4} \
CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR1 {2} \
CONFIG.PCW_FCLK_CLK0_BUF {true} \
CONFIG.PCW_FCLK_CLK1_BUF {true} \
CONFIG.PCW_FCLK_CLK2_BUF {true} \
CONFIG.PCW_FCLK_CLK3_BUF {true} \
CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100} \
CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {100} \
CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {200} \
CONFIG.PCW_FPGA3_PERIPHERAL_FREQMHZ {250} \
CONFIG.PCW_FPGA_FCLK0_ENABLE {1} \
CONFIG.PCW_FPGA_FCLK1_ENABLE {1} \
CONFIG.PCW_FPGA_FCLK2_ENABLE {1} \
CONFIG.PCW_FPGA_FCLK3_ENABLE {1} \
CONFIG.PCW_FTM_CTI_IN0 {<Select>} \
CONFIG.PCW_FTM_CTI_IN1 {<Select>} \
CONFIG.PCW_FTM_CTI_IN2 {<Select>} \
CONFIG.PCW_FTM_CTI_IN3 {<Select>} \
CONFIG.PCW_FTM_CTI_OUT0 {<Select>} \
CONFIG.PCW_FTM_CTI_OUT1 {<Select>} \
CONFIG.PCW_FTM_CTI_OUT2 {<Select>} \
CONFIG.PCW_FTM_CTI_OUT3 {<Select>} \
CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {0} \
CONFIG.PCW_GPIO_EMIO_GPIO_IO {<Select>} \
CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} \
CONFIG.PCW_GPIO_MIO_GPIO_IO {MIO} \
CONFIG.PCW_GPIO_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_I2C0_GRP_INT_ENABLE {0} \
CONFIG.PCW_I2C0_GRP_INT_IO {<Select>} \
CONFIG.PCW_I2C0_I2C0_IO {MIO 50 .. 51} \
CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_I2C0_RESET_ENABLE {1} \
CONFIG.PCW_I2C0_RESET_IO {MIO 46} \
CONFIG.PCW_I2C1_GRP_INT_ENABLE {0} \
CONFIG.PCW_I2C1_GRP_INT_IO {<Select>} \
CONFIG.PCW_I2C1_I2C1_IO {<Select>} \
CONFIG.PCW_I2C1_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_I2C1_RESET_ENABLE {0} \
CONFIG.PCW_I2C1_RESET_IO {<Select>} \
CONFIG.PCW_I2C_PERIPHERAL_FREQMHZ {166.666672} \
CONFIG.PCW_I2C_RESET_ENABLE {1} \
CONFIG.PCW_I2C_RESET_POLARITY {Active Low} \
CONFIG.PCW_I2C_RESET_SELECT {Share reset pin} \
CONFIG.PCW_IOPLL_CTRL_FBDIV {60} \
CONFIG.PCW_IO_IO_PLL_FREQMHZ {2000.000} \
CONFIG.PCW_IRQ_F2P_INTR {1} \
CONFIG.PCW_MIO_0_DIRECTION {out} \
CONFIG.PCW_MIO_0_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_0_PULLUP {enabled} \
CONFIG.PCW_MIO_0_SLEW {slow} \
CONFIG.PCW_MIO_10_DIRECTION {inout} \
CONFIG.PCW_MIO_10_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_10_PULLUP {disabled} \
CONFIG.PCW_MIO_10_SLEW {slow} \
CONFIG.PCW_MIO_11_DIRECTION {inout} \
CONFIG.PCW_MIO_11_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_11_PULLUP {disabled} \
CONFIG.PCW_MIO_11_SLEW {slow} \
CONFIG.PCW_MIO_12_DIRECTION {inout} \
CONFIG.PCW_MIO_12_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_12_PULLUP {disabled} \
CONFIG.PCW_MIO_12_SLEW {slow} \
CONFIG.PCW_MIO_13_DIRECTION {inout} \
CONFIG.PCW_MIO_13_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_13_PULLUP {disabled} \
CONFIG.PCW_MIO_13_SLEW {slow} \
CONFIG.PCW_MIO_14_DIRECTION {in} \
CONFIG.PCW_MIO_14_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_14_PULLUP {enabled} \
CONFIG.PCW_MIO_14_SLEW {slow} \
CONFIG.PCW_MIO_15_DIRECTION {in} \
CONFIG.PCW_MIO_15_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_15_PULLUP {enabled} \
CONFIG.PCW_MIO_15_SLEW {slow} \
CONFIG.PCW_MIO_16_DIRECTION {out} \
CONFIG.PCW_MIO_16_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_16_PULLUP {disabled} \
CONFIG.PCW_MIO_16_SLEW {slow} \
CONFIG.PCW_MIO_17_DIRECTION {out} \
CONFIG.PCW_MIO_17_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_17_PULLUP {disabled} \
CONFIG.PCW_MIO_17_SLEW {slow} \
CONFIG.PCW_MIO_18_DIRECTION {out} \
CONFIG.PCW_MIO_18_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_18_PULLUP {disabled} \
CONFIG.PCW_MIO_18_SLEW {slow} \
CONFIG.PCW_MIO_19_DIRECTION {out} \
CONFIG.PCW_MIO_19_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_19_PULLUP {disabled} \
CONFIG.PCW_MIO_19_SLEW {slow} \
CONFIG.PCW_MIO_1_DIRECTION {out} \
CONFIG.PCW_MIO_1_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_1_PULLUP {enabled} \
CONFIG.PCW_MIO_1_SLEW {slow} \
CONFIG.PCW_MIO_20_DIRECTION {out} \
CONFIG.PCW_MIO_20_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_20_PULLUP {disabled} \
CONFIG.PCW_MIO_20_SLEW {slow} \
CONFIG.PCW_MIO_21_DIRECTION {out} \
CONFIG.PCW_MIO_21_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_21_PULLUP {disabled} \
CONFIG.PCW_MIO_21_SLEW {slow} \
CONFIG.PCW_MIO_22_DIRECTION {in} \
CONFIG.PCW_MIO_22_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_22_PULLUP {disabled} \
CONFIG.PCW_MIO_22_SLEW {slow} \
CONFIG.PCW_MIO_23_DIRECTION {in} \
CONFIG.PCW_MIO_23_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_23_PULLUP {disabled} \
CONFIG.PCW_MIO_23_SLEW {slow} \
CONFIG.PCW_MIO_24_DIRECTION {in} \
CONFIG.PCW_MIO_24_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_24_PULLUP {disabled} \
CONFIG.PCW_MIO_24_SLEW {slow} \
CONFIG.PCW_MIO_25_DIRECTION {in} \
CONFIG.PCW_MIO_25_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_25_PULLUP {disabled} \
CONFIG.PCW_MIO_25_SLEW {slow} \
CONFIG.PCW_MIO_26_DIRECTION {in} \
CONFIG.PCW_MIO_26_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_26_PULLUP {disabled} \
CONFIG.PCW_MIO_26_SLEW {slow} \
CONFIG.PCW_MIO_27_DIRECTION {in} \
CONFIG.PCW_MIO_27_IOTYPE {HSTL 1.8V} \
CONFIG.PCW_MIO_27_PULLUP {disabled} \
CONFIG.PCW_MIO_27_SLEW {slow} \
CONFIG.PCW_MIO_28_DIRECTION {inout} \
CONFIG.PCW_MIO_28_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_28_PULLUP {disabled} \
CONFIG.PCW_MIO_28_SLEW {slow} \
CONFIG.PCW_MIO_29_DIRECTION {in} \
CONFIG.PCW_MIO_29_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_29_PULLUP {disabled} \
CONFIG.PCW_MIO_29_SLEW {slow} \
CONFIG.PCW_MIO_2_DIRECTION {inout} \
CONFIG.PCW_MIO_2_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_2_PULLUP {disabled} \
CONFIG.PCW_MIO_2_SLEW {slow} \
CONFIG.PCW_MIO_30_DIRECTION {out} \
CONFIG.PCW_MIO_30_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_30_PULLUP {disabled} \
CONFIG.PCW_MIO_30_SLEW {slow} \
CONFIG.PCW_MIO_31_DIRECTION {in} \
CONFIG.PCW_MIO_31_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_31_PULLUP {disabled} \
CONFIG.PCW_MIO_31_SLEW {slow} \
CONFIG.PCW_MIO_32_DIRECTION {inout} \
CONFIG.PCW_MIO_32_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_32_PULLUP {disabled} \
CONFIG.PCW_MIO_32_SLEW {slow} \
CONFIG.PCW_MIO_33_DIRECTION {inout} \
CONFIG.PCW_MIO_33_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_33_PULLUP {disabled} \
CONFIG.PCW_MIO_33_SLEW {slow} \
CONFIG.PCW_MIO_34_DIRECTION {inout} \
CONFIG.PCW_MIO_34_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_34_PULLUP {disabled} \
CONFIG.PCW_MIO_34_SLEW {slow} \
CONFIG.PCW_MIO_35_DIRECTION {inout} \
CONFIG.PCW_MIO_35_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_35_PULLUP {disabled} \
CONFIG.PCW_MIO_35_SLEW {slow} \
CONFIG.PCW_MIO_36_DIRECTION {in} \
CONFIG.PCW_MIO_36_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_36_PULLUP {disabled} \
CONFIG.PCW_MIO_36_SLEW {slow} \
CONFIG.PCW_MIO_37_DIRECTION {inout} \
CONFIG.PCW_MIO_37_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_37_PULLUP {disabled} \
CONFIG.PCW_MIO_37_SLEW {slow} \
CONFIG.PCW_MIO_38_DIRECTION {inout} \
CONFIG.PCW_MIO_38_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_38_PULLUP {disabled} \
CONFIG.PCW_MIO_38_SLEW {slow} \
CONFIG.PCW_MIO_39_DIRECTION {inout} \
CONFIG.PCW_MIO_39_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_39_PULLUP {disabled} \
CONFIG.PCW_MIO_39_SLEW {slow} \
CONFIG.PCW_MIO_3_DIRECTION {inout} \
CONFIG.PCW_MIO_3_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_3_PULLUP {disabled} \
CONFIG.PCW_MIO_3_SLEW {slow} \
CONFIG.PCW_MIO_40_DIRECTION {inout} \
CONFIG.PCW_MIO_40_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_40_PULLUP {disabled} \
CONFIG.PCW_MIO_40_SLEW {slow} \
CONFIG.PCW_MIO_41_DIRECTION {inout} \
CONFIG.PCW_MIO_41_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_41_PULLUP {disabled} \
CONFIG.PCW_MIO_41_SLEW {slow} \
CONFIG.PCW_MIO_42_DIRECTION {inout} \
CONFIG.PCW_MIO_42_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_42_PULLUP {disabled} \
CONFIG.PCW_MIO_42_SLEW {slow} \
CONFIG.PCW_MIO_43_DIRECTION {inout} \
CONFIG.PCW_MIO_43_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_43_PULLUP {disabled} \
CONFIG.PCW_MIO_43_SLEW {slow} \
CONFIG.PCW_MIO_44_DIRECTION {inout} \
CONFIG.PCW_MIO_44_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_44_PULLUP {disabled} \
CONFIG.PCW_MIO_44_SLEW {slow} \
CONFIG.PCW_MIO_45_DIRECTION {inout} \
CONFIG.PCW_MIO_45_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_45_PULLUP {disabled} \
CONFIG.PCW_MIO_45_SLEW {slow} \
CONFIG.PCW_MIO_46_DIRECTION {out} \
CONFIG.PCW_MIO_46_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_46_PULLUP {enabled} \
CONFIG.PCW_MIO_46_SLEW {slow} \
CONFIG.PCW_MIO_47_DIRECTION {out} \
CONFIG.PCW_MIO_47_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_47_PULLUP {enabled} \
CONFIG.PCW_MIO_47_SLEW {slow} \
CONFIG.PCW_MIO_48_DIRECTION {out} \
CONFIG.PCW_MIO_48_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_48_PULLUP {enabled} \
CONFIG.PCW_MIO_48_SLEW {slow} \
CONFIG.PCW_MIO_49_DIRECTION {in} \
CONFIG.PCW_MIO_49_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_49_PULLUP {enabled} \
CONFIG.PCW_MIO_49_SLEW {slow} \
CONFIG.PCW_MIO_4_DIRECTION {inout} \
CONFIG.PCW_MIO_4_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_4_PULLUP {disabled} \
CONFIG.PCW_MIO_4_SLEW {slow} \
CONFIG.PCW_MIO_50_DIRECTION {inout} \
CONFIG.PCW_MIO_50_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_50_PULLUP {enabled} \
CONFIG.PCW_MIO_50_SLEW {slow} \
CONFIG.PCW_MIO_51_DIRECTION {inout} \
CONFIG.PCW_MIO_51_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_51_PULLUP {enabled} \
CONFIG.PCW_MIO_51_SLEW {slow} \
CONFIG.PCW_MIO_52_DIRECTION {out} \
CONFIG.PCW_MIO_52_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_52_PULLUP {enabled} \
CONFIG.PCW_MIO_52_SLEW {slow} \
CONFIG.PCW_MIO_53_DIRECTION {inout} \
CONFIG.PCW_MIO_53_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_53_PULLUP {enabled} \
CONFIG.PCW_MIO_53_SLEW {slow} \
CONFIG.PCW_MIO_5_DIRECTION {inout} \
CONFIG.PCW_MIO_5_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_5_PULLUP {disabled} \
CONFIG.PCW_MIO_5_SLEW {slow} \
CONFIG.PCW_MIO_6_DIRECTION {out} \
CONFIG.PCW_MIO_6_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_6_PULLUP {disabled} \
CONFIG.PCW_MIO_6_SLEW {slow} \
CONFIG.PCW_MIO_7_DIRECTION {out} \
CONFIG.PCW_MIO_7_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_7_PULLUP {disabled} \
CONFIG.PCW_MIO_7_SLEW {slow} \
CONFIG.PCW_MIO_8_DIRECTION {out} \
CONFIG.PCW_MIO_8_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_8_PULLUP {disabled} \
CONFIG.PCW_MIO_8_SLEW {slow} \
CONFIG.PCW_MIO_9_DIRECTION {out} \
CONFIG.PCW_MIO_9_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_9_PULLUP {disabled} \
CONFIG.PCW_MIO_9_SLEW {slow} \
CONFIG.PCW_MIO_TREE_PERIPHERALS {Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#USB Reset#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#SD 0#SD 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#I2C Reset#ENET Reset#UART 1#UART 1#I2C 0#I2C 0#Enet 0#Enet 0} \
CONFIG.PCW_MIO_TREE_SIGNALS {qspi1_ss_b#qspi0_ss_b#qspi0_io[0]#qspi0_io[1]#qspi0_io[2]#qspi0_io[3]#qspi0_sclk#reset#qspi_fbclk#qspi1_sclk#qspi1_io[0]#qspi1_io[1]#qspi1_io[2]#qspi1_io[3]#cd#wp#tx_clk#txd[0]#txd[1]#txd[2]#txd[3]#tx_ctl#rx_clk#rxd[0]#rxd[1]#rxd[2]#rxd[3]#rx_ctl#data[4]#dir#stp#nxt#data[0]#data[1]#data[2]#data[3]#clk#data[5]#data[6]#data[7]#clk#cmd#data[0]#data[1]#data[2]#data[3]#reset#reset#tx#rx#scl#sda#mdc#mdio} \
CONFIG.PCW_NAND_CYCLES_T_AR {1} \
CONFIG.PCW_NAND_CYCLES_T_CLR {1} \
CONFIG.PCW_NAND_CYCLES_T_RC {2} \
CONFIG.PCW_NAND_CYCLES_T_REA {1} \
CONFIG.PCW_NAND_CYCLES_T_RR {1} \
CONFIG.PCW_NAND_CYCLES_T_WC {2} \
CONFIG.PCW_NAND_CYCLES_T_WP {1} \
CONFIG.PCW_NAND_GRP_D8_ENABLE {0} \
CONFIG.PCW_NAND_GRP_D8_IO {<Select>} \
CONFIG.PCW_NAND_NAND_IO {<Select>} \
CONFIG.PCW_NAND_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_NOR_CS0_T_CEOE {1} \
CONFIG.PCW_NOR_CS0_T_PC {1} \
CONFIG.PCW_NOR_CS0_T_RC {2} \
CONFIG.PCW_NOR_CS0_T_TR {1} \
CONFIG.PCW_NOR_CS0_T_WC {2} \
CONFIG.PCW_NOR_CS0_T_WP {1} \
CONFIG.PCW_NOR_CS0_WE_TIME {0} \
CONFIG.PCW_NOR_CS1_T_CEOE {1} \
CONFIG.PCW_NOR_CS1_T_PC {1} \
CONFIG.PCW_NOR_CS1_T_RC {2} \
CONFIG.PCW_NOR_CS1_T_TR {1} \
CONFIG.PCW_NOR_CS1_T_WC {2} \
CONFIG.PCW_NOR_CS1_T_WP {1} \
CONFIG.PCW_NOR_CS1_WE_TIME {0} \
CONFIG.PCW_NOR_GRP_A25_ENABLE {0} \
CONFIG.PCW_NOR_GRP_A25_IO {<Select>} \
CONFIG.PCW_NOR_GRP_CS0_ENABLE {0} \
CONFIG.PCW_NOR_GRP_CS0_IO {<Select>} \
CONFIG.PCW_NOR_GRP_CS1_ENABLE {0} \
CONFIG.PCW_NOR_GRP_CS1_IO {<Select>} \
CONFIG.PCW_NOR_GRP_SRAM_CS0_ENABLE {0} \
CONFIG.PCW_NOR_GRP_SRAM_CS0_IO {<Select>} \
CONFIG.PCW_NOR_GRP_SRAM_CS1_ENABLE {0} \
CONFIG.PCW_NOR_GRP_SRAM_CS1_IO {<Select>} \
CONFIG.PCW_NOR_GRP_SRAM_INT_ENABLE {0} \
CONFIG.PCW_NOR_GRP_SRAM_INT_IO {<Select>} \
CONFIG.PCW_NOR_NOR_IO {<Select>} \
CONFIG.PCW_NOR_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_NOR_SRAM_CS0_T_CEOE {1} \
CONFIG.PCW_NOR_SRAM_CS0_T_PC {1} \
CONFIG.PCW_NOR_SRAM_CS0_T_RC {2} \
CONFIG.PCW_NOR_SRAM_CS0_T_TR {1} \
CONFIG.PCW_NOR_SRAM_CS0_T_WC {2} \
CONFIG.PCW_NOR_SRAM_CS0_T_WP {1} \
CONFIG.PCW_NOR_SRAM_CS0_WE_TIME {0} \
CONFIG.PCW_NOR_SRAM_CS1_T_CEOE {1} \
CONFIG.PCW_NOR_SRAM_CS1_T_PC {1} \
CONFIG.PCW_NOR_SRAM_CS1_T_RC {2} \
CONFIG.PCW_NOR_SRAM_CS1_T_TR {1} \
CONFIG.PCW_NOR_SRAM_CS1_T_WC {2} \
CONFIG.PCW_NOR_SRAM_CS1_T_WP {1} \
CONFIG.PCW_NOR_SRAM_CS1_WE_TIME {0} \
CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY0 {0.100} \
CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY1 {0.113} \
CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY2 {0.111} \
CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY3 {0.100} \
CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_0 {-0.017} \
CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_1 {-0.039} \
CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_2 {-0.040} \
CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_3 {-0.016} \
CONFIG.PCW_PACKAGE_NAME {ffg900} \
CONFIG.PCW_PCAP_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_PCAP_PERIPHERAL_DIVISOR0 {10} \
CONFIG.PCW_PCAP_PERIPHERAL_FREQMHZ {200} \
CONFIG.PCW_PJTAG_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_PJTAG_PJTAG_IO {<Select>} \
CONFIG.PCW_PLL_BYPASSMODE_ENABLE {0} \
CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 1.8V} \
CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} \
CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {1} \
CONFIG.PCW_QSPI_GRP_FBCLK_IO {MIO 8} \
CONFIG.PCW_QSPI_GRP_IO1_ENABLE {1} \
CONFIG.PCW_QSPI_GRP_IO1_IO {MIO 0 9 .. 13} \
CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {0} \
CONFIG.PCW_QSPI_GRP_SINGLE_SS_IO {<Select>} \
CONFIG.PCW_QSPI_GRP_SS1_ENABLE {0} \
CONFIG.PCW_QSPI_GRP_SS1_IO {<Select>} \
CONFIG.PCW_QSPI_INTERNAL_HIGHADDRESS {0xFDFFFFFF} \
CONFIG.PCW_QSPI_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_QSPI_PERIPHERAL_DIVISOR0 {10} \
CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_QSPI_PERIPHERAL_FREQMHZ {200} \
CONFIG.PCW_QSPI_QSPI_IO {MIO 1 .. 6} \
CONFIG.PCW_SD0_GRP_CD_ENABLE {1} \
CONFIG.PCW_SD0_GRP_CD_IO {MIO 14} \
CONFIG.PCW_SD0_GRP_POW_ENABLE {0} \
CONFIG.PCW_SD0_GRP_POW_IO {<Select>} \
CONFIG.PCW_SD0_GRP_WP_ENABLE {1} \
CONFIG.PCW_SD0_GRP_WP_IO {MIO 15} \
CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_SD0_SD0_IO {MIO 40 .. 45} \
CONFIG.PCW_SD1_GRP_CD_ENABLE {0} \
CONFIG.PCW_SD1_GRP_CD_IO {<Select>} \
CONFIG.PCW_SD1_GRP_POW_ENABLE {0} \
CONFIG.PCW_SD1_GRP_POW_IO {<Select>} \
CONFIG.PCW_SD1_GRP_WP_ENABLE {0} \
CONFIG.PCW_SD1_GRP_WP_IO {<Select>} \
CONFIG.PCW_SD1_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_SD1_SD1_IO {<Select>} \
CONFIG.PCW_SDIO_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_SDIO_PERIPHERAL_DIVISOR0 {40} \
CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {50} \
CONFIG.PCW_SDIO_PERIPHERAL_VALID {1} \
CONFIG.PCW_SMC_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_SMC_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_SMC_PERIPHERAL_FREQMHZ {100} \
CONFIG.PCW_SPI0_GRP_SS0_ENABLE {0} \
CONFIG.PCW_SPI0_GRP_SS0_IO {<Select>} \
CONFIG.PCW_SPI0_GRP_SS1_ENABLE {0} \
CONFIG.PCW_SPI0_GRP_SS1_IO {<Select>} \
CONFIG.PCW_SPI0_GRP_SS2_ENABLE {0} \
CONFIG.PCW_SPI0_GRP_SS2_IO {<Select>} \
CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_SPI0_SPI0_IO {<Select>} \
CONFIG.PCW_SPI1_GRP_SS0_ENABLE {0} \
CONFIG.PCW_SPI1_GRP_SS0_IO {<Select>} \
CONFIG.PCW_SPI1_GRP_SS1_ENABLE {0} \
CONFIG.PCW_SPI1_GRP_SS1_IO {<Select>} \
CONFIG.PCW_SPI1_GRP_SS2_ENABLE {0} \
CONFIG.PCW_SPI1_GRP_SS2_IO {<Select>} \
CONFIG.PCW_SPI1_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_SPI1_SPI1_IO {<Select>} \
CONFIG.PCW_SPI_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_SPI_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_SPI_PERIPHERAL_FREQMHZ {166.666666} \
CONFIG.PCW_S_AXI_HP0_DATA_WIDTH {64} \
CONFIG.PCW_S_AXI_HP1_DATA_WIDTH {64} \
CONFIG.PCW_S_AXI_HP1_FREQMHZ {250} \
CONFIG.PCW_S_AXI_HP2_DATA_WIDTH {64} \
CONFIG.PCW_S_AXI_HP3_DATA_WIDTH {64} \
CONFIG.PCW_TPIU_PERIPHERAL_CLKSRC {External} \
CONFIG.PCW_TPIU_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_TPIU_PERIPHERAL_FREQMHZ {200} \
CONFIG.PCW_TRACE_GRP_16BIT_ENABLE {0} \
CONFIG.PCW_TRACE_GRP_16BIT_IO {<Select>} \
CONFIG.PCW_TRACE_GRP_2BIT_ENABLE {0} \
CONFIG.PCW_TRACE_GRP_2BIT_IO {<Select>} \
CONFIG.PCW_TRACE_GRP_32BIT_ENABLE {0} \
CONFIG.PCW_TRACE_GRP_32BIT_IO {<Select>} \
CONFIG.PCW_TRACE_GRP_4BIT_ENABLE {0} \
CONFIG.PCW_TRACE_GRP_4BIT_IO {<Select>} \
CONFIG.PCW_TRACE_GRP_8BIT_ENABLE {0} \
CONFIG.PCW_TRACE_GRP_8BIT_IO {<Select>} \
CONFIG.PCW_TRACE_INTERNAL_WIDTH {2} \
CONFIG.PCW_TRACE_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_TRACE_TRACE_IO {<Select>} \
CONFIG.PCW_TTC0_CLK0_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_TTC0_CLK0_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_TTC0_CLK0_PERIPHERAL_FREQMHZ {133.333333} \
CONFIG.PCW_TTC0_CLK1_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_TTC0_CLK1_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_TTC0_CLK1_PERIPHERAL_FREQMHZ {133.333333} \
CONFIG.PCW_TTC0_CLK2_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_TTC0_CLK2_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_TTC0_CLK2_PERIPHERAL_FREQMHZ {133.333333} \
CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_TTC0_TTC0_IO {<Select>} \
CONFIG.PCW_TTC1_CLK0_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_TTC1_CLK0_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_TTC1_CLK0_PERIPHERAL_FREQMHZ {133.333333} \
CONFIG.PCW_TTC1_CLK1_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_TTC1_CLK1_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_TTC1_CLK1_PERIPHERAL_FREQMHZ {133.333333} \
CONFIG.PCW_TTC1_CLK2_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_TTC1_CLK2_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_TTC1_CLK2_PERIPHERAL_FREQMHZ {133.333333} \
CONFIG.PCW_TTC1_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_TTC1_TTC1_IO {<Select>} \
CONFIG.PCW_TTC_PERIPHERAL_FREQMHZ {50} \
CONFIG.PCW_UART0_BAUD_RATE {115200} \
CONFIG.PCW_UART0_GRP_FULL_ENABLE {0} \
CONFIG.PCW_UART0_GRP_FULL_IO {<Select>} \
CONFIG.PCW_UART0_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_UART0_UART0_IO {<Select>} \
CONFIG.PCW_UART1_BAUD_RATE {115200} \
CONFIG.PCW_UART1_GRP_FULL_ENABLE {0} \
CONFIG.PCW_UART1_GRP_FULL_IO {<Select>} \
CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_UART1_UART1_IO {MIO 48 .. 49} \
CONFIG.PCW_UART_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_UART_PERIPHERAL_DIVISOR0 {20} \
CONFIG.PCW_UART_PERIPHERAL_FREQMHZ {100} \
CONFIG.PCW_UART_PERIPHERAL_VALID {1} \
CONFIG.PCW_UIPARAM_DDR_ADV_ENABLE {1} \
CONFIG.PCW_UIPARAM_DDR_AL {0} \
CONFIG.PCW_UIPARAM_DDR_BANK_ADDR_COUNT {3} \
CONFIG.PCW_UIPARAM_DDR_BL {8} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.521} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.636} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {0.540} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {0.621} \
CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH {32 Bit} \
CONFIG.PCW_UIPARAM_DDR_CL {7} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_0_LENGTH_MM {0} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PACKAGE_LENGTH {92.3275} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_1_LENGTH_MM {0} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PACKAGE_LENGTH {92.3275} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_2_LENGTH_MM {0} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PACKAGE_LENGTH {92.3275} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_3_LENGTH_MM {0} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PACKAGE_LENGTH {92.3275} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_STOP_EN {0} \
CONFIG.PCW_UIPARAM_DDR_COL_ADDR_COUNT {10} \
CONFIG.PCW_UIPARAM_DDR_CWL {6} \
CONFIG.PCW_UIPARAM_DDR_DEVICE_CAPACITY {4096 MBits} \
CONFIG.PCW_UIPARAM_DDR_DQS_0_LENGTH_MM {0} \
CONFIG.PCW_UIPARAM_DDR_DQS_0_PACKAGE_LENGTH {108.9255} \
CONFIG.PCW_UIPARAM_DDR_DQS_0_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_DQS_1_LENGTH_MM {0} \
CONFIG.PCW_UIPARAM_DDR_DQS_1_PACKAGE_LENGTH {131.286} \
CONFIG.PCW_UIPARAM_DDR_DQS_1_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_DQS_2_LENGTH_MM {0} \
CONFIG.PCW_UIPARAM_DDR_DQS_2_PACKAGE_LENGTH {131.83} \
CONFIG.PCW_UIPARAM_DDR_DQS_2_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_DQS_3_LENGTH_MM {0} \
CONFIG.PCW_UIPARAM_DDR_DQS_3_PACKAGE_LENGTH {108.5285} \
CONFIG.PCW_UIPARAM_DDR_DQS_3_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {0.226} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {0.278} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {0.184} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {0.309} \
CONFIG.PCW_UIPARAM_DDR_DQ_0_LENGTH_MM {0} \
CONFIG.PCW_UIPARAM_DDR_DQ_0_PACKAGE_LENGTH {107.643} \
CONFIG.PCW_UIPARAM_DDR_DQ_0_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_DQ_1_LENGTH_MM {0} \
CONFIG.PCW_UIPARAM_DDR_DQ_1_PACKAGE_LENGTH {132.917} \
CONFIG.PCW_UIPARAM_DDR_DQ_1_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_DQ_2_LENGTH_MM {0} \
CONFIG.PCW_UIPARAM_DDR_DQ_2_PACKAGE_LENGTH {129.6135} \
CONFIG.PCW_UIPARAM_DDR_DQ_2_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_DQ_3_LENGTH_MM {0} \
CONFIG.PCW_UIPARAM_DDR_DQ_3_PACKAGE_LENGTH {108.6395} \
CONFIG.PCW_UIPARAM_DDR_DQ_3_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_DRAM_WIDTH {16 Bits} \
CONFIG.PCW_UIPARAM_DDR_ECC {Disabled} \
CONFIG.PCW_UIPARAM_DDR_ENABLE {1} \
CONFIG.PCW_UIPARAM_DDR_FREQ_MHZ {533.333333} \
CONFIG.PCW_UIPARAM_DDR_HIGH_TEMP {Normal (0-85)} \
CONFIG.PCW_UIPARAM_DDR_MEMORY_TYPE {DDR 3} \
CONFIG.PCW_UIPARAM_DDR_PARTNO {Custom} \
CONFIG.PCW_UIPARAM_DDR_ROW_ADDR_COUNT {15} \
CONFIG.PCW_UIPARAM_DDR_SPEED_BIN {DDR3_1066F} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {0} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {0} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {1} \
CONFIG.PCW_UIPARAM_DDR_T_FAW {50} \
CONFIG.PCW_UIPARAM_DDR_T_RAS_MIN {37.5} \
CONFIG.PCW_UIPARAM_DDR_T_RC {50.62} \
CONFIG.PCW_UIPARAM_DDR_T_RCD {7} \
CONFIG.PCW_UIPARAM_DDR_T_RP {7} \
CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF {1} \
CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_USB0_PERIPHERAL_FREQMHZ {60} \
CONFIG.PCW_USB0_RESET_ENABLE {1} \
CONFIG.PCW_USB0_RESET_IO {MIO 7} \
CONFIG.PCW_USB0_USB0_IO {MIO 28 .. 39} \
CONFIG.PCW_USB1_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_USB1_PERIPHERAL_FREQMHZ {60} \
CONFIG.PCW_USB1_RESET_ENABLE {0} \
CONFIG.PCW_USB1_RESET_IO {<Select>} \
CONFIG.PCW_USB1_USB1_IO {<Select>} \
CONFIG.PCW_USB_RESET_ENABLE {1} \
CONFIG.PCW_USB_RESET_POLARITY {Active Low} \
CONFIG.PCW_USB_RESET_SELECT {Share reset pin} \
CONFIG.PCW_USE_CROSS_TRIGGER {0} \
CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
CONFIG.PCW_USE_M_AXI_GP1 {1} \
CONFIG.PCW_USE_S_AXI_GP0 {0} \
CONFIG.PCW_USE_S_AXI_GP1 {0} \
CONFIG.PCW_USE_S_AXI_HP0 {1} \
CONFIG.PCW_USE_S_AXI_HP1 {0} \
CONFIG.PCW_USE_S_AXI_HP2 {1} \
CONFIG.PCW_USE_S_AXI_HP3 {1} \
CONFIG.PCW_WDT_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_WDT_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_WDT_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_WDT_PERIPHERAL_FREQMHZ {133.333333} \
CONFIG.PCW_WDT_WDT_IO {<Select>} \
 ] $PS

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.PCW_ACT_APU_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_CAN_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_DCI_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_ENET0_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_ENET1_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_FPGA2_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_FPGA3_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_PCAP_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_QSPI_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_SDIO_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_SMC_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_SPI_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_TPIU_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_TTC0_CLK0_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_TTC0_CLK1_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_TTC0_CLK2_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_TTC1_CLK0_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_TTC1_CLK1_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_TTC1_CLK2_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_WDT_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_APU_CLK_RATIO_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ARMPLL_CTRL_FBDIV.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CAN0_CAN0_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CAN0_GRP_CLK_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CAN0_GRP_CLK_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CAN0_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CAN0_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CAN1_CAN1_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CAN1_GRP_CLK_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CAN1_GRP_CLK_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CAN1_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CAN1_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CAN_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CAN_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CAN_PERIPHERAL_DIVISOR1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CAN_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CLK0_FREQ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CLK1_FREQ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CLK2_FREQ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CLK3_FREQ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CPU_CPU_6X4X_MAX_RANGE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CPU_CPU_PLL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CPU_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CPU_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CRYSTAL_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DCI_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DCI_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DCI_PERIPHERAL_DIVISOR1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DCI_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDRPLL_CTRL_FBDIV.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_DDR_PLL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_HPRLPR_QUEUE_PARTITION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_HPR_TO_CRITICAL_PRIORITY_LEVEL.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_LPR_TO_CRITICAL_PRIORITY_LEVEL.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_PORT0_HPR_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_PORT1_HPR_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_PRIORITY_READPORT_1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_PRIORITY_WRITEPORT_1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_WRITE_TO_CRITICAL_PRIORITY_LEVEL.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET0_GRP_MDIO_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET0_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET1_ENET1_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET1_GRP_MDIO_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET1_GRP_MDIO_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET1_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET1_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET1_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET1_RESET_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET1_RESET_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET_RESET_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET_RESET_POLARITY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET_RESET_SELECT.VALUE_SRC {DEFAULT} \
CONFIG.PCW_EN_4K_TIMER.VALUE_SRC {DEFAULT} \
CONFIG.PCW_EN_ENET0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_EN_I2C0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_EN_PTP_ENET0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_EN_QSPI.VALUE_SRC {DEFAULT} \
CONFIG.PCW_EN_SDIO0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_EN_UART1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_EN_USB0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK0_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK1_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK2_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK3_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK_CLK0_BUF.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK_CLK1_BUF.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK_CLK2_BUF.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK_CLK3_BUF.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FPGA_FCLK0_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FPGA_FCLK1_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FPGA_FCLK2_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FPGA_FCLK3_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FTM_CTI_IN0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FTM_CTI_IN1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FTM_CTI_IN2.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FTM_CTI_IN3.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FTM_CTI_OUT0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FTM_CTI_OUT1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FTM_CTI_OUT2.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FTM_CTI_OUT3.VALUE_SRC {DEFAULT} \
CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_GPIO_EMIO_GPIO_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_GPIO_MIO_GPIO_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_GPIO_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_I2C0_GRP_INT_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_I2C0_GRP_INT_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_I2C1_GRP_INT_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_I2C1_GRP_INT_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_I2C1_I2C1_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_I2C1_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_I2C1_RESET_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_I2C1_RESET_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_I2C_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_I2C_RESET_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_I2C_RESET_POLARITY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_I2C_RESET_SELECT.VALUE_SRC {DEFAULT} \
CONFIG.PCW_IOPLL_CTRL_FBDIV.VALUE_SRC {DEFAULT} \
CONFIG.PCW_IO_IO_PLL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_0_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_0_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_0_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_0_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_10_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_10_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_10_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_11_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_11_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_11_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_12_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_12_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_12_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_13_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_13_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_13_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_14_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_14_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_14_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_14_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_15_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_15_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_15_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_15_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_16_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_16_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_17_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_17_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_18_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_18_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_19_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_19_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_1_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_1_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_1_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_1_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_20_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_20_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_21_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_21_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_22_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_22_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_23_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_23_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_24_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_24_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_25_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_25_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_26_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_26_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_27_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_27_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_28_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_28_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_28_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_29_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_29_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_29_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_2_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_2_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_2_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_2_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_30_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_30_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_30_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_31_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_31_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_31_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_32_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_32_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_32_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_33_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_33_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_33_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_34_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_34_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_34_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_35_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_35_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_35_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_36_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_36_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_36_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_37_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_37_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_37_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_38_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_38_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_38_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_39_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_39_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_39_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_3_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_3_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_3_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_3_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_40_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_40_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_40_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_41_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_41_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_41_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_42_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_42_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_42_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_43_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_43_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_43_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_44_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_44_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_44_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_45_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_45_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_45_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_46_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_46_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_46_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_46_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_47_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_47_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_47_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_47_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_48_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_48_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_48_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_48_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_49_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_49_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_49_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_49_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_4_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_4_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_4_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_4_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_50_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_50_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_50_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_50_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_51_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_51_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_51_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_51_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_52_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_52_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_52_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_52_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_53_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_53_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_53_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_53_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_5_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_5_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_5_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_5_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_6_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_6_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_6_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_6_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_7_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_7_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_7_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_7_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_8_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_8_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_8_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_8_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_9_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_9_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_9_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_TREE_PERIPHERALS.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_TREE_SIGNALS.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NAND_CYCLES_T_AR.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NAND_CYCLES_T_CLR.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NAND_CYCLES_T_RC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NAND_CYCLES_T_REA.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NAND_CYCLES_T_RR.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NAND_CYCLES_T_WC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NAND_CYCLES_T_WP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NAND_GRP_D8_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NAND_GRP_D8_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NAND_NAND_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NAND_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_CS0_T_CEOE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_CS0_T_PC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_CS0_T_RC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_CS0_T_TR.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_CS0_T_WC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_CS0_T_WP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_CS0_WE_TIME.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_CS1_T_CEOE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_CS1_T_PC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_CS1_T_RC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_CS1_T_TR.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_CS1_T_WC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_CS1_T_WP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_CS1_WE_TIME.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_GRP_A25_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_GRP_A25_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_GRP_CS0_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_GRP_CS0_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_GRP_CS1_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_GRP_CS1_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_GRP_SRAM_CS0_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_GRP_SRAM_CS0_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_GRP_SRAM_CS1_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_GRP_SRAM_CS1_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_GRP_SRAM_INT_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_GRP_SRAM_INT_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_NOR_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_SRAM_CS0_T_CEOE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_SRAM_CS0_T_PC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_SRAM_CS0_T_RC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_SRAM_CS0_T_TR.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_SRAM_CS0_T_WC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_SRAM_CS0_T_WP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_SRAM_CS0_WE_TIME.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_SRAM_CS1_T_CEOE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_SRAM_CS1_T_PC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_SRAM_CS1_T_RC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_SRAM_CS1_T_TR.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_SRAM_CS1_T_WC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_SRAM_CS1_T_WP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_SRAM_CS1_WE_TIME.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY2.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY3.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_2.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_3.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PACKAGE_NAME.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PCAP_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PCAP_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PCAP_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PJTAG_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PJTAG_PJTAG_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PLL_BYPASSMODE_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_QSPI_GRP_FBCLK_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_QSPI_GRP_IO1_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_QSPI_GRP_SINGLE_SS_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_QSPI_GRP_SS1_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_QSPI_INTERNAL_HIGHADDRESS.VALUE_SRC {DEFAULT} \
CONFIG.PCW_QSPI_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_QSPI_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_QSPI_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_QSPI_QSPI_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SD0_GRP_POW_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SD0_GRP_POW_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SD0_SD0_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SD1_GRP_CD_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SD1_GRP_CD_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SD1_GRP_POW_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SD1_GRP_POW_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SD1_GRP_WP_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SD1_GRP_WP_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SD1_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SD1_SD1_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SDIO_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SDIO_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SDIO_PERIPHERAL_VALID.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SMC_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SMC_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SMC_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI0_GRP_SS0_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI0_GRP_SS0_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI0_GRP_SS1_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI0_GRP_SS1_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI0_GRP_SS2_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI0_GRP_SS2_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI0_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI0_SPI0_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI1_GRP_SS0_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI1_GRP_SS0_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI1_GRP_SS1_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI1_GRP_SS1_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI1_GRP_SS2_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI1_GRP_SS2_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI1_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI1_SPI1_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_S_AXI_HP1_DATA_WIDTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_S_AXI_HP1_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_S_AXI_HP2_DATA_WIDTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_S_AXI_HP3_DATA_WIDTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TPIU_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TPIU_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TPIU_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TRACE_GRP_16BIT_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TRACE_GRP_16BIT_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TRACE_GRP_2BIT_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TRACE_GRP_2BIT_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TRACE_GRP_32BIT_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TRACE_GRP_32BIT_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TRACE_GRP_4BIT_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TRACE_GRP_4BIT_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TRACE_GRP_8BIT_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TRACE_GRP_8BIT_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TRACE_INTERNAL_WIDTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TRACE_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TRACE_TRACE_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC0_CLK0_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC0_CLK0_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC0_CLK0_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC0_CLK1_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC0_CLK1_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC0_CLK1_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC0_CLK2_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC0_CLK2_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC0_CLK2_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC0_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC0_TTC0_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC1_CLK0_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC1_CLK0_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC1_CLK0_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC1_CLK1_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC1_CLK1_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC1_CLK1_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC1_CLK2_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC1_CLK2_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC1_CLK2_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC1_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC1_TTC1_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UART0_BAUD_RATE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UART0_GRP_FULL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UART0_GRP_FULL_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UART0_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UART0_UART0_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UART1_BAUD_RATE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UART1_GRP_FULL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UART1_GRP_FULL_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UART1_UART1_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UART_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UART_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UART_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UART_PERIPHERAL_VALID.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_AL.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_BANK_ADDR_COUNT.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_BL.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_CL.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_0_LENGTH_MM.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PACKAGE_LENGTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PROPOGATION_DELAY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_1_LENGTH_MM.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PACKAGE_LENGTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PROPOGATION_DELAY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_2_LENGTH_MM.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PACKAGE_LENGTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PROPOGATION_DELAY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_3_LENGTH_MM.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PACKAGE_LENGTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PROPOGATION_DELAY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_STOP_EN.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_COL_ADDR_COUNT.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQS_0_LENGTH_MM.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQS_0_PACKAGE_LENGTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQS_0_PROPOGATION_DELAY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQS_1_LENGTH_MM.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQS_1_PACKAGE_LENGTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQS_1_PROPOGATION_DELAY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQS_2_LENGTH_MM.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQS_2_PACKAGE_LENGTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQS_2_PROPOGATION_DELAY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQS_3_LENGTH_MM.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQS_3_PACKAGE_LENGTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQS_3_PROPOGATION_DELAY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQ_0_LENGTH_MM.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQ_0_PACKAGE_LENGTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQ_0_PROPOGATION_DELAY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQ_1_LENGTH_MM.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQ_1_PACKAGE_LENGTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQ_1_PROPOGATION_DELAY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQ_2_LENGTH_MM.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQ_2_PACKAGE_LENGTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQ_2_PROPOGATION_DELAY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQ_3_LENGTH_MM.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQ_3_PACKAGE_LENGTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQ_3_PROPOGATION_DELAY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_ECC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_FREQ_MHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_HIGH_TEMP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_MEMORY_TYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_ROW_ADDR_COUNT.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_SPEED_BIN.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_T_RCD.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_T_RP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_USB0_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_USB0_USB0_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_USB1_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_USB1_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_USB1_RESET_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_USB1_RESET_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_USB1_USB1_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_USB_RESET_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_USB_RESET_POLARITY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_USB_RESET_SELECT.VALUE_SRC {DEFAULT} \
CONFIG.PCW_USE_CROSS_TRIGGER.VALUE_SRC {DEFAULT} \
CONFIG.PCW_WDT_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_WDT_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_WDT_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_WDT_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_WDT_WDT_IO.VALUE_SRC {DEFAULT} \
 ] $PS

  # Create instance: Tiger4NSC_0, and set properties
  set Tiger4NSC_0 [ create_bd_cell -type ip -vlnv ENCLab:ip:Tiger4NSC:1.2.5 Tiger4NSC_0 ]

  # Create instance: Tiger4NSC_1, and set properties
  set Tiger4NSC_1 [ create_bd_cell -type ip -vlnv ENCLab:ip:Tiger4NSC:1.2.5 Tiger4NSC_1 ]

  # Create instance: Tiger4NSC_2, and set properties
  set Tiger4NSC_2 [ create_bd_cell -type ip -vlnv ENCLab:ip:Tiger4NSC:1.2.5 Tiger4NSC_2 ]

  # Create instance: Tiger4NSC_3, and set properties
  set Tiger4NSC_3 [ create_bd_cell -type ip -vlnv ENCLab:ip:Tiger4NSC:1.2.5 Tiger4NSC_3 ]

  # Create instance: Tiger4NSC_4, and set properties
  set Tiger4NSC_4 [ create_bd_cell -type ip -vlnv ENCLab:ip:Tiger4NSC:1.2.5 Tiger4NSC_4 ]

  # Create instance: Tiger4NSC_5, and set properties
  set Tiger4NSC_5 [ create_bd_cell -type ip -vlnv ENCLab:ip:Tiger4NSC:1.2.5 Tiger4NSC_5 ]

  # Create instance: Tiger4NSC_6, and set properties
  set Tiger4NSC_6 [ create_bd_cell -type ip -vlnv ENCLab:ip:Tiger4NSC:1.2.5 Tiger4NSC_6 ]

  # Create instance: Tiger4NSC_7, and set properties
  set Tiger4NSC_7 [ create_bd_cell -type ip -vlnv ENCLab:ip:Tiger4NSC:1.2.5 Tiger4NSC_7 ]

  # Create instance: Tiger4SharedKES_0, and set properties
  set Tiger4SharedKES_0 [ create_bd_cell -type ip -vlnv ENCLab:ip:Tiger4SharedKES:1.0.1 Tiger4SharedKES_0 ]

  # Create instance: Tiger4SharedKES_1, and set properties
  set Tiger4SharedKES_1 [ create_bd_cell -type ip -vlnv ENCLab:ip:Tiger4SharedKES:1.0.1 Tiger4SharedKES_1 ]

  # Create instance: V2NFC100DDR_0, and set properties
  set V2NFC100DDR_0 [ create_bd_cell -type ip -vlnv ENCLab:ip:V2NFC100DDR:1.0.0 V2NFC100DDR_0 ]
  set_property -dict [ list \
CONFIG.InputClockBufferType {2} \
 ] $V2NFC100DDR_0

  # Create instance: V2NFC100DDR_1, and set properties
  set V2NFC100DDR_1 [ create_bd_cell -type ip -vlnv ENCLab:ip:V2NFC100DDR:1.0.0 V2NFC100DDR_1 ]
  set_property -dict [ list \
CONFIG.InputClockBufferType {2} \
 ] $V2NFC100DDR_1

  # Create instance: V2NFC100DDR_2, and set properties
  set V2NFC100DDR_2 [ create_bd_cell -type ip -vlnv ENCLab:ip:V2NFC100DDR:1.0.0 V2NFC100DDR_2 ]
  set_property -dict [ list \
CONFIG.InputClockBufferType {2} \
 ] $V2NFC100DDR_2

  # Create instance: V2NFC100DDR_3, and set properties
  set V2NFC100DDR_3 [ create_bd_cell -type ip -vlnv ENCLab:ip:V2NFC100DDR:1.0.0 V2NFC100DDR_3 ]
  set_property -dict [ list \
CONFIG.InputClockBufferType {2} \
 ] $V2NFC100DDR_3

  # Create instance: V2NFC100DDR_4, and set properties
  set V2NFC100DDR_4 [ create_bd_cell -type ip -vlnv ENCLab:ip:V2NFC100DDR:1.0.0 V2NFC100DDR_4 ]
  set_property -dict [ list \
CONFIG.InputClockBufferType {2} \
 ] $V2NFC100DDR_4

  # Create instance: V2NFC100DDR_5, and set properties
  set V2NFC100DDR_5 [ create_bd_cell -type ip -vlnv ENCLab:ip:V2NFC100DDR:1.0.0 V2NFC100DDR_5 ]
  set_property -dict [ list \
CONFIG.InputClockBufferType {2} \
 ] $V2NFC100DDR_5

  # Create instance: V2NFC100DDR_6, and set properties
  set V2NFC100DDR_6 [ create_bd_cell -type ip -vlnv ENCLab:ip:V2NFC100DDR:1.0.0 V2NFC100DDR_6 ]
  set_property -dict [ list \
CONFIG.InputClockBufferType {2} \
 ] $V2NFC100DDR_6

  # Create instance: V2NFC100DDR_7, and set properties
  set V2NFC100DDR_7 [ create_bd_cell -type ip -vlnv ENCLab:ip:V2NFC100DDR:1.0.0 V2NFC100DDR_7 ]
  set_property -dict [ list \
CONFIG.InputClockBufferType {2} \
 ] $V2NFC100DDR_7

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
CONFIG.ENABLE_ADVANCED_OPTIONS {1} \
CONFIG.M00_HAS_DATA_FIFO {2} \
CONFIG.M00_HAS_REGSLICE {1} \
CONFIG.M01_HAS_REGSLICE {1} \
CONFIG.NUM_MI {1} \
CONFIG.NUM_SI {4} \
CONFIG.S00_HAS_DATA_FIFO {2} \
CONFIG.S00_HAS_REGSLICE {1} \
CONFIG.S01_HAS_DATA_FIFO {2} \
CONFIG.S01_HAS_REGSLICE {1} \
CONFIG.S02_HAS_DATA_FIFO {2} \
CONFIG.S02_HAS_REGSLICE {1} \
CONFIG.S03_HAS_DATA_FIFO {2} \
CONFIG.S03_HAS_REGSLICE {1} \
CONFIG.STRATEGY {2} \
 ] $axi_interconnect_0

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.S00_HAS_DATA_FIFO.VALUE_SRC {DEFAULT} \
CONFIG.S01_HAS_DATA_FIFO.VALUE_SRC {DEFAULT} \
CONFIG.S02_HAS_DATA_FIFO.VALUE_SRC {DEFAULT} \
CONFIG.S03_HAS_DATA_FIFO.VALUE_SRC {DEFAULT} \
 ] $axi_interconnect_0

  # Create instance: axi_interconnect_1, and set properties
  set axi_interconnect_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_1 ]
  set_property -dict [ list \
CONFIG.ENABLE_ADVANCED_OPTIONS {1} \
CONFIG.M00_HAS_DATA_FIFO {2} \
CONFIG.M00_HAS_REGSLICE {1} \
CONFIG.M01_HAS_REGSLICE {1} \
CONFIG.NUM_MI {1} \
CONFIG.NUM_SI {4} \
CONFIG.S00_HAS_DATA_FIFO {2} \
CONFIG.S00_HAS_REGSLICE {1} \
CONFIG.S01_HAS_DATA_FIFO {2} \
CONFIG.S01_HAS_REGSLICE {1} \
CONFIG.S02_HAS_DATA_FIFO {2} \
CONFIG.S02_HAS_REGSLICE {1} \
CONFIG.S03_HAS_DATA_FIFO {2} \
CONFIG.S03_HAS_REGSLICE {1} \
CONFIG.STRATEGY {2} \
 ] $axi_interconnect_1

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.S00_HAS_DATA_FIFO.VALUE_SRC {DEFAULT} \
CONFIG.S01_HAS_DATA_FIFO.VALUE_SRC {DEFAULT} \
CONFIG.S02_HAS_DATA_FIFO.VALUE_SRC {DEFAULT} \
CONFIG.S03_HAS_DATA_FIFO.VALUE_SRC {DEFAULT} \
 ] $axi_interconnect_1

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: proc_sys_reset_1, and set properties
  set proc_sys_reset_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_1 ]

  # Create instance: proc_sys_reset_2, and set properties
  set proc_sys_reset_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_2 ]

  # Create instance: proc_sys_reset_3, and set properties
  set proc_sys_reset_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_3 ]

  # Create interface connections
  connect_bd_intf_net -intf_net GPIC0_M00_AXI [get_bd_intf_pins GPIC0/M00_AXI] [get_bd_intf_pins Tiger4NSC_0/C_AXI]
  connect_bd_intf_net -intf_net GPIC0_M01_AXI [get_bd_intf_pins GPIC0/M01_AXI] [get_bd_intf_pins Tiger4NSC_1/C_AXI]
  connect_bd_intf_net -intf_net GPIC0_M02_AXI [get_bd_intf_pins GPIC0/M02_AXI] [get_bd_intf_pins Tiger4NSC_2/C_AXI]
  connect_bd_intf_net -intf_net GPIC0_M03_AXI [get_bd_intf_pins GPIC0/M03_AXI] [get_bd_intf_pins Tiger4NSC_3/C_AXI]
  connect_bd_intf_net -intf_net GPIC0_M04_AXI [get_bd_intf_pins GPIC0/M04_AXI] [get_bd_intf_pins GPIC2/S00_AXI]
  connect_bd_intf_net -intf_net GPIC1_M00_AXI [get_bd_intf_pins GPIC1/M00_AXI] [get_bd_intf_pins NVMeHostController_0/s0_axi]
  connect_bd_intf_net -intf_net GPIC2_M00_AXI [get_bd_intf_pins GPIC2/M00_AXI] [get_bd_intf_pins Tiger4NSC_4/C_AXI]
  connect_bd_intf_net -intf_net GPIC2_M01_AXI [get_bd_intf_pins GPIC2/M01_AXI] [get_bd_intf_pins Tiger4NSC_5/C_AXI]
  connect_bd_intf_net -intf_net GPIC2_M02_AXI [get_bd_intf_pins GPIC2/M02_AXI] [get_bd_intf_pins Tiger4NSC_6/C_AXI]
  connect_bd_intf_net -intf_net GPIC2_M03_AXI [get_bd_intf_pins GPIC2/M03_AXI] [get_bd_intf_pins Tiger4NSC_7/C_AXI]
  connect_bd_intf_net -intf_net HPIC3_M00_AXI [get_bd_intf_pins HPIC3/M00_AXI] [get_bd_intf_pins PS/S_AXI_HP3]
  connect_bd_intf_net -intf_net NVMeHostController_0_m0_axi [get_bd_intf_pins HPIC3/S00_AXI] [get_bd_intf_pins NVMeHostController_0/m0_axi]
  connect_bd_intf_net -intf_net PS_M_AXI_GP0 [get_bd_intf_pins GPIC0/S00_AXI] [get_bd_intf_pins PS/M_AXI_GP0]
  connect_bd_intf_net -intf_net S00_AXI_2 [get_bd_intf_pins GPIC1/S00_AXI] [get_bd_intf_pins PS/M_AXI_GP1]
  connect_bd_intf_net -intf_net S01_AXI_1 [get_bd_intf_pins Tiger4NSC_1/D_AXI] [get_bd_intf_pins axi_interconnect_0/S01_AXI]
  connect_bd_intf_net -intf_net Tiger4NSC_0_D_AXI [get_bd_intf_pins Tiger4NSC_0/D_AXI] [get_bd_intf_pins axi_interconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net Tiger4NSC_0_NFCInterface [get_bd_intf_pins Tiger4NSC_0/NFCInterface] [get_bd_intf_pins V2NFC100DDR_0/NFCInterface]
  connect_bd_intf_net -intf_net Tiger4NSC_0_SharedKESInterface [get_bd_intf_pins Tiger4NSC_0/SharedKESInterface] [get_bd_intf_pins Tiger4SharedKES_0/SharedKESInterface_CH0]
  connect_bd_intf_net -intf_net Tiger4NSC_0_uROMInterface [get_bd_intf_pins Dispatcher_uCode_0/BRAM_PORTA] [get_bd_intf_pins Tiger4NSC_0/uROMInterface]
  connect_bd_intf_net -intf_net Tiger4NSC_1_NFCInterface [get_bd_intf_pins Tiger4NSC_1/NFCInterface] [get_bd_intf_pins V2NFC100DDR_1/NFCInterface]
  connect_bd_intf_net -intf_net Tiger4NSC_1_SharedKESInterface [get_bd_intf_pins Tiger4NSC_1/SharedKESInterface] [get_bd_intf_pins Tiger4SharedKES_0/SharedKESInterface_CH1]
  connect_bd_intf_net -intf_net Tiger4NSC_1_uROMInterface [get_bd_intf_pins Dispatcher_uCode_1/BRAM_PORTA] [get_bd_intf_pins Tiger4NSC_1/uROMInterface]
  connect_bd_intf_net -intf_net Tiger4NSC_2_D_AXI [get_bd_intf_pins Tiger4NSC_2/D_AXI] [get_bd_intf_pins axi_interconnect_0/S02_AXI]
  connect_bd_intf_net -intf_net Tiger4NSC_2_NFCInterface [get_bd_intf_pins Tiger4NSC_2/NFCInterface] [get_bd_intf_pins V2NFC100DDR_2/NFCInterface]
  connect_bd_intf_net -intf_net Tiger4NSC_2_SharedKESInterface [get_bd_intf_pins Tiger4NSC_2/SharedKESInterface] [get_bd_intf_pins Tiger4SharedKES_0/SharedKESInterface_CH2]
  connect_bd_intf_net -intf_net Tiger4NSC_2_uROMInterface [get_bd_intf_pins Dispatcher_uCode_2/BRAM_PORTA] [get_bd_intf_pins Tiger4NSC_2/uROMInterface]
  connect_bd_intf_net -intf_net Tiger4NSC_3_D_AXI [get_bd_intf_pins Tiger4NSC_3/D_AXI] [get_bd_intf_pins axi_interconnect_0/S03_AXI]
  connect_bd_intf_net -intf_net Tiger4NSC_3_NFCInterface [get_bd_intf_pins Tiger4NSC_3/NFCInterface] [get_bd_intf_pins V2NFC100DDR_3/NFCInterface]
  connect_bd_intf_net -intf_net Tiger4NSC_3_SharedKESInterface [get_bd_intf_pins Tiger4NSC_3/SharedKESInterface] [get_bd_intf_pins Tiger4SharedKES_0/SharedKESInterface_CH3]
  connect_bd_intf_net -intf_net Tiger4NSC_3_uROMInterface [get_bd_intf_pins Dispatcher_uCode_3/BRAM_PORTA] [get_bd_intf_pins Tiger4NSC_3/uROMInterface]
  connect_bd_intf_net -intf_net Tiger4NSC_4_D_AXI [get_bd_intf_pins Tiger4NSC_4/D_AXI] [get_bd_intf_pins axi_interconnect_1/S00_AXI]
  connect_bd_intf_net -intf_net Tiger4NSC_4_NFCInterface [get_bd_intf_pins Tiger4NSC_4/NFCInterface] [get_bd_intf_pins V2NFC100DDR_4/NFCInterface]
  connect_bd_intf_net -intf_net Tiger4NSC_4_SharedKESInterface [get_bd_intf_pins Tiger4NSC_4/SharedKESInterface] [get_bd_intf_pins Tiger4SharedKES_1/SharedKESInterface_CH0]
  connect_bd_intf_net -intf_net Tiger4NSC_4_uROMInterface [get_bd_intf_pins Dispatcher_uCode_4/BRAM_PORTA] [get_bd_intf_pins Tiger4NSC_4/uROMInterface]
  connect_bd_intf_net -intf_net Tiger4NSC_5_D_AXI [get_bd_intf_pins Tiger4NSC_5/D_AXI] [get_bd_intf_pins axi_interconnect_1/S01_AXI]
  connect_bd_intf_net -intf_net Tiger4NSC_5_NFCInterface [get_bd_intf_pins Tiger4NSC_5/NFCInterface] [get_bd_intf_pins V2NFC100DDR_5/NFCInterface]
  connect_bd_intf_net -intf_net Tiger4NSC_5_SharedKESInterface [get_bd_intf_pins Tiger4NSC_5/SharedKESInterface] [get_bd_intf_pins Tiger4SharedKES_1/SharedKESInterface_CH1]
  connect_bd_intf_net -intf_net Tiger4NSC_5_uROMInterface [get_bd_intf_pins Dispatcher_uCode_5/BRAM_PORTA] [get_bd_intf_pins Tiger4NSC_5/uROMInterface]
  connect_bd_intf_net -intf_net Tiger4NSC_6_D_AXI [get_bd_intf_pins Tiger4NSC_6/D_AXI] [get_bd_intf_pins axi_interconnect_1/S02_AXI]
  connect_bd_intf_net -intf_net Tiger4NSC_6_NFCInterface [get_bd_intf_pins Tiger4NSC_6/NFCInterface] [get_bd_intf_pins V2NFC100DDR_6/NFCInterface]
  connect_bd_intf_net -intf_net Tiger4NSC_6_SharedKESInterface [get_bd_intf_pins Tiger4NSC_6/SharedKESInterface] [get_bd_intf_pins Tiger4SharedKES_1/SharedKESInterface_CH2]
  connect_bd_intf_net -intf_net Tiger4NSC_6_uROMInterface [get_bd_intf_pins Dispatcher_uCode_6/BRAM_PORTA] [get_bd_intf_pins Tiger4NSC_6/uROMInterface]
  connect_bd_intf_net -intf_net Tiger4NSC_7_D_AXI [get_bd_intf_pins Tiger4NSC_7/D_AXI] [get_bd_intf_pins axi_interconnect_1/S03_AXI]
  connect_bd_intf_net -intf_net Tiger4NSC_7_NFCInterface [get_bd_intf_pins Tiger4NSC_7/NFCInterface] [get_bd_intf_pins V2NFC100DDR_7/NFCInterface]
  connect_bd_intf_net -intf_net Tiger4NSC_7_SharedKESInterface [get_bd_intf_pins Tiger4NSC_7/SharedKESInterface] [get_bd_intf_pins Tiger4SharedKES_1/SharedKESInterface_CH3]
  connect_bd_intf_net -intf_net Tiger4NSC_7_uROMInterface [get_bd_intf_pins Dispatcher_uCode_7/BRAM_PORTA] [get_bd_intf_pins Tiger4NSC_7/uROMInterface]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins PS/S_AXI_HP0] [get_bd_intf_pins axi_interconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M00_AXI [get_bd_intf_pins PS/S_AXI_HP2] [get_bd_intf_pins axi_interconnect_1/M00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins PS/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins PS/FIXED_IO]

  # Create port connections
  connect_bd_net -net ARESETN_1 [get_bd_pins GPIC0/ARESETN] [get_bd_pins proc_sys_reset_0/interconnect_aresetn]
  connect_bd_net -net ARESETN_2 [get_bd_pins HPIC3/ARESETN] [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axi_interconnect_1/ARESETN] [get_bd_pins proc_sys_reset_3/interconnect_aresetn]
  connect_bd_net -net ARESETN_3 [get_bd_pins GPIC1/ARESETN] [get_bd_pins proc_sys_reset_2/interconnect_aresetn]
  connect_bd_net -net CH0MMCMC1H200_clk_out1 [get_bd_pins CH0MMCMC1H200/clk_out1] [get_bd_pins V2NFC100DDR_0/iDelayRefClock] [get_bd_pins V2NFC100DDR_0/iOutputDrivingClock] [get_bd_pins V2NFC100DDR_1/iDelayRefClock] [get_bd_pins V2NFC100DDR_1/iOutputDrivingClock]
  connect_bd_net -net CH2MMCMC1H200_clk_out1 [get_bd_pins CH2MMCMC1H200/clk_out1] [get_bd_pins V2NFC100DDR_2/iDelayRefClock] [get_bd_pins V2NFC100DDR_2/iOutputDrivingClock]
  connect_bd_net -net CH3MMCMC1H200_clk_out1 [get_bd_pins CH3MMCMC1H200/clk_out1] [get_bd_pins V2NFC100DDR_3/iDelayRefClock] [get_bd_pins V2NFC100DDR_3/iOutputDrivingClock]
  connect_bd_net -net CH4MMCMC1H200_clk_out1 [get_bd_pins CH4MMCMC1H200/clk_out1] [get_bd_pins V2NFC100DDR_4/iDelayRefClock] [get_bd_pins V2NFC100DDR_4/iOutputDrivingClock] [get_bd_pins V2NFC100DDR_5/iDelayRefClock] [get_bd_pins V2NFC100DDR_5/iOutputDrivingClock]
  connect_bd_net -net CH6MMCMC1H200_clk_out1 [get_bd_pins CH6MMCMC1H200/clk_out1] [get_bd_pins V2NFC100DDR_6/iDelayRefClock] [get_bd_pins V2NFC100DDR_6/iOutputDrivingClock]
  connect_bd_net -net CH7MMCMC1H200_clk_out1 [get_bd_pins CH7MMCMC1H200/clk_out1] [get_bd_pins V2NFC100DDR_7/iDelayRefClock] [get_bd_pins V2NFC100DDR_7/iOutputDrivingClock]
  connect_bd_net -net I_NAND_RB_1 [get_bd_ports I_NAND_CH0_RB] [get_bd_pins V2NFC100DDR_0/I_NAND_RB]
  connect_bd_net -net I_NAND_RB_2 [get_bd_ports I_NAND_CH1_RB] [get_bd_pins V2NFC100DDR_1/I_NAND_RB]
  connect_bd_net -net I_NAND_RB_3 [get_bd_ports I_NAND_CH2_RB] [get_bd_pins V2NFC100DDR_2/I_NAND_RB]
  connect_bd_net -net I_NAND_RB_4 [get_bd_ports I_NAND_CH3_RB] [get_bd_pins V2NFC100DDR_3/I_NAND_RB]
  connect_bd_net -net I_NAND_RB_5 [get_bd_ports I_NAND_CH4_RB] [get_bd_pins V2NFC100DDR_4/I_NAND_RB]
  connect_bd_net -net I_NAND_RB_6 [get_bd_ports I_NAND_CH5_RB] [get_bd_pins V2NFC100DDR_5/I_NAND_RB]
  connect_bd_net -net I_NAND_RB_7 [get_bd_ports I_NAND_CH6_RB] [get_bd_pins V2NFC100DDR_6/I_NAND_RB]
  connect_bd_net -net I_NAND_RB_8 [get_bd_ports I_NAND_CH7_RB] [get_bd_pins V2NFC100DDR_7/I_NAND_RB]
  connect_bd_net -net M00_ARESETN_1 [get_bd_pins GPIC0/M00_ARESETN] [get_bd_pins GPIC0/M01_ARESETN] [get_bd_pins GPIC0/M02_ARESETN] [get_bd_pins GPIC0/M03_ARESETN] [get_bd_pins GPIC0/S00_ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins axi_interconnect_0/S01_ARESETN] [get_bd_pins axi_interconnect_0/S02_ARESETN] [get_bd_pins axi_interconnect_0/S03_ARESETN] [get_bd_pins proc_sys_reset_0/peripheral_aresetn]
  connect_bd_net -net M00_ARESETN_2 [get_bd_pins HPIC3/M00_ARESETN] [get_bd_pins HPIC3/S00_ARESETN] [get_bd_pins NVMeHostController_0/m0_axi_aresetn] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_1/M00_ARESETN] [get_bd_pins proc_sys_reset_3/peripheral_aresetn]
  connect_bd_net -net NVMeHostController_0_dev_irq_assert [get_bd_pins NVMeHostController_0/dev_irq_assert] [get_bd_pins PS/IRQ_F2P]
  connect_bd_net -net NVMeHostController_0_pcie_tx_n [get_bd_ports pcie_tx_n] [get_bd_pins NVMeHostController_0/pcie_tx_n]
  connect_bd_net -net NVMeHostController_0_pcie_tx_p [get_bd_ports pcie_tx_p] [get_bd_pins NVMeHostController_0/pcie_tx_p]
  connect_bd_net -net Net [get_bd_ports IO_NAND_CH0_DQS_N] [get_bd_pins V2NFC100DDR_0/IO_NAND_DQS_N]
  connect_bd_net -net Net1 [get_bd_ports IO_NAND_CH0_DQ] [get_bd_pins V2NFC100DDR_0/IO_NAND_DQ]
  connect_bd_net -net Net2 [get_bd_ports IO_NAND_CH0_DQS_P] [get_bd_pins V2NFC100DDR_0/IO_NAND_DQS_P]
  connect_bd_net -net Net3 [get_bd_ports IO_NAND_CH1_DQS_N] [get_bd_pins V2NFC100DDR_1/IO_NAND_DQS_N]
  connect_bd_net -net Net4 [get_bd_ports IO_NAND_CH1_DQS_P] [get_bd_pins V2NFC100DDR_1/IO_NAND_DQS_P]
  connect_bd_net -net Net5 [get_bd_ports IO_NAND_CH1_DQ] [get_bd_pins V2NFC100DDR_1/IO_NAND_DQ]
  connect_bd_net -net Net6 [get_bd_ports IO_NAND_CH2_DQS_N] [get_bd_pins V2NFC100DDR_2/IO_NAND_DQS_N]
  connect_bd_net -net Net7 [get_bd_ports IO_NAND_CH2_DQ] [get_bd_pins V2NFC100DDR_2/IO_NAND_DQ]
  connect_bd_net -net Net8 [get_bd_ports IO_NAND_CH2_DQS_P] [get_bd_pins V2NFC100DDR_2/IO_NAND_DQS_P]
  connect_bd_net -net Net9 [get_bd_ports IO_NAND_CH3_DQ] [get_bd_pins V2NFC100DDR_3/IO_NAND_DQ]
  connect_bd_net -net Net10 [get_bd_ports IO_NAND_CH3_DQS_P] [get_bd_pins V2NFC100DDR_3/IO_NAND_DQS_P]
  connect_bd_net -net Net11 [get_bd_ports IO_NAND_CH3_DQS_N] [get_bd_pins V2NFC100DDR_3/IO_NAND_DQS_N]
  connect_bd_net -net Net12 [get_bd_ports IO_NAND_CH4_DQ] [get_bd_pins V2NFC100DDR_4/IO_NAND_DQ]
  connect_bd_net -net Net13 [get_bd_ports IO_NAND_CH4_DQS_P] [get_bd_pins V2NFC100DDR_4/IO_NAND_DQS_P]
  connect_bd_net -net Net14 [get_bd_ports IO_NAND_CH4_DQS_N] [get_bd_pins V2NFC100DDR_4/IO_NAND_DQS_N]
  connect_bd_net -net Net15 [get_bd_ports IO_NAND_CH5_DQ] [get_bd_pins V2NFC100DDR_5/IO_NAND_DQ]
  connect_bd_net -net Net16 [get_bd_ports IO_NAND_CH5_DQS_P] [get_bd_pins V2NFC100DDR_5/IO_NAND_DQS_P]
  connect_bd_net -net Net17 [get_bd_ports IO_NAND_CH5_DQS_N] [get_bd_pins V2NFC100DDR_5/IO_NAND_DQS_N]
  connect_bd_net -net Net18 [get_bd_ports IO_NAND_CH6_DQS_N] [get_bd_pins V2NFC100DDR_6/IO_NAND_DQS_N]
  connect_bd_net -net Net19 [get_bd_ports IO_NAND_CH6_DQ] [get_bd_pins V2NFC100DDR_6/IO_NAND_DQ]
  connect_bd_net -net Net20 [get_bd_ports IO_NAND_CH6_DQS_P] [get_bd_pins V2NFC100DDR_6/IO_NAND_DQS_P]
  connect_bd_net -net Net21 [get_bd_ports IO_NAND_CH7_DQS_N] [get_bd_pins V2NFC100DDR_7/IO_NAND_DQS_N]
  connect_bd_net -net Net22 [get_bd_ports IO_NAND_CH7_DQ] [get_bd_pins V2NFC100DDR_7/IO_NAND_DQ]
  connect_bd_net -net Net23 [get_bd_ports IO_NAND_CH7_DQS_P] [get_bd_pins V2NFC100DDR_7/IO_NAND_DQS_P]
  connect_bd_net -net PS_FCLK_CLK0 [get_bd_pins CH0MMCMC1H200/clk_in1] [get_bd_pins CH2MMCMC1H200/clk_in1] [get_bd_pins CH3MMCMC1H200/clk_in1] [get_bd_pins GPIC0/ACLK] [get_bd_pins GPIC0/M00_ACLK] [get_bd_pins GPIC0/M01_ACLK] [get_bd_pins GPIC0/M02_ACLK] [get_bd_pins GPIC0/M03_ACLK] [get_bd_pins GPIC0/S00_ACLK] [get_bd_pins PS/FCLK_CLK0] [get_bd_pins PS/M_AXI_GP0_ACLK] [get_bd_pins Tiger4NSC_0/iClock] [get_bd_pins Tiger4NSC_1/iClock] [get_bd_pins Tiger4NSC_2/iClock] [get_bd_pins Tiger4NSC_3/iClock] [get_bd_pins Tiger4SharedKES_0/iClock] [get_bd_pins Tiger4SharedKES_1/iClock] [get_bd_pins V2NFC100DDR_0/iSystemClock] [get_bd_pins V2NFC100DDR_1/iSystemClock] [get_bd_pins V2NFC100DDR_2/iSystemClock] [get_bd_pins V2NFC100DDR_3/iSystemClock] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins axi_interconnect_0/S01_ACLK] [get_bd_pins axi_interconnect_0/S02_ACLK] [get_bd_pins axi_interconnect_0/S03_ACLK] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
  connect_bd_net -net PS_FCLK_CLK1 [get_bd_pins CH4MMCMC1H200/clk_in1] [get_bd_pins CH6MMCMC1H200/clk_in1] [get_bd_pins CH7MMCMC1H200/clk_in1] [get_bd_pins GPIC0/M04_ACLK] [get_bd_pins GPIC2/ACLK] [get_bd_pins GPIC2/M00_ACLK] [get_bd_pins GPIC2/M01_ACLK] [get_bd_pins GPIC2/M02_ACLK] [get_bd_pins GPIC2/M03_ACLK] [get_bd_pins GPIC2/S00_ACLK] [get_bd_pins PS/FCLK_CLK1] [get_bd_pins Tiger4NSC_4/iClock] [get_bd_pins Tiger4NSC_5/iClock] [get_bd_pins Tiger4NSC_6/iClock] [get_bd_pins Tiger4NSC_7/iClock] [get_bd_pins V2NFC100DDR_4/iSystemClock] [get_bd_pins V2NFC100DDR_5/iSystemClock] [get_bd_pins V2NFC100DDR_6/iSystemClock] [get_bd_pins V2NFC100DDR_7/iSystemClock] [get_bd_pins axi_interconnect_1/S00_ACLK] [get_bd_pins axi_interconnect_1/S01_ACLK] [get_bd_pins axi_interconnect_1/S02_ACLK] [get_bd_pins axi_interconnect_1/S03_ACLK] [get_bd_pins proc_sys_reset_1/slowest_sync_clk]
  connect_bd_net -net PS_FCLK_CLK2 [get_bd_pins GPIC1/ACLK] [get_bd_pins GPIC1/M00_ACLK] [get_bd_pins GPIC1/S00_ACLK] [get_bd_pins NVMeHostController_0/s0_axi_aclk] [get_bd_pins PS/FCLK_CLK2] [get_bd_pins PS/M_AXI_GP1_ACLK] [get_bd_pins proc_sys_reset_2/slowest_sync_clk]
  connect_bd_net -net PS_FCLK_CLK3 [get_bd_pins HPIC3/ACLK] [get_bd_pins HPIC3/M00_ACLK] [get_bd_pins HPIC3/S00_ACLK] [get_bd_pins NVMeHostController_0/m0_axi_aclk] [get_bd_pins PS/FCLK_CLK3] [get_bd_pins PS/S_AXI_HP0_ACLK] [get_bd_pins PS/S_AXI_HP2_ACLK] [get_bd_pins PS/S_AXI_HP3_ACLK] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_1/ACLK] [get_bd_pins axi_interconnect_1/M00_ACLK] [get_bd_pins proc_sys_reset_3/slowest_sync_clk]
  connect_bd_net -net PS_FCLK_RESET0_N [get_bd_pins PS/FCLK_RESET0_N] [get_bd_pins proc_sys_reset_0/ext_reset_in]
  connect_bd_net -net PS_FCLK_RESET1_N [get_bd_pins PS/FCLK_RESET1_N] [get_bd_pins proc_sys_reset_1/ext_reset_in]
  connect_bd_net -net PS_FCLK_RESET2_N [get_bd_pins PS/FCLK_RESET2_N] [get_bd_pins proc_sys_reset_2/ext_reset_in]
  connect_bd_net -net PS_FCLK_RESET3_N [get_bd_pins PS/FCLK_RESET3_N] [get_bd_pins proc_sys_reset_3/ext_reset_in]
  connect_bd_net -net V2NFC100DDR_0_O_NAND_ALE [get_bd_ports O_NAND_CH0_ALE] [get_bd_pins V2NFC100DDR_0/O_NAND_ALE]
  connect_bd_net -net V2NFC100DDR_0_O_NAND_CE [get_bd_ports O_NAND_CH0_CE] [get_bd_pins V2NFC100DDR_0/O_NAND_CE]
  connect_bd_net -net V2NFC100DDR_0_O_NAND_CLE [get_bd_ports O_NAND_CH0_CLE] [get_bd_pins V2NFC100DDR_0/O_NAND_CLE]
  connect_bd_net -net V2NFC100DDR_0_O_NAND_RE_N [get_bd_ports O_NAND_CH0_RE_N] [get_bd_pins V2NFC100DDR_0/O_NAND_RE_N]
  connect_bd_net -net V2NFC100DDR_0_O_NAND_RE_P [get_bd_ports O_NAND_CH0_RE_P] [get_bd_pins V2NFC100DDR_0/O_NAND_RE_P]
  connect_bd_net -net V2NFC100DDR_0_O_NAND_WE [get_bd_ports O_NAND_CH0_WE] [get_bd_pins V2NFC100DDR_0/O_NAND_WE]
  connect_bd_net -net V2NFC100DDR_0_O_NAND_WP [get_bd_ports O_NAND_CH0_WP] [get_bd_pins V2NFC100DDR_0/O_NAND_WP]
  connect_bd_net -net V2NFC100DDR_1_O_NAND_ALE [get_bd_ports O_NAND_CH1_ALE] [get_bd_pins V2NFC100DDR_1/O_NAND_ALE]
  connect_bd_net -net V2NFC100DDR_1_O_NAND_CE [get_bd_ports O_NAND_CH1_CE] [get_bd_pins V2NFC100DDR_1/O_NAND_CE]
  connect_bd_net -net V2NFC100DDR_1_O_NAND_CLE [get_bd_ports O_NAND_CH1_CLE] [get_bd_pins V2NFC100DDR_1/O_NAND_CLE]
  connect_bd_net -net V2NFC100DDR_1_O_NAND_RE_N [get_bd_ports O_NAND_CH1_RE_N] [get_bd_pins V2NFC100DDR_1/O_NAND_RE_N]
  connect_bd_net -net V2NFC100DDR_1_O_NAND_RE_P [get_bd_ports O_NAND_CH1_RE_P] [get_bd_pins V2NFC100DDR_1/O_NAND_RE_P]
  connect_bd_net -net V2NFC100DDR_1_O_NAND_WE [get_bd_ports O_NAND_CH1_WE] [get_bd_pins V2NFC100DDR_1/O_NAND_WE]
  connect_bd_net -net V2NFC100DDR_1_O_NAND_WP [get_bd_ports O_NAND_CH1_WP] [get_bd_pins V2NFC100DDR_1/O_NAND_WP]
  connect_bd_net -net V2NFC100DDR_2_O_NAND_ALE [get_bd_ports O_NAND_CH2_ALE] [get_bd_pins V2NFC100DDR_2/O_NAND_ALE]
  connect_bd_net -net V2NFC100DDR_2_O_NAND_CE [get_bd_ports O_NAND_CH2_CE] [get_bd_pins V2NFC100DDR_2/O_NAND_CE]
  connect_bd_net -net V2NFC100DDR_2_O_NAND_CLE [get_bd_ports O_NAND_CH2_CLE] [get_bd_pins V2NFC100DDR_2/O_NAND_CLE]
  connect_bd_net -net V2NFC100DDR_2_O_NAND_RE_N [get_bd_ports O_NAND_CH2_RE_N] [get_bd_pins V2NFC100DDR_2/O_NAND_RE_N]
  connect_bd_net -net V2NFC100DDR_2_O_NAND_RE_P [get_bd_ports O_NAND_CH2_RE_P] [get_bd_pins V2NFC100DDR_2/O_NAND_RE_P]
  connect_bd_net -net V2NFC100DDR_2_O_NAND_WE [get_bd_ports O_NAND_CH2_WE] [get_bd_pins V2NFC100DDR_2/O_NAND_WE]
  connect_bd_net -net V2NFC100DDR_2_O_NAND_WP [get_bd_ports O_NAND_CH2_WP] [get_bd_pins V2NFC100DDR_2/O_NAND_WP]
  connect_bd_net -net V2NFC100DDR_3_O_NAND_ALE [get_bd_ports O_NAND_CH3_ALE] [get_bd_pins V2NFC100DDR_3/O_NAND_ALE]
  connect_bd_net -net V2NFC100DDR_3_O_NAND_CE [get_bd_ports O_NAND_CH3_CE] [get_bd_pins V2NFC100DDR_3/O_NAND_CE]
  connect_bd_net -net V2NFC100DDR_3_O_NAND_CLE [get_bd_ports O_NAND_CH3_CLE] [get_bd_pins V2NFC100DDR_3/O_NAND_CLE]
  connect_bd_net -net V2NFC100DDR_3_O_NAND_RE_N [get_bd_ports O_NAND_CH3_RE_N] [get_bd_pins V2NFC100DDR_3/O_NAND_RE_N]
  connect_bd_net -net V2NFC100DDR_3_O_NAND_RE_P [get_bd_ports O_NAND_CH3_RE_P] [get_bd_pins V2NFC100DDR_3/O_NAND_RE_P]
  connect_bd_net -net V2NFC100DDR_3_O_NAND_WE [get_bd_ports O_NAND_CH3_WE] [get_bd_pins V2NFC100DDR_3/O_NAND_WE]
  connect_bd_net -net V2NFC100DDR_3_O_NAND_WP [get_bd_ports O_NAND_CH3_WP] [get_bd_pins V2NFC100DDR_3/O_NAND_WP]
  connect_bd_net -net V2NFC100DDR_4_O_NAND_ALE [get_bd_ports O_NAND_CH4_ALE] [get_bd_pins V2NFC100DDR_4/O_NAND_ALE]
  connect_bd_net -net V2NFC100DDR_4_O_NAND_CE [get_bd_ports O_NAND_CH4_CE] [get_bd_pins V2NFC100DDR_4/O_NAND_CE]
  connect_bd_net -net V2NFC100DDR_4_O_NAND_CLE [get_bd_ports O_NAND_CH4_CLE] [get_bd_pins V2NFC100DDR_4/O_NAND_CLE]
  connect_bd_net -net V2NFC100DDR_4_O_NAND_RE_N [get_bd_ports O_NAND_CH4_RE_N] [get_bd_pins V2NFC100DDR_4/O_NAND_RE_N]
  connect_bd_net -net V2NFC100DDR_4_O_NAND_RE_P [get_bd_ports O_NAND_CH4_RE_P] [get_bd_pins V2NFC100DDR_4/O_NAND_RE_P]
  connect_bd_net -net V2NFC100DDR_4_O_NAND_WE [get_bd_ports O_NAND_CH4_WE] [get_bd_pins V2NFC100DDR_4/O_NAND_WE]
  connect_bd_net -net V2NFC100DDR_4_O_NAND_WP [get_bd_ports O_NAND_CH4_WP] [get_bd_pins V2NFC100DDR_4/O_NAND_WP]
  connect_bd_net -net V2NFC100DDR_5_O_NAND_ALE [get_bd_ports O_NAND_CH5_ALE] [get_bd_pins V2NFC100DDR_5/O_NAND_ALE]
  connect_bd_net -net V2NFC100DDR_5_O_NAND_CE [get_bd_ports O_NAND_CH5_CE] [get_bd_pins V2NFC100DDR_5/O_NAND_CE]
  connect_bd_net -net V2NFC100DDR_5_O_NAND_CLE [get_bd_ports O_NAND_CH5_CLE] [get_bd_pins V2NFC100DDR_5/O_NAND_CLE]
  connect_bd_net -net V2NFC100DDR_5_O_NAND_RE_N [get_bd_ports O_NAND_CH5_E_N] [get_bd_pins V2NFC100DDR_5/O_NAND_RE_N]
  connect_bd_net -net V2NFC100DDR_5_O_NAND_RE_P [get_bd_ports O_NAND_CH5_RE_P] [get_bd_pins V2NFC100DDR_5/O_NAND_RE_P]
  connect_bd_net -net V2NFC100DDR_5_O_NAND_WE [get_bd_ports O_NAND_CH5_WE] [get_bd_pins V2NFC100DDR_5/O_NAND_WE]
  connect_bd_net -net V2NFC100DDR_5_O_NAND_WP [get_bd_ports O_NAND_CH5_WP] [get_bd_pins V2NFC100DDR_5/O_NAND_WP]
  connect_bd_net -net V2NFC100DDR_6_O_NAND_ALE [get_bd_ports O_NAND_CH6_ALE] [get_bd_pins V2NFC100DDR_6/O_NAND_ALE]
  connect_bd_net -net V2NFC100DDR_6_O_NAND_CE [get_bd_ports O_NAND_CH6_CE] [get_bd_pins V2NFC100DDR_6/O_NAND_CE]
  connect_bd_net -net V2NFC100DDR_6_O_NAND_CLE [get_bd_ports O_NAND_CH6_CLE] [get_bd_pins V2NFC100DDR_6/O_NAND_CLE]
  connect_bd_net -net V2NFC100DDR_6_O_NAND_RE_N [get_bd_ports O_NAND_CH6_RE_N] [get_bd_pins V2NFC100DDR_6/O_NAND_RE_N]
  connect_bd_net -net V2NFC100DDR_6_O_NAND_RE_P [get_bd_ports O_NAND_CH6_RE_P] [get_bd_pins V2NFC100DDR_6/O_NAND_RE_P]
  connect_bd_net -net V2NFC100DDR_6_O_NAND_WE [get_bd_ports O_NAND_CH6_WE] [get_bd_pins V2NFC100DDR_6/O_NAND_WE]
  connect_bd_net -net V2NFC100DDR_6_O_NAND_WP [get_bd_ports O_NAND_CH6_WP] [get_bd_pins V2NFC100DDR_6/O_NAND_WP]
  connect_bd_net -net V2NFC100DDR_7_O_NAND_ALE [get_bd_ports O_NAND_CH7_ALE] [get_bd_pins V2NFC100DDR_7/O_NAND_ALE]
  connect_bd_net -net V2NFC100DDR_7_O_NAND_CE [get_bd_ports O_NAND_CH7_CE] [get_bd_pins V2NFC100DDR_7/O_NAND_CE]
  connect_bd_net -net V2NFC100DDR_7_O_NAND_CLE [get_bd_ports O_NAND_CH7_CLE] [get_bd_pins V2NFC100DDR_7/O_NAND_CLE]
  connect_bd_net -net V2NFC100DDR_7_O_NAND_RE_N [get_bd_ports O_NAND_CH7_RE_N] [get_bd_pins V2NFC100DDR_7/O_NAND_RE_N]
  connect_bd_net -net V2NFC100DDR_7_O_NAND_RE_P [get_bd_ports O_NAND_CH7_RE_P] [get_bd_pins V2NFC100DDR_7/O_NAND_RE_P]
  connect_bd_net -net V2NFC100DDR_7_O_NAND_WE [get_bd_ports O_NAND_CH7_WE] [get_bd_pins V2NFC100DDR_7/O_NAND_WE]
  connect_bd_net -net V2NFC100DDR_7_O_NAND_WP [get_bd_ports O_NAND_CH7_WP] [get_bd_pins V2NFC100DDR_7/O_NAND_WP]
  connect_bd_net -net pcie_perst_n_1 [get_bd_ports pcie_perst_n] [get_bd_pins NVMeHostController_0/pcie_perst_n]
  connect_bd_net -net pcie_ref_clk_n_1 [get_bd_ports pcie_ref_clk_n] [get_bd_pins NVMeHostController_0/pcie_ref_clk_n]
  connect_bd_net -net pcie_ref_clk_p_1 [get_bd_ports pcie_ref_clk_p] [get_bd_pins NVMeHostController_0/pcie_ref_clk_p]
  connect_bd_net -net pcie_rx_n_1 [get_bd_ports pcie_rx_n] [get_bd_pins NVMeHostController_0/pcie_rx_n]
  connect_bd_net -net pcie_rx_p_1 [get_bd_ports pcie_rx_p] [get_bd_pins NVMeHostController_0/pcie_rx_p]
  connect_bd_net -net proc_sys_reset_0_peripheral_reset [get_bd_pins CH0MMCMC1H200/reset] [get_bd_pins CH2MMCMC1H200/reset] [get_bd_pins CH3MMCMC1H200/reset] [get_bd_pins Tiger4NSC_0/iReset] [get_bd_pins Tiger4NSC_1/iReset] [get_bd_pins Tiger4NSC_2/iReset] [get_bd_pins Tiger4NSC_3/iReset] [get_bd_pins Tiger4SharedKES_0/iReset] [get_bd_pins Tiger4SharedKES_1/iReset] [get_bd_pins V2NFC100DDR_0/iReset] [get_bd_pins V2NFC100DDR_1/iReset] [get_bd_pins V2NFC100DDR_2/iReset] [get_bd_pins V2NFC100DDR_3/iReset] [get_bd_pins proc_sys_reset_0/peripheral_reset]
  connect_bd_net -net proc_sys_reset_1_interconnect_aresetn [get_bd_pins GPIC2/ARESETN] [get_bd_pins proc_sys_reset_1/interconnect_aresetn]
  connect_bd_net -net proc_sys_reset_1_peripheral_aresetn [get_bd_pins GPIC0/M04_ARESETN] [get_bd_pins GPIC2/M00_ARESETN] [get_bd_pins GPIC2/M01_ARESETN] [get_bd_pins GPIC2/M02_ARESETN] [get_bd_pins GPIC2/M03_ARESETN] [get_bd_pins GPIC2/S00_ARESETN] [get_bd_pins axi_interconnect_1/S00_ARESETN] [get_bd_pins axi_interconnect_1/S01_ARESETN] [get_bd_pins axi_interconnect_1/S02_ARESETN] [get_bd_pins axi_interconnect_1/S03_ARESETN] [get_bd_pins proc_sys_reset_1/peripheral_aresetn]
  connect_bd_net -net proc_sys_reset_1_peripheral_reset [get_bd_pins CH4MMCMC1H200/reset] [get_bd_pins CH6MMCMC1H200/reset] [get_bd_pins CH7MMCMC1H200/reset] [get_bd_pins Tiger4NSC_4/iReset] [get_bd_pins Tiger4NSC_5/iReset] [get_bd_pins Tiger4NSC_6/iReset] [get_bd_pins Tiger4NSC_7/iReset] [get_bd_pins V2NFC100DDR_4/iReset] [get_bd_pins V2NFC100DDR_5/iReset] [get_bd_pins V2NFC100DDR_6/iReset] [get_bd_pins V2NFC100DDR_7/iReset] [get_bd_pins proc_sys_reset_1/peripheral_reset]
  connect_bd_net -net proc_sys_reset_2_peripheral_aresetn [get_bd_pins GPIC1/M00_ARESETN] [get_bd_pins GPIC1/S00_ARESETN] [get_bd_pins NVMeHostController_0/s0_axi_aresetn] [get_bd_pins proc_sys_reset_2/peripheral_aresetn]

  # Create address segments
  create_bd_addr_seg -range 0x40000000 -offset 0x00000000 [get_bd_addr_spaces NVMeHostController_0/m0_axi] [get_bd_addr_segs PS/S_AXI_HP3/HP3_DDR_LOWOCM] SEG_PS_HP3_DDR_LOWOCM
  create_bd_addr_seg -range 0x00010000 -offset 0x83C00000 [get_bd_addr_spaces PS/Data] [get_bd_addr_segs NVMeHostController_0/s0_axi/reg0] SEG_NVMeHostController_0_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x43C00000 [get_bd_addr_spaces PS/Data] [get_bd_addr_segs Tiger4NSC_0/C_AXI/reg0] SEG_Tiger4NSC_0_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x43C10000 [get_bd_addr_spaces PS/Data] [get_bd_addr_segs Tiger4NSC_1/C_AXI/reg0] SEG_Tiger4NSC_1_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x43C20000 [get_bd_addr_spaces PS/Data] [get_bd_addr_segs Tiger4NSC_2/C_AXI/reg0] SEG_Tiger4NSC_2_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x43C30000 [get_bd_addr_spaces PS/Data] [get_bd_addr_segs Tiger4NSC_3/C_AXI/reg0] SEG_Tiger4NSC_3_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x43C40000 [get_bd_addr_spaces PS/Data] [get_bd_addr_segs Tiger4NSC_4/C_AXI/reg0] SEG_Tiger4NSC_4_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x43C50000 [get_bd_addr_spaces PS/Data] [get_bd_addr_segs Tiger4NSC_5/C_AXI/reg0] SEG_Tiger4NSC_5_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x43C60000 [get_bd_addr_spaces PS/Data] [get_bd_addr_segs Tiger4NSC_6/C_AXI/reg0] SEG_Tiger4NSC_6_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x43C70000 [get_bd_addr_spaces PS/Data] [get_bd_addr_segs Tiger4NSC_7/C_AXI/reg0] SEG_Tiger4NSC_7_reg0
  create_bd_addr_seg -range 0x40000000 -offset 0x00000000 [get_bd_addr_spaces Tiger4NSC_0/D_AXI] [get_bd_addr_segs PS/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_PS_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x40000000 -offset 0x00000000 [get_bd_addr_spaces Tiger4NSC_1/D_AXI] [get_bd_addr_segs PS/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_PS_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x40000000 -offset 0x00000000 [get_bd_addr_spaces Tiger4NSC_2/D_AXI] [get_bd_addr_segs PS/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_PS_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x40000000 -offset 0x00000000 [get_bd_addr_spaces Tiger4NSC_3/D_AXI] [get_bd_addr_segs PS/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_PS_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x40000000 -offset 0x00000000 [get_bd_addr_spaces Tiger4NSC_4/D_AXI] [get_bd_addr_segs PS/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_PS_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x40000000 -offset 0x00000000 [get_bd_addr_spaces Tiger4NSC_5/D_AXI] [get_bd_addr_segs PS/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_PS_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x40000000 -offset 0x00000000 [get_bd_addr_spaces Tiger4NSC_6/D_AXI] [get_bd_addr_segs PS/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_PS_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x40000000 -offset 0x00000000 [get_bd_addr_spaces Tiger4NSC_7/D_AXI] [get_bd_addr_segs PS/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_PS_HP2_DDR_LOWOCM

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   DisplayTieOff: "1",
   guistr: "# # String gsaved with Nlview 6.5.12  2016-01-29 bk=1.3547 VDI=39 GEI=35 GUI=JA:1.6
#  -string -flagsOSRD
preplace port O_NAND_CH7_RE_P -pg 1 -y 3180 -defaultsOSRD
preplace port O_NAND_CH7_ALE -pg 1 -y 3220 -defaultsOSRD
preplace port IO_NAND_CH6_DQS_P -pg 1 -y 2600 -defaultsOSRD
preplace port O_NAND_CH3_WP -pg 1 -y 300 -defaultsOSRD
preplace port O_NAND_CH6_RE_P -pg 1 -y 2700 -defaultsOSRD
preplace port O_NAND_CH6_ALE -pg 1 -y 2740 -defaultsOSRD
preplace port O_NAND_CH4_WE -pg 1 -y 1890 -defaultsOSRD
preplace port IO_NAND_CH5_DQS_N -pg 1 -y 2230 -defaultsOSRD
preplace port O_NAND_CH2_WP -pg 1 -y 20 -defaultsOSRD
preplace port O_NAND_CH7_WP -pg 1 -y 3260 -defaultsOSRD
preplace port O_NAND_CH1_ALE -pg 1 -y -390 -defaultsOSRD
preplace port IO_NAND_CH5_DQS_P -pg 1 -y 2210 -defaultsOSRD
preplace port O_NAND_CH0_RE_N -pg 1 -y -760 -defaultsOSRD
preplace port O_NAND_CH5_WE -pg 1 -y 2290 -defaultsOSRD
preplace port O_NAND_CH5_RE_P -pg 1 -y 2310 -defaultsOSRD
preplace port O_NAND_CH4_ALE -pg 1 -y 1950 -defaultsOSRD
preplace port O_NAND_CH0_WP -pg 1 -y -700 -defaultsOSRD
preplace port O_NAND_CH0_RE_P -pg 1 -y -780 -defaultsOSRD
preplace port O_NAND_CH1_RE_N -pg 1 -y -410 -defaultsOSRD
preplace port O_NAND_CH5_CLE -pg 1 -y 2370 -defaultsOSRD
preplace port pcie_ref_clk_n -pg 1 -y 1620 -defaultsOSRD -right
preplace port O_NAND_CH4_WP -pg 1 -y 1990 -defaultsOSRD
preplace port O_NAND_CH4_CLE -pg 1 -y 1970 -defaultsOSRD
preplace port O_NAND_CH1_RE_P -pg 1 -y -430 -defaultsOSRD
preplace port O_NAND_CH0_ALE -pg 1 -y -740 -defaultsOSRD
preplace port pcie_ref_clk_p -pg 1 -y 1600 -defaultsOSRD -right
preplace port FIXED_IO -pg 1 -y 790 -defaultsOSRD
preplace port O_NAND_CH5_WP -pg 1 -y 2390 -defaultsOSRD
preplace port O_NAND_CH2_ALE -pg 1 -y -20 -defaultsOSRD
preplace port IO_NAND_CH4_DQS_N -pg 1 -y 1830 -defaultsOSRD
preplace port IO_NAND_CH4_DQS_P -pg 1 -y 1810 -defaultsOSRD
preplace port O_NAND_CH0_CLE -pg 1 -y -720 -defaultsOSRD
preplace port O_NAND_CH6_WE -pg 1 -y 2680 -defaultsOSRD
preplace port O_NAND_CH5_ALE -pg 1 -y 2350 -defaultsOSRD
preplace port O_NAND_CH1_WE -pg 1 -y -450 -defaultsOSRD
preplace port O_NAND_CH3_RE_N -pg 1 -y 240 -defaultsOSRD
preplace port DDR -pg 1 -y 770 -defaultsOSRD
preplace port IO_NAND_CH7_DQS_N -pg 1 -y 3100 -defaultsOSRD
preplace port O_NAND_CH2_CLE -pg 1 -y 0 -defaultsOSRD
preplace port O_NAND_CH3_RE_P -pg 1 -y 220 -defaultsOSRD
preplace port pcie_perst_n -pg 1 -y 1640 -defaultsOSRD -right
preplace port IO_NAND_CH7_DQS_P -pg 1 -y 3080 -defaultsOSRD
preplace port O_NAND_CH3_ALE -pg 1 -y 260 -defaultsOSRD
preplace port IO_NAND_CH3_DQS_N -pg 1 -y 140 -defaultsOSRD
preplace port O_NAND_CH1_CLE -pg 1 -y -370 -defaultsOSRD
preplace port O_NAND_CH3_WE -pg 1 -y 200 -defaultsOSRD
preplace port O_NAND_CH3_CLE -pg 1 -y 280 -defaultsOSRD
preplace port O_NAND_CH6_WP -pg 1 -y 2780 -defaultsOSRD
preplace port O_NAND_CH1_WP -pg 1 -y -350 -defaultsOSRD
preplace port IO_NAND_CH3_DQS_P -pg 1 -y 120 -defaultsOSRD
preplace port O_NAND_CH5_E_N -pg 1 -y 2330 -defaultsOSRD
preplace port O_NAND_CH2_WE -pg 1 -y -80 -defaultsOSRD
preplace port O_NAND_CH7_WE -pg 1 -y 3160 -defaultsOSRD
preplace port O_NAND_CH6_CLE -pg 1 -y 2760 -defaultsOSRD
preplace port IO_NAND_CH0_DQS_N -pg 1 -y -860 -defaultsOSRD
preplace port IO_NAND_CH2_DQS_N -pg 1 -y -140 -defaultsOSRD
preplace port IO_NAND_CH0_DQS_P -pg 1 -y -880 -defaultsOSRD
preplace port O_NAND_CH4_RE_N -pg 1 -y 1930 -defaultsOSRD
preplace port IO_NAND_CH1_DQS_N -pg 1 -y -510 -defaultsOSRD
preplace port IO_NAND_CH2_DQS_P -pg 1 -y -160 -defaultsOSRD
preplace port O_NAND_CH2_RE_N -pg 1 -y -40 -defaultsOSRD
preplace port O_NAND_CH7_RE_N -pg 1 -y 3200 -defaultsOSRD
preplace port O_NAND_CH7_CLE -pg 1 -y 3240 -defaultsOSRD
preplace port IO_NAND_CH6_DQS_N -pg 1 -y 2620 -defaultsOSRD
preplace port O_NAND_CH0_WE -pg 1 -y -800 -defaultsOSRD
preplace port O_NAND_CH4_RE_P -pg 1 -y 1910 -defaultsOSRD
preplace port IO_NAND_CH1_DQS_P -pg 1 -y -530 -defaultsOSRD
preplace port O_NAND_CH6_RE_N -pg 1 -y 2720 -defaultsOSRD
preplace port O_NAND_CH2_RE_P -pg 1 -y -60 -defaultsOSRD
preplace portBus IO_NAND_CH3_DQ -pg 1 -y 160 -defaultsOSRD
preplace portBus O_NAND_CH1_CE -pg 1 -y -470 -defaultsOSRD
preplace portBus pcie_tx_p -pg 1 -y 1470 -defaultsOSRD
preplace portBus I_NAND_CH1_RB -pg 1 -y -290 -defaultsOSRD -right
preplace portBus I_NAND_CH0_RB -pg 1 -y -640 -defaultsOSRD -right
preplace portBus O_NAND_CH7_CE -pg 1 -y 3140 -defaultsOSRD
preplace portBus I_NAND_CH6_RB -pg 1 -y 2840 -defaultsOSRD -right
preplace portBus O_NAND_CH4_CE -pg 1 -y 1870 -defaultsOSRD
preplace portBus IO_NAND_CH4_DQ -pg 1 -y 1850 -defaultsOSRD
preplace portBus I_NAND_CH2_RB -pg 1 -y 70 -defaultsOSRD -right
preplace portBus O_NAND_CH2_CE -pg 1 -y -100 -defaultsOSRD
preplace portBus IO_NAND_CH0_DQ -pg 1 -y -840 -defaultsOSRD
preplace portBus O_NAND_CH6_CE -pg 1 -y 2660 -defaultsOSRD
preplace portBus I_NAND_CH4_RB -pg 1 -y 2050 -defaultsOSRD -right
preplace portBus O_NAND_CH3_CE -pg 1 -y 180 -defaultsOSRD
preplace portBus I_NAND_CH7_RB -pg 1 -y 3320 -defaultsOSRD -right
preplace portBus IO_NAND_CH2_DQ -pg 1 -y -120 -defaultsOSRD
preplace portBus IO_NAND_CH6_DQ -pg 1 -y 2640 -defaultsOSRD
preplace portBus I_NAND_CH3_RB -pg 1 -y 360 -defaultsOSRD -right
preplace portBus O_NAND_CH0_CE -pg 1 -y -820 -defaultsOSRD
preplace portBus O_DEBUG -pg 1 -y -920 -defaultsOSRD
preplace portBus pcie_rx_n -pg 1 -y 1680 -defaultsOSRD -right
preplace portBus IO_NAND_CH7_DQ -pg 1 -y 3120 -defaultsOSRD
preplace portBus I_NAND_CH5_RB -pg 1 -y 2440 -defaultsOSRD -right
preplace portBus O_NAND_CH5_CE -pg 1 -y 2270 -defaultsOSRD
preplace portBus IO_NAND_CH5_DQ -pg 1 -y 2250 -defaultsOSRD
preplace portBus pcie_rx_p -pg 1 -y 1660 -defaultsOSRD -right
preplace portBus IO_NAND_CH1_DQ -pg 1 -y -490 -defaultsOSRD
preplace portBus pcie_tx_n -pg 1 -y 1490 -defaultsOSRD
preplace inst V2NFC100DDR_6 -pg 1 -lvl 5 -y 2690 -defaultsOSRD
preplace inst Tiger4NSC_6 -pg 1 -lvl 3 -y 2470 -defaultsOSRD
preplace inst Dispatcher_uCode_2 -pg 1 -lvl 4 -y 100 -defaultsOSRD
preplace inst PS -pg 1 -lvl 5 -y 860 -defaultsOSRD
preplace inst GPIC1 -pg 1 -lvl 4 -y 1370 -defaultsOSRD
preplace inst V2NFC100DDR_7 -pg 1 -lvl 5 -y 3170 -defaultsOSRD
preplace inst Tiger4NSC_7 -pg 1 -lvl 3 -y 2740 -defaultsOSRD
preplace inst GPIC2 -pg 1 -lvl 2 -y 1640 -defaultsOSRD
preplace inst Dispatcher_uCode_3 -pg 1 -lvl 4 -y 320 -defaultsOSRD
preplace inst CH2MMCMC1H200 -pg 1 -lvl 4 -y -370 -defaultsOSRD
preplace inst Dispatcher_uCode_4 -pg 1 -lvl 4 -y 2280 -defaultsOSRD
preplace inst Dispatcher_uCode_5 -pg 1 -lvl 4 -y 2410 -defaultsOSRD
preplace inst Dispatcher_uCode_6 -pg 1 -lvl 4 -y 2500 -defaultsOSRD
preplace inst Dispatcher_uCode_7 -pg 1 -lvl 4 -y 2590 -defaultsOSRD
preplace inst CH3MMCMC1H200 -pg 1 -lvl 4 -y -30 -defaultsOSRD
preplace inst proc_sys_reset_0 -pg 1 -lvl 1 -y 660 -defaultsOSRD
preplace inst proc_sys_reset_1 -pg 1 -lvl 1 -y 1050 -defaultsOSRD
preplace inst CH6MMCMC1H200 -pg 1 -lvl 4 -y 2840 -defaultsOSRD
preplace inst proc_sys_reset_2 -pg 1 -lvl 3 -y 1350 -defaultsOSRD
preplace inst HPIC3 -pg 1 -lvl 4 -y 1040 -defaultsOSRD
preplace inst V2NFC100DDR_0 -pg 1 -lvl 5 -y -790 -defaultsOSRD
preplace inst Tiger4NSC_0 -pg 1 -lvl 3 -y -370 -defaultsOSRD
preplace inst NVMeHostController_0 -pg 1 -lvl 5 -y 1460 -defaultsOSRD
preplace inst proc_sys_reset_3 -pg 1 -lvl 3 -y 1150 -defaultsOSRD
preplace inst V2NFC100DDR_1 -pg 1 -lvl 5 -y -440 -defaultsOSRD
preplace inst Tiger4NSC_1 -pg 1 -lvl 3 -y -140 -defaultsOSRD
preplace inst Tiger4NSC_2 -pg 1 -lvl 3 -y 100 -defaultsOSRD
preplace inst V2NFC100DDR_2 -pg 1 -lvl 5 -y -70 -defaultsOSRD
preplace inst axi_interconnect_0 -pg 1 -lvl 4 -y 650 -defaultsOSRD
preplace inst Tiger4SharedKES_0 -pg 1 -lvl 4 -y -940 -defaultsOSRD
preplace inst axi_interconnect_1 -pg 1 -lvl 4 -y 2020 -defaultsOSRD
preplace inst Tiger4SharedKES_1 -pg 1 -lvl 4 -y 1660 -defaultsOSRD
preplace inst Tiger4NSC_3 -pg 1 -lvl 3 -y 320 -defaultsOSRD
preplace inst V2NFC100DDR_3 -pg 1 -lvl 5 -y 210 -defaultsOSRD
preplace inst V2NFC100DDR_4 -pg 1 -lvl 5 -y 1900 -defaultsOSRD
preplace inst Tiger4NSC_4 -pg 1 -lvl 3 -y 1880 -defaultsOSRD
preplace inst Dispatcher_uCode_0 -pg 1 -lvl 4 -y -270 -defaultsOSRD
preplace inst CH7MMCMC1H200 -pg 1 -lvl 4 -y 2990 -defaultsOSRD
preplace inst CH4MMCMC1H200 -pg 1 -lvl 4 -y 2710 -defaultsOSRD
preplace inst V2NFC100DDR_5 -pg 1 -lvl 5 -y 2300 -defaultsOSRD
preplace inst Tiger4NSC_5 -pg 1 -lvl 3 -y 2150 -defaultsOSRD
preplace inst CH0MMCMC1H200 -pg 1 -lvl 4 -y -570 -defaultsOSRD
preplace inst GPIC0 -pg 1 -lvl 2 -y 510 -defaultsOSRD
preplace inst Dispatcher_uCode_1 -pg 1 -lvl 4 -y -150 -defaultsOSRD
preplace netloc Tiger4NSC_6_SharedKESInterface 1 3 1 1290
preplace netloc Tiger4NSC_0_uROMInterface 1 3 1 1260
preplace netloc S00_AXI_2 1 3 3 1370 920 NJ 1040 2270
preplace netloc V2NFC100DDR_5_O_NAND_ALE 1 5 1 NJ
preplace netloc pcie_rx_p_1 1 4 2 1780 1660 NJ
preplace netloc V2NFC100DDR_4_O_NAND_ALE 1 5 1 NJ
preplace netloc V2NFC100DDR_4_O_NAND_WE 1 5 1 NJ
preplace netloc PS_M_AXI_GP0 1 1 5 430 860 NJ 860 NJ 860 NJ 680 2270
preplace netloc V2NFC100DDR_7_O_NAND_RE_N 1 5 1 NJ
preplace netloc V2NFC100DDR_3_O_NAND_RE_N 1 5 1 NJ
preplace netloc Tiger4NSC_4_NFCInterface 1 3 2 NJ 1810 NJ
preplace netloc processing_system7_0_FIXED_IO 1 5 1 2290
preplace netloc V2NFC100DDR_7_O_NAND_RE_P 1 5 1 NJ
preplace netloc pcie_perst_n_1 1 4 2 1770 1640 NJ
preplace netloc V2NFC100DDR_3_O_NAND_RE_P 1 5 1 NJ
preplace netloc V2NFC100DDR_5_O_NAND_CLE 1 5 1 NJ
preplace netloc V2NFC100DDR_0_O_NAND_ALE 1 5 1 N
preplace netloc CH6MMCMC1H200_clk_out1 1 4 1 1780
preplace netloc GPIC0_M02_AXI 1 2 1 780
preplace netloc HPIC3_M00_AXI 1 4 1 1680
preplace netloc proc_sys_reset_0_peripheral_reset 1 1 4 NJ 300 750 -270 1230 -760 1770
preplace netloc V2NFC100DDR_6_O_NAND_WE 1 5 1 NJ
preplace netloc proc_sys_reset_2_peripheral_aresetn 1 3 2 1360 1250 NJ
preplace netloc V2NFC100DDR_3_O_NAND_WP 1 5 1 NJ
preplace netloc NVMeHostController_0_dev_irq_assert 1 4 2 1790 1110 2230
preplace netloc Tiger4NSC_2_uROMInterface 1 3 1 N
preplace netloc Net20 1 5 1 NJ
preplace netloc V2NFC100DDR_5_O_NAND_WE 1 5 1 NJ
preplace netloc Tiger4NSC_6_uROMInterface 1 3 1 1140
preplace netloc GPIC2_M00_AXI 1 2 1 780
preplace netloc Tiger4NSC_2_NFCInterface 1 3 2 1220 -100 NJ
preplace netloc processing_system7_0_DDR 1 5 1 2300
preplace netloc Net21 1 5 1 NJ
preplace netloc V2NFC100DDR_4_O_NAND_WP 1 5 1 NJ
preplace netloc CH7MMCMC1H200_clk_out1 1 4 1 1670
preplace netloc PS_FCLK_RESET0_N 1 0 6 10 870 NJ 870 NJ 870 NJ 870 NJ 1060 2250
preplace netloc V2NFC100DDR_3_O_NAND_ALE 1 5 1 NJ
preplace netloc S01_AXI_1 1 3 1 1260
preplace netloc Net22 1 5 1 NJ
preplace netloc V2NFC100DDR_0_O_NAND_CE 1 5 1 N
preplace netloc Net23 1 5 1 NJ
preplace netloc axi_interconnect_1_M00_AXI 1 4 1 1710
preplace netloc Tiger4NSC_7_uROMInterface 1 3 1 1370
preplace netloc V2NFC100DDR_4_O_NAND_CLE 1 5 1 NJ
preplace netloc CH4MMCMC1H200_clk_out1 1 4 1 1730
preplace netloc V2NFC100DDR_0_O_NAND_WE 1 5 1 N
preplace netloc Tiger4NSC_3_NFCInterface 1 3 2 1220 160 NJ
preplace netloc GPIC2_M02_AXI 1 2 1 750
preplace netloc Tiger4NSC_3_SharedKESInterface 1 3 1 1210
preplace netloc proc_sys_reset_1_interconnect_aresetn 1 1 1 370
preplace netloc Tiger4NSC_5_NFCInterface 1 3 2 NJ 2230 NJ
preplace netloc Tiger4NSC_4_SharedKESInterface 1 3 1 1220
preplace netloc Tiger4NSC_5_uROMInterface 1 3 1 1160
preplace netloc Tiger4NSC_3_uROMInterface 1 3 1 N
preplace netloc V2NFC100DDR_0_O_NAND_RE_N 1 5 1 N
preplace netloc Tiger4NSC_6_D_AXI 1 3 1 1300
preplace netloc V2NFC100DDR_2_O_NAND_CE 1 5 1 NJ
preplace netloc PS_FCLK_CLK0 1 0 6 10 570 390 280 800 -280 1280 -820 1760 670 2280
preplace netloc Tiger4NSC_0_SharedKESInterface 1 3 1 1140
preplace netloc PS_FCLK_CLK1 1 0 6 20 1140 NJ 1830 NJ 1770 NJ 1770 NJ 1760 2300
preplace netloc V2NFC100DDR_6_O_NAND_WP 1 5 1 NJ
preplace netloc CH3MMCMC1H200_clk_out1 1 4 1 1680
preplace netloc V2NFC100DDR_0_O_NAND_CLE 1 5 1 N
preplace netloc V2NFC100DDR_0_O_NAND_RE_P 1 5 1 N
preplace netloc GPIC2_M03_AXI 1 2 1 730
preplace netloc Tiger4NSC_2_SharedKESInterface 1 3 1 1190
preplace netloc PS_FCLK_CLK2 1 2 4 800 1260 1350 1240 1780 1090 2290
preplace netloc pcie_ref_clk_n_1 1 4 2 1750 1620 NJ
preplace netloc V2NFC100DDR_2_O_NAND_CLE 1 5 1 NJ
preplace netloc V2NFC100DDR_7_O_NAND_CLE 1 5 1 NJ
preplace netloc V2NFC100DDR_5_O_NAND_WP 1 5 1 NJ
preplace netloc PS_FCLK_CLK3 1 2 4 800 1060 1310 880 1700 1080 2280
preplace netloc Tiger4NSC_2_D_AXI 1 3 1 1250
preplace netloc V2NFC100DDR_2_O_NAND_WE 1 5 1 NJ
preplace netloc V2NFC100DDR_2_O_NAND_ALE 1 5 1 NJ
preplace netloc pcie_rx_n_1 1 4 2 1790 1680 NJ
preplace netloc Tiger4NSC_4_D_AXI 1 3 1 1210
preplace netloc V2NFC100DDR_1_O_NAND_CE 1 5 1 N
preplace netloc NVMeHostController_0_m0_axi 1 3 3 1350 910 NJ 1100 2240
preplace netloc V2NFC100DDR_4_O_NAND_RE_N 1 5 1 NJ
preplace netloc NVMeHostController_0_pcie_tx_n 1 5 1 N
preplace netloc V2NFC100DDR_1_O_NAND_WE 1 5 1 N
preplace netloc PS_FCLK_RESET1_N 1 0 6 10 900 NJ 900 NJ 900 NJ 900 NJ 1050 2240
preplace netloc Net 1 5 1 N
preplace netloc Net10 1 5 1 NJ
preplace netloc V2NFC100DDR_0_O_NAND_WP 1 5 1 N
preplace netloc Tiger4NSC_6_NFCInterface 1 3 2 NJ 2360 NJ
preplace netloc GPIC0_M04_AXI 1 1 2 420 310 730
preplace netloc Tiger4NSC_0_D_AXI 1 3 1 1270
preplace netloc V2NFC100DDR_6_O_NAND_ALE 1 5 1 NJ
preplace netloc V2NFC100DDR_4_O_NAND_RE_P 1 5 1 NJ
preplace netloc Net11 1 5 1 NJ
preplace netloc Net1 1 5 1 N
preplace netloc NVMeHostController_0_pcie_tx_p 1 5 1 N
preplace netloc Tiger4NSC_3_D_AXI 1 3 1 1240
preplace netloc Tiger4NSC_1_NFCInterface 1 3 2 NJ -490 NJ
preplace netloc V2NFC100DDR_7_O_NAND_CE 1 5 1 NJ
preplace netloc V2NFC100DDR_6_O_NAND_CE 1 5 1 NJ
preplace netloc Net12 1 5 1 NJ
preplace netloc Net2 1 5 1 N
preplace netloc PS_FCLK_RESET3_N 1 2 4 790 890 NJ 890 NJ 1070 2230
preplace netloc GPIC2_M01_AXI 1 2 1 770
preplace netloc V2NFC100DDR_7_O_NAND_WE 1 5 1 NJ
preplace netloc Net13 1 5 1 NJ
preplace netloc Net3 1 5 1 N
preplace netloc GPIC0_M01_AXI 1 2 1 760
preplace netloc Net14 1 5 1 NJ
preplace netloc Net4 1 5 1 N
preplace netloc Tiger4NSC_7_NFCInterface 1 3 2 NJ 2770 1700
preplace netloc Tiger4NSC_4_uROMInterface 1 3 1 1180
preplace netloc GPIC0_M03_AXI 1 2 1 790
preplace netloc GPIC0_M00_AXI 1 2 1 740
preplace netloc Net15 1 5 1 NJ
preplace netloc Net5 1 5 1 N
preplace netloc Net16 1 5 1 NJ
preplace netloc Net6 1 5 1 NJ
preplace netloc V2NFC100DDR_2_O_NAND_RE_N 1 5 1 NJ
preplace netloc Tiger4NSC_7_SharedKESInterface 1 3 1 1320
preplace netloc proc_sys_reset_1_peripheral_aresetn 1 1 3 410 1820 NJ 1790 1190
preplace netloc V2NFC100DDR_7_O_NAND_ALE 1 5 1 NJ
preplace netloc V2NFC100DDR_6_O_NAND_CLE 1 5 1 NJ
preplace netloc Net17 1 5 1 NJ
preplace netloc Net7 1 5 1 NJ
preplace netloc Net18 1 5 1 NJ
preplace netloc M00_ARESETN_1 1 1 3 400 710 NJ 710 1370
preplace netloc V2NFC100DDR_2_O_NAND_WP 1 5 1 NJ
preplace netloc Net8 1 5 1 NJ
preplace netloc I_NAND_RB_1 1 4 2 1790 -640 NJ
preplace netloc V2NFC100DDR_2_O_NAND_RE_P 1 5 1 NJ
preplace netloc Tiger4NSC_5_D_AXI 1 3 1 1160
preplace netloc Tiger4NSC_0_NFCInterface 1 3 2 1180 -840 NJ
preplace netloc GPIC1_M00_AXI 1 4 1 N
preplace netloc Net19 1 5 1 NJ
preplace netloc M00_ARESETN_2 1 3 2 1340 1490 NJ
preplace netloc Net9 1 5 1 NJ
preplace netloc I_NAND_RB_2 1 4 2 1790 -290 NJ
preplace netloc Tiger4NSC_5_SharedKESInterface 1 3 1 1140
preplace netloc proc_sys_reset_1_peripheral_reset 1 1 4 NJ 1050 760 2650 1160 2650 NJ
preplace netloc V2NFC100DDR_5_O_NAND_CE 1 5 1 NJ
preplace netloc V2NFC100DDR_1_O_NAND_WP 1 5 1 N
preplace netloc I_NAND_RB_3 1 4 2 NJ 70 NJ
preplace netloc V2NFC100DDR_1_O_NAND_CLE 1 5 1 N
preplace netloc Tiger4NSC_7_D_AXI 1 3 1 1150
preplace netloc Tiger4NSC_1_SharedKESInterface 1 3 1 1160
preplace netloc I_NAND_RB_4 1 4 2 NJ 360 NJ
preplace netloc CH2MMCMC1H200_clk_out1 1 4 1 1780
preplace netloc V2NFC100DDR_5_O_NAND_RE_N 1 5 1 NJ
preplace netloc I_NAND_RB_5 1 4 2 NJ 2050 NJ
preplace netloc V2NFC100DDR_4_O_NAND_CE 1 5 1 NJ
preplace netloc V2NFC100DDR_1_O_NAND_ALE 1 5 1 N
preplace netloc V2NFC100DDR_1_O_NAND_RE_N 1 5 1 N
preplace netloc CH0MMCMC1H200_clk_out1 1 4 1 1780
preplace netloc I_NAND_RB_6 1 4 2 NJ 2440 NJ
preplace netloc ARESETN_1 1 1 1 380
preplace netloc V2NFC100DDR_3_O_NAND_CE 1 5 1 NJ
preplace netloc Tiger4NSC_1_uROMInterface 1 3 1 1220
preplace netloc V2NFC100DDR_7_O_NAND_WP 1 5 1 N
preplace netloc I_NAND_RB_7 1 4 2 NJ 2840 NJ
preplace netloc V2NFC100DDR_6_O_NAND_RE_N 1 5 1 NJ
preplace netloc V2NFC100DDR_5_O_NAND_RE_P 1 5 1 NJ
preplace netloc pcie_ref_clk_p_1 1 4 2 1740 1600 NJ
preplace netloc V2NFC100DDR_1_O_NAND_RE_P 1 5 1 N
preplace netloc ARESETN_2 1 3 1 1330
preplace netloc PS_FCLK_RESET2_N 1 2 4 790 1240 NJ 1210 NJ 1210 2260
preplace netloc I_NAND_RB_8 1 4 2 NJ 3320 NJ
preplace netloc ARESETN_3 1 3 1 1160
preplace netloc axi_interconnect_0_M00_AXI 1 4 1 1680
preplace netloc V2NFC100DDR_6_O_NAND_RE_P 1 5 1 NJ
preplace netloc V2NFC100DDR_3_O_NAND_CLE 1 5 1 NJ
preplace netloc V2NFC100DDR_3_O_NAND_WE 1 5 1 NJ
levelinfo -pg 1 -10 200 580 970 1520 2010 2680 -top -1060 -bot 3360
",
}

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


