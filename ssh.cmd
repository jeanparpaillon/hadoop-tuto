#!/bin/sh
# Demarrage d'un jon 'sleep' pour obtenir une session interactive

# @ job_name = hadoop
# @ output = $(job_name).out
# @ error = $(job_name).err
# @ job_type = mpich
# @ node = 4
# @ class = specialIntel
# @ wall_clock_limit = 04:02:00,04:00:00
# @ environment = COPY_ALL
# @ account_no = F_Ecole13
# @ queue

sleep 4h
