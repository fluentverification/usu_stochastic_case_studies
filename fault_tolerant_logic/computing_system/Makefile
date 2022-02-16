OCTAVECMD := $(strip $(shell which octave))

all: pfail t0 simpath analyze

.PHONY: pfail t0 simpath analyze

pfail: 
	@prism computing_system.pm pfail.prop > pfail.out
	@printf "Failure Probability "
	@grep "esult" pfail.out

t0:
	@prism computing_system.pm t0.prop > t0.out
	@printf "Mean Return Time "
	@grep "esult" t0.out

simpath: 
	@prism -simpath 10000 path.dat computing_system.pm > simpath.out
	@printf "Stochastic Simulation "
	@grep "Generated " simpath.out

analyze:
ifeq  (${OCTAVECMD},)
	printf "Octave not found\n"
else
	@printf "\n===========================================\n"
	@printf "Path Statistics from Stochastic Simulation\n===========================================\n"
	@octave --no-gui --silent analyze_simpath.m
endif
