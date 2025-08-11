
venv-make:
	# https://docs.python.org/3/library/venv.html
	# https://spacy.io/usage
	# python3 -m venv .venv
	# source .venv/bin/activate
	# pip install -U lxml
	# pip install -U tqdm
	#### pip install -U pip setuptools wheel
	# pip install -U spacy
	#### python -m spacy download en_core_web_sm
	# pip install -U spacy-transformers
	# pip install -U cupy-cuda12x
	# pip install spacy-llm
	# pip install accelerate

venv-activate:
	source .venv/bin/activate

venv-deactivate:
	deactivate

gpu-test:
	python gpu_test.py

obp_to_prodigy:
	python obp_to_prodigy.py

config:
	python -m spacy init config ./baseconfigs/t2v_ner.cfg --lang en --pipeline ner
	python -m spacy init config ./baseconfigs/tra_ner.cfg --lang en --pipeline ner -G
	python -m spacy init config ./baseconfigs/t2v_spf.cfg --lang en --pipeline span_finder,spancat_singlelabel
	python -m spacy init config ./baseconfigs/tra_spf.cfg --lang en --pipeline span_finder,spancat_singlelabel -G
	# spacy init config does not work out of the box with custom components.

fillconfig:
	python -m spacy init fill-config ./baseconfigs/t2v_ner.cfg ./configs/t2v_ner.cfg
	python -m spacy init fill-config ./baseconfigs/tra_ner.cfg ./configs/tra_ner.cfg
	python -m spacy init fill-config ./baseconfigs/t2v_spf.cfg ./configs/t2v_spf.cfg
	python -m spacy init fill-config ./baseconfigs/tra_spf.cfg ./configs/tra_spf.cfg
	python -m spacy init fill-config ./baseconfigs/t2v_rel.cfg ./configs/t2v_rel.cfg -c ./relation_extractor/custom_functions.py
	python -m spacy init fill-config ./baseconfigs/tra_rel.cfg ./configs/tra_rel.cfg -c ./relation_extractor/custom_functions.py
	python -m spacy init fill-config ./baseconfigs/t2v_rcx.cfg ./configs/t2v_rcx.cfg -c ./relation_extractor_context/custom_functions.py
	python -m spacy init fill-config ./baseconfigs/tra_rcx.cfg ./configs/tra_rcx.cfg -c ./relation_extractor_context/custom_functions.py

dvv_ner:
	# Defendant Victim Verdict Entity Recognition
	#
	# Create the DocBins
	# Training 70%, Validation (dev) 20%, Test 10% (dev is what spacy calls validation sets)
	python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dvv_train.spacy -s0 -e3270 --ents=DEFENDANT,VICTIM,GUILTY,NOTGUILTY --maxlen=1000
	python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dvv_train_md.spacy -s0 -e3270 --ents=DEFENDANT,VICTIM,GUILTY,NOTGUILTY --maxlen=10000
	python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dvv_train_lg.spacy -s0 -e3270 --ents=DEFENDANT,VICTIM,GUILTY,NOTGUILTY
	python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dvv_dev.spacy -s3271 -e4205 --ents=DEFENDANT,VICTIM,GUILTY,NOTGUILTY --maxlen=1000
	python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dvv_dev_md.spacy -s3271 -e4205 --ents=DEFENDANT,VICTIM,GUILTY,NOTGUILTY --maxlen=10000
	python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dvv_dev_lg.spacy -s3271 -e4205 --ents=DEFENDANT,VICTIM,GUILTY,NOTGUILTY
	python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dvv_test.spacy -s4206 --ents=DEFENDANT,VICTIM,GUILTY,NOTGUILTY --maxlen=1000
	python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dvv_test_lg.spacy -s4206 --ents=DEFENDANT,VICTIM,GUILTY,NOTGUILTY
	python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dvv_test_xl.spacy -s4206 --ents=DEFENDANT,VICTIM,GUILTY,NOTGUILTY --minlen=1000
	#
	# Debug
	python -m spacy debug data ./configs/t2v_ner.cfg --paths.train ./docbins/dvv_train.spacy --paths.dev ./docbins/dvv_dev.spacy
	python -m spacy debug data ./configs/t2v_ner.cfg --paths.train ./docbins/dvv_train_lg.spacy --paths.dev ./docbins/dvv_dev_lg.spacy
	python -m spacy debug data ./configs/tra_ner.cfg --paths.train ./docbins/dvv_train_md.spacy --paths.dev ./docbins/dvv_dev_md.spacy
	#
	# Train
	python -m spacy train ./configs/t2v_ner.cfg --output ./models/dvv_t2v_ner --paths.train ./docbins/dvv_train.spacy --paths.dev ./docbins/dvv_dev.spacy
	python -m spacy train ./configs/t2v_ner.cfg --output ./models/dvv_lg_t2v_ner --paths.train ./docbins/dvv_train_lg.spacy --paths.dev ./docbins/dvv_dev_lg.spacy
	python -m spacy train ./configs/tra_ner.cfg --output ./models/dvv_md_tra_ner --paths.train ./docbins/dvv_train_md.spacy --paths.dev ./docbins/dvv_dev_md.spacy --gpu-id 0
	#
	# Test
	python test.py ./models/dvv_t2v_ner/model-best ./docbins/dvv_test_lg.spacy
	python test.py ./models/dvv_lg_t2v_ner/model-best ./docbins/dvv_test_lg.spacy
	python test.py ./models/dvv_md_tra_ner/model-best ./docbins/dvv_test_lg.spacy
	#
	# Evaluate
	python -m spacy evaluate ./models/dvv_t2v_ner/model-best ./docbins/dvv_test.spacy
	python -m spacy evaluate ./models/dvv_t2v_ner/model-best ./docbins/dvv_test_lg.spacy
	python -m spacy evaluate ./models/dvv_t2v_ner/model-best ./docbins/dvv_test_xl.spacy
	python -m spacy evaluate ./models/dvv_lg_t2v_ner/model-best ./docbins/dvv_test.spacy
	python -m spacy evaluate ./models/dvv_lg_t2v_ner/model-best ./docbins/dvv_test_lg.spacy
	python -m spacy evaluate ./models/dvv_lg_t2v_ner/model-best ./docbins/dvv_test_xl.spacy
	python -m spacy evaluate ./models/dvv_md_tra_ner/model-best ./docbins/dvv_test.spacy
	python -m spacy evaluate ./models/dvv_md_tra_ner/model-best ./docbins/dvv_test_lg.spacy
	python -m spacy evaluate ./models/dvv_md_tra_ner/model-best ./docbins/dvv_test_xl.spacy

cri_ner:
	# Offence Description Entity Recognition
	#
	# Create the DocBins
	python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/cri_train.spacy -s0 -e3270 --ents=GRANDLARCENY,THEFT,THEFTFROMPLACE,HIGHWAYROBBERY,SHOPLIFTING,POCKETPICKING,BURGLARY,RECEIVING,ANIMALTHEFT,ROBBERY,HOUSEBREAKING,BIGAMY,PERJURY,FORGERY,RAPE,PETTYLARCENY,FRAUD,COININGOFFENCES,INFANTICIDE,EXTORTION,PERVERTINGJUSTICE,MURDER --maxlen=1000
	python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/cri_train_lg.spacy -s0 -e3270 --ents=GRANDLARCENY,THEFT,THEFTFROMPLACE,HIGHWAYROBBERY,SHOPLIFTING,POCKETPICKING,BURGLARY,RECEIVING,ANIMALTHEFT,ROBBERY,HOUSEBREAKING,BIGAMY,PERJURY,FORGERY,RAPE,PETTYLARCENY,FRAUD,COININGOFFENCES,INFANTICIDE,EXTORTION,PERVERTINGJUSTICE,MURDER
	python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/cri_dev.spacy -s3271 -e4205 --ents=GRANDLARCENY,THEFT,THEFTFROMPLACE,HIGHWAYROBBERY,SHOPLIFTING,POCKETPICKING,BURGLARY,RECEIVING,ANIMALTHEFT,ROBBERY,HOUSEBREAKING,BIGAMY,PERJURY,FORGERY,RAPE,PETTYLARCENY,FRAUD,COININGOFFENCES,INFANTICIDE,EXTORTION,PERVERTINGJUSTICE,MURDER --maxlen=1000
	python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/cri_dev_lg.spacy -s3271 -e4205 --ents=GRANDLARCENY,THEFT,THEFTFROMPLACE,HIGHWAYROBBERY,SHOPLIFTING,POCKETPICKING,BURGLARY,RECEIVING,ANIMALTHEFT,ROBBERY,HOUSEBREAKING,BIGAMY,PERJURY,FORGERY,RAPE,PETTYLARCENY,FRAUD,COININGOFFENCES,INFANTICIDE,EXTORTION,PERVERTINGJUSTICE,MURDER
	python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/cri_test_lg.spacy -s4206 --ents=GRANDLARCENY,THEFT,THEFTFROMPLACE,HIGHWAYROBBERY,SHOPLIFTING,POCKETPICKING,BURGLARY,RECEIVING,ANIMALTHEFT,ROBBERY,HOUSEBREAKING,BIGAMY,PERJURY,FORGERY,RAPE,PETTYLARCENY,FRAUD,COININGOFFENCES,INFANTICIDE,EXTORTION,PERVERTINGJUSTICE,MURDER
	python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/crs_train.spacy -s0 -e3270 --spans=GRANDLARCENY,THEFT,THEFTFROMPLACE,HIGHWAYROBBERY,SHOPLIFTING,POCKETPICKING,BURGLARY,RECEIVING,ANIMALTHEFT,ROBBERY,HOUSEBREAKING,BIGAMY,PERJURY,FORGERY,RAPE,PETTYLARCENY,FRAUD,COININGOFFENCES,INFANTICIDE,EXTORTION,PERVERTINGJUSTICE,MURDER --maxlen=1000
	python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/crs_dev.spacy -s3271 -e4205 --spans=GRANDLARCENY,THEFT,THEFTFROMPLACE,HIGHWAYROBBERY,SHOPLIFTING,POCKETPICKING,BURGLARY,RECEIVING,ANIMALTHEFT,ROBBERY,HOUSEBREAKING,BIGAMY,PERJURY,FORGERY,RAPE,PETTYLARCENY,FRAUD,COININGOFFENCES,INFANTICIDE,EXTORTION,PERVERTINGJUSTICE,MURDER --maxlen=1000
	python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/crs_test.spacy -s4206 --spans=GRANDLARCENY,THEFT,THEFTFROMPLACE,HIGHWAYROBBERY,SHOPLIFTING,POCKETPICKING,BURGLARY,RECEIVING,ANIMALTHEFT,ROBBERY,HOUSEBREAKING,BIGAMY,PERJURY,FORGERY,RAPE,PETTYLARCENY,FRAUD,COININGOFFENCES,INFANTICIDE,EXTORTION,PERVERTINGJUSTICE,MURDER --maxlen=1000
	#
	# Debug
	python -m spacy debug data ./configs/t2v_ner.cfg --paths.train ./docbins/cri_train_lg.spacy --paths.dev ./docbins/cri_dev_lg.spacy
	python -m spacy debug data ./configs/tra_ner.cfg --paths.train ./docbins/cri_train.spacy --paths.dev ./docbins/cri_dev.spacy
	python -m spacy debug data ./configs/tra_spf.cfg --paths.train ./docbins/crs_train.spacy --paths.dev ./docbins/crs_dev.spacy
	#
	# Train
	python -m spacy train ./configs/t2v_ner.cfg --output ./models/cri_lg_t2v_ner --paths.train ./docbins/cri_train_lg.spacy --paths.dev ./docbins/cri_dev_lg.spacy
	python -m spacy train ./configs/tra_ner.cfg --output ./models/cri_tra_ner --paths.train ./docbins/cri_train.spacy --paths.dev ./docbins/cri_dev.spacy --gpu-id 0
	python -m spacy train ./configs/tra_spf.cfg --output ./models/crs_tra_spf --paths.train ./docbins/crs_train.spacy --paths.dev ./docbins/crs_dev.spacy --gpu-id 0
	#
	# Test
	python test.py ./models/cri_lg_t2v_ner/model-best ./docbins/cri_test_lg.spacy
	python test.py ./models/cri_tra_ner/model-best ./docbins/cri_test_lg.spacy
	python test.py ./models/crs_tra_spf/model-best ./docbins/crs_test.spacy
	#
	# Evaluate
	python -m spacy evaluate ./models/cri_lg_t2v_ner/model-best ./docbins/cri_test_lg.spacy
	python -m spacy evaluate ./models/cri_tra_ner/model-best ./docbins/cri_test_lg.spacy
	python -m spacy evaluate ./models/crs_tra_spf/model-best ./docbins/crs_test.spacy

dcr_rel:
	# Defendant and Crime Relation Extraction
	python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dcr_train.spacy -s0 -e3270 --ents=DEFENDANT,GRANDLARCENY:OFF,THEFT:OFF,THEFTFROMPLACE:OFF,HIGHWAYROBBERY:OFF,SHOPLIFTING:OFF,POCKETPICKING:OFF,BURGLARY:OFF,RECEIVING:OFF,ANIMALTHEFT:OFF,ROBBERY:OFF,HOUSEBREAKING:OFF,BIGAMY:OFF,PERJURY:OFF,FORGERY:OFF,RAPE:OFF,PETTYLARCENY:OFF,FRAUD:OFF,COININGOFFENCES:OFF,INFANTICIDE:OFF,EXTORTION:OFF,PERVERTINGJUSTICE:OFF,MURDER:OFF --rels=DEFOFF --relmaxtok=64 --maxlen=1000
	python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dcr_train_md.spacy -s0 -e3270 --ents=DEFENDANT,GRANDLARCENY:OFF,THEFT:OFF,THEFTFROMPLACE:OFF,HIGHWAYROBBERY:OFF,SHOPLIFTING:OFF,POCKETPICKING:OFF,BURGLARY:OFF,RECEIVING:OFF,ANIMALTHEFT:OFF,ROBBERY:OFF,HOUSEBREAKING:OFF,BIGAMY:OFF,PERJURY:OFF,FORGERY:OFF,RAPE:OFF,PETTYLARCENY:OFF,FRAUD:OFF,COININGOFFENCES:OFF,INFANTICIDE:OFF,EXTORTION:OFF,PERVERTINGJUSTICE:OFF,MURDER:OFF --rels=DEFOFF --relmaxtok=100 --maxlen=2000
	python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dcr_train_lg.spacy -s0 -e3270 --ents=DEFENDANT,GRANDLARCENY:OFF,THEFT:OFF,THEFTFROMPLACE:OFF,HIGHWAYROBBERY:OFF,SHOPLIFTING:OFF,POCKETPICKING:OFF,BURGLARY:OFF,RECEIVING:OFF,ANIMALTHEFT:OFF,ROBBERY:OFF,HOUSEBREAKING:OFF,BIGAMY:OFF,PERJURY:OFF,FORGERY:OFF,RAPE:OFF,PETTYLARCENY:OFF,FRAUD:OFF,COININGOFFENCES:OFF,INFANTICIDE:OFF,EXTORTION:OFF,PERVERTINGJUSTICE:OFF,MURDER:OFF --rels=DEFOFF --relmaxtok=100
	python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dcr_train_mu.spacy -s0 -e3270 --ents=DEFENDANT,GRANDLARCENY:OFF,THEFT:OFF,THEFTFROMPLACE:OFF,HIGHWAYROBBERY:OFF,SHOPLIFTING:OFF,POCKETPICKING:OFF,BURGLARY:OFF,RECEIVING:OFF,ANIMALTHEFT:OFF,ROBBERY:OFF,HOUSEBREAKING:OFF,BIGAMY:OFF,PERJURY:OFF,FORGERY:OFF,RAPE:OFF,PETTYLARCENY:OFF,FRAUD:OFF,COININGOFFENCES:OFF,INFANTICIDE:OFF,EXTORTION:OFF,PERVERTINGJUSTICE:OFF,MURDER:OFF --rels=DEFOFF --relmaxtok=100 --maxlen=2000 --minents=OFF:2
	python prodigy_to_docbin.py jsonl/obpxl.jsonl --outfile=docbins/dcr_train_mx.spacy -s0 -e19646 --ents=DEFENDANT,GRANDLARCENY:OFF,THEFT:OFF,THEFTFROMPLACE:OFF,HIGHWAYROBBERY:OFF,SHOPLIFTING:OFF,POCKETPICKING:OFF,BURGLARY:OFF,RECEIVING:OFF,ANIMALTHEFT:OFF,ROBBERY:OFF,HOUSEBREAKING:OFF,BIGAMY:OFF,PERJURY:OFF,FORGERY:OFF,RAPE:OFF,PETTYLARCENY:OFF,FRAUD:OFF,COININGOFFENCES:OFF,INFANTICIDE:OFF,EXTORTION:OFF,PERVERTINGJUSTICE:OFF,MURDER:OFF --rels=DEFOFF --relmaxtok=100 --maxlen=2000 --minents=OFF:2,DEFENDANT:2
	python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dcr_dev.spacy -s3271 -e4205 --ents=DEFENDANT,GRANDLARCENY:OFF,THEFT:OFF,THEFTFROMPLACE:OFF,HIGHWAYROBBERY:OFF,SHOPLIFTING:OFF,POCKETPICKING:OFF,BURGLARY:OFF,RECEIVING:OFF,ANIMALTHEFT:OFF,ROBBERY:OFF,HOUSEBREAKING:OFF,BIGAMY:OFF,PERJURY:OFF,FORGERY:OFF,RAPE:OFF,PETTYLARCENY:OFF,FRAUD:OFF,COININGOFFENCES:OFF,INFANTICIDE:OFF,EXTORTION:OFF,PERVERTINGJUSTICE:OFF,MURDER:OFF --rels=DEFOFF --relmaxtok=64 --maxlen=1000
	python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dcr_dev_md.spacy -s3271 -e4205 --ents=DEFENDANT,GRANDLARCENY:OFF,THEFT:OFF,THEFTFROMPLACE:OFF,HIGHWAYROBBERY:OFF,SHOPLIFTING:OFF,POCKETPICKING:OFF,BURGLARY:OFF,RECEIVING:OFF,ANIMALTHEFT:OFF,ROBBERY:OFF,HOUSEBREAKING:OFF,BIGAMY:OFF,PERJURY:OFF,FORGERY:OFF,RAPE:OFF,PETTYLARCENY:OFF,FRAUD:OFF,COININGOFFENCES:OFF,INFANTICIDE:OFF,EXTORTION:OFF,PERVERTINGJUSTICE:OFF,MURDER:OFF --rels=DEFOFF --relmaxtok=100 --maxlen=2000
	python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dcr_dev_lg.spacy -s3271 -e4205 --ents=DEFENDANT,GRANDLARCENY:OFF,THEFT:OFF,THEFTFROMPLACE:OFF,HIGHWAYROBBERY:OFF,SHOPLIFTING:OFF,POCKETPICKING:OFF,BURGLARY:OFF,RECEIVING:OFF,ANIMALTHEFT:OFF,ROBBERY:OFF,HOUSEBREAKING:OFF,BIGAMY:OFF,PERJURY:OFF,FORGERY:OFF,RAPE:OFF,PETTYLARCENY:OFF,FRAUD:OFF,COININGOFFENCES:OFF,INFANTICIDE:OFF,EXTORTION:OFF,PERVERTINGJUSTICE:OFF,MURDER:OFF --rels=DEFOFF --relmaxtok=100
	python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dcr_dev_mu.spacy -s3271 -e4205 --ents=DEFENDANT,GRANDLARCENY:OFF,THEFT:OFF,THEFTFROMPLACE:OFF,HIGHWAYROBBERY:OFF,SHOPLIFTING:OFF,POCKETPICKING:OFF,BURGLARY:OFF,RECEIVING:OFF,ANIMALTHEFT:OFF,ROBBERY:OFF,HOUSEBREAKING:OFF,BIGAMY:OFF,PERJURY:OFF,FORGERY:OFF,RAPE:OFF,PETTYLARCENY:OFF,FRAUD:OFF,COININGOFFENCES:OFF,INFANTICIDE:OFF,EXTORTION:OFF,PERVERTINGJUSTICE:OFF,MURDER:OFF --rels=DEFOFF --relmaxtok=100 --maxlen=2000 --minents=OFF:2
	python prodigy_to_docbin.py jsonl/obpxl.jsonl --outfile=docbins/dcr_dev_mx.spacy -s19647 -e25259 --ents=DEFENDANT,GRANDLARCENY:OFF,THEFT:OFF,THEFTFROMPLACE:OFF,HIGHWAYROBBERY:OFF,SHOPLIFTING:OFF,POCKETPICKING:OFF,BURGLARY:OFF,RECEIVING:OFF,ANIMALTHEFT:OFF,ROBBERY:OFF,HOUSEBREAKING:OFF,BIGAMY:OFF,PERJURY:OFF,FORGERY:OFF,RAPE:OFF,PETTYLARCENY:OFF,FRAUD:OFF,COININGOFFENCES:OFF,INFANTICIDE:OFF,EXTORTION:OFF,PERVERTINGJUSTICE:OFF,MURDER:OFF --rels=DEFOFF --relmaxtok=100 --maxlen=2000 --minents=OFF:2,DEFENDANT:2
	python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dcr_test_lg.spacy -s4206 --ents=DEFENDANT,GRANDLARCENY:OFF,THEFT:OFF,THEFTFROMPLACE:OFF,HIGHWAYROBBERY:OFF,SHOPLIFTING:OFF,POCKETPICKING:OFF,BURGLARY:OFF,RECEIVING:OFF,ANIMALTHEFT:OFF,ROBBERY:OFF,HOUSEBREAKING:OFF,BIGAMY:OFF,PERJURY:OFF,FORGERY:OFF,RAPE:OFF,PETTYLARCENY:OFF,FRAUD:OFF,COININGOFFENCES:OFF,INFANTICIDE:OFF,EXTORTION:OFF,PERVERTINGJUSTICE:OFF,MURDER:OFF --rels=DEFOFF
	python prodigy_to_docbin.py jsonl/obp.jsonl --outfile=docbins/dcr_test_mu.spacy -s4206 --ents=DEFENDANT,GRANDLARCENY:OFF,THEFT:OFF,THEFTFROMPLACE:OFF,HIGHWAYROBBERY:OFF,SHOPLIFTING:OFF,POCKETPICKING:OFF,BURGLARY:OFF,RECEIVING:OFF,ANIMALTHEFT:OFF,ROBBERY:OFF,HOUSEBREAKING:OFF,BIGAMY:OFF,PERJURY:OFF,FORGERY:OFF,RAPE:OFF,PETTYLARCENY:OFF,FRAUD:OFF,COININGOFFENCES:OFF,INFANTICIDE:OFF,EXTORTION:OFF,PERVERTINGJUSTICE:OFF,MURDER:OFF --rels=DEFOFF --maxlen=2000 --minents=OFF:2
	#
	# Debug
	python -m spacy debug data ./configs/t2v_rel.cfg -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dcr_train.spacy --paths.dev ./docbins/dcr_dev.spacy
	python -m spacy debug data ./configs/t2v_rel.cfg -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dcr_train_lg.spacy --paths.dev ./docbins/dcr_dev_lg.spacy
	python -m spacy debug data ./configs/tra_rel.cfg -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dcr_train.spacy --paths.dev ./docbins/dcr_dev.spacy
	python -m spacy debug data ./configs/tra_rel.cfg -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dcr_train_md.spacy --paths.dev ./docbins/dcr_dev_md.spacy
	python -m spacy debug data ./configs/t2v_rel.cfg -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dcr_train_mu.spacy --paths.dev ./docbins/dcr_dev_mu.spacy
	python -m spacy debug data ./configs/tra_rel.cfg -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dcr_train_mu.spacy --paths.dev ./docbins/dcr_dev_mu.spacy
	python -m spacy debug data ./configs/tra_rel.cfg -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dcr_train_mx.spacy --paths.dev ./docbins/dcr_dev_mx.spacy
	python -m spacy debug data ./configs/t2v_rcx.cfg -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dcr_train_mu.spacy --paths.dev ./docbins/dcr_dev_mu.spacy
	python -m spacy debug data ./configs/tra_rcx.cfg -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dcr_train_mu.spacy --paths.dev ./docbins/dcr_dev_mu.spacy
	#
	# Train
	python -m spacy train ./configs/t2v_rel.cfg --output ./models/dcr_t2v_rel -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dcr_train.spacy --paths.dev ./docbins/dcr_dev.spacy
	python -m spacy train ./configs/t2v_rel.cfg --output ./models/dcr_lg_t2v_rel -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dcr_train_lg.spacy --paths.dev ./docbins/dcr_dev_lg.spacy
	python -m spacy train ./configs/tra_rel.cfg --output ./models/dcr_tra_rel -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dcr_train.spacy --paths.dev ./docbins/dcr_dev.spacy --gpu-id 0
	python -m spacy train ./configs/tra_rel.cfg --output ./models/dcr_md_tra_rel -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dcr_train_md.spacy --paths.dev ./docbins/dcr_dev_md.spacy --gpu-id 0
	python -m spacy train ./configs/t2v_rel.cfg --output ./models/dcr_mu_t2v_rel -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dcr_train_mu.spacy --paths.dev ./docbins/dcr_dev_mu.spacy
	python -m spacy train ./configs/tra_rel.cfg --output ./models/dcr_mu_tra_rel -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dcr_train_mu.spacy --paths.dev ./docbins/dcr_dev_mu.spacy --gpu-id 0
	python -m spacy train ./configs/tra_rel.cfg --output ./models/dcr_mx_tra_rel -c ./relation_extractor/custom_functions.py --paths.train ./docbins/dcr_train_mx.spacy --paths.dev ./docbins/dcr_dev_mx.spacy --gpu-id 0
	python -m spacy train ./configs/t2v_rcx.cfg --output ./models/dcr_mu_t2v_rcx -c ./relation_extractor_context/custom_functions.py --paths.train ./docbins/dcr_train_mu.spacy --paths.dev ./docbins/dcr_dev_mu.spacy --components.relation_extractor.model.create_instance_tensor.get_instances.ent1label DEFENDANT --components.relation_extractor.model.create_instance_tensor.get_instances.ent2label OFF
	python -m spacy train ./configs/tra_rcx.cfg --output ./models/dcr_mu_tra_rcx -c ./relation_extractor_context/custom_functions.py --paths.train ./docbins/dcr_train_mu.spacy --paths.dev ./docbins/dcr_dev_mu.spacy --gpu-id 0
	#
	# Test
	python test.py ./models/dcr_t2v_rel/model-best ./docbins/dcr_test_lg.spacy --copyents
	python test.py ./models/dcr_lg_t2v_rel/model-best ./docbins/dcr_test_lg.spacy --copyents
	python test.py ./models/dcr_tra_rel/model-best ./docbins/dcr_test_lg.spacy --copyents
	python test.py ./models/dcr_md_tra_rel/model-best ./docbins/dcr_test_lg.spacy --copyents
	python test.py ./models/dcr_t2v_rel/model-best ./docbins/dcr_test_mu.spacy --copyents
	python test.py ./models/dcr_lg_t2v_rel/model-best ./docbins/dcr_test_mu.spacy --copyents
	python test.py ./models/dcr_tra_rel/model-best ./docbins/dcr_test_mu.spacy --copyents
	python test.py ./models/dcr_md_tra_rel/model-best ./docbins/dcr_test_mu.spacy --copyents
	python test.py ./models/dcr_mu_t2v_rel/model-best ./docbins/dcr_test_lg.spacy --copyents
	python test.py ./models/dcr_mu_t2v_rel/model-best ./docbins/dcr_test_mu.spacy --copyents
	python test.py ./models/dcr_mu_tra_rel/model-best ./docbins/dcr_test_lg.spacy --copyents
	python test.py ./models/dcr_mu_tra_rel/model-best ./docbins/dcr_test_mu.spacy --copyents
	python test.py ./models/dcr_mx_tra_rel/model-best ./docbins/dcr_test_lg.spacy --copyents
	python test.py ./models/dcr_mx_tra_rel/model-best ./docbins/dcr_test_mu.spacy --copyents
	python test.py ./models/dcr_mu_t2v_rcx/model-best ./docbins/dcr_test_mu.spacy --copyents
	python test.py ./models/dcr_mu_tra_rcx/model-best ./docbins/dcr_test_mu.spacy --copyents
	#
	# Spacy evaluate does not work out of the box with custom components.

