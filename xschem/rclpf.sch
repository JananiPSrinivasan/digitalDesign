v {xschem version=3.4.6 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 150 20 190 20 {lab=VOUT}
N 190 20 190 30 {lab=VOUT}
N 50 80 50 100 {lab=GND}
N 190 90 190 100 {lab=GND}
N 50 20 90 20 {lab=VIN}
C {res.sym} 120 20 1 1 {name=R1
value=1k
footprint=1206
device=resistor
m=1}
C {capa.sym} 190 60 0 0 {name=C1
m=1
value=1p
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 50 100 0 0 {name=l1 lab=GND}
C {gnd.sym} 190 100 0 0 {name=l2 lab=GND}
C {simulator_commands_shown.sym} 290 60 0 0 {name=COMMANDS
simulator=ngspice
only_toplevel=false 
value="
.tran 100p 10n
.save all

"}
C {lab_wire.sym} 80 20 3 1 {name=p1 sig_type=std_logic lab=VIN
}
C {lab_wire.sym} 170 20 1 0 {name=p2 sig_type=std_logic lab=VOUT}
C {vsource.sym} 50 50 0 0 {name=V1 value="PULSE(0 1 0.5NS 100p 100p 1NS 2NS 5)"}
