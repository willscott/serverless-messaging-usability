title = paper
latex  = pdflatex
papers = $(title).tex

all: pdf

remote : $(paper)
	$(eval TMPDIR := $(shell mktemp -d remote_XXXX))
	$(eval DIRNAME := $(basename $(TMPDIR)))
	scp -r . $(REMOTEHOST):$(DIRNAME)
	-ssh $(REMOTEHOST) 'cd $(DIRNAME) && make pdf'
	scp $(REMOTEHOST):$(DIRNAME)/*.pdf ./
	ssh $(REMOTEHOST) 'rm -r $(DIRNAME)'
	rm -rf $(TMPDIR)
	

pdf : $(papers)
	$(latex) $(papers)
	bibtex $(title)
	$(latex) $(papers)
	$(latex) $(papers)

once:
	$(latex) $(papers)

clean:
	rm -rf $(title).bbl $(title).aux $(title).pdf $(title).blg $(title).log
