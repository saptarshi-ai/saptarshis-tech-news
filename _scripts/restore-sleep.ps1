# Runs daily at 06:00. Re-enables idle sleep (10 min) so the PC
# goes back to sleep on its own if nobody's using it.
powercfg /change standby-timeout-ac 10
