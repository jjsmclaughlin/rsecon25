
venv-make:
	# https://docs.python.org/3/library/venv.html
	# https://spacy.io/usage
	# python3 -m venv .venv
	# source .venv/bin/activate
	# pip install -U lxml
	# pip install -U tqdm
	## pip install -U pip setuptools wheel
	# pip install -U spacy
	## python -m spacy download en_core_web_sm
	# pip install -U spacy-transformers
	# pip install -U cupy-cuda12x
	# pip install spacy-llm
	# pip install accelerate
	#### pip install protobuf
	#### pip install sentencepiece

venv-activate:
	# source .venv/bin/activate

venv-deactivate:
	# deactivate

git-add-dryrun:
	git add . --dry-run --verbose

obp_to_prodigy:
	# source .venv/bin/activate
	# python obp_to_prodigy.py

prodigy_to_docbin:
	# source .venv/bin/activate
	# training 70%, validation 20%, test 10%
	# dev is what spacy calls validation sets
	#
	# dvv: Defendant victim verdict testing
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dvv_train.spacy -s0 -e3270 --ents=DEFENDANT,VICTIM,GUILTY,NOTGUILTY --maxlen=1000
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dvv_train_md.spacy -s0 -e3270 --ents=DEFENDANT,VICTIM,GUILTY,NOTGUILTY --maxlen=10000
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dvv_train_lg.spacy -s0 -e3270 --ents=DEFENDANT,VICTIM,GUILTY,NOTGUILTY
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dvv_dev.spacy -s3271 -e4205 --ents=DEFENDANT,VICTIM,GUILTY,NOTGUILTY --maxlen=1000
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dvv_dev_md.spacy -s3271 -e4205 --ents=DEFENDANT,VICTIM,GUILTY,NOTGUILTY --maxlen=10000
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dvv_dev_lg.spacy -s3271 -e4205 --ents=DEFENDANT,VICTIM,GUILTY,NOTGUILTY
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dvv_test.spacy -s4206 --ents=DEFENDANT,VICTIM,GUILTY,NOTGUILTY --maxlen=1000
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dvv_test_lg.spacy -s4206 --ents=DEFENDANT,VICTIM,GUILTY,NOTGUILTY
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dvv_test_xl.spacy -s4206 --ents=DEFENDANT,VICTIM,GUILTY,NOTGUILTY --minlen=1000
	#
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dvs_train.spacy -s0 -e3270 --spans=DEFENDANT,VICTIM,GUILTY,NOTGUILTY --maxlen=1000
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dvs_dev.spacy -s3271 -e4205 --spans=DEFENDANT,VICTIM,GUILTY,NOTGUILTY --maxlen=1000
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dvs_test.spacy -s4206 --spans=DEFENDANT,VICTIM,GUILTY,NOTGUILTY --maxlen=1000
	#
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dvv_tiny_train.spacy -s0 -e800 --ents=DEFENDANT,VICTIM,GUILTY,NOTGUILTY --maxlen=150
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dvv_tiny_dev.spacy -s801 -e1000 --ents=DEFENDANT,VICTIM,GUILTY,NOTGUILTY --maxlen=150
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dvv_tiny_test.spacy -s1001 -e1100 --ents=DEFENDANT,VICTIM,GUILTY,NOTGUILTY --maxlen=150
	#
	# cri: Crime ner testing
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/cri_mini_train.spacy -s0 -e350 --ents=GRANDLARCENY,THEFT,THEFTFROMPLACE,HIGHWAYROBBERY,SHOPLIFTING --maxlen=300
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/cri_mini_dev.spacy -s351 -e451 --ents=GRANDLARCENY,THEFT,THEFTFROMPLACE,HIGHWAYROBBERY,SHOPLIFTING --maxlen=300
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/cri_mini_test.spacy -s452 -e501 --ents=GRANDLARCENY,THEFT,THEFTFROMPLACE,HIGHWAYROBBERY,SHOPLIFTING --maxlen=300
	#
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/cri_train.spacy -s0 -e3270 --ents=GRANDLARCENY,THEFT,THEFTFROMPLACE,HIGHWAYROBBERY,SHOPLIFTING,POCKETPICKING,BURGLARY,RECEIVING,ANIMALTHEFT,ROBBERY,HOUSEBREAKING,BIGAMY,PERJURY,FORGERY,RAPE,PETTYLARCENY,FRAUD,COININGOFFENCES,INFANTICIDE,EXTORTION,PERVERTINGJUSTICE,MURDER --maxlen=1000
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/cri_train_md.spacy -s0 -e3270 --ents=GRANDLARCENY,THEFT,THEFTFROMPLACE,HIGHWAYROBBERY,SHOPLIFTING,POCKETPICKING,BURGLARY,RECEIVING,ANIMALTHEFT,ROBBERY,HOUSEBREAKING,BIGAMY,PERJURY,FORGERY,RAPE,PETTYLARCENY,FRAUD,COININGOFFENCES,INFANTICIDE,EXTORTION,PERVERTINGJUSTICE,MURDER --maxlen=10000
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/cri_train_lg.spacy -s0 -e3270 --ents=GRANDLARCENY,THEFT,THEFTFROMPLACE,HIGHWAYROBBERY,SHOPLIFTING,POCKETPICKING,BURGLARY,RECEIVING,ANIMALTHEFT,ROBBERY,HOUSEBREAKING,BIGAMY,PERJURY,FORGERY,RAPE,PETTYLARCENY,FRAUD,COININGOFFENCES,INFANTICIDE,EXTORTION,PERVERTINGJUSTICE,MURDER
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/cri_dev.spacy -s3271 -e4205 --ents=GRANDLARCENY,THEFT,THEFTFROMPLACE,HIGHWAYROBBERY,SHOPLIFTING,POCKETPICKING,BURGLARY,RECEIVING,ANIMALTHEFT,ROBBERY,HOUSEBREAKING,BIGAMY,PERJURY,FORGERY,RAPE,PETTYLARCENY,FRAUD,COININGOFFENCES,INFANTICIDE,EXTORTION,PERVERTINGJUSTICE,MURDER --maxlen=1000
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/cri_dev_md.spacy -s3271 -e4205 --ents=GRANDLARCENY,THEFT,THEFTFROMPLACE,HIGHWAYROBBERY,SHOPLIFTING,POCKETPICKING,BURGLARY,RECEIVING,ANIMALTHEFT,ROBBERY,HOUSEBREAKING,BIGAMY,PERJURY,FORGERY,RAPE,PETTYLARCENY,FRAUD,COININGOFFENCES,INFANTICIDE,EXTORTION,PERVERTINGJUSTICE,MURDER --maxlen=10000
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/cri_dev_lg.spacy -s3271 -e4205 --ents=GRANDLARCENY,THEFT,THEFTFROMPLACE,HIGHWAYROBBERY,SHOPLIFTING,POCKETPICKING,BURGLARY,RECEIVING,ANIMALTHEFT,ROBBERY,HOUSEBREAKING,BIGAMY,PERJURY,FORGERY,RAPE,PETTYLARCENY,FRAUD,COININGOFFENCES,INFANTICIDE,EXTORTION,PERVERTINGJUSTICE,MURDER
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/cri_test.spacy -s4206 --ents=GRANDLARCENY,THEFT,THEFTFROMPLACE,HIGHWAYROBBERY,SHOPLIFTING,POCKETPICKING,BURGLARY,RECEIVING,ANIMALTHEFT,ROBBERY,HOUSEBREAKING,BIGAMY,PERJURY,FORGERY,RAPE,PETTYLARCENY,FRAUD,COININGOFFENCES,INFANTICIDE,EXTORTION,PERVERTINGJUSTICE,MURDER --maxlen=1000
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/cri_test_lg.spacy -s4206 --ents=GRANDLARCENY,THEFT,THEFTFROMPLACE,HIGHWAYROBBERY,SHOPLIFTING,POCKETPICKING,BURGLARY,RECEIVING,ANIMALTHEFT,ROBBERY,HOUSEBREAKING,BIGAMY,PERJURY,FORGERY,RAPE,PETTYLARCENY,FRAUD,COININGOFFENCES,INFANTICIDE,EXTORTION,PERVERTINGJUSTICE,MURDER
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/cri_test_xl.spacy -s4206 --ents=GRANDLARCENY,THEFT,THEFTFROMPLACE,HIGHWAYROBBERY,SHOPLIFTING,POCKETPICKING,BURGLARY,RECEIVING,ANIMALTHEFT,ROBBERY,HOUSEBREAKING,BIGAMY,PERJURY,FORGERY,RAPE,PETTYLARCENY,FRAUD,COININGOFFENCES,INFANTICIDE,EXTORTION,PERVERTINGJUSTICE,MURDER --minlen=1000
	#
	# crs: Crime span testing
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/crs_mini_train.spacy -s0 -e350 --spans=GRANDLARCENY,THEFT,THEFTFROMPLACE,HIGHWAYROBBERY,SHOPLIFTING --maxlen=300
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/crs_mini_dev.spacy -s351 -e451 --spans=GRANDLARCENY,THEFT,THEFTFROMPLACE,HIGHWAYROBBERY,SHOPLIFTING --maxlen=300
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/crs_mini_test.spacy -s452 -e501 --spans=GRANDLARCENY,THEFT,THEFTFROMPLACE,HIGHWAYROBBERY,SHOPLIFTING --maxlen=300
	#
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/crs_train.spacy -s0 -e3270 --spans=GRANDLARCENY,THEFT,THEFTFROMPLACE,HIGHWAYROBBERY,SHOPLIFTING,POCKETPICKING,BURGLARY,RECEIVING,ANIMALTHEFT,ROBBERY,HOUSEBREAKING,BIGAMY,PERJURY,FORGERY,RAPE,PETTYLARCENY,FRAUD,COININGOFFENCES,INFANTICIDE,EXTORTION,PERVERTINGJUSTICE,MURDER --maxlen=1000
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/crs_dev.spacy -s3271 -e4205 --spans=GRANDLARCENY,THEFT,THEFTFROMPLACE,HIGHWAYROBBERY,SHOPLIFTING,POCKETPICKING,BURGLARY,RECEIVING,ANIMALTHEFT,ROBBERY,HOUSEBREAKING,BIGAMY,PERJURY,FORGERY,RAPE,PETTYLARCENY,FRAUD,COININGOFFENCES,INFANTICIDE,EXTORTION,PERVERTINGJUSTICE,MURDER --maxlen=1000
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/crs_test.spacy -s4206 --spans=GRANDLARCENY,THEFT,THEFTFROMPLACE,HIGHWAYROBBERY,SHOPLIFTING,POCKETPICKING,BURGLARY,RECEIVING,ANIMALTHEFT,ROBBERY,HOUSEBREAKING,BIGAMY,PERJURY,FORGERY,RAPE,PETTYLARCENY,FRAUD,COININGOFFENCES,INFANTICIDE,EXTORTION,PERVERTINGJUSTICE,MURDER --maxlen=1000
	#
	# dcr: Defendant crime relationship testing
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dcr_train.spacy -s0 -e3270 --ents=DEFENDANT,GRANDLARCENY:OFF,THEFT:OFF,THEFTFROMPLACE:OFF,HIGHWAYROBBERY:OFF,SHOPLIFTING:OFF,POCKETPICKING:OFF,BURGLARY:OFF,RECEIVING:OFF,ANIMALTHEFT:OFF,ROBBERY:OFF,HOUSEBREAKING:OFF,BIGAMY:OFF,PERJURY:OFF,FORGERY:OFF,RAPE:OFF,PETTYLARCENY:OFF,FRAUD:OFF,COININGOFFENCES:OFF,INFANTICIDE:OFF,EXTORTION:OFF,PERVERTINGJUSTICE:OFF,MURDER:OFF --rels=DEFOFF --relmaxtok=64 --maxlen=1000
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dcr_train_md.spacy -s0 -e3270 --ents=DEFENDANT,GRANDLARCENY:OFF,THEFT:OFF,THEFTFROMPLACE:OFF,HIGHWAYROBBERY:OFF,SHOPLIFTING:OFF,POCKETPICKING:OFF,BURGLARY:OFF,RECEIVING:OFF,ANIMALTHEFT:OFF,ROBBERY:OFF,HOUSEBREAKING:OFF,BIGAMY:OFF,PERJURY:OFF,FORGERY:OFF,RAPE:OFF,PETTYLARCENY:OFF,FRAUD:OFF,COININGOFFENCES:OFF,INFANTICIDE:OFF,EXTORTION:OFF,PERVERTINGJUSTICE:OFF,MURDER:OFF --rels=DEFOFF --relmaxtok=100 --maxlen=2000
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dcr_train_lg.spacy -s0 -e3270 --ents=DEFENDANT,GRANDLARCENY:OFF,THEFT:OFF,THEFTFROMPLACE:OFF,HIGHWAYROBBERY:OFF,SHOPLIFTING:OFF,POCKETPICKING:OFF,BURGLARY:OFF,RECEIVING:OFF,ANIMALTHEFT:OFF,ROBBERY:OFF,HOUSEBREAKING:OFF,BIGAMY:OFF,PERJURY:OFF,FORGERY:OFF,RAPE:OFF,PETTYLARCENY:OFF,FRAUD:OFF,COININGOFFENCES:OFF,INFANTICIDE:OFF,EXTORTION:OFF,PERVERTINGJUSTICE:OFF,MURDER:OFF --rels=DEFOFF --relmaxtok=100
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dcr_train_mu.spacy -s0 -e3270 --ents=DEFENDANT,GRANDLARCENY:OFF,THEFT:OFF,THEFTFROMPLACE:OFF,HIGHWAYROBBERY:OFF,SHOPLIFTING:OFF,POCKETPICKING:OFF,BURGLARY:OFF,RECEIVING:OFF,ANIMALTHEFT:OFF,ROBBERY:OFF,HOUSEBREAKING:OFF,BIGAMY:OFF,PERJURY:OFF,FORGERY:OFF,RAPE:OFF,PETTYLARCENY:OFF,FRAUD:OFF,COININGOFFENCES:OFF,INFANTICIDE:OFF,EXTORTION:OFF,PERVERTINGJUSTICE:OFF,MURDER:OFF --rels=DEFOFF --relmaxtok=100 --maxlen=2000 --minents=OFF:2
	# python prodigy_to_docbin.py jsonl/obpxl.jsonl --outfile=docbins/dcr_train_mx.spacy -s0 -e19646 --ents=DEFENDANT,GRANDLARCENY:OFF,THEFT:OFF,THEFTFROMPLACE:OFF,HIGHWAYROBBERY:OFF,SHOPLIFTING:OFF,POCKETPICKING:OFF,BURGLARY:OFF,RECEIVING:OFF,ANIMALTHEFT:OFF,ROBBERY:OFF,HOUSEBREAKING:OFF,BIGAMY:OFF,PERJURY:OFF,FORGERY:OFF,RAPE:OFF,PETTYLARCENY:OFF,FRAUD:OFF,COININGOFFENCES:OFF,INFANTICIDE:OFF,EXTORTION:OFF,PERVERTINGJUSTICE:OFF,MURDER:OFF --rels=DEFOFF --relmaxtok=100 --maxlen=2000 --minents=OFF:2,DEFENDANT:2
	# python prodigy_to_docbin.py jsonl/obpxl.jsonl --outfile=docbins/dcr_train_mn.spacy -s0 -e19646 --ents=DEFENDANT,GRANDLARCENY:OFF,THEFT:OFF,THEFTFROMPLACE:OFF,HIGHWAYROBBERY:OFF,SHOPLIFTING:OFF,POCKETPICKING:OFF,BURGLARY:OFF,RECEIVING:OFF,ANIMALTHEFT:OFF,ROBBERY:OFF,HOUSEBREAKING:OFF,BIGAMY:OFF,PERJURY:OFF,FORGERY:OFF,RAPE:OFF,PETTYLARCENY:OFF,FRAUD:OFF,COININGOFFENCES:OFF,INFANTICIDE:OFF,EXTORTION:OFF,PERVERTINGJUSTICE:OFF,MURDER:OFF --rels=DEFOFF,NO_REL --relmaxtok=100 --maxlen=2000 --minents=OFF:2,DEFENDANT:2 --relnegations=DEFENDANT:OFF:DEFOFF:NO_REL
	#
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dcr_dev.spacy -s3271 -e4205 --ents=DEFENDANT,GRANDLARCENY:OFF,THEFT:OFF,THEFTFROMPLACE:OFF,HIGHWAYROBBERY:OFF,SHOPLIFTING:OFF,POCKETPICKING:OFF,BURGLARY:OFF,RECEIVING:OFF,ANIMALTHEFT:OFF,ROBBERY:OFF,HOUSEBREAKING:OFF,BIGAMY:OFF,PERJURY:OFF,FORGERY:OFF,RAPE:OFF,PETTYLARCENY:OFF,FRAUD:OFF,COININGOFFENCES:OFF,INFANTICIDE:OFF,EXTORTION:OFF,PERVERTINGJUSTICE:OFF,MURDER:OFF --rels=DEFOFF --relmaxtok=64 --maxlen=1000
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dcr_dev_md.spacy -s3271 -e4205 --ents=DEFENDANT,GRANDLARCENY:OFF,THEFT:OFF,THEFTFROMPLACE:OFF,HIGHWAYROBBERY:OFF,SHOPLIFTING:OFF,POCKETPICKING:OFF,BURGLARY:OFF,RECEIVING:OFF,ANIMALTHEFT:OFF,ROBBERY:OFF,HOUSEBREAKING:OFF,BIGAMY:OFF,PERJURY:OFF,FORGERY:OFF,RAPE:OFF,PETTYLARCENY:OFF,FRAUD:OFF,COININGOFFENCES:OFF,INFANTICIDE:OFF,EXTORTION:OFF,PERVERTINGJUSTICE:OFF,MURDER:OFF --rels=DEFOFF --relmaxtok=100 --maxlen=2000
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dcr_dev_lg.spacy -s3271 -e4205 --ents=DEFENDANT,GRANDLARCENY:OFF,THEFT:OFF,THEFTFROMPLACE:OFF,HIGHWAYROBBERY:OFF,SHOPLIFTING:OFF,POCKETPICKING:OFF,BURGLARY:OFF,RECEIVING:OFF,ANIMALTHEFT:OFF,ROBBERY:OFF,HOUSEBREAKING:OFF,BIGAMY:OFF,PERJURY:OFF,FORGERY:OFF,RAPE:OFF,PETTYLARCENY:OFF,FRAUD:OFF,COININGOFFENCES:OFF,INFANTICIDE:OFF,EXTORTION:OFF,PERVERTINGJUSTICE:OFF,MURDER:OFF --rels=DEFOFF --relmaxtok=100
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dcr_dev_mu.spacy -s3271 -e4205 --ents=DEFENDANT,GRANDLARCENY:OFF,THEFT:OFF,THEFTFROMPLACE:OFF,HIGHWAYROBBERY:OFF,SHOPLIFTING:OFF,POCKETPICKING:OFF,BURGLARY:OFF,RECEIVING:OFF,ANIMALTHEFT:OFF,ROBBERY:OFF,HOUSEBREAKING:OFF,BIGAMY:OFF,PERJURY:OFF,FORGERY:OFF,RAPE:OFF,PETTYLARCENY:OFF,FRAUD:OFF,COININGOFFENCES:OFF,INFANTICIDE:OFF,EXTORTION:OFF,PERVERTINGJUSTICE:OFF,MURDER:OFF --rels=DEFOFF --relmaxtok=100 --maxlen=2000 --minents=OFF:2
	# python prodigy_to_docbin.py jsonl/obpxl.jsonl --outfile=docbins/dcr_dev_mx.spacy -s19647 -e25259 --ents=DEFENDANT,GRANDLARCENY:OFF,THEFT:OFF,THEFTFROMPLACE:OFF,HIGHWAYROBBERY:OFF,SHOPLIFTING:OFF,POCKETPICKING:OFF,BURGLARY:OFF,RECEIVING:OFF,ANIMALTHEFT:OFF,ROBBERY:OFF,HOUSEBREAKING:OFF,BIGAMY:OFF,PERJURY:OFF,FORGERY:OFF,RAPE:OFF,PETTYLARCENY:OFF,FRAUD:OFF,COININGOFFENCES:OFF,INFANTICIDE:OFF,EXTORTION:OFF,PERVERTINGJUSTICE:OFF,MURDER:OFF --rels=DEFOFF --relmaxtok=100 --maxlen=2000 --minents=OFF:2,DEFENDANT:2
	# python prodigy_to_docbin.py jsonl/obpxl.jsonl --outfile=docbins/dcr_dev_mn.spacy -s19647 -e25259 --ents=DEFENDANT,GRANDLARCENY:OFF,THEFT:OFF,THEFTFROMPLACE:OFF,HIGHWAYROBBERY:OFF,SHOPLIFTING:OFF,POCKETPICKING:OFF,BURGLARY:OFF,RECEIVING:OFF,ANIMALTHEFT:OFF,ROBBERY:OFF,HOUSEBREAKING:OFF,BIGAMY:OFF,PERJURY:OFF,FORGERY:OFF,RAPE:OFF,PETTYLARCENY:OFF,FRAUD:OFF,COININGOFFENCES:OFF,INFANTICIDE:OFF,EXTORTION:OFF,PERVERTINGJUSTICE:OFF,MURDER:OFF --rels=DEFOFF,NO_REL --relmaxtok=100 --maxlen=2000 --minents=OFF:2,DEFENDANT:2 --relnegations=DEFENDANT:OFF:DEFOFF:NO_REL
	#
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dcr_test.spacy -s4206 --ents=DEFENDANT,GRANDLARCENY:OFF,THEFT:OFF,THEFTFROMPLACE:OFF,HIGHWAYROBBERY:OFF,SHOPLIFTING:OFF,POCKETPICKING:OFF,BURGLARY:OFF,RECEIVING:OFF,ANIMALTHEFT:OFF,ROBBERY:OFF,HOUSEBREAKING:OFF,BIGAMY:OFF,PERJURY:OFF,FORGERY:OFF,RAPE:OFF,PETTYLARCENY:OFF,FRAUD:OFF,COININGOFFENCES:OFF,INFANTICIDE:OFF,EXTORTION:OFF,PERVERTINGJUSTICE:OFF,MURDER:OFF --rels=DEFOFF --relmaxtok=64 --maxlen=1000
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dcr_test_lg.spacy -s4206 --ents=DEFENDANT,GRANDLARCENY:OFF,THEFT:OFF,THEFTFROMPLACE:OFF,HIGHWAYROBBERY:OFF,SHOPLIFTING:OFF,POCKETPICKING:OFF,BURGLARY:OFF,RECEIVING:OFF,ANIMALTHEFT:OFF,ROBBERY:OFF,HOUSEBREAKING:OFF,BIGAMY:OFF,PERJURY:OFF,FORGERY:OFF,RAPE:OFF,PETTYLARCENY:OFF,FRAUD:OFF,COININGOFFENCES:OFF,INFANTICIDE:OFF,EXTORTION:OFF,PERVERTINGJUSTICE:OFF,MURDER:OFF --rels=DEFOFF
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dcr_test_xl.spacy -s4206 --ents=DEFENDANT,GRANDLARCENY:OFF,THEFT:OFF,THEFTFROMPLACE:OFF,HIGHWAYROBBERY:OFF,SHOPLIFTING:OFF,POCKETPICKING:OFF,BURGLARY:OFF,RECEIVING:OFF,ANIMALTHEFT:OFF,ROBBERY:OFF,HOUSEBREAKING:OFF,BIGAMY:OFF,PERJURY:OFF,FORGERY:OFF,RAPE:OFF,PETTYLARCENY:OFF,FRAUD:OFF,COININGOFFENCES:OFF,INFANTICIDE:OFF,EXTORTION:OFF,PERVERTINGJUSTICE:OFF,MURDER:OFF --rels=DEFOFF --minlen=1000
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dcr_test_mu.spacy -s4206 --ents=DEFENDANT,GRANDLARCENY:OFF,THEFT:OFF,THEFTFROMPLACE:OFF,HIGHWAYROBBERY:OFF,SHOPLIFTING:OFF,POCKETPICKING:OFF,BURGLARY:OFF,RECEIVING:OFF,ANIMALTHEFT:OFF,ROBBERY:OFF,HOUSEBREAKING:OFF,BIGAMY:OFF,PERJURY:OFF,FORGERY:OFF,RAPE:OFF,PETTYLARCENY:OFF,FRAUD:OFF,COININGOFFENCES:OFF,INFANTICIDE:OFF,EXTORTION:OFF,PERVERTINGJUSTICE:OFF,MURDER:OFF --rels=DEFOFF --maxlen=2000 --minents=OFF:2
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dcr_test_sn.spacy -s4206 --ents=DEFENDANT,GRANDLARCENY:OFF,THEFT:OFF,THEFTFROMPLACE:OFF,HIGHWAYROBBERY:OFF,SHOPLIFTING:OFF,POCKETPICKING:OFF,BURGLARY:OFF,RECEIVING:OFF,ANIMALTHEFT:OFF,ROBBERY:OFF,HOUSEBREAKING:OFF,BIGAMY:OFF,PERJURY:OFF,FORGERY:OFF,RAPE:OFF,PETTYLARCENY:OFF,FRAUD:OFF,COININGOFFENCES:OFF,INFANTICIDE:OFF,EXTORTION:OFF,PERVERTINGJUSTICE:OFF,MURDER:OFF --rels=DEFOFF,NO_REL --relmaxtok=100 --maxlen=2000 --minents=OFF:2,DEFENDANT:2 --relnegations=DEFENDANT:OFF:DEFOFF:NO_REL
	# python prodigy_to_docbin.py jsonl/obpxl.jsonl --outfile=docbins/dcr_test_mx.spacy -s25260 --ents=DEFENDANT,GRANDLARCENY:OFF,THEFT:OFF,THEFTFROMPLACE:OFF,HIGHWAYROBBERY:OFF,SHOPLIFTING:OFF,POCKETPICKING:OFF,BURGLARY:OFF,RECEIVING:OFF,ANIMALTHEFT:OFF,ROBBERY:OFF,HOUSEBREAKING:OFF,BIGAMY:OFF,PERJURY:OFF,FORGERY:OFF,RAPE:OFF,PETTYLARCENY:OFF,FRAUD:OFF,COININGOFFENCES:OFF,INFANTICIDE:OFF,EXTORTION:OFF,PERVERTINGJUSTICE:OFF,MURDER:OFF --rels=DEFOFF --relmaxtok=100 --maxlen=2000 --minents=OFF:2,DEFENDANT:2
	# python prodigy_to_docbin.py jsonl/obpxl.jsonl --outfile=docbins/dcr_test_mn.spacy -s25260 --ents=DEFENDANT,GRANDLARCENY:OFF,THEFT:OFF,THEFTFROMPLACE:OFF,HIGHWAYROBBERY:OFF,SHOPLIFTING:OFF,POCKETPICKING:OFF,BURGLARY:OFF,RECEIVING:OFF,ANIMALTHEFT:OFF,ROBBERY:OFF,HOUSEBREAKING:OFF,BIGAMY:OFF,PERJURY:OFF,FORGERY:OFF,RAPE:OFF,PETTYLARCENY:OFF,FRAUD:OFF,COININGOFFENCES:OFF,INFANTICIDE:OFF,EXTORTION:OFF,PERVERTINGJUSTICE:OFF,MURDER:OFF --rels=DEFOFF,NO_REL --relmaxtok=100 --maxlen=2000 --minents=OFF:2,DEFENDANT:2 --relnegations=DEFENDANT:OFF:DEFOFF:NO_REL
	#
	#
	# dvr: Defendant verdict relationship testing
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dvr_train.spacy -s0 -e3270 --ents=DEFENDANT,GUILTY:VER,NOTGUILTY:VER --rels=DEFVER --relmaxtok=64 --maxlen=1000
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dvr_train_lg.spacy -s0 -e3270 --ents=DEFENDANT,GUILTY:VER,NOTGUILTY:VER --rels=DEFVER --relmaxtok=100
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dvr_train_mu.spacy -s0 -e3270 --ents=DEFENDANT,GUILTY:VER,NOTGUILTY:VER --rels=DEFVER --relmaxtok=100 --minents=VER:2,DEFENDANT:2
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dvr_train_mn.spacy -s0 -e3270 --ents=DEFENDANT,GUILTY:VER,NOTGUILTY:VER --rels=DEFVER,NO_REL --relmaxtok=100 --minents=VER:2,DEFENDANT:2 --relnegations=DEFENDANT:VER:DEFVER:NO_REL
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dvr_dev.spacy -s3271 -e4205 --ents=DEFENDANT,GUILTY:VER,NOTGUILTY:VER --rels=DEFVER --relmaxtok=64 --maxlen=1000
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dvr_dev_lg.spacy -s3271 -e4205 --ents=DEFENDANT,GUILTY:VER,NOTGUILTY:VER --rels=DEFVER --relmaxtok=100
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dvr_dev_mu.spacy -s3271 -e4205 --ents=DEFENDANT,GUILTY:VER,NOTGUILTY:VER --rels=DEFVER --relmaxtok=100 --minents=VER:2,DEFENDANT:2
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dvr_dev_mn.spacy -s3271 -e4205 --ents=DEFENDANT,GUILTY:VER,NOTGUILTY:VER --rels=DEFVER,NO_REL --relmaxtok=100 --minents=VER:2,DEFENDANT:2 --relnegations=DEFENDANT:VER:DEFVER:NO_REL
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dvr_test.spacy -s4206 --ents=DEFENDANT,GUILTY:VER,NOTGUILTY:VER --rels=DEFVER --relmaxtok=64 --maxlen=1000
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dvr_test_lg.spacy -s4206 --ents=DEFENDANT,GUILTY:VER,NOTGUILTY:VER --rels=DEFVER
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dvr_test_mu.spacy -s4206 --ents=DEFENDANT,GUILTY:VER,NOTGUILTY:VER --rels=DEFVER --minents=VER:2,DEFENDANT:2
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dvr_test_mn.spacy -s4206 --ents=DEFENDANT,GUILTY:VER,NOTGUILTY:VER --rels=DEFVER,NO_REL --minents=VER:2,DEFENDANT:2 --relnegations=DEFENDANT:VER:DEFVER:NO_REL
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dvr_test_xl.spacy -s4206 --ents=DEFENDANT,GUILTY:VER,NOTGUILTY:VER --rels=DEFVER --minlen=1000
	#
	# ppo: Person Place Occupation relationship testing.
	# The rel_component example has 149 examples in total. 70% = 104, 20% = 29, 10% = 14
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/ppo_mini_train.spacy -s0 -e800 --ents=VICTIM:PER,DEFENDANT:PER,DEFENDANTHOME:PLA,OCCUPATION:OCC --rels=PERSPLACE:PERPLA,PERSOCC:PEROCC --relmaxtok=32 --maxlen=300
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/ppo_mini_dev.spacy -s801 -e1000 --ents=VICTIM:PER,DEFENDANT:PER,DEFENDANTHOME:PLA,OCCUPATION:OCC --rels=PERSPLACE:PERPLA,PERSOCC:PEROCC --relmaxtok=32 --maxlen=300
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/ppo_mini_test.spacy -s1001 -e1100 --ents=VICTIM:PER,DEFENDANT:PER,DEFENDANTHOME:PLA,OCCUPATION:OCC --rels=PERSPLACE:PERPLA,PERSOCC:PEROCC --relmaxtok=32 --maxlen=300
	#
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/ppo_train.spacy -s0 -e3270 --ents=VICTIM:PER,DEFENDANT:PER,DEFENDANTHOME:PLA,OCCUPATION:OCC --rels=PERSPLACE:PERPLA,PERSOCC:PEROCC --relmaxtok=64 --maxlen=1000
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/ppo_train_md.spacy -s0 -e3270 --ents=VICTIM:PER,DEFENDANT:PER,DEFENDANTHOME:PLA,OCCUPATION:OCC --rels=PERSPLACE:PERPLA,PERSOCC:PEROCC --relmaxtok=100 --maxlen=4000
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/ppo_train_lg.spacy -s0 -e3270 --ents=VICTIM:PER,DEFENDANT:PER,DEFENDANTHOME:PLA,OCCUPATION:OCC --rels=PERSPLACE:PERPLA,PERSOCC:PEROCC --relmaxtok=100
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/ppo_dev.spacy -s3271 -e4205 --ents=VICTIM:PER,DEFENDANT:PER,DEFENDANTHOME:PLA,OCCUPATION:OCC --rels=PERSPLACE:PERPLA,PERSOCC:PEROCC --relmaxtok=64 --maxlen=1000
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/ppo_dev_md.spacy -s3271 -e4205 --ents=VICTIM:PER,DEFENDANT:PER,DEFENDANTHOME:PLA,OCCUPATION:OCC --rels=PERSPLACE:PERPLA,PERSOCC:PEROCC --relmaxtok=100 --maxlen=4000
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/ppo_dev_lg.spacy -s3271 -e4205 --ents=VICTIM:PER,DEFENDANT:PER,DEFENDANTHOME:PLA,OCCUPATION:OCC --rels=PERSPLACE:PERPLA,PERSOCC:PEROCC --relmaxtok=100
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/ppo_test.spacy -s4206 --ents=VICTIM:PER,DEFENDANT:PER,DEFENDANTHOME:PLA,OCCUPATION:OCC --rels=PERSPLACE:PERPLA,PERSOCC:PEROCC --relmaxtok=64 --maxlen=1000
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/ppo_test_lg.spacy -s4206 --ents=VICTIM:PER,DEFENDANT:PER,DEFENDANTHOME:PLA,OCCUPATION:OCC --rels=PERSPLACE:PERPLA,PERSOCC:PEROCC
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/ppo_test_xl.spacy -s4206 --ents=VICTIM:PER,DEFENDANT:PER,DEFENDANTHOME:PLA,OCCUPATION:OCC --rels=PERSPLACE:PERPLA,PERSOCC:PEROCC --minlen=1000
	#
	# pun: Punishment testing
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/pun_train.spacy -s0 -e3270 --ents=TRANSPORT,DEATH,BRANDING,WHIPPING --maxlen=1000
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/pun_dev.spacy -s3271 -e4205 --ents=TRANSPORT,DEATH,BRANDING,WHIPPING --maxlen=1000
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/pun_test.spacy -s4206 --ents=TRANSPORT,DEATH,BRANDING,WHIPPING --maxlen=1000
	#
	# pus: Punishment span testing
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/pus_train.spacy -s0 -e3270 --spans=TRANSPORT,DEATH,BRANDING,WHIPPING --maxlen=1000
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/pus_dev.spacy -s3271 -e4205 --spans=TRANSPORT,DEATH,BRANDING,WHIPPING --maxlen=1000
	# python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/pus_test.spacy -s4206 --spans=TRANSPORT,DEATH,BRANDING,WHIPPING --maxlen=1000

config:
	# source .venv/bin/activate
	# It looks like spacy init config cannot be used with a custom component like relation_extractor.
	# python -m spacy init config ./baseconfigs/t2v_ner.cfg --lang en --pipeline ner
	# python -m spacy init config ./baseconfigs/t2v_sps.cfg --lang en --pipeline spancat_singlelabel
	# python -m spacy init config ./baseconfigs/t2v_spc.cfg --lang en --pipeline spancat
	# python -m spacy init config ./baseconfigs/t2v_spf.cfg --lang en --pipeline span_finder,spancat_singlelabel
	#
	# Looks like spacy init config cannot be used to generate a transformer relation_extractor config either.
	# python -m spacy init config ./baseconfigs/tra_ner.cfg --lang en --pipeline ner -G
	# python -m spacy init config ./baseconfigs/tra_sps.cfg --lang en --pipeline spancat_singlelabel -G
	# python -m spacy init config ./baseconfigs/tra_spc.cfg --lang en --pipeline spancat -G
	# python -m spacy init config ./baseconfigs/tra_spf.cfg --lang en --pipeline span_finder,spancat_singlelabel -G

fillconfig:
	# source .venv/bin/activate
	# https://ner.pythonhumanities.com/03_02_train_spacy_ner_model.html
	# visit https://spacy.io/usage/training to generate a base_config.cfg
	#
	# python -m spacy init fill-config ./baseconfigs/t2v_ner.cfg ./configs/t2v_ner.cfg
	# python -m spacy init fill-config ./baseconfigs/t2v_sps.cfg ./configs/t2v_sps.cfg
	# python -m spacy init fill-config ./baseconfigs/t2v_spc.cfg ./configs/t2v_spc.cfg
	# python -m spacy init fill-config ./baseconfigs/t2v_spf.cfg ./configs/t2v_spf.cfg
	# python -m spacy init fill-config ./baseconfigs/t2v_rel.cfg ./configs/t2v_rel.cfg -c ./relation_extractor/custom_functions.py
	# python -m spacy init fill-config ./baseconfigs/t2v_rcx.cfg ./configs/t2v_rcx.cfg -c ./relation_extractor_context/custom_functions.py
	#
	# python -m spacy init fill-config ./baseconfigs/tra_ner.cfg ./configs/tra_ner.cfg
	# python -m spacy init fill-config ./baseconfigs/tra_sps.cfg ./configs/tra_sps.cfg
	# python -m spacy init fill-config ./baseconfigs/tra_spc.cfg ./configs/tra_spc.cfg
	# python -m spacy init fill-config ./baseconfigs/tra_spf.cfg ./configs/tra_spf.cfg
	# python -m spacy init fill-config ./baseconfigs/tra_rel.cfg ./configs/tra_rel.cfg -c ./relation_extractor/custom_functions.py
	# python -m spacy init fill-config ./baseconfigs/tra_rcx.cfg ./configs/tra_rcx.cfg -c ./relation_extractor_context/custom_functions.py
	#
	# python -m spacy init fill-config ./baseconfigs/llm_ner.cfg ./configs/llm_ner.cfg

debug:
	# source .venv/bin/activate
	#
	# python -m spacy debug data ./configs/t2v_ner.cfg --paths.train ./docbins/dvv_train.spacy --paths.dev ./docbins/dvv_dev.spacy
	# python -m spacy debug data ./configs/t2v_ner.cfg --paths.train ./docbins/dvv_train_lg.spacy --paths.dev ./docbins/dvv_dev_lg.spacy
	# python -m spacy debug data ./configs/t2v_sps.cfg --paths.train ./docbins/dvs_train.spacy --paths.dev ./docbins/dvs_dev.spacy
	# python -m spacy debug data ./configs/t2v_spc.cfg --paths.train ./docbins/dvs_train.spacy --paths.dev ./docbins/dvs_dev.spacy
	#
	# python -m spacy debug data ./configs/t2v_ner.cfg --paths.train ./docbins/cri_mini_train.spacy --paths.dev ./docbins/cri_mini_dev.spacy
	# python -m spacy debug data ./configs/t2v_ner.cfg --paths.train ./docbins/cri_train.spacy --paths.dev ./docbins/cri_dev.spacy
	# python -m spacy debug data ./configs/t2v_ner.cfg --paths.train ./docbins/cri_train_lg.spacy --paths.dev ./docbins/cri_dev_lg.spacy
	# python -m spacy debug data ./configs/t2v_sps.cfg --paths.train ./docbins/crs_mini_train.spacy --paths.dev ./docbins/crs_mini_dev.spacy
	# python -m spacy debug data ./configs/t2v_sps.cfg --paths.train ./docbins/crs_train.spacy --paths.dev ./docbins/crs_dev.spacy
	# python -m spacy debug data ./configs/t2v_spc.cfg --paths.train ./docbins/crs_train.spacy --paths.dev ./docbins/crs_dev.spacy
	# python -m spacy debug data ./configs/t2v_spf.cfg --paths.train ./docbins/crs_train.spacy --paths.dev ./docbins/crs_dev.spacy
	#
	# python -m spacy debug data ./configs/t2v_rel.cfg -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dcr_train.spacy --paths.dev ./docbins/dcr_dev.spacy
	# python -m spacy debug data ./configs/t2v_rel.cfg -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dcr_train_lg.spacy --paths.dev ./docbins/dcr_dev_lg.spacy
	# python -m spacy debug data ./configs/t2v_rel.cfg -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dcr_train_mu.spacy --paths.dev ./docbins/dcr_dev_mu.spacy
	# python -m spacy debug data ./configs/t2v_rel.cfg -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dcr_train_mx.spacy --paths.dev ./docbins/dcr_dev_mx.spacy
	# python -m spacy debug data ./configs/t2v_rel.cfg -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dcr_train_mn.spacy --paths.dev ./docbins/dcr_dev_mn.spacy
	#
	# python -m spacy debug data ./configs/t2v_rel.cfg -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dvr_train.spacy --paths.dev ./docbins/dvr_dev.spacy
	# python -m spacy debug data ./configs/t2v_rel.cfg -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dvr_train_lg.spacy --paths.dev ./docbins/dvr_dev_lg.spacy
	#
	# python -m spacy debug data ./configs/t2v_rel.cfg -c ./relation_extractor/custom_functions.py --paths.train ./docbins/ppo_mini_train.spacy --paths.dev ./docbins/ppo_mini_dev.spacy
	# python -m spacy debug data ./configs/t2v_rel.cfg -c ./relation_extractor/custom_functions.py --paths.train ./docbins/ppo_train.spacy --paths.dev ./docbins/ppo_dev.spacy
	# python -m spacy debug data ./configs/t2v_rel.cfg -c ./relation_extractor/custom_functions.py --paths.train ./docbins/ppo_train_lg.spacy --paths.dev ./docbins/ppo_dev_lg.spacy
	#
	# python -m spacy debug data ./configs/t2v_ner.cfg --paths.train ./docbins/pun_train.spacy --paths.dev ./docbins/pun_dev.spacy
	# python -m spacy debug data ./configs/t2v_sps.cfg --paths.train ./docbins/pus_train.spacy --paths.dev ./docbins/pus_dev.spacy
	# python -m spacy debug data ./configs/t2v_spc.cfg --paths.train ./docbins/pus_train.spacy --paths.dev ./docbins/pus_dev.spacy
	#
	# python -m spacy debug data ./configs/tra_ner.cfg --paths.train ./docbins/dvv_train.spacy --paths.dev ./docbins/dvv_dev.spacy
	# python -m spacy debug data ./configs/tra_ner.cfg --paths.train ./docbins/dvv_train_md.spacy --paths.dev ./docbins/dvv_dev_md.spacy
	# python -m spacy debug data ./configs/tra_ner.cfg --paths.train ./docbins/dvv_train_lg.spacy --paths.dev ./docbins/dvv_dev_lg.spacy
	# python -m spacy debug data ./configs/tra_sps.cfg --paths.train ./docbins/dvs_train.spacy --paths.dev ./docbins/dvs_dev.spacy
	# python -m spacy debug data ./configs/tra_spc.cfg --paths.train ./docbins/dvs_train.spacy --paths.dev ./docbins/dvs_dev.spacy
	# python -m spacy debug data ./configs/tra_ner.cfg --paths.train ./docbins/dvv_tiny_train.spacy --paths.dev ./docbins/dvv_tiny_dev.spacy
	#
	# python -m spacy debug data ./configs/tra_ner.cfg --paths.train ./docbins/cri_train.spacy --paths.dev ./docbins/cri_dev.spacy
	# python -m spacy debug data ./configs/tra_ner.cfg --paths.train ./docbins/cri_train_lg.spacy --paths.dev ./docbins/cri_dev_lg.spacy
	# python -m spacy debug data ./configs/tra_ner.cfg --paths.train ./docbins/cri_train_md.spacy --paths.dev ./docbins/cri_dev_md.spacy
	# python -m spacy debug data ./configs/tra_sps.cfg --paths.train ./docbins/crs_train.spacy --paths.dev ./docbins/crs_dev.spacy
	# python -m spacy debug data ./configs/tra_spc.cfg --paths.train ./docbins/crs_train.spacy --paths.dev ./docbins/crs_dev.spacy
	# python -m spacy debug data ./configs/tra_spf.cfg --paths.train ./docbins/crs_train.spacy --paths.dev ./docbins/crs_dev.spacy
	#
	# python -m spacy debug data ./configs/tra_rel.cfg -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dcr_train.spacy --paths.dev ./docbins/dcr_dev.spacy
	# python -m spacy debug data ./configs/tra_rel.cfg -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dcr_train_lg.spacy --paths.dev ./docbins/dcr_dev_lg.spacy
	# python -m spacy debug data ./configs/tra_rel.cfg -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dcr_train_mu.spacy --paths.dev ./docbins/dcr_dev_mu.spacy
	# python -m spacy debug data ./configs/tra_rel.cfg -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dcr_train_mx.spacy --paths.dev ./docbins/dcr_dev_mx.spacy
	# python -m spacy debug data ./configs/tra_rel.cfg -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dcr_train_mn.spacy --paths.dev ./docbins/dcr_dev_mn.spacy
	#
	# python -m spacy debug data ./configs/tra_rel.cfg -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dvr_train.spacy --paths.dev ./docbins/dvr_dev.spacy
	# python -m spacy debug data ./configs/tra_rel.cfg -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dvr_train_lg.spacy --paths.dev ./docbins/dvr_dev_lg.spacy
	#
	# python -m spacy debug data ./configs/tra_rel.cfg -c ./relation_extractor/custom_functions.py --paths.train ./docbins/ppo_mini_train.spacy --paths.dev ./docbins/ppo_mini_dev.spacy
	# python -m spacy debug data ./configs/tra_rel.cfg -c ./relation_extractor/custom_functions.py --paths.train ./docbins/ppo_train.spacy --paths.dev ./docbins/ppo_dev.spacy
	# python -m spacy debug data ./configs/tra_rel.cfg -c ./relation_extractor/custom_functions.py --paths.train ./docbins/ppo_train_md.spacy --paths.dev ./docbins/ppo_dev_md.spacy
	# python -m spacy debug data ./configs/tra_rel.cfg -c ./relation_extractor/custom_functions.py --paths.train ./docbins/ppo_train_lg.spacy --paths.dev ./docbins/ppo_dev_lg.spacy
	#
	# python -m spacy debug data ./configs/tra_ner.cfg --paths.train ./docbins/pun_train.spacy --paths.dev ./docbins/pun_dev.spacy
	# python -m spacy debug data ./configs/tra_sps.cfg --paths.train ./docbins/pus_train.spacy --paths.dev ./docbins/pus_dev.spacy
	# python -m spacy debug data ./configs/tra_spc.cfg --paths.train ./docbins/pus_train.spacy --paths.dev ./docbins/pus_dev.spacy

gpu-test:
	# source .venv/bin/activate
	# python gpu_test.py

train:
	# source .venv/bin/activate
	#
	# python -m spacy train ./configs/t2v_ner.cfg --output ./models/dvv_t2v_ner --paths.train ./docbins/dvv_train.spacy --paths.dev ./docbins/dvv_dev.spacy
	# python -m spacy train ./configs/t2v_ner.cfg --output ./models/dvv_lg_t2v_ner --paths.train ./docbins/dvv_train_lg.spacy --paths.dev ./docbins/dvv_dev_lg.spacy
	# python -m spacy train ./configs/t2v_sps.cfg --output ./models/dvs_t2v_sps --paths.train ./docbins/dvs_train.spacy --paths.dev ./docbins/dvs_dev.spacy
	# python -m spacy train ./configs/t2v_spc.cfg --output ./models/dvs_t2v_spc --paths.train ./docbins/dvs_train.spacy --paths.dev ./docbins/dvs_dev.spacy
	#
	# python -m spacy train ./configs/t2v_ner.cfg --output ./models/cri_mini_t2v_ner --paths.train ./docbins/cri_mini_train.spacy --paths.dev ./docbins/cri_mini_dev.spacy
	# python -m spacy train ./configs/t2v_ner.cfg --output ./models/cri_t2v_ner --paths.train ./docbins/cri_train.spacy --paths.dev ./docbins/cri_dev.spacy
	# python -m spacy train ./configs/t2v_ner.cfg --output ./models/cri_lg_t2v_ner --paths.train ./docbins/cri_train_lg.spacy --paths.dev ./docbins/cri_dev_lg.spacy
	# python -m spacy train ./configs/t2v_sps.cfg --output ./models/crs_mini_t2v_sps --paths.train ./docbins/crs_mini_train.spacy --paths.dev ./docbins/crs_mini_dev.spacy
	# python -m spacy train ./configs/t2v_sps.cfg --output ./models/crs_t2v_sps --paths.train ./docbins/crs_train.spacy --paths.dev ./docbins/crs_dev.spacy
	# python -m spacy train ./configs/t2v_spc.cfg --output ./models/crs_mini_t2v_spc --paths.train ./docbins/crs_mini_train.spacy --paths.dev ./docbins/crs_mini_dev.spacy
	# python -m spacy train ./configs/t2v_spc.cfg --output ./models/crs_t2v_spc --paths.train ./docbins/crs_train.spacy --paths.dev ./docbins/crs_dev.spacy
	# python -m spacy train ./configs/t2v_spf.cfg --output ./models/crs_t2v_spf --paths.train ./docbins/crs_train.spacy --paths.dev ./docbins/crs_dev.spacy
	#
	# python -m spacy train ./configs/t2v_rel.cfg --output ./models/dcr_t2v_rel -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dcr_train.spacy --paths.dev ./docbins/dcr_dev.spacy
	# python -m spacy train ./configs/t2v_rel.cfg --output ./models/dcr_lg_t2v_rel -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dcr_train_lg.spacy --paths.dev ./docbins/dcr_dev_lg.spacy
	# python -m spacy train ./configs/t2v_rel.cfg --output ./models/dcr_mu_t2v_rel -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dcr_train_mu.spacy --paths.dev ./docbins/dcr_dev_mu.spacy
	#### python -m spacy train ./configs/t2v_rel.cfg --output ./models/dcr_mn_t2v_rel -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dcr_train_mn.spacy --paths.dev ./docbins/dcr_dev_mn.spacy
	#### python -m spacy train ./configs/t2v_rel.cfg --output ./models/dcr_mu_t2v_rej -c ./relation_extractor_jm/custom_functions.py --paths.train ./docbins/dcr_train_mu.spacy --paths.dev ./docbins/dcr_dev_mu.spacy
	# python -m spacy train ./configs/t2v_rel.cfg --output ./models/dcr_mx_t2v_rel -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dcr_train_mx.spacy --paths.dev ./docbins/dcr_dev_mx.spacy
	# python -m spacy train ./configs/t2v_rel.cfg --output ./models/dcr_mn_t2v_rel -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dcr_train_mn.spacy --paths.dev ./docbins/dcr_dev_mn.spacy
	# python -m spacy train ./configs/t2v_rel.cfg --output ./models/dcr_mx_t2v_rjm -c ./relation_extractor_jm/custom_functions.py --paths.train ./docbins/dcr_train_mx.spacy --paths.dev ./docbins/dcr_dev_mx.spacy
	# python -m spacy train ./configs/t2v_rel.cfg --output ./models/dcr_mn_t2v_rjm -c ./relation_extractor_jm/custom_functions.py --paths.train ./docbins/dcr_train_mn.spacy --paths.dev ./docbins/dcr_dev_mn.spacy
	# python -m spacy train ./configs/t2v_rcx.cfg --output ./models/dcr_mu_t2v_rcx -c ./relation_extractor_context/custom_functions.py --paths.train ./docbins/dcr_train_mu.spacy --paths.dev ./docbins/dcr_dev_mu.spacy --components.relation_extractor.model.create_instance_tensor.get_instances.ent1label DEFENDANT --components.relation_extractor.model.create_instance_tensor.get_instances.ent2label OFF
	#
	# python -m spacy train ./configs/t2v_rel.cfg --output ./models/dvr_t2v_rel -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dvr_train.spacy --paths.dev ./docbins/dvr_dev.spacy
	# python -m spacy train ./configs/t2v_rel.cfg --output ./models/dvr_lg_t2v_rel -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dvr_train_lg.spacy --paths.dev ./docbins/dvr_dev_lg.spacy
	# python -m spacy train ./configs/t2v_rel.cfg --output ./models/dvr_mu_t2v_rel -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dvr_train_mu.spacy --paths.dev ./docbins/dvr_dev_mu.spacy
	# python -m spacy train ./configs/t2v_rcx.cfg --output ./models/dvr_mu_t2v_rcx -c ./relation_extractor_context/custom_functions.py --paths.train ./docbins/dvr_train_mu.spacy --paths.dev ./docbins/dvr_dev_mu.spacy --components.relation_extractor.model.create_instance_tensor.get_instances.ent1label DEFENDANT --components.relation_extractor.model.create_instance_tensor.get_instances.ent2label VER
	# python -m spacy train ./configs/t2v_rcx.cfg --output ./models/dvr_mn_t2v_rcx -c ./relation_extractor_contect/custom_functions.py --paths.train ./docbins/dvr_train_mn.spacy --paths.dev ./docbins/dvr_dev_mn.spacy --components.relation_extractor.model.create_instance_tensor.get_instances.ent1label DEFENDANT --components.relation_extractor.model.create_instance_tensor.get_instances.ent2label VER
	#
	# python -m spacy train ./configs/t2v_rel.cfg --output ./models/ppo_mini_t2v_rel -c ./relation_extractor/custom_functions.py --paths.train ./docbins/ppo_mini_train.spacy --paths.dev ./docbins/ppo_mini_dev.spacy
	# python -m spacy train ./configs/t2v_rel.cfg --output ./models/ppo_t2v_rel -c ./relation_extractor/custom_functions.py --paths.train ./docbins/ppo_train.spacy --paths.dev ./docbins/ppo_dev.spacy
	# python -m spacy train ./configs/t2v_rel.cfg --output ./models/ppo_lg_t2v_rel -c ./relation_extractor/custom_functions.py --paths.train ./docbins/ppo_train_lg.spacy --paths.dev ./docbins/ppo_dev_lg.spacy
	#
	# python -m spacy train ./configs/t2v_ner.cfg --output ./models/pun_t2v_ner --paths.train ./docbins/pun_train.spacy --paths.dev ./docbins/pun_dev.spacy
	# python -m spacy train ./configs/t2v_sps.cfg --output ./models/pus_t2v_sps --paths.train ./docbins/pus_train.spacy --paths.dev ./docbins/pus_dev.spacy
	# python -m spacy train ./configs/t2v_spc.cfg --output ./models/pus_t2v_spc --paths.train ./docbins/pus_train.spacy --paths.dev ./docbins/pus_dev.spacy
	#
	# python -m spacy train ./configs/tra_ner.cfg --output ./models/dvv_tiny_tra_ner --paths.train ./docbins/dvv_tiny_train.spacy --paths.dev ./docbins/dvv_tiny_dev.spacy --gpu-id 0
	# python -m spacy train ./configs/tra_ner.cfg --output ./models/dvv_tra_ner --paths.train ./docbins/dvv_train.spacy --paths.dev ./docbins/dvv_dev.spacy --gpu-id 0
	# python -m spacy train ./configs/tra_ner.cfg --output ./models/dvv_md_tra_ner --paths.train ./docbins/dvv_train_md.spacy --paths.dev ./docbins/dvv_dev_md.spacy --gpu-id 0
	# NOT ENOUGH MEMORY python -m spacy train ./configs/tra_ner.cfg --output ./models/dvv_lg_tra_ner --paths.train ./docbins/dvv_train_lg.spacy --paths.dev ./docbins/dvv_dev_lg.spacy --gpu-id 0
	# python -m spacy train ./configs/tra_sps.cfg --output ./models/dvs_tra_sps --paths.train ./docbins/dvs_train.spacy --paths.dev ./docbins/dvs_dev.spacy --gpu-id 0
	# python -m spacy train ./configs/tra_spc.cfg --output ./models/dvs_tra_spc --paths.train ./docbins/dvs_train.spacy --paths.dev ./docbins/dvs_dev.spacy --gpu-id 0
	#
	# python -m spacy train ./configs/tra_ner.cfg --output ./models/cri_tra_ner --paths.train ./docbins/cri_train.spacy --paths.dev ./docbins/cri_dev.spacy --gpu-id 0
	# SEEMS TO LEARN BUT PRF SCORE REMAINS AT 0 python -m spacy train ./configs/tra_ner.cfg --output ./models/cri_md_tra_ner --paths.train ./docbins/cri_train_md.spacy --paths.dev ./docbins/cri_dev_md.spacy --gpu-id 0
	# NOT ENOUGH MEMORY python -m spacy train ./configs/tra_ner.cfg --output ./models/cri_lg_tra_ner --paths.train ./docbins/cri_train_lg.spacy --paths.dev ./docbins/cri_dev_lg.spacy --gpu-id 0
	# python -m spacy train ./configs/tra_sps.cfg --output ./models/crs_tra_sps --paths.train ./docbins/crs_train.spacy --paths.dev ./docbins/crs_dev.spacy --gpu-id 0
	# python -m spacy train ./configs/tra_spc.cfg --output ./models/crs_tra_spc --paths.train ./docbins/crs_train.spacy --paths.dev ./docbins/crs_dev.spacy --gpu-id 0
	# python -m spacy train ./configs/tra_spf.cfg --output ./models/crs_tra_spf --paths.train ./docbins/crs_train.spacy --paths.dev ./docbins/crs_dev.spacy --gpu-id 0
	#
	# python -m spacy train ./configs/tra_rel.cfg --output ./models/dcr_tra_rel -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dcr_train.spacy --paths.dev ./docbins/dcr_dev.spacy --gpu-id 0
	# python -m spacy train ./configs/tra_rel.cfg --output ./models/dcr_md_tra_rel -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dcr_train_md.spacy --paths.dev ./docbins/dcr_dev_md.spacy --gpu-id 0
	# NOT ENOUGH MEMORY python -m spacy train ./configs/tra_rel.cfg --output ./models/dcr_lg_tra_rel -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dcr_train_lg.spacy --paths.dev ./docbins/dcr_dev_lg.spacy --gpu-id 0
	# python -m spacy train ./configs/tra_rel.cfg --output ./models/dcr_mu_tra_rel -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dcr_train_mu.spacy --paths.dev ./docbins/dcr_dev_mu.spacy --gpu-id 0
	#### python -m spacy train ./configs/tra_rel.cfg --output ./models/dcr_mn_tra_rel -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dcr_train_mn.spacy --paths.dev ./docbins/dcr_dev_mn.spacy --gpu-id 0
	#### python -m spacy train ./configs/tra_rel.cfg --output ./models/dcr_mn_tra_rej -c ./relation_extractor_jm/custom_functions.py --paths.train ./docbins/dcr_train_mn.spacy --paths.dev ./docbins/dcr_dev_mn.spacy --gpu-id 0
	#### python -m spacy train ./configs/tra_rel.cfg --output ./models/dcr_mx_tra_rel -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dcr_train_mx.spacy --paths.dev ./docbins/dcr_dev_mx.spacy --gpu-id 0
	# python -m spacy train ./configs/tra_rcx.cfg --output ./models/dcr_mu_tra_rcx -c ./relation_extractor_context/custom_functions.py --paths.train ./docbins/dcr_train_mu.spacy --paths.dev ./docbins/dcr_dev_mu.spacy --gpu-id 0
	#
	# python -m spacy train ./configs/tra_rel.cfg --output ./models/dvr_tra_rel -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dvr_train.spacy --paths.dev ./docbins/dvr_dev.spacy --gpu-id 0
	# python -m spacy train ./configs/tra_rel.cfg --output ./models/dvr_lg_tra_rel -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dvr_train_lg.spacy --paths.dev ./docbins/dvr_dev_lg.spacy --gpu-id 0
	# python -m spacy train ./configs/tra_rel.cfg --output ./models/dvr_mu_tra_rel -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dvr_train_mu.spacy --paths.dev ./docbins/dvr_dev_mu.spacy --gpu-id 0
	# python -m spacy train ./configs/tra_rcx.cfg --output ./models/dvr_mu_tra_rcx -c ./relation_extractor_context/custom_functions.py --paths.train ./docbins/dvr_train_mu.spacy --paths.dev ./docbins/dvr_dev_mu.spacy --components.relation_extractor.model.create_instance_tensor.get_instances.ent1label DEFENDANT --components.relation_extractor.model.create_instance_tensor.get_instances.ent2label VER  --gpu-id 0
	# python -m spacy train ./configs/tra_rcx.cfg --output ./models/dvr_mn_tra_rcx -c ./relation_extractor_context/custom_functions.py --paths.train ./docbins/dvr_train_mn.spacy --paths.dev ./docbins/dvr_dev_mn.spacy --components.relation_extractor.model.create_instance_tensor.get_instances.ent1label DEFENDANT --components.relation_extractor.model.create_instance_tensor.get_instances.ent2label VER  --gpu-id 0
	#
	# python -m spacy train ./configs/tra_rel.cfg --output ./models/ppo_mini_tra_rel -c ./relation_extractor/custom_functions.py --paths.train ./docbins/ppo_mini_train.spacy --paths.dev ./docbins/ppo_mini_dev.spacy --gpu-id 0
	# python -m spacy train ./configs/tra_rel.cfg --output ./models/ppo_tra_rel -c ./relation_extractor/custom_functions.py --paths.train ./docbins/ppo_train.spacy --paths.dev ./docbins/ppo_dev.spacy --gpu-id 0
	# python -m spacy train ./configs/tra_rel.cfg --output ./models/ppo_md_tra_rel -c ./relation_extractor/custom_functions.py --paths.train ./docbins/ppo_train_md.spacy --paths.dev ./docbins/ppo_dev_md.spacy --gpu-id 0
	# NOT ENOUGH MEMORY python -m spacy train ./configs/tra_rel.cfg --output ./models/ppo_lg_tra_rel -c ./relation_extractor/custom_functions.py --paths.train ./docbins/ppo_train_lg.spacy --paths.dev ./docbins/ppo_dev_lg.spacy --gpu-id 0
	#
	# python -m spacy train ./configs/tra_ner.cfg --output ./models/pun_tra_ner --paths.train ./docbins/pun_train.spacy --paths.dev ./docbins/pun_dev.spacy --gpu-id 0
	# python -m spacy train ./configs/tra_sps.cfg --output ./models/pus_tra_sps --paths.train ./docbins/pus_train.spacy --paths.dev ./docbins/pus_dev.spacy --gpu-id 0
	# python -m spacy train ./configs/tra_spc.cfg --output ./models/pus_tra_spc --paths.train ./docbins/pus_train.spacy --paths.dev ./docbins/pus_dev.spacy --gpu-id 0
	#
	######## python -m spacy train ./configs/config_tr.cfg --output ./models/v5 --gpu-id 0
	######## python -m spacy train ./configs/config_tr_rel.cfg --output ./models/v6 --gpu-id 0 -c ./relation_extractor/custom_functions.py
	
test:
	# source .venv/bin/activate
	#
	# python test.py ./models/dvv_t2v_ner/model-best ./docbins/dvv_test.spacy
	# python test.py ./models/dvv_tra_ner/model-best ./docbins/dvv_test.spacy
	# python test.py ./models/dvv_tiny_tra_ner/model-best ./docbins/dvv_tiny_test.spacy
	# python test.py ./models/dvs_tra_sps/model-best ./docbins/dvs_test.spacy
	# python test.py ./models/dvs_tra_spc/model-best ./docbins/dvs_test.spacy
	# python test.py ./models/dvs_t2v_sps/model-best ./docbins/dvs_test.spacy
	# python test.py ./models/dvs_t2v_spc/model-best ./docbins/dvs_test.spacy
	#
	# python test.py ./models/cri_mini_t2v_ner/model-best ./docbins/cri_mini_test.spacy
	# python test.py ./models/cri_t2v_ner/model-best ./docbins/cri_test.spacy
	# python test.py ./models/crs_mini_t2v_sps/model-best ./docbins/crs_mini_test.spacy
	# python test.py ./models/crs_t2v_sps/model-best ./docbins/crs_test.spacy
	# python test.py ./models/crs_mini_t2v_spc/model-best ./docbins/crs_mini_test.spacy
	# python test.py ./models/crs_t2v_spc/model-best ./docbins/crs_test.spacy
	# python test.py ./models/crs_t2v_spf/model-best ./docbins/crs_test.spacy
	#
	# python test.py ./models/dcr_t2v_rel/model-best ./docbins/dcr_test.spacy --copyents
	# python test.py ./models/dcr_t2v_rel/model-best ./docbins/dcr_test_lg.spacy --copyents
	# python test.py ./models/dcr_t2v_rel/model-best ./docbins/dcr_test_lg.spacy --copyents
	# python test.py ./models/dcr_mu_t2v_rel/model-best ./docbins/dcr_test_mu.spacy --copyents
	# python test.py ./models/dcr_mn_t2v_rel/model-best ./docbins/dcr_test_mn.spacy --copyents
	# python test.py ./models/dcr_t2v_rel/model-best ./docbins/dcr_test_xl.spacy --copyents
	#
	# python test.py ./models/dvr_t2v_rel/model-best ./docbins/dvr_test.spacy --copyents
	# python test.py ./models/dvr_t2v_rel/model-best ./docbins/dvr_test_lg.spacy --copyents
	# python test.py ./models/dvr_mu_t2v_rel/model-best ./docbins/dvr_test_mu.spacy --copyents
	# python test.py ./models/dvr_t2v_rel/model-best ./docbins/dvr_test_xl.spacy --copyents
	# python test_rcx.py ./models/dvr_mu_t2v_rcx/model-best ./docbins/dvr_test_mu.spacy --copyents
	# python test_rcx.py ./models/dvr_mn_t2v_rcx/model-best ./docbins/dvr_test_mn.spacy --copyents
	#
	# python test.py ./models/ppo_mini_t2v_rel/model-best ./docbins/ppo_mini_test.spacy --copyents
	# python test.py ./models/ppo_t2v_rel/model-best ./docbins/ppo_test.spacy --copyents
	# python test.py ./models/ppo_t2v_rel/model-best ./docbins/ppo_test_lg.spacy --copyents
	# python test.py ./models/ppo_t2v_rel/model-best ./docbins/ppo_test_xl.spacy --copyents
	#
	# python test.py ./models/pun_t2v_ner/model-best ./docbins/pun_test.spacy
	# python test.py ./models/pus_t2v_sps/model-best ./docbins/pus_test.spacy
	# python test.py ./models/pus_t2v_spc/model-best ./docbins/pus_test.spacy
	#
	# python test.py ./models/cri_tra_ner/model-best ./docbins/cri_test.spacy
	# python test.py ./models/cri_md_tra_ner/model-best ./docbins/cri_test.spacy
	# python test.py ./models/cri_tra_sps/model-best ./docbins/cri_test.spacy
	# python test.py ./models/cri_tra_spc/model-best ./docbins/cri_test.spacy
	#
	# python test.py ./models/dcr_tra_rel/model-best ./docbins/dcr_test.spacy --copyents
	# python test.py ./models/dcr_mu_tra_rel/model-best ./docbins/dcr_test_mu.spacy --copyents
	# python test.py ./models/dcr_mn_tra_rel/model-best ./docbins/dcr_test_mn.spacy --copyents
	# python test.py ./models/dcr_mn_tra_rej/model-best ./docbins/dcr_test_mn.spacy --copyents
	#
	# python test.py ./models/dvr_tra_rel/model-best ./docbins/dvr_test.spacy --copyents
	# python test.py ./models/dvr_mu_tra_rel/model-best ./docbins/dvr_test_mu.spacy --copyents
	# python test_rcx.py ./models/dvr_mu_tra_rcx/model-best ./docbins/dvr_test_mu.spacy --copyents
	# python test_rcx.py ./models/dvr_mn_tra_rcx/model-best ./docbins/dvr_test_mn.spacy --copyents
	#
	# python test.py ./models/ppo_mini_tra_rel/model-best ./docbins/ppo_mini_test.spacy --copyents
	# python test.py ./models/ppo_tra_rel/model-best ./docbins/ppo_test.spacy --copyents
	# python test.py ./models/ppo_md_tra_rel/model-best ./docbins/ppo_test.spacy --copyents
	#
	# python test.py ./models/pun_tra_ner/model-best ./docbins/pun_test.spacy
	# python test.py ./models/pus_tra_sps/model-best ./docbins/pus_test.spacy
	# python test.py ./models/pus_tra_spc/model-best ./docbins/pus_test.spacy

evaluate:
	# source .venv/bin/activate
	#
	# python -m spacy evaluate ./models/dvv_t2v_ner/model-best ./docbins/dvv_test.spacy
	# python -m spacy evaluate ./models/dvv_t2v_ner/model-best ./docbins/dvv_test_lg.spacy
	# python -m spacy evaluate ./models/dvv_t2v_ner/model-best ./docbins/dvv_test_xl.spacy
	# python -m spacy evaluate ./models/dvs_t2v_sps/model-best ./docbins/dvs_test.spacy
	# python -m spacy evaluate ./models/dvs_t2v_spc/model-best ./docbins/dvs_test.spacy
	#
	# python -m spacy evaluate ./models/cri_mini_t2v_ner/model-best ./docbins/cri_mini_test.spacy
	# python -m spacy evaluate ./models/cri_t2v_ner/model-best ./docbins/cri_test.spacy
	# python -m spacy evaluate ./models/cri_t2v_ner/model-best ./docbins/cri_test_lg.spacy
	# python -m spacy evaluate ./models/cri_t2v_ner/model-best ./docbins/cri_test_xl.spacy
	# python -m spacy evaluate ./models/cri_lg_t2v_ner/model-best ./docbins/cri_test.spacy
	# python -m spacy evaluate ./models/cri_lg_t2v_ner/model-best ./docbins/cri_test_lg.spacy
	# python -m spacy evaluate ./models/cri_lg_t2v_ner/model-best ./docbins/cri_test_xl.spacy
	# python -m spacy evaluate ./models/crs_mini_t2v_sps/model-best ./docbins/crs_mini_test.spacy
	# python -m spacy evaluate ./models/crs_t2v_sps/model-best ./docbins/crs_test.spacy
	# python -m spacy evaluate ./models/crs_mini_t2v_spc/model-best ./docbins/crs_mini_test.spacy
	# python -m spacy evaluate ./models/crs_t2v_spc/model-best ./docbins/crs_test.spacy
	#
	# # Don't seem to be able to use built in evaluate command with relation_extractor
	#
	# python -m spacy evaluate ./models/pun_t2v_ner/model-best ./docbins/pun_test.spacy
	# python -m spacy evaluate ./models/pus_t2v_spc/model-best ./docbins/pus_test.spacy
	# python -m spacy evaluate ./models/pus_t2v_sps/model-best ./docbins/pus_test.spacy
	#
	# python -m spacy evaluate ./models/dvv_tra_ner/model-best ./docbins/dvv_test.spacy
	# python -m spacy evaluate ./models/dvs_tra_sps/model-best ./docbins/dvs_test.spacy
	# python -m spacy evaluate ./models/dvs_tra_spc/model-best ./docbins/dvs_test.spacy
	# python -m spacy evaluate ./models/dvv_tiny_tra_ner/model-best ./docbins/dvv_tiny_test.spacy
	#
	# python -m spacy evaluate ./models/cri_tra_ner/model-best ./docbins/cri_test.spacy
	# REPORTS PRF SCORE AS 0 BUT WILL RETURN MEDIOCRE RESULTS USING TEST.PY ABOVE python -m spacy evaluate ./models/cri_md_tra_ner/model-best ./docbins/cri_test.spacy
	# python -m spacy evaluate ./models/cri_tra_sps/model-best ./docbins/crs_test.spacy
	# python -m spacy evaluate ./models/cri_tra_spc/model-best ./docbins/crs_test.spacy
	#
	# python -m spacy evaluate ./models/pun_tra_ner/model-best ./docbins/pun_test.spacy
	# python -m spacy evaluate ./models/pus_tra_sps/model-best ./docbins/pus_test.spacy
	# python -m spacy evaluate ./models/pus_tra_spc/model-best ./docbins/pus_test.spacy

