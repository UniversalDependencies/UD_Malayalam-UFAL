SHELL=/bin/bash
MLPATH=/net/work/people/zeman/ml
UDMLPATH=/net/work/people/zeman/unidep/UD_Malayalam-UFAL
EDITORDATAPATH=/net/work/projects/conllu/UD_Malayalam-UFAL
UDPIPE=/home/zeman/nastroje/udpipe/udpipe-1.2.0-bin/bin-linux64/udpipe
UDAPI=/home/zeman/nastroje/udapi-python/bin/udapy
MODEL=$(UDMLPATH)/not-to-release/ml-2023-01-27.udpipe12
CONLLUCUT=/net/work/people/zeman/unidep/tools/conllu_cut.pl
NORMALIZE=$(UDMLPATH)/not-to-release/normalize_chillu.pl
TRANSLIT=/home/zeman/projekty/translit/conllu_translit.pl --lang ml -s
WCC=/home/zeman/tools/wc_conll.pl
VALIDATE=/net/work/people/zeman/unidep/tools/validate.py
# IndicCorp contains over 50M sentences. Parsing them all on a single CPU could take a week.
# We need only the initial batch of sentences preprocessed for manual annotation. How many?
# (In any case we must include the initial sentences that we already annotated in the past.
# That way the sentence numbers (ids) will stay consistent.)
NSENT=10000
# After $(NSENT) initial sentences are parsed, which portion exactly do we want to add to
# the data to be manually annotated?
FIRST=201
LAST=400

udpipe:
	zcat $(MLPATH)/ml.txt.gz | head -$(NSENT) > $(MLPATH)/mlpart.txt
	cat $(MLPATH)/mlpart.txt |\
	    $(UDPIPE) --tokenize --tag --parse --tokenizer=presegmented $(MODEL) |\
	    perl -pe 's/\# sent_id = (\d+)/\# sent_id = indiccorp$$1/' |\
	    $(UDAPI) -s util.Eval node='node.misc["SpacesAfter"] = ""' \
	    > $(MLPATH)/mlpart.conllu
	$(WCC) $(MLPATH)/mlpart.conllu

cut:
	$(CONLLUCUT) --first indiccorp$(FIRST) --last indiccorp$(LAST) < $(MLPATH)/mlpart.conllu | $(TRANSLIT) > $(MLPATH)/new_portion.conllu
	$(WCC) $(MLPATH)/new_portion.conllu

# We can use Google Translate of HTML pages to obtain text_en for each sentence.
# First, generate a HTML page where each sentence will be a list item, so sentence boundaries are preserved.
for_translate:
	echo '<html><head><title>Malayalam</title></head><body><ul>' > $(MLPATH)/new_portion.html
	cat $(MLPATH)/new_portion.conllu | grep -P '^\# text =' | perl -CDS -pe 'chomp; s/^\#\s*text\s*=\s*(.+)/  <li>\1<\/li>\n/;' >> $(MLPATH)/new_portion.html
	echo '</ul></body></html>' >> $(MLPATH)/new_portion.html
	###!!! We could also use udapy write.SentencesHtml!
# Now open this page in Google Chrome and use its "Translate to English" function.
# When the English translation is displayed, press CTRL+A and CTRL+C, then go to a text editor, press CTRL+V and save new_portion_en.txt.
# Subsequently, import the translated sentences into the CoNLL-U file.
add_translation:
	$(UDAPI) -s ud.SetTranslation file=$(MLPATH)/new_portion_en.txt < $(MLPATH)/new_portion.conllu > $(MLPATH)/new_portion_with_en.conllu

add_to_repo:
	cp $(UDMLPATH)/ml_ufal-ud-test.conllu $(MLPATH)
	cat $(MLPATH)/ml_ufal-ud-test.conllu $(MLPATH)/new_portion_with_en.conllu > $(UDMLPATH)/ml_ufal-ud-test.conllu
	$(WCC) $(UDMLPATH)/ml_ufal-ud-test.conllu

# Better turn the editor off (ssh 10.10.24.50) before giving it updated data, then turn it on again.
# There are also the scripts $(UDMLPATH)/not-to-release/fetch-from-conllueditor.sh, send-to-conllueditor.sh.
to_editor:
	cp $(UDMLPATH)/ml_ufal-ud-test.conllu $(EDITORDATAPATH)

from_editor:
	cp $(EDITORDATAPATH)/ml_ufal-ud-test.conllu $(UDMLPATH)

validate:
	$(VALIDATE) --lang ml $(UDMLPATH)/ml_ufal-ud-test.conllu
	cat $(UDMLPATH)/ml_ufal-ud-test.conllu | $(UDAPI) -HAMX layout=compact ud.ml.MarkFeatsBugs > $(UDMLPATH)/bugs.html

train:
	$(UDPIPE) --train $(MODEL) $(UDMLPATH)/ml_ufal-ud-test.conllu

# Unicode normalization plus the chillu consonants. This needs to be done only once in the
# beginning, with the entire IndicCorp, before UDPipe is fed with it.
normalize:
	zcat ml.txt.gz | $(NORMALIZE) | gzip -c > normalized.txt.gz
	# mv normalized.txt.gz ml.txt.gz

