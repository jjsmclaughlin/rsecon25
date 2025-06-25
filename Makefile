
venv-make:
	# https://docs.python.org/3/library/venv.html
	# https://spacy.io/usage
	# python3 -m venv .venv
	# source .venv/bin/activate
	# pip install -U lxml
	## pip install -U pip setuptools wheel
	## pip install -U spacy
	## python -m spacy download en_core_web_sm

venv-activate:
	# source .venv/bin/activate

venv-deactivate:
	# deactivate

git-add-dryrun:
	git add . --dry-run --verbose

preprocess:
	# source .venv/bin/activate
	# python obp_to_prodigy.py

