
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

venv-activate:
	# source .venv/bin/activate

venv-deactivate:
	# deactivate

git-add-dryrun:
	git add . --dry-run --verbose

obp_to_prodigy:
	# source .venv/bin/activate
	# python obp_to_prodigy.py

# VICTIM, DEFENDANT, DEFENDANTHOME, OCCUPATION 
# PERSPLACE, PERSOCC

prodigy_to_docbin:
	# source .venv/bin/activate
	# training 70%, validation 20%, test 10%
	# python prodigy_to_docbin.py jsonl/obp.jsonl docbins/train.spacy 0 3270
	# python prodigy_to_docbin.py jsonl/obp.jsonl docbins/valid.spacy 3271
	# python prodigy_to_docbin.py jsonl/obp.jsonl docbins/train_rel.spacy 0 3270
	# python prodigy_to_docbin.py jsonl/obp.jsonl docbins/valid_rel.spacy 3271
	# python prodigy_to_docbin.py jsonl/obp.jsonl docbins/train_rel_tiny.spacy 0 70
	# python prodigy_to_docbin.py jsonl/obp.jsonl docbins/valid_rel_tiny.spacy 71 90
	# python prodigy_to_docbin.py jsonl/obp.jsonl docbins/train_rel_mini.spacy 0 140
	# python prodigy_to_docbin.py jsonl/obp.jsonl docbins/valid_rel_mini.spacy 141 181
	#
	# python prodigy_to_docbin.py jsonl/obp.jsonl --ents=VICTIM:PER,DEFENDANT:PER,DEFENDANTHOME:PLA,OCCUPATION:OCC --rels=PERSPLACE:PERPLA,PERSOCC:PEROCC -s=0 -e=0
	# python prodigy_to_docbin.py jsonl/obp.jsonl -s=0 -e=70 --ents=VICTIM:PER,DEFENDANT:PER,DEFENDANTHOME:PLA,OCCUPATION:OCC --rels=PERSPLACE:PERPLA,PERSOCC:PEROCC --outfile=docbins/train_rel_tiny.spacy
	# python prodigy_to_docbin.py jsonl/obp.jsonl docbins/valid_rel_tiny.spacy 71 90
	#
	# The rel_component example has 149 examples in total. 70% = 104, 20% = 29, 10% = 14
	# python prodigy_to_docbin.py jsonl/obp.jsonl --ents=VICTIM:PER,DEFENDANT:PER,DEFENDANTHOME:PLA,OCCUPATION:OCC --rels=PERSPLACE:PERPLA,PERSOCC:PEROCC --relmaxtok=32 --maxlen=300 -s0 -e800 --outfile=docbins/train_rel_only.spacy
	# python prodigy_to_docbin.py jsonl/obp.jsonl --ents=VICTIM:PER,DEFENDANT:PER,DEFENDANTHOME:PLA,OCCUPATION:OCC --rels=PERSPLACE:PERPLA,PERSOCC:PEROCC --relmaxtok=32 --maxlen=300 -s801 -e1000 --outfile=docbins/valid_rel_only.spacy
	# python prodigy_to_docbin.py jsonl/obp.jsonl --ents=VICTIM:PER,DEFENDANT:PER,DEFENDANTHOME:PLA,OCCUPATION:OCC --maxlen=300 -s1001 -e1100 --outfile=docbins/test_rel_only.spacy

config:
	# source .venv/bin/activate
	# https://ner.pythonhumanities.com/03_02_train_spacy_ner_model.html
	# visit https://spacy.io/usage/training to generate a base_config.cfg
	# python -m spacy init fill-config ./base_config_old.cfg ./configs/config_old.cfg
	# python -m spacy init fill-config ./base_config_old_rel.cfg ./configs/config_old_rel.cfg -c ./scripts/custom_functions.py
	# python -m spacy init fill-config ./base_config.cfg ./configs/config.cfg
	# python -m spacy init fill-config ./base_config_rel.cfg ./configs/config_rel.cfg -c ./scripts/custom_functions.py
	# python -m spacy init fill-config ./base_config_rel_only.cfg ./configs/config_rel_only.cfg -c ./scripts/custom_functions.py
	# python -m spacy init fill-config ./base_config_tr.cfg ./configs/config_tr.cfg
	# python -m spacy init fill-config ./base_config_tr_rel.cfg ./configs/config_tr_rel.cfg -c ./scripts/custom_functions.py
	#
	# python -m spacy init fill-config ./rel_tok2vec.cfg ./configs/rel_toc2vec.cfg -c ./scripts/custom_functions.py

debug:
	# source .venv/bin/activate
	# python -m spacy debug data ./configs/config.cfg
	# python -m spacy debug data ./configs/config_rel.cfg -c ./scripts/custom_functions.py
	# python -m spacy debug data ./configs/config_rel_only.cfg -c ./scripts/custom_functions.py
	# python -m spacy debug data ./configs/config_tr.cfg
	# python -m spacy debug data ./configs/config_tr_rel.cfg -c ./scripts/custom_functions.py
	#
	# python -m spacy debug data ./configs/rel_toc2vec.cfg -c ./scripts/custom_functions.py

gpu-test:
	# source .venv/bin/activate
	# python scripts/gpu_test.py

train:
	# source .venv/bin/activate
	####### python -m spacy train config.cfg --paths.train ./train.spacy --paths.dev ./dev.spacy
	# python -m spacy train ./configs/config_old.cfg --output ./models/v1
	# python -m spacy train ./configs/config_old_rel.cfg --output ./models/v2 -c ./scripts/custom_functions.py
	# python -m spacy train ./configs/config.cfg --output ./models/v3
	# python -m spacy train ./configs/config_rel.cfg --output ./models/v2 -c ./scripts/custom_functions.py
	# python -m spacy train ./configs/config_rel_only.cfg --output ./models/v3 -c ./scripts/custom_functions.py
	# python -m spacy train ./configs/config_tr.cfg --output ./models/v4
	# python -m spacy train ./configs/config_tr.cfg --output ./models/v5 --gpu-id 0
	# python -m spacy train ./configs/config_tr_rel.cfg --output ./models/v6 --gpu-id 0 -c ./scripts/custom_functions.py
	#
	# python -m spacy train ./configs/rel_toc2vec.cfg --output ./models/v3 -c ./scripts/custom_functions.py
	
test:
	# source .venv/bin/activate
	# python test_old.py models/v1/model-best jsonl/obp.jsonl 100 101
	# python test_old.py models/v2/model-best jsonl/obp.jsonl 101 102
	# python test_old.py models/v3/model-best jsonl/obp.jsonl 203 204
	# python test_old.py models/v4/model-best jsonl/obp.jsonl 100 101
	#
	# python test.py ./models/v3/model-best ./docbins/test_rel_only.spacy
