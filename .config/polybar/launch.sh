#!/bin/bash

killall -q polybar
polybar workspaces &
polybar info &
polybar date_time &
polybar sound_monitor &
polybar modules &
