#!/bin/sh
# Demarrage d'un jon 'sleep' pour obtenir une session interactive

# @ job_name = hadoop
# @ output = $(job_name).out
# @ error = $(job_name).err
# @ job_type = mpich
# @ node = 6
# @ class = specialIntel
# @ wall_clock_limit = 60:02:00,60:00:00
# @ environment = COPY_ALL
# @ account_no = F_Ecole13
# @ queue
# @ node_usage = not_shared

sleep 60h
