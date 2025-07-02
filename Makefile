
venv-make:
	# https://docs.python.org/3/library/venv.html
	# https://spacy.io/usage
	# python3 -m venv .venv
	# source .venv/bin/activate
	# pip install -U lxml
	## pip install -U pip setuptools wheel
	# pip install -U spacy
	## python -m spacy download en_core_web_sm

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
	# python prodigy_to_docbin.py obp.jsonl train.spacy 0 3270
	# python prodigy_to_docbin.py obp.jsonl valid.spacy 3271
	# python prodigy_to_docbin.py obp.jsonl train_rel.spacy 0 3270

train:
	# https://ner.pythonhumanities.com/03_02_train_spacy_ner_model.html
	# visit https://spacy.io/usage/training to generate a base_config.cfg
	# source .venv/bin/activate
	# python -m spacy init fill-config ./base_config.cfg ./config.cfg
	## python -m spacy train config.cfg --paths.train ./train.spacy --paths.dev ./dev.spacy
	# python -m spacy train ./config.cfg --output ./models/v1

test:
	# source .venv/bin/activate
	# python test.py models/v1/model-best obp.jsonl  0 1
