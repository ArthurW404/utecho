CC=gcc
DEPS = utecho.h

.PHONY: clean


utecho: utecho.c udp_echo.c tcp_echo.c $(DEPS)
	$(CC) -o '$@' utecho.c udp_echo.c tcp_echo.c $(DEPS) 


util_socket: util_socket.c 
	$(CC) -o '$@' util_socket.c 

utilisationsocket: utilisationsocket.c utilisation.h 
	$(CC) -o '$@' utilisationsocket.c 

measure_tsc: measure_tsc.c utilisation.h 
	$(CC) -o '$@' measure_tsc.c -lm

clean:
	rm utecho
