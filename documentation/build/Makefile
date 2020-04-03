
FILES = metadata.yaml \
	frontmatter.md \
	mainmatter.md \
	../stochastic_circuit_models.md 

OUTPUT = ../stochastic_circuit_models.pdf

FLAGS = 	-s \
		-f markdown+implicit_figures+link_attributes \
		--filter pandoc-fignos\
		--filter pandoc-tablenos\
		-M xnos-capitalise=true\
		--top-level-division=chapter\
		--toc

FLAGS_PDF = --template=template.latex

all: pdf

pdf:
	pandoc -o $(OUTPUT) $(FLAGS) $(FLAGS_PDF) $(FILES)

clean:
	rm build/*

