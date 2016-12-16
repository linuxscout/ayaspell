#/usr/bin/sh
# Build Ayaspell dictionary files
DATA :=dict/builddict
RELEASES :=releases
TMP :=tests/output
SCRIPT :=tools
VERSION:=3.7.2016-12-16
DOC:="."
TEMPLATE:=templates
default: all
# Clean build files
clean:
	rm -f -r $(RELEASES)/*
backup: 
	mkdir -p $(RELEASES)/backup$(VERSION)
	#~ mv $(RELEASES)/*.zip $(RELEASES)/*.oxi $(RELEASES)/backup$(VERSION)
#create all files 
all: backup build zip libreoffice mozilla
	#copy dic and aff files to zip package
build:
	#build the dictionary from partial dictionary
	cat $(DATA)/stopwords.dic $(DATA)/tools.dic $(DATA)/names.dic > $(TMP)/arb.tmp.dic
	cat $(DATA)/Condidate3.4.dic $(DATA)/verb.huns.dic >> $(TMP)/arb.tmp.dic
	#add lines count
	wc -l $(TMP)/arb.tmp.dic > $(TMP)/arb.dic
	cat $(TMP)/arb.tmp.dic  >> $(TMP)/arb.dic

	# compress dictionary file
	cp $(DATA)/arb.aff $(TMP)/
	$(SCRIPT)/makealias $(TMP)/arb.dic $(TMP)/arb.aff

	#copy results to parent directory
	mv arb_alias.dic $(TEMPLATE)/ar.dic
	mv arb_alias.aff $(TEMPLATE)/ar.aff	

	# delete temp file
	rm $(TMP)/arb.tmp.dic
zip:
	mkdir -p $(TEMPLATE)/zip
	#copy file to zip directory
	cp $(TEMPLATE)/ar.dic $(TEMPLATE)/zip/ar.dic
	cp $(TEMPLATE)/ar.aff $(TEMPLATE)/zip/ar.aff
	#modify version
	echo "$(VERSION)" >  $(TEMPLATE)/zip/VERSION

	#create the zip package
	cd $(TEMPLATE)/zip/ && 	zip -r  hunspell-ar_$(VERSION).zip  *
	mv   $(TEMPLATE)/zip/hunspell-ar_$(VERSION).zip  $(RELEASES)/

mozilla:
	#copy dic and aff files to Mozilla package
	cp $(TEMPLATE)/ar.dic $(TEMPLATE)/mozilla/dictionaries/ar.dic
	cp $(TEMPLATE)/ar.aff $(TEMPLATE)/mozilla/dictionaries/ar.aff
	#modify version
	sed -i "s/<em:version>.*<\/em:version>/<em:version>$(VERSION)<\/em:version>/g" $(TEMPLATE)/mozilla/install.rdf 

	#create the zip package
	cd $(TEMPLATE)/mozilla/ && zip -r arabic_spellchecking_dictionary_$(VERSION).xpi  *
	mv $(TEMPLATE)/mozilla/arabic_spellchecking_dictionary_$(VERSION).xpi  $(RELEASES)/

libreoffice:
	#copy dic and aff files to OpenOffice/LibreOffice package
	cp $(TEMPLATE)/ar.dic $(TEMPLATE)/openoffice/ar.dic
	cp $(TEMPLATE)/ar.aff $(TEMPLATE)/openoffice/ar.aff
	#modify version
	sed -i "s/<version value=\".*\"\/>/<version value=\"$(VERSION)\"\/>/g" $(TEMPLATE)/openoffice/description.xml 

	#create the zip package
	cd $(TEMPLATE)/openoffice && zip  -r dict_ar-$(VERSION).oxt *
	mv $(TEMPLATE)/openoffice/dict_ar-$(VERSION).oxt   $(RELEASES)/


