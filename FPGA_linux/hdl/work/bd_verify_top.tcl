
################################################################
# This is a generated script based on design: verify_top
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
set scripts_vivado_version 2022.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source verify_top_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# top

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcvu9p-flga2104-2L-e
   set_property BOARD_PART xilinx.com:vcu118:part0:2.4 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name verify_top

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
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

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

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:axi_vip:1.1\
xilinx.com:ip:util_vector_logic:2.0\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
top\
"

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set main_clk [ create_bd_port -dir I -type clk -freq_hz 250000000 main_clk ]
  set main_rst [ create_bd_port -dir I -type rst main_rst ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $main_rst
  set sa_clk [ create_bd_port -dir I -type clk -freq_hz 398437500 sa_clk ]

#*********************************************************
# cyz changed begin
# We should create the AXI-VIP IPs with the same order as they were created in the GUI
# to make the CONFIG.Component_Name correct.
#*********************************************************

#   # Create instance: ddr, and set properties
#   set ddr [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 ddr ]
#   set_property -dict [ list \
#    CONFIG.DATA_WIDTH {512} \
#    CONFIG.INTERFACE_MODE {SLAVE} \
#  ] $ddr

#   # Create instance: sr_cr, and set properties
#   set sr_cr [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 sr_cr ]
#   set_property -dict [ list \
#    CONFIG.ADDR_WIDTH {32} \
#    CONFIG.ARUSER_WIDTH {0} \
#    CONFIG.AWUSER_WIDTH {0} \
#    CONFIG.BUSER_WIDTH {0} \
#    CONFIG.DATA_WIDTH {32} \
#    CONFIG.HAS_BRESP {1} \
#    CONFIG.HAS_BURST {0} \
#    CONFIG.HAS_CACHE {0} \
#    CONFIG.HAS_LOCK {0} \
#    CONFIG.HAS_PROT {1} \
#    CONFIG.HAS_QOS {0} \
#    CONFIG.HAS_REGION {0} \
#    CONFIG.HAS_RRESP {1} \
#    CONFIG.HAS_WSTRB {1} \
#    CONFIG.ID_WIDTH {0} \
#    CONFIG.INTERFACE_MODE {MASTER} \
#    CONFIG.PROTOCOL {AXI4LITE} \
#    CONFIG.READ_WRITE_MODE {READ_WRITE} \
#    CONFIG.RUSER_BITS_PER_BYTE {0} \
#    CONFIG.RUSER_WIDTH {0} \
#    CONFIG.SUPPORTS_NARROW {0} \
#    CONFIG.WUSER_BITS_PER_BYTE {0} \
#    CONFIG.WUSER_WIDTH {0} \
#  ] $sr_cr

  # Create instance: sr_cr, and set properties
  set sr_cr [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_0 ]
  set_property name sr_cr $sr_cr
  puts "----------------------------------------------"
  puts [get_property CONFIG.Component_Name $sr_cr]
  puts "----------------------------------------------"
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.INTERFACE_MODE {MASTER} \
   CONFIG.PROTOCOL {AXI4LITE} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW {0} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
 ] $sr_cr

  # Create instance: ddr, and set properties
  set ddr [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_0]
  set_property name ddr $ddr
  puts "----------------------------------------------"
  puts [get_property CONFIG.Component_Name $ddr]
  puts "----------------------------------------------"
  # cyz changed end
  set_property -dict [ list \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.INTERFACE_MODE {SLAVE} \
 ] $ddr

#*********************************************************
# cyz changed end
#*********************************************************

  # Create instance: top, and set properties
  set block_name top
  set block_cell_name top
  if { [catch {set top [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $top eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_0

  # Create interface connections
  connect_bd_intf_net -intf_net sr_cr_M_AXI [get_bd_intf_pins sr_cr/M_AXI] [get_bd_intf_pins top/sr_cr_S_AXI]
  connect_bd_intf_net -intf_net top_dma_m_axi [get_bd_intf_pins ddr/S_AXI] [get_bd_intf_pins top/dma_m_axi]

  # Create port connections
  connect_bd_net -net main_clk_0_1 [get_bd_ports main_clk] [get_bd_pins ddr/aclk] [get_bd_pins sr_cr/aclk] [get_bd_pins top/main_clk]
  connect_bd_net -net main_rst_0_1 [get_bd_ports main_rst] [get_bd_pins top/main_rst] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net sa_clk_0_1 [get_bd_ports sa_clk] [get_bd_pins top/sa_clk]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins ddr/aresetn] [get_bd_pins sr_cr/aresetn] [get_bd_pins util_vector_logic_0/Res]

  # Create address segments
  assign_bd_address -offset 0x00000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces sr_cr/Master_AXI] [get_bd_addr_segs top/sr_cr_S_AXI/reg0] -force
  assign_bd_address -offset 0x80000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces top/dma_m_axi] [get_bd_addr_segs ddr/S_AXI/Reg] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


common::send_gid_msg -ssname BD::TCL -id 2053 -severity "WARNING" "This Tcl script was generated from a block design that has not been validated. It is possible that design <$design_name> may result in errors during validation."

