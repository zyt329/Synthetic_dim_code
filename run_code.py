import os
import paramiko

os.system('ssh -f zyt329@kendall.physics.ucdavis.edu "cd /nfs/home/zyt329/Research/Synthetic_dim_code/Remote_result;nohup nice /nfs/software/julia/julia-1.2.0/bin/julia /nfs/home/zyt329/Research/Synthetic_dim_code/L6_Q8_shullMax_def_driver.jl&"')
